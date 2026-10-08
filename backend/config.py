import os
from dotenv import load_dotenv
load_dotenv(os.path.join(os.path.dirname(__file__), "..", ".env"))

DB = dict(host=os.getenv("DB_HOST", "localhost"), port=int(os.getenv("DB_PORT", 5432)),
          dbname=os.getenv("DB_NAME", "postgres"), user=os.getenv("DB_USER", "postgres"),
          password=os.getenv("DB_PASSWORD", ""))
SECRET_KEY = os.environ["SECRET_KEY"]          # assina o cookie de sessão
BIOMETRIA_KEY = os.environ["BIOMETRIA_KEY"]    # cifra os templates faciais

LIMITE_DISTANCIA = 0.5   # face_recognition: menor = mais parecido (padrão da lib é 0.6)
MAX_FALHAS = 3           # falhas biométricas antes do bloqueio
BLOQUEIO_MIN = 5         # minutos de bloqueio
IDENTIFICACAO_SEG = 300  # tempo para concluir a biometria após identificar
SESSAO_SEG = 900         # sessão expira após 15 min sem uso
