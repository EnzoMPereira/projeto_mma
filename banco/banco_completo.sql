--
-- PostgreSQL database dump
--

\restrict LrFXZejOne1Ch3gvtdcFfRGY2oeA7cMy3pSwbSnJN8cj2tDPkgMMupFZasgXVwh

-- Dumped from database version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)

-- Started on 2026-10-08 00:48:30 -03

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16444)
-- Name: biometria_facial; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.biometria_facial (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    template_cifrado bytea NOT NULL,
    criado_em timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.biometria_facial OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16443)
-- Name: biomatria_facial_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.biomatria_facial_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.biomatria_facial_id_seq OWNER TO postgres;

--
-- TOC entry 3502 (class 0 OID 0)
-- Dependencies: 219
-- Name: biomatria_facial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.biomatria_facial_id_seq OWNED BY public.biometria_facial.id;


--
-- TOC entry 224 (class 1259 OID 16472)
-- Name: fnmc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fnmc (
    id integer NOT NULL,
    ano_pda integer NOT NULL,
    acao text NOT NULL,
    fonte text,
    descricao_fonte text,
    mecanismo text,
    forma_acesso text,
    demais_informacoes text,
    area_responsavel text
);


ALTER TABLE public.fnmc OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16480)
-- Name: fnmc_completo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fnmc_completo (
    ano_pda integer,
    acao character varying(256),
    fonte character varying(50),
    descricao_fonte character varying(50),
    mecanismo character varying(128),
    forma_acesso character varying(128),
    demais_informacoes character varying(256),
    area_responsavel character varying(128),
    id integer NOT NULL,
    nivel_minimo smallint DEFAULT 1 NOT NULL,
    CONSTRAINT fnmc_completo_nivel_minimo_check CHECK (((nivel_minimo >= 1) AND (nivel_minimo <= 3)))
);


ALTER TABLE public.fnmc_completo OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 16488)
-- Name: fnmc_completo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fnmc_completo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fnmc_completo_id_seq OWNER TO postgres;

--
-- TOC entry 3503 (class 0 OID 0)
-- Dependencies: 226
-- Name: fnmc_completo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fnmc_completo_id_seq OWNED BY public.fnmc_completo.id;


--
-- TOC entry 223 (class 1259 OID 16471)
-- Name: fnmc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fnmc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fnmc_id_seq OWNER TO postgres;

--
-- TOC entry 3504 (class 0 OID 0)
-- Dependencies: 223
-- Name: fnmc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fnmc_id_seq OWNED BY public.fnmc.id;


--
-- TOC entry 216 (class 1259 OID 16415)
-- Name: perfil; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfil (
    id integer NOT NULL,
    nome character varying(60) NOT NULL,
    nivel smallint NOT NULL,
    CONSTRAINT perfil_nivel_check CHECK (((nivel >= 1) AND (nivel <= 3)))
);


ALTER TABLE public.perfil OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16414)
-- Name: perfil_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.perfil_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.perfil_id_seq OWNER TO postgres;

--
-- TOC entry 3505 (class 0 OID 0)
-- Dependencies: 215
-- Name: perfil_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.perfil_id_seq OWNED BY public.perfil.id;


--
-- TOC entry 222 (class 1259 OID 16459)
-- Name: registro_acesso; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.registro_acesso (
    id bigint NOT NULL,
    usuario_id integer,
    tipo character varying(30) NOT NULL,
    sucesso boolean NOT NULL,
    motivo character varying(160),
    data_hora timestamp without time zone DEFAULT now() NOT NULL,
    ip character varying(45)
);


ALTER TABLE public.registro_acesso OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16458)
-- Name: registro_acesso_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.registro_acesso_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.registro_acesso_id_seq OWNER TO postgres;

--
-- TOC entry 3506 (class 0 OID 0)
-- Dependencies: 221
-- Name: registro_acesso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.registro_acesso_id_seq OWNED BY public.registro_acesso.id;


--
-- TOC entry 218 (class 1259 OID 16425)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    nome character varying(120) NOT NULL,
    email character varying(160) NOT NULL,
    perfil_id integer NOT NULL,
    ativo boolean DEFAULT true NOT NULL,
    tentativas_falhas smallint DEFAULT 0 NOT NULL,
    bloqueado_ate timestamp without time zone,
    criado_em timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16424)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_seq OWNER TO postgres;

--
-- TOC entry 3507 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- TOC entry 3313 (class 2604 OID 16447)
-- Name: biometria_facial id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biometria_facial ALTER COLUMN id SET DEFAULT nextval('public.biomatria_facial_id_seq'::regclass);


