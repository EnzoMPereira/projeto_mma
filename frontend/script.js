// O front-end só APRESENTA. Quem decide o acesso é o back-end (Flask + PostgreSQL).
const pagina = document.body.dataset.page;
const $ = (id) => document.getElementById(id);

async function api(rota, corpo) {
    const r = await fetch(rota, {
        method: corpo !== undefined ? 'POST' : 'GET',
        headers: { 'Content-Type': 'application/json' },
        body: corpo !== undefined ? JSON.stringify(corpo) : undefined,
    });
    let dados = {};
    try { dados = await r.json(); } catch (e) { dados = { erro: 'Resposta inválida do servidor.' }; }
    return { ok: r.ok, status: r.status, dados };
}
function msg(el, texto, ok) {
    el.textContent = texto;
    el.className = ok ? 'success-text' : 'error-text';
}
function capturarCamera(video) {
    const c = document.createElement('canvas');
    c.width = video.videoWidth; c.height = video.videoHeight;
    c.getContext('2d').drawImage(video, 0, 0);
    return c.toDataURL('image/jpeg', 0.9);
}
function lerArquivo(file) {
    return new Promise((res) => { const f = new FileReader(); f.onload = () => res(f.result); f.readAsDataURL(file); });
}
async function ligarCamera(video, erroEl) {
    try { video.srcObject = await navigator.mediaDevices.getUserMedia({ video: true }); }
    catch (e) { msg(erroEl, 'Erro: permissão da câmera negada.', false); erroEl.classList.remove('hidden'); }
}

// ---------- TELA 1: IDENTIFICAÇÃO ----------
if (pagina === 'index') {
    const aviso = sessionStorage.getItem('mma_aviso');
    if (aviso) { $('aviso').textContent = aviso; $('aviso').classList.remove('hidden'); sessionStorage.removeItem('mma_aviso'); }
    $('next-button').addEventListener('click', async () => {
        const r = await api('/api/identificar', { email: $('username').value.trim() });
        if (!r.ok) { $('aviso').textContent = r.dados.erro; $('aviso').classList.remove('hidden'); return; }
        sessionStorage.setItem('mma_nome', r.dados.nome);   // só para exibir; não concede nada
        location.href = 'biometria.html';
    });
}

// ---------- TELA 2: AUTENTICAÇÃO BIOMÉTRICA ----------
if (pagina === 'biometria') {
    const nome = sessionStorage.getItem('mma_nome');
    if (!nome) location.href = 'index.html';
    $('welcome-message').textContent = `Usuário: ${nome} | Etapa 2`;
    const video = $('camera-feed'), status = $('status-message'), up = $('image-upload'), rm = $('remove-image-btn');
    ligarCamera(video, status);
    up.addEventListener('change', () => {
        if (up.files[0] && !up.files[0].type.startsWith('image/')) { alert('Envie um arquivo de imagem.'); up.value = ''; }
        rm.classList.toggle('hidden', !up.files.length);
    });
    rm.addEventListener('click', () => { up.value = ''; rm.classList.add('hidden'); });
    $('auth-button').addEventListener('click', async () => {
        status.classList.remove('hidden');
        const imagem = up.files.length ? await lerArquivo(up.files[0]) : capturarCamera(video);
        msg(status, 'Verificando biometria...', true);
        const r = await api('/api/autenticar', { imagem });
        if (!r.ok) {
            msg(status, r.dados.erro, false);
            if (r.status === 401 || r.status === 423) setTimeout(() => {
                if (/Sessão|bloqueada/.test(r.dados.erro)) location.href = 'index.html';
            }, 2500);
            return;
        }
        msg(status, `Acesso liberado - ${r.dados.perfil} (nível ${r.dados.nivel})`, true);
        setTimeout(() => location.href = 'painel.html', 1000);
    });
}

// ---------- CADASTRO ----------
if (pagina === 'cadastro') {
    const video = $('Register-camera');
    ligarCamera(video, $('msg'));
    $('save-user-btn').addEventListener('click', async () => {
        $('msg').classList.remove('hidden');
        const r = await api('/api/cadastrar', {
            nome: $('new-nome').value, email: $('new-email').value,
            nivel: $('nivel-acesso').value, imagem: capturarCamera(video),
        });
        msg($('msg'), r.ok ? `Cadastrado! Nível concedido pelo servidor: ${r.dados.nivel}` : r.dados.erro, r.ok);
    });
}

// ---------- PAINEL ----------
if (pagina === 'painel') {
    (async () => {
        const r = await api('/api/sessao');
        if (!r.ok) { sessionStorage.setItem('mma_aviso', r.dados.erro); location.href = 'index.html'; return; }
        $('user-display').textContent = `Usuário: ${r.dados.nome}`;
        $('level-display').textContent = `${r.dados.perfil} - Nível ${r.dados.nivel}`;
    })();
    $('logout').addEventListener('click', async (e) => { e.preventDefault(); await api('/api/logout', {}); location.href = 'home.html'; });
    document.querySelectorAll('[data-rota]').forEach((b) => b.addEventListener('click', async () => {
        const r = await api(b.dataset.rota), erro = $('erro'), saida = $('saida');
        saida.replaceChildren();
        if (r.status === 401) { sessionStorage.setItem('mma_aviso', r.dados.erro); location.href = 'index.html'; return; }
        erro.classList.toggle('hidden', r.ok);
        if (!r.ok) { erro.textContent = `${r.status} - ${r.dados.erro}`; return; }
        const linhas = r.dados.linhas, t = document.createElement('table'); t.className = 'data-table';
        if (!linhas.length) { saida.textContent = 'Sem registros.'; return; }
        const cab = t.insertRow(); Object.keys(linhas[0]).forEach((k) => { const th = document.createElement('th'); th.textContent = k; cab.appendChild(th); });
        linhas.forEach((l) => { const tr = t.insertRow(); Object.values(l).forEach((v) => { tr.insertCell().textContent = v ?? ''; }); });
        saida.appendChild(t);   // textContent evita XSS
    }));
}
