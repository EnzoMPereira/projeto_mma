# MMA - Autenticação biométrica facial + controle de acesso por nível

## Instalação
1. DBeaver: restaure seu dump e execute `banco/01_migracao.sql` UMA vez.
2. `python preparar.py` (cria o .env com as chaves; só pede a senha do Postgres).
3. Linux: `sudo apt install cmake build-essential` (necessário ao dlib).
4. `python -m venv venv && source venv/bin/activate && pip install -r requirements.txt`
5. `cd backend && python app.py` e abra http://localhost:5000
6. Cadastre o 1º usuário: vira nível 3 automaticamente. Os demais entram como nível 1; o nível 3 logado pode conceder 2 ou 3.
