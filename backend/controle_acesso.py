"""AUTORIZAÇÃO no back-end: a cada requisição o nível é relido do PostgreSQL.
Alterar HTML/JS ou forjar requisição não adianta."""
import time
from functools import wraps
from flask import session, jsonify, g, request
from db import conectar
from config import SESSAO_SEG
from logs import registrar

SQL_USUARIO = """SELECT u.id,u.nome,u.email,u.ativo,u.tentativas_falhas,u.bloqueado_ate,p.nome AS perfil,p.nivel
                 FROM usuario u JOIN perfil p ON p.id=u.perfil_id WHERE {}"""

def buscar_usuario(campo, valor):
    cond = "u.id=%s" if campo == "id" else "lower(u.email)=lower(%s)"
    with conectar() as c:
        return c.execute(SQL_USUARIO.format(cond), (valor,)).fetchone()

def usuario_logado():
    """Retorna o usuário se houver sessão autenticada válida; senão None (sem erro)."""
    if session.get("etapa") != "autenticado" or time.time() > session.get("exp", 0):
        return None
    u = buscar_usuario("id", session["uid"])
    return u if u and u["ativo"] else None

def exige_nivel(minimo):
    def deco(f):
        @wraps(f)
        def wrapper(*a, **k):
            if session.get("etapa") != "autenticado" or time.time() > session.get("exp", 0):
                uid = session.get("uid"); session.clear()
                registrar("SESSAO_INVALIDA", False, f"Sessão ausente/expirada em {request.path}", uid)
                return jsonify(erro="Sessão inválida ou expirada. Faça login novamente."), 401
            u = buscar_usuario("id", session["uid"])
            if not u or not u["ativo"]:
                session.clear()
                return jsonify(erro="Usuário inexistente ou desativado."), 403
            if u["nivel"] < minimo:
                registrar("ACESSO_NEGADO", False,
                          f"Nível {u['nivel']} tentou recurso de nível {minimo}: {request.path}", u["id"])
                return jsonify(erro=f"Acesso negado: requer nível {minimo}; seu nível é {u['nivel']}."), 403
            session["exp"] = time.time() + SESSAO_SEG   # sessão deslizante
            g.usuario = u
            return f(*a, **k)
        return wrapper
    return deco