--
-- TOC entry 3317 (class 2604 OID 16475)
-- Name: fnmc id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fnmc ALTER COLUMN id SET DEFAULT nextval('public.fnmc_id_seq'::regclass);


--
-- TOC entry 3318 (class 2604 OID 16489)
-- Name: fnmc_completo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fnmc_completo ALTER COLUMN id SET DEFAULT nextval('public.fnmc_completo_id_seq'::regclass);


--
-- TOC entry 3308 (class 2604 OID 16418)
-- Name: perfil id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil ALTER COLUMN id SET DEFAULT nextval('public.perfil_id_seq'::regclass);


--
-- TOC entry 3315 (class 2604 OID 16462)
-- Name: registro_acesso id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_acesso ALTER COLUMN id SET DEFAULT nextval('public.registro_acesso_id_seq'::regclass);


--
-- TOC entry 3309 (class 2604 OID 16428)
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- TOC entry 3490 (class 0 OID 16444)
-- Dependencies: 220
-- Data for Name: biometria_facial; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.biometria_facial (id, usuario_id, template_cifrado, criado_em) FROM stdin;
1	1	\\x67414141414142717873374678486f46643979376674587753386952414b7236366c4c516e4c6c6f4e766b6b464d626e2d443653387032615866666d376a6f48666275713372763665577347426775715f7965746f3275666b364d6b7259383271734d33637367626a32774a5a6a79794f684870656d6f6d5f4d4f683565335a4a59787245706a4a426e326446614b3743464d6a6f4e314a69495857317a6a59637a474a5a513843534f3039306d6a4463446e6d5546653933736178485f4d564344445962693739556c61466969414145436c70645961487250487177543368396a367a4b62623636544c4f5578464570365849315634724f444c4658563652396c523832696368636a343957686e533776464b535f384a566577464d687369515f514b56347a7237517663424a685a6c753359506c434669584179695a614d344e304c33344979695a5273356f647a36416a48326e5f6c5f4f77557779623171594f3277332d514b76507048484f797a49426b39506e76324c4b43662d6631766c684865415256366b76444377424149314f617663384e51614f5235726d596c514b586e785630524865486a7763713167502d4161664e43307a4f49424c68426f346554554e703735495447687553614d69346a6a4b666a3173755f334f556b517a664a48535370656c4b3456434966536c4c7a6156446a7867585846546a72534b464464724854576a576b5a48506f6464775374424132797a6865456a68464a646a39353767316b4a635a6a65515074503453426432674863656c344d5662466d333657346333467a697237353073323449796171466853476634522d637969674c735653354c6a486d6b4c2d4b6b4c686830656b4f71386a4731437267386c334a4a4831317a76546c4d776d4a45385a7237616435646b797971786b772d584a4e775873755133433765774538346d7943392d6454444265596e4b413347334c527844373158336a7a735f4276497477337a6d536a66784331414441774f43466b52454f4575464b6967373249674f4674473766546f4f586f4b573679595a77524d77774c46447a506b593337594f746564634f4572464a494c4b4765414f6468496944505650485550435f2d5a2d6e575f474947346c497246484b374f5830324771436b4d45353938756748746b46316555765475476a4661513435437a6c6968766b3074486b4a714954347375615847714e5a66736736506a56564530452d78685a71637341576b5639732d796c762d625f6b33696b6b4d4d2d59697951526c3176576c2d65364e45687137626859547545557355545234374b347542595f3567792d4d6175746957414b496364306e48493059673076667034622d494c47535245674950525634556e7769726a694251676d59355a4c6c385a5775417552447968517a5574305364626e587548306e4e4f546952633562545838394466553177475261685a784f6c327762506b4c47384b452d5f6d434c37326a4e505975785949536e31594c79354351633031695832756f46644e3864477a4a6b412d63344e6f576234444a463936334b66457454486b5f6f4477442d62754f464449457277384e35636f624731626964366159446c5739364f48684e456e7445324c586d6459454c65637150424a49387675333648587953616f507574774259746a497354775f65414e62444f7173753576694539577342343071354641345238677755534f685048315f30354a734c31646f4c516e6b7068584b58785a78464a6b497a69555951366a62366f6d53626576717475664648677658394762457467766d2d41375853576776326b62775570756f5253735f6d425a314d2d4735636d6b6347695764662d64506f44786c597a767555776f3562475477397435714b4162566e6b68376e35717536456a3550667433634d6d61534f5f78426d37624948567a71456c414646686536563742326e555930654c61456e5041516a727068434d574a70542d3830774a4e4f39636c564c7a3132673d	2026-10-07 19:59:17.427156
2	2	\\x67414141414142717874444c31637859714a39555a6c5341494673473562776a453574335a6c5a4e7445396a4b4b504a2d4c434d612d317274575f64597641444369594d64415a34794b313974792d725a6268487951444e44576b65317066354b6752317569566b52505f714b466e4c6848596d5464416b79474a734761383177696651323251674e5f615878764e4163526a496531776647484f62666264514f304d6d515a2d46336b3955324f563073477a41396e6d4765516a6a72577a38697377366831385578516c3977645759593366586e794a635449534b5734536e634e54573462317877486c634f71513063756d4d39316e456b70726d634e336767486e6d4f7066656645464167776d3873666d71586f44634b4877305634716764744a2d397242724f5736477554414569364f366c797177564938736655684a50746e4f4f3747375f6c45465a55464c5961787157656a64383669386e493077556a542d42614e34774f76367a3432337539536b6d725573624e594255306c4d547133567756346a5a6a7237795a583456762d534e4f6933664d674f5744744e7931705653375242366b77456a4d30455547725533624d50394b6c7664307245434b434f35626c3077434c5438527436486e63675372646c4f71322d5973504c385f545033374d4c38786a42653164515543374935495f304b4b676c5849314350475633696c7a44554e7a515a58324857736d725f32765f4e37535777434c6762537879433773643463755568395975344b69436a33713661334c7a736d3877346e4e374864384e7074666f38334830552d6b745935715f504e454a30697a37745432316f7a6a4b5348516d32726465394278646e5567727477765348516b394575437855546b6a7746585853674330594c73356f7a47665950327a5958777949634b54304c7a64465a46325553714846706d39754432564135655238694967585739787132487a364234446e4b47666d62686e35785242647534476848574e4d58364647774e74584e47452d55706d56315231356a6b5a5a6a7a45554972327472575f4961613177766839306c515242487a566e687266784a4f366b59416c454d4d4e6e5776433544324f6841423068335a4e5856347a5f7036784c6b495351715f3054486f467656514754594e777675345a776946774734446f4d47795a6d5469374a39754d716a5551726e6d3452324b724d51775269567142444239376370542d41656b78506c725038444463744e7742575141486d6831765f52483753574931775f714e547a586776664d6e3745346f615a7163426f646e35666c69454f756d437a654163566c5f417077796650695172566a724e7a7177677a4770565f36444c4f78376e4f396e5558475a35515a364652586c31503657734c645a4f4567417477473739794172617a47774b786a3353444843426a4b554f76534a4f454e4a424e65383650367362442d456f433736377457415a77307a735134354a6b46554965454d5f663538797765507a674d6845345a527334507a464f6a6e6670365569316d32592d397170626b6e71724732734d634a756b726c697533582d73784e3753705834783539626175787542474c66466364615f4f77356136797652775838464650745a667477743579797355744d786a4372427659615969726b46794d356a6a4b6279684141765236506f50756934586a452d70396e30543971535135426e737745794d35353866643879586865515f4d78506a77753455442d41446556655f5162536f443833347132306f435f6d6d6e7a7a50456e707a4d314276624f364a7847513259744b795736626f553844612d456a30786458463351567a4d706642626c3873575934415377645374496c6264425f64726a6563414a5161626772655a71356d737869576a323678454257347a6e75583259505268515a326543447a465f39356c65773832632d6174724c494f6363354f58497579664e64504e4f3044614e7153566e71774a47463236314d3d	2026-10-07 20:07:55.96136
\.


