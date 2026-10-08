import logging, os
from flask import request, has_request_context
from db import conectar

_arq = logging.FileHandler(os.path.join(os.path.dirname(__file__), "..", "logs", "seguranca.log"), encoding="utf-8")
_arq.setFormatter(logging.Formatter("%(asctime)s %(message)s"))
log = logging.getLogger("seguranca"); log.setLevel(logging.INFO); log.addHandler(_arq)

def registrar(tipo, sucesso, motivo, usuario_id=None):
    """Grava no PostgreSQL e em arquivo. Nunca grava imagem nem template facial."""
    ip = request.remote_addr if has_request_context() else None
    log.info("%s ok=%s uid=%s ip=%s %s", tipo, sucesso, usuario_id, ip, motivo)
    try:
        with conectar() as c:
            c.execute("INSERT INTO registro_acesso (usuario_id,tipo,sucesso,motivo,ip) VALUES (%s,%s,%s,%s,%s)",
                      (usuario_id, tipo, sucesso, motivo[:160], ip))
    except Exception:
        log.exception("Falha ao gravar log no banco")  # o arquivo garante o registro
