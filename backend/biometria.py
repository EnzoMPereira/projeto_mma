"""Biometria facial: a FOTO nunca é guardada. Guardamos só um vetor de 128 números
(embedding) calculado pela rede neural, CIFRADO com Fernet (AES-128 + HMAC)."""
import base64, io
import numpy as np, face_recognition
from cryptography.fernet import Fernet
from config import BIOMETRIA_KEY, LIMITE_DISTANCIA

_fernet = Fernet(BIOMETRIA_KEY.encode())

class ErroBiometria(Exception):
    pass

def extrair_embedding(data_url: str) -> np.ndarray:
    try:
        bruto = base64.b64decode(data_url.split(",")[-1])
        img = face_recognition.load_image_file(io.BytesIO(bruto))
    except Exception:
        raise ErroBiometria("Imagem inválida.")
    rostos = face_recognition.face_locations(img)
    if len(rostos) == 0:
        raise ErroBiometria("Nenhum rosto detectado. Melhore a iluminação e centralize o rosto.")
    if len(rostos) > 1:
        raise ErroBiometria("Mais de um rosto na imagem.")
    return face_recognition.face_encodings(img, rostos)[0]   # a imagem é descartada aqui

def cifrar(emb: np.ndarray) -> bytes:
    return _fernet.encrypt(emb.astype(np.float64).tobytes())

def decifrar(blob) -> np.ndarray:
    return np.frombuffer(_fernet.decrypt(bytes(blob)), dtype=np.float64)

def confere(emb_novo, blob) -> tuple[bool, float]:
    d = float(np.linalg.norm(emb_novo - decifrar(blob)))   # distância euclidiana
    return d <= LIMITE_DISTANCIA, d