--
-- TOC entry 3494 (class 0 OID 16472)
-- Dependencies: 224
-- Data for Name: fnmc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fnmc (id, ano_pda, acao, fonte, descricao_fonte, mecanismo, forma_acesso, demais_informacoes, area_responsavel) FROM stdin;
\.


--
-- TOC entry 3495 (class 0 OID 16480)
-- Dependencies: 225
-- Data for Name: fnmc_completo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fnmc_completo (ano_pda, acao, fonte, descricao_fonte, mecanismo, forma_acesso, demais_informacoes, area_responsavel, id, nivel_minimo) FROM stdin;
2021	Plano Operativo (2020-2023)	OGU	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Em andamento	Departamento de Conservação Florestal e Serviços Ambientais/ Secretaria da Amazônia e Serviços Ambientais	19	2
2022	FML-BRA/16/G71 - Fortalecimento Institucional para a Proteção da Camada de Ozônio - Fase VIII	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 449,280.00	Gerência de Projetos de Clima /DCL/SCRI/MMA - PROJETO CONCLUÍDO	37	1
2022	BRA/14/G31 PIMS 4675 – Produção sustentável de carvão vegetal à base de biomassa renovável para a indústria siderúrgica no Brasil.	PNUD/GEF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 7,150,000.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	38	2
2022	BRA/22/G71 - Projeto Fortalecimento Institucional para Implementação do Protocolo de Montreal no Brasil – Fase IX	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 449,280.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	39	2
2021	Iniciativas para Implementação e Monitoramento da PNMC	OGU - Ação Orçamentária 20W1	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Disponibilidade de R$ 538 mil para o ano corrente (2021)	Gerência de Projetos de Clima /DCL/SCRI/MMA	1	1
2021	Redução da Vulnerabilidade aos Efeitos da Desertificação	OGU - Ação Orçamentária 20W2	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Disponibilidade de R$ 194,28 mil para o ano corrente (2021)	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	2	1
2021	Projeto BRA/14/G32 (PIMS 3066) - Manejo do Uso Sustentável da Terra no Semiárido do Nordeste Brasileiro - Sergipe	PNUD/GEF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	 Valor total da ação: US$ 3,815,192.00	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	3	2
2021	BRA/IICA/14/001- Apoio à implementação de estratégias e ações de prevenção, controle e combate à desertificação face aos cenários de mudanças climáticas e à UNCCD	IICA/MMA	Ação Orçamentária (LOA)	Cooperação Técnica Internacional (Execução Nacional)	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	 Valor Total da Ação: R$ 10.306.096,99 	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	4	2
2021	Revertendo o Processo de Desertificação nas Áreas Suscetíveis do Brasil: Práticas Agroflorestais Sustentáveis e Conservação da Biodiversidade (REDESER)	FAO/GEF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 3,930,155.00	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	5	3
2021	GEF Vertentes - Consórcio de Uso Múltiplo Sustentável e Gestão da Paisagem	SENAR/GEF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 26,790,000.00	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	6	1
2021	OEI/AECID (Trifinio+Paraguai) - Cooperação Espanhola	OEI/AECID	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: EU 297.697,72	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	7	1
2021	BMUB-PROADAPTA - Apoio ao Brasil na Implementação da sua Agenda Nacional de Adaptação à Mudança do Clima	 GIZ/BMUB	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: EU 5.000.000,00	Gerência de Projetos de Clima /DCL/SCRI/MMA	8	2
2021	FML-BRA/14/G72 - Projeto Demonstrativo para o gerenciamento e destinação final dos resíduos de SDO	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 1,490,600.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	9	2
2021	FML-BRA/16/G76 - Programa Brasileiro de Eliminação dos HCFCs Etapa 2 - Projeto para o Setor de Manufaturas de Espumas de Poliuretano	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 17,020,000.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	10	3
2021	FML-OZÔNIO-002 - Programa Brasileiro de Eliminação dos HCFCs Etapa 2 - Setor de Manufatura de Equipamentos de Refrigeração e Ar condicionado	UNIDO/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 3,969,228.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	11	1
2021	FML-OZÔNIO-003 - Programa Brasileiro de Eliminação dos HCFCs Etapa 2 - Setor de Serviços de Refrigeração	GIZ/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	 Valor Total da Ação: US$ 7,727,273.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	12	1
2021	FML-BRA/16/G71 - Fortalecimento Institucional para a Proteção da Camada de Ozônio - Fase VIII	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 449,280.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	13	2
2021	BRA/14/G31 PIMS 4675 – Produção sustentável de carvão vegetal à base de biomassa renovável para a indústria siderúrgica no Brasil.	PNUD/GEF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 7,150,000.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	14	2
2021	BRA/21/G71 - Projeto Fortalecimento Institucional para implementação do Protocolo de Montreal no Brasil – Fase IX	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 449,280.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	15	3
2021	Fomento a Estudos e Projetos para Mitigação e Adaptação à Mudança do Clima	OGU - Ação Orçamentária 20G4	Ação Orçamentária (LOA)	Execução orçamentária direta ou descentralizada mediante aprovação do Comitê Gestor 	Seleção de projetos prioritários ou por meio de editais específicos	Orçamento de R$ 525.980,00 para o ano corrente (2021), sendo R$ 319.6 mil disponibilizados para novas ações	Departamento de Fundos de Meio Ambiente/Secex/MMA	16	1
2021	Financiamento Reembolsável de Projetos para Mitigação e Adaptação à Mudança do Clima	OGU - Ação Orçamentária 00J4	Ação Orçamentária (LOA)	Concessão de empréstimos pelo BNDES e instituições parceiras	Financiamento reembolsável de projetos, na forma de empréstimos para pessoas físicas e jurídicas	Disponibilidade inicial de R$ 866.655.000 no BNDES, mais R$ 322.971.081,00 orçados para transferência pelo MMA no exercício (2021)	Departamento de Fundos de Meio Ambiente/Secex/MMA	17	1
2021	Plano Nacional para Controle do Desmatamento Ilegal e Recuperação da Vegetação Nativa (2020-2023)	OGU	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Em andamento	Departamento de Conservação Florestal e Serviços Ambientais/ Secretaria da Amazônia e Serviços Ambientais	18	2
2021	Projeto Floresta + Amazonia	PNUD/GCF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Implementação em quatro modalidades. Pagamentos diretos ou indiretos, a depender do público.	Valor total da ação: \n80  milhoes de dolares	Departamento de Conservação Florestal e Serviços Ambientais/ Secretaria da Amazônia e Serviços Ambientais	20	3
2021	Projeto POMUC	GIZ/KFW	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor total da ação: \n9 milhoes de euros 	Departamento de Conservação Florestal e Serviços Ambientais/ Secretaria da Amazônia e Serviços Ambientais	21	1
2021	Projeto Biodiversidade e Mudanças Climáticas na Mata Atlântica	BMU/KFW e GIZ	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor total primeira e segundas fases (2013 - 2020): 11.130.728,00 euros. \n\nValor total da fase atual (2021-2023): 5.169.271,00 euros	Departamento de Ecossistemas / Secretaria da Amazônia e Serviços Ambientais	22	1
2021	Projeto Paisagens Sustentáveis da Amazônia - Fase 1	GEF/Banco Mundial	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor total do projeto: US$ 60,3 milhões	Departamento de Ecossistemas / Secretaria da Amazônia e Serviços Ambientais	23	2
2021	Projeto Paisagens Sustentáveis da Amazônia - Fase 2	GEF/Banco Mundial	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor total do projeto: US$ 21,02 milhões	Departamento de Ecossistemas / Secretaria da Amazônia e Serviços Ambientais	24	2
2022	Iniciativas para Implementação e Monitoramento da PNMC	OGU - Ação Orçamentária 20W1	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Disponibilidade de R$ 538 mil para o ano corrente (2021)	Gerência de Projetos de Clima /DCL/SCRI/MMA	25	3
2022	Redução da Vulnerabilidade aos Efeitos da Desertificação	OGU - Ação Orçamentária 20W2	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Disponibilidade de R$ 194,28 mil para o ano corrente (2021)	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	26	1
2022	Projeto BRA/14/G32 (PIMS 3066) - Manejo do Uso Sustentável da Terra no Semiárido do Nordeste Brasileiro - Sergipe	PNUD/GEF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	 Valor total da ação: US$ 3,815,192.00	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	27	1
2022	BRA/IICA/14/001- Apoio à implementação de estratégias e ações de prevenção, controle e combate à desertificação face aos cenários de mudanças climáticas e à UNCCD	IICA/MMA	Ação Orçamentária (LOA)	Cooperação Técnica Internacional (Execução Nacional)	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	 Valor Total da Ação: R$ 10.306.096,99 	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	28	2
2022	Revertendo o Processo de Desertificação nas Áreas Suscetíveis do Brasil: Práticas Agroflorestais Sustentáveis e Conservação da Biodiversidade (REDESER)	FAO/GEF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 3,930,155.00	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	29	2
2022	GEF Vertentes - Consórcio de Uso Múltiplo Sustentável e Gestão da Paisagem	SENAR/GEF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 26,790,000.00	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	30	3
2022	OEI/AECID (Trifinio+Paraguai) - Cooperação Espanhola	OEI/AECID	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: EU 297.697,72	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	31	1
2022	BMUB-PROADAPTA - Apoio ao Brasil na Implementação da sua Agenda Nacional de Adaptação à Mudança do Clima	 GIZ/BMUB	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: EU 5.000.000,00	Gerência de Projetos de Clima /DCL/SCRI/MMA	32	1
2022	FML-BRA/14/G72 - Projeto Demonstrativo para o gerenciamento e destinação final dos resíduos de SDO	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 1,490,600.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	33	2
2022	FML-BRA/16/G76 - Programa Brasileiro de Eliminação dos HCFCs Etapa 2 - Projeto para o Setor de Manufaturas de Espumas de Poliuretano	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 17,020,000.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	34	2
2022	FML-OZÔNIO-002 - Programa Brasileiro de Eliminação dos HCFCs Etapa 2 - Setor de Manufatura de Equipamentos de Refrigeração e Ar condicionado	UNIDO/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 3,969,228.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	35	3
2022	FML-OZÔNIO-003 - Programa Brasileiro de Eliminação dos HCFCs Etapa 2 - Setor de Serviços de Refrigeração	GIZ/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	 Valor Total da Ação: US$ 7,727,273.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	36	1
2022	Redução da Vulnerabilidade aos Efeitos da Desertificação	OGU - Ação Orçamentária 20W2	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Disponibilidade de R$ 30.000,00 para o ano corrente (2022)	Gerência de Projetos de Combate à Desertificação /DCL/SCRI/MMA	40	3
2022	FML-BRA/16/G71 - Fortalecimento Institucional para a Proteção da Camada de Ozônio - Fase VIII (AÇÃO CONCLUÍDA)	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 449,280.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	41	1
2022	BRA/22/G71 - Projeto Fortalecimento Institucional para implementação do Protocolo de Montreal no Brasil – Fase IX	PNUD/FML	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor Total da Ação: US$ 449,280.00	Gerência de Projetos de Clima /DCL/SCRI/MMA	42	1
2022	Fomento a Estudos e Projetos para Mitigação e Adaptação à Mudança do Clima	OGU - Ação Orçamentária 20G4	Ação Orçamentária (LOA)	Execução orçamentária direta ou descentralizada mediante aprovação do Comitê Gestor 	Seleção de projetos prioritários ou por meio de editais específicos	Orçamento de R$ 525.980,00 para o ano corrente (2021), sendo R$ 319.6 mil disponibilizados para novas ações	Departamento de Fundos de Meio Ambiente/Secex/MMA	43	2
2022	Financiamento Reembolsável de Projetos para Mitigação e Adaptação à Mudança do Clima	OGU - Ação Orçamentária 00J4	Ação Orçamentária (LOA)	Concessão de empréstimos pelo BNDES e instituições parceiras	Financiamento reembolsável de projetos, na forma de empréstimos para pessoas físicas e jurídicas	Disponibilidade inicial de R$ 866.655.000 no BNDES, mais R$ 322.971.081,00 orçados para transferência pelo MMA no exercício (2021)	Departamento de Fundos de Meio Ambiente/Secex/MMA	44	2
2022	Plano Nacional para Controle do Desmatamento Ilegal e Recuperação da Vegetação Nativa (2020-2023)	OGU	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Em andamento	Departamento de Conservação Florestal e Serviços Ambientais/ Secretaria da Amazônia e Serviços Ambientais	45	3
2022	Plano Operativo (2020-2023)	OGU	Ação Orçamentária (LOA)	Execução orçamentária direta do Orçamento Geral da União	Execução Orçamentária Institucional	Em andamento	Departamento de Conservação Florestal e Serviços Ambientais/ Secretaria da Amazônia e Serviços Ambientais	46	1
2022	Projeto Floresta + Amazonia	PNUD/GCF	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Implementação em quatro modalidades. Pagamentos diretos ou indiretos, a depender do público.	Valor total da ação: \n80  milhoes de dolares	Departamento de Conservação Florestal e Serviços Ambientais/ Secretaria da Amazônia e Serviços Ambientais	47	1
2022	Projeto POMUC	GIZ/KFW	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor total da ação: \n9 milhoes de euros 	Departamento de Conservação Florestal e Serviços Ambientais/ Secretaria da Amazônia e Serviços Ambientais	48	2
2022	Projeto Biodiversidade e Mudanças Climáticas na Mata Atlântica	BMU/KFW e GIZ	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor total primeira e segundas fases (2013 - 2020): 11.130.728,00 euros. \n\nValor total da fase atual (2021-2023): 5.169.271,00 euros	Departamento de Ecossistemas / Secretaria da Amazônia e Serviços Ambientais	49	2
2022	Projeto Paisagens Sustentáveis da Amazônia - Fase 1	GEF/Banco Mundial	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor total do projeto: US$ 60,3 milhões	Departamento de Ecossistemas / Secretaria da Amazônia e Serviços Ambientais	50	3
2022	Projeto Paisagens Sustentáveis da Amazônia - Fase 2	GEF/Banco Mundial	Recursos Externos (Internacionais)	Cooperação Técnica Internacional	Contratação por meio de Termos de Referências no âmbito do Projeto Internacional junto às Agências Executoras	Valor total do projeto: US$ 21,02 milhões	Departamento de Ecossistemas / Secretaria da Amazônia e Serviços Ambientais	51	1
\.


