import re, time, logging
from datetime import datetime, timedelta
from flask import Blueprint, request, session, jsonify, g
import psycopg
from db import conectar
from config import *
from logs import registrar
from biometria import extrair_embedding, cifrar, confere, ErroBiometria
from controle_acesso import buscar_usuario, usuario_logado, exige_nivel

bp = Blueprint("auth", __name__, url_prefix="/api")
EMAIL = re.compile(r"^[^@\s]+@[^@\s]+\.[^@\s]+$")

@bp.post("/identificar")            # ETAPA 1 - IDENTIFICAÇÃO: "quem diz ser?"
def identificar():
    email = (request.json or {}).get("email", "").strip()
    u = buscar_usuario("email", email) if EMAIL.match(email) else None
    if not u:
        registrar("USUARIO_NAO_CADASTRADO", False, f"Identificação desconhecida: {email[:60]}")
        return jsonify(erro="Usuário não cadastrado."), 404
    if not u["ativo"]:
        registrar("USUARIO_INATIVO", False, "Conta desativada", u["id"])
        return jsonify(erro="Conta desativada."), 403
    if u["bloqueado_ate"] and u["bloqueado_ate"] > datetime.now():
        registrar("BLOQUEIO", False, "Tentativa durante bloqueio", u["id"])
        return jsonify(erro=f"Conta bloqueada até {u['bloqueado_ate']:%H:%M}."), 423
    session.clear()
    session.update(uid=u["id"], etapa="identificado", exp=time.time() + IDENTIFICACAO_SEG)
    return jsonify(nome=u["nome"])

@bp.post("/autenticar")             # ETAPA 2 - AUTENTICAÇÃO: "é mesmo essa pessoa?"
def autenticar():
    if session.get("etapa") != "identificado" or time.time() > session.get("exp", 0):
        registrar("SESSAO_INVALIDA", False, "Biometria sem identificação prévia/expirada", session.get("uid"))
        session.clear()
        return jsonify(erro="Sessão expirada. Identifique-se novamente."), 401
    u = buscar_usuario("id", session["uid"])
    if u["bloqueado_ate"] and u["bloqueado_ate"] > datetime.now():
        return jsonify(erro="Conta temporariamente bloqueada."), 423
    try:
        emb = extrair_embedding((request.json or {}).get("imagem", ""))
        logging.info(emb)
    except ErroBiometria as e:
        registrar("BIOMETRIA_INVALIDA", False, str(e), u["id"])
        return jsonify(erro=str(e)), 422
    with conectar() as c:
        bio = c.execute("SELECT template_cifrado FROM biometria_facial WHERE usuario_id=%s", (u["id"],)).fetchone()
        if not bio:
            return jsonify(erro="Usuário sem biometria cadastrada."), 409
        logging.info(bio["template_cifrado"])
        ok, dist = confere(emb, bio["template_cifrado"])
        if not ok:
            falhas = u["tentativas_falhas"] + 1
            bloq = datetime.now() + timedelta(minutes=BLOQUEIO_MIN) if falhas >= MAX_FALHAS else None
            c.execute("UPDATE usuario SET tentativas_falhas=%s, bloqueado_ate=%s WHERE id=%s",
                      (0 if bloq else falhas, bloq, u["id"]))
            registrar("BIOMETRIA_FALHA", False, f"Face não confere (distância {dist:.2f}); falha {falhas}/{MAX_FALHAS}", u["id"])
            msg = "Conta bloqueada por excesso de falhas." if bloq else f"Biometria não confere. Tentativa {falhas}/{MAX_FALHAS}."
            return jsonify(erro=msg), 401
        c.execute("UPDATE usuario SET tentativas_falhas=0, bloqueado_ate=NULL WHERE id=%s", (u["id"],))
    session.update(etapa="autenticado", exp=time.time() + SESSAO_SEG)   # nível NÃO vai no cookie
    registrar("LOGIN_OK", True, f"Autenticado (distância {dist:.2f})", u["id"])
    return jsonify(nome=u["nome"], perfil=u["perfil"], nivel=u["nivel"])

@bp.get("/sessao")                  # ETAPA 3 - AUTORIZAÇÃO: perfil/nível vêm do banco
@exige_nivel(1)
def sessao():
    u = g.usuario
    return jsonify(nome=u["nome"], perfil=u["perfil"], nivel=u["nivel"])

@bp.post("/logout")
def logout():
    registrar("LOGOUT", True, "Sessão encerrada", session.get("uid"))
    session.clear()
    return jsonify(ok=True)

@bp.post("/cadastrar")
def cadastrar():
    d = request.json or {}
    nome, email = d.get("nome", "").strip(), d.get("email", "").strip().lower()
    if len(nome) < 3 or not EMAIL.match(email):
        return jsonify(erro="Informe nome e e-mail válidos."), 400
    with conectar() as c:
        vazio = c.execute("SELECT count(*) AS n FROM usuario").fetchone()["n"] == 0
    logado = usuario_logado()
    try:
        pedido = int(d.get("nivel", 1))
    except (TypeError, ValueError):
        pedido = 1
    # REGRA ANTI-ESCALADA: o nível pedido pelo navegador só vale se quem pede é nível 3.
    if vazio:
        nivel = 3                                   # bootstrap: 1º usuário é a autoridade máxima
    elif logado and logado["nivel"] == 3 and pedido in (1, 2, 3):
        nivel = pedido
    else:
        nivel = 1
        if pedido != 1:
            registrar("ESCALADA_NEGADA", False, f"Cadastro pediu nível {pedido} sem ser nível 3: {email[:60]}")
    try:
        emb = extrair_embedding(d.get("imagem", ""))
    except ErroBiometria as e:
        return jsonify(erro=str(e)), 422
    try:
        with conectar() as c:
            uid = c.execute("INSERT INTO usuario (nome,email,perfil_id) VALUES (%s,%s,%s) RETURNING id",
                            (nome, email, nivel)).fetchone()["id"]   # perfil_id 1/2/3 = nível 1/2/3
            c.execute("INSERT INTO biometria_facial (usuario_id,template_cifrado) VALUES (%s,%s)",
                      (uid, cifrar(emb)))
    except psycopg.errors.UniqueViolation:
        return jsonify(erro="E-mail já cadastrado."), 409
    registrar("CADASTRO", True, f"Novo usuário nível {nivel}", uid)
    return jsonify(ok=True, nivel=nivel)
