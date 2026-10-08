import os, psycopg
from flask import Flask, jsonify
from config import SECRET_KEY
from logs import log
import rotas_auth, rotas_dados

FRONT = os.path.join(os.path.dirname(__file__), "..", "frontend")
app = Flask(__name__, static_folder=FRONT, static_url_path="")
app.config.update(SECRET_KEY=SECRET_KEY, MAX_CONTENT_LENGTH=6 * 1024 * 1024,
                  SESSION_COOKIE_HTTPONLY=True, SESSION_COOKIE_SAMESITE="Strict")
app.register_blueprint(rotas_auth.bp)
app.register_blueprint(rotas_dados.bp)

@app.get("/")
def raiz():
    return app.send_static_file("home.html")

@app.errorhandler(psycopg.Error)
def erro_banco(e):
    log.error("Erro de banco: %s", e)
    return jsonify(erro="Erro de comunicação com o banco de dados. Tente novamente."), 503

@app.errorhandler(413)
def grande(e):
    return jsonify(erro="Imagem muito grande."), 413

if __name__ == "__main__":
    app.run(debug=False, port=5000)   # câmera exige localhost ou HTTPS