--
-- TOC entry 3486 (class 0 OID 16415)
-- Dependencies: 216
-- Data for Name: perfil; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.perfil (id, nome, nivel) FROM stdin;
1	Consulta Geral	1
2	Direcao	2
3	Autoridade Maxima	3
\.


--
-- TOC entry 3492 (class 0 OID 16459)
-- Dependencies: 222
-- Data for Name: registro_acesso; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.registro_acesso (id, usuario_id, tipo, sucesso, motivo, data_hora, ip) FROM stdin;
1	1	CADASTRO	t	Novo usuário nível 3	2026-10-07 19:59:17.439236	127.0.0.1
2	1	BIOMETRIA_INVALIDA	f	Nenhum rosto detectado. Melhore a iluminação e centralize o rosto.	2026-10-07 19:59:55.110183	127.0.0.1
3	1	BIOMETRIA_INVALIDA	f	Nenhum rosto detectado. Melhore a iluminação e centralize o rosto.	2026-10-07 20:00:11.590156	127.0.0.1
4	1	LOGIN_OK	t	Autenticado (distância 0.20)	2026-10-07 20:00:17.509515	127.0.0.1
5	1	LOGOUT	t	Sessão encerrada	2026-10-07 20:01:27.514115	127.0.0.1
6	\N	USUARIO_NAO_CADASTRADO	f	Identificação desconhecida: teste@gmail.com	2026-10-07 20:01:39.786254	127.0.0.1
7	1	BIOMETRIA_FALHA	f	Face não confere (distância 0.58); falha 1/3	2026-10-07 20:01:57.879883	127.0.0.1
8	1	LOGIN_OK	t	Autenticado (distância 0.37)	2026-10-07 20:02:09.730593	127.0.0.1
9	1	LOGOUT	t	Sessão encerrada	2026-10-07 20:06:29.328676	127.0.0.1
10	2	CADASTRO	t	Novo usuário nível 1	2026-10-07 20:07:55.981604	127.0.0.1
11	2	LOGIN_OK	t	Autenticado (distância 0.18)	2026-10-07 20:08:30.552928	127.0.0.1
12	2	ACESSO_NEGADO	f	Nível 1 tentou recurso de nível 3: /api/admin/auditoria	2026-10-07 20:09:51.91	127.0.0.1
13	2	ACESSO_NEGADO	f	Nível 1 tentou recurso de nível 2: /api/direcao/resumo	2026-10-07 20:09:58.542104	127.0.0.1
14	2	ACESSO_NEGADO	f	Nível 1 tentou recurso de nível 2: /api/direcao/resumo	2026-10-07 20:09:59.174695	127.0.0.1
15	2	ACESSO_NEGADO	f	Nível 1 tentou recurso de nível 2: /api/direcao/resumo	2026-10-07 20:09:59.876987	127.0.0.1
16	2	ACESSO_NEGADO	f	Nível 1 tentou recurso de nível 2: /api/direcao/resumo	2026-10-07 20:10:00.90072	127.0.0.1
17	2	ACESSO_NEGADO	f	Nível 1 tentou recurso de nível 2: /api/direcao/resumo	2026-10-07 20:10:02.825748	127.0.0.1
18	2	ACESSO_NEGADO	f	Nível 1 tentou recurso de nível 3: /api/admin/auditoria	2026-10-07 20:10:07.722345	127.0.0.1
19	2	ACESSO_NEGADO	f	Nível 1 tentou recurso de nível 3: /api/admin/auditoria	2026-10-07 20:18:12.616141	127.0.0.1
20	2	LOGOUT	t	Sessão encerrada	2026-10-07 20:18:14.272373	127.0.0.1
21	1	LOGIN_OK	t	Autenticado (distância 0.35)	2026-10-07 20:18:28.609234	127.0.0.1
22	1	LOGIN_OK	t	Autenticado (distância 0.34)	2026-10-07 20:39:41.874834	127.0.0.1
23	1	LOGOUT	t	Sessão encerrada	2026-10-07 20:46:53.339588	127.0.0.1
24	1	BIOMETRIA_FALHA	f	Face não confere (distância 0.71); falha 1/3	2026-10-07 20:55:30.748719	127.0.0.1
25	1	BIOMETRIA_INVALIDA	f	Nenhum rosto detectado. Melhore a iluminação e centralize o rosto.	2026-10-07 20:57:07.277092	127.0.0.1
26	1	LOGIN_OK	t	Autenticado (distância 0.35)	2026-10-07 20:57:14.518711	127.0.0.1
27	1	LOGOUT	t	Sessão encerrada	2026-10-07 20:57:20.640788	127.0.0.1
28	1	BIOMETRIA_INVALIDA	f	Nenhum rosto detectado. Melhore a iluminação e centralize o rosto.	2026-10-07 20:57:30.137005	127.0.0.1
29	1	BIOMETRIA_INVALIDA	f	Nenhum rosto detectado. Melhore a iluminação e centralize o rosto.	2026-10-07 20:57:39.3052	127.0.0.1
30	1	BIOMETRIA_INVALIDA	f	Nenhum rosto detectado. Melhore a iluminação e centralize o rosto.	2026-10-07 20:57:47.151004	127.0.0.1
31	1	LOGIN_OK	t	Autenticado (distância 0.34)	2026-10-07 20:57:56.958608	127.0.0.1
32	1	LOGOUT	t	Sessão encerrada	2026-10-07 21:00:52.626384	127.0.0.1
33	1	LOGIN_OK	t	Autenticado (distância 0.39)	2026-10-07 21:01:19.739123	127.0.0.1
34	1	SESSAO_INVALIDA	f	Biometria sem identificação prévia/expirada	2026-10-07 21:01:32.92493	127.0.0.1
35	\N	SESSAO_INVALIDA	f	Biometria sem identificação prévia/expirada	2026-10-07 21:01:42.537973	127.0.0.1
36	1	BIOMETRIA_FALHA	f	Face não confere (distância 0.62); falha 1/3	2026-10-07 21:02:15.268104	127.0.0.1
37	1	LOGIN_OK	t	Autenticado (distância 0.35)	2026-10-07 21:08:30.865196	127.0.0.1
\.


