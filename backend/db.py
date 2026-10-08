import psycopg
from psycopg.rows import dict_row
from config import DB

def conectar():
    """Nova conexão. Use: with conectar() as c: (faz commit e fecha ao sair)."""
    return psycopg.connect(**DB, row_factory=dict_row)
