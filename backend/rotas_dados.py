from flask import Blueprint, jsonify, g
from db import conectar
from controle_acesso import exige_nivel

bp = Blueprint("dados", __name__, url_prefix="/api")

@bp.get("/dados")                       # nível 1+: o SQL já filtra pelo nível do usuário
@exige_nivel(1)
def dados():
    with conectar() as c:
        linhas = c.execute("""SELECT ano_pda,acao,fonte,mecanismo,area_responsavel,nivel_minimo
                              FROM fnmc_completo WHERE nivel_minimo <= %s ORDER BY ano_pda,id""",
                           (g.usuario["nivel"],)).fetchall()
    return jsonify(linhas=linhas)

@bp.get("/direcao/resumo")              # nível 2+
@exige_nivel(2)
def resumo():
    with conectar() as c:
        linhas = c.execute("""SELECT area_responsavel, count(*) AS qtd_acoes
                              FROM fnmc_completo GROUP BY 1 ORDER BY 2 DESC""").fetchall()
    return jsonify(linhas=linhas)

@bp.get("/admin/auditoria")             # nível 3 apenas
@exige_nivel(3)
def auditoria():
    with conectar() as c:
        linhas = c.execute("""SELECT to_char(r.data_hora,'DD/MM HH24:MI:SS') AS quando, r.tipo, r.sucesso,
                                     r.motivo, r.ip, u.email
                              FROM registro_acesso r LEFT JOIN usuario u ON u.id=r.usuario_id
                              ORDER BY r.id DESC LIMIT 50""").fetchall()
    return jsonify(linhas=linhas)