--
-- TOC entry 3488 (class 0 OID 16425)
-- Dependencies: 218
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, nome, email, perfil_id, ativo, tentativas_falhas, bloqueado_ate, criado_em) FROM stdin;
2	Claudio Pereira	cpclaudio.cp@gmail.com	1	t	0	\N	2026-10-07 20:07:55.96136
1	test	test@gmail.com	3	t	0	\N	2026-10-07 19:59:17.427156
\.


--
-- TOC entry 3508 (class 0 OID 0)
-- Dependencies: 219
-- Name: biomatria_facial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.biomatria_facial_id_seq', 2, true);


--
-- TOC entry 3509 (class 0 OID 0)
-- Dependencies: 226
-- Name: fnmc_completo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fnmc_completo_id_seq', 51, true);


--
-- TOC entry 3510 (class 0 OID 0)
-- Dependencies: 223
-- Name: fnmc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fnmc_id_seq', 1, false);


--
-- TOC entry 3511 (class 0 OID 0)
-- Dependencies: 215
-- Name: perfil_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.perfil_id_seq', 3, true);


--
-- TOC entry 3512 (class 0 OID 0)
-- Dependencies: 221
-- Name: registro_acesso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.registro_acesso_id_seq', 37, true);


--
-- TOC entry 3513 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 2, true);


