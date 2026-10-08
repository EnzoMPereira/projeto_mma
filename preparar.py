"""Cria o arquivo .env com as chaves já geradas. Uso: python preparar.py"""
import os, secrets, getpass
from cryptography.fernet import Fernet

if os.path.exists(".env"):
    print(".env já existe. Apague-o se quiser recriar (CUIDADO: nova chave invalida rostos já cadastrados).")
    raise SystemExit
senha = getpass.getpass("Senha do seu PostgreSQL: ")
with open(".env", "w", encoding="utf-8") as f:
    f.write(f"DB_HOST=localhost\nDB_PORT=5432\nDB_NAME=postgres\nDB_USER=postgres\nDB_PASSWORD={senha}\n")
    f.write(f"SECRET_KEY={secrets.token_hex(32)}\nBIOMETRIA_KEY={Fernet.generate_key().decode()}\n")
print(".env criado com sucesso. Agora: cd backend && python app.py")