--
-- TOC entry 3331 (class 2606 OID 16452)
-- Name: biometria_facial biomatria_facial_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biometria_facial
    ADD CONSTRAINT biomatria_facial_pkey PRIMARY KEY (id);


--
-- TOC entry 3338 (class 2606 OID 16479)
-- Name: fnmc fnmc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fnmc
    ADD CONSTRAINT fnmc_pkey PRIMARY KEY (id);


--
-- TOC entry 3323 (class 2606 OID 16423)
-- Name: perfil perfil_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil
    ADD CONSTRAINT perfil_nome_key UNIQUE (nome);


--
-- TOC entry 3325 (class 2606 OID 16421)
-- Name: perfil perfil_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfil
    ADD CONSTRAINT perfil_pkey PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 16465)
-- Name: registro_acesso registro_acesso_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_acesso
    ADD CONSTRAINT registro_acesso_pkey PRIMARY KEY (id);


--
-- TOC entry 3333 (class 2606 OID 16486)
-- Name: biometria_facial uq_bio_usuario; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biometria_facial
    ADD CONSTRAINT uq_bio_usuario UNIQUE (usuario_id);


--
-- TOC entry 3327 (class 2606 OID 16437)
-- Name: usuario usuario_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_email_key UNIQUE (email);


--
-- TOC entry 3329 (class 2606 OID 16435)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 3334 (class 1259 OID 16487)
-- Name: idx_registro_data; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_registro_data ON public.registro_acesso USING btree (data_hora DESC);


--
-- TOC entry 3340 (class 2606 OID 16453)
-- Name: biometria_facial biomatria_facial_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.biometria_facial
    ADD CONSTRAINT biomatria_facial_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;


--
-- TOC entry 3341 (class 2606 OID 16466)
-- Name: registro_acesso registro_acesso_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.registro_acesso
    ADD CONSTRAINT registro_acesso_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 3339 (class 2606 OID 16438)
-- Name: usuario usuario_perfil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_perfil_id_fkey FOREIGN KEY (perfil_id) REFERENCES public.perfil(id);


-- Completed on 2026-10-08 00:48:30 -03

--
-- PostgreSQL database dump complete
--

\unrestrict LrFXZejOne1Ch3gvtdcFfRGY2oeA7cMy3pSwbSnJN8cj2tDPkgMMupFZasgXVwh

