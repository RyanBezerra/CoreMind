--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-06-11 22:08:16

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- TOC entry 234 (class 1259 OID 16501)
-- Name: audios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audios (
    id integer NOT NULL,
    conversa_id integer,
    arquivo bytea,
    nome_arquivo character varying(255),
    mime_type character varying(50),
    data_upload timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.audios OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16500)
-- Name: audios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audios_id_seq OWNER TO postgres;

--
-- TOC entry 5024 (class 0 OID 0)
-- Dependencies: 233
-- Name: audios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audios_id_seq OWNED BY public.audios.id;


--
-- TOC entry 226 (class 1259 OID 16442)
-- Name: conversas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.conversas (
    id integer NOT NULL,
    usuario_id integer,
    data_inicio timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    modelo_ia character varying(50),
    status character varying(20) DEFAULT 'ativo'::character varying
);


ALTER TABLE public.conversas OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16441)
-- Name: conversas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.conversas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.conversas_id_seq OWNER TO postgres;

--
-- TOC entry 5025 (class 0 OID 0)
-- Dependencies: 225
-- Name: conversas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.conversas_id_seq OWNED BY public.conversas.id;


--
-- TOC entry 232 (class 1259 OID 16486)
-- Name: imagens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.imagens (
    id integer NOT NULL,
    conversa_id integer,
    arquivo bytea,
    nome_arquivo character varying(255),
    mime_type character varying(50),
    data_upload timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.imagens OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16485)
-- Name: imagens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.imagens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.imagens_id_seq OWNER TO postgres;

--
-- TOC entry 5026 (class 0 OID 0)
-- Dependencies: 231
-- Name: imagens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.imagens_id_seq OWNED BY public.imagens.id;


--
-- TOC entry 242 (class 1259 OID 16563)
-- Name: integracoes_externas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.integracoes_externas (
    id integer NOT NULL,
    usuario_id integer,
    nome_api character varying(50),
    chave_api_encriptada bytea,
    configuracoes jsonb,
    data_cadastro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.integracoes_externas OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16562)
-- Name: integracoes_externas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.integracoes_externas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.integracoes_externas_id_seq OWNER TO postgres;

--
-- TOC entry 5027 (class 0 OID 0)
-- Dependencies: 241
-- Name: integracoes_externas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.integracoes_externas_id_seq OWNED BY public.integracoes_externas.id;


--
-- TOC entry 230 (class 1259 OID 16471)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    usuario_id integer,
    acao character varying(100) NOT NULL,
    detalhes jsonb,
    data_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16470)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;

--
-- TOC entry 5028 (class 0 OID 0)
-- Dependencies: 229
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- TOC entry 228 (class 1259 OID 16456)
-- Name: mensagens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mensagens (
    id integer NOT NULL,
    conversa_id integer,
    autor character varying(20) NOT NULL,
    conteudo text,
    data_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.mensagens OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16455)
-- Name: mensagens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mensagens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mensagens_id_seq OWNER TO postgres;

--
-- TOC entry 5029 (class 0 OID 0)
-- Dependencies: 227
-- Name: mensagens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mensagens_id_seq OWNED BY public.mensagens.id;


--
-- TOC entry 220 (class 1259 OID 16402)
-- Name: perfis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.perfis (
    id integer NOT NULL,
    nome character varying(50) NOT NULL,
    permissoes jsonb NOT NULL
);


ALTER TABLE public.perfis OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16401)
-- Name: perfis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.perfis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.perfis_id_seq OWNER TO postgres;

--
-- TOC entry 5030 (class 0 OID 0)
-- Dependencies: 219
-- Name: perfis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.perfis_id_seq OWNED BY public.perfis.id;


--
-- TOC entry 236 (class 1259 OID 16516)
-- Name: preferencias_usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.preferencias_usuarios (
    id integer NOT NULL,
    usuario_id integer,
    modelo_padrao character varying(50),
    idioma character varying(20),
    tema character varying(20),
    outras_preferencias jsonb
);


ALTER TABLE public.preferencias_usuarios OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16515)
-- Name: preferencias_usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.preferencias_usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.preferencias_usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 5031 (class 0 OID 0)
-- Dependencies: 235
-- Name: preferencias_usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.preferencias_usuarios_id_seq OWNED BY public.preferencias_usuarios.id;


--
-- TOC entry 224 (class 1259 OID 16430)
-- Name: servidores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servidores (
    id integer NOT NULL,
    nome character varying(100) NOT NULL,
    ip inet NOT NULL,
    sistema_operacional character varying(50),
    data_cadastro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.servidores OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16429)
-- Name: servidores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servidores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.servidores_id_seq OWNER TO postgres;

--
-- TOC entry 5032 (class 0 OID 0)
-- Dependencies: 223
-- Name: servidores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servidores_id_seq OWNED BY public.servidores.id;


--
-- TOC entry 240 (class 1259 OID 16548)
-- Name: tarefas_agendadas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tarefas_agendadas (
    id integer NOT NULL,
    usuario_id integer,
    nome_tarefa character varying(100),
    parametros jsonb,
    proxima_execucao timestamp without time zone,
    periodicidade character varying(50),
    status character varying(20) DEFAULT 'pendente'::character varying
);


ALTER TABLE public.tarefas_agendadas OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16547)
-- Name: tarefas_agendadas_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tarefas_agendadas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tarefas_agendadas_id_seq OWNER TO postgres;

--
-- TOC entry 5033 (class 0 OID 0)
-- Dependencies: 239
-- Name: tarefas_agendadas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tarefas_agendadas_id_seq OWNED BY public.tarefas_agendadas.id;


--
-- TOC entry 238 (class 1259 OID 16532)
-- Name: tokens_sessoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokens_sessoes (
    id integer NOT NULL,
    usuario_id integer,
    token character varying(256) NOT NULL,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expira_em timestamp without time zone,
    ativo boolean DEFAULT true
);


ALTER TABLE public.tokens_sessoes OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16531)
-- Name: tokens_sessoes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tokens_sessoes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tokens_sessoes_id_seq OWNER TO postgres;

--
-- TOC entry 5034 (class 0 OID 0)
-- Dependencies: 237
-- Name: tokens_sessoes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tokens_sessoes_id_seq OWNED BY public.tokens_sessoes.id;


--
-- TOC entry 218 (class 1259 OID 16390)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    login character varying(100) NOT NULL,
    senha_hash character varying(256) NOT NULL,
    ip_cadastro inet,
    data_criacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

--
-- TOC entry 5035 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- TOC entry 222 (class 1259 OID 16413)
-- Name: usuarios_perfis; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios_perfis (
    id integer NOT NULL,
    usuario_id integer,
    perfil_id integer
);


ALTER TABLE public.usuarios_perfis OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16412)
-- Name: usuarios_perfis_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_perfis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_perfis_id_seq OWNER TO postgres;

--
-- TOC entry 5036 (class 0 OID 0)
-- Dependencies: 221
-- Name: usuarios_perfis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_perfis_id_seq OWNED BY public.usuarios_perfis.id;


--
-- TOC entry 4817 (class 2604 OID 16504)
-- Name: audios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audios ALTER COLUMN id SET DEFAULT nextval('public.audios_id_seq'::regclass);


--
-- TOC entry 4808 (class 2604 OID 16445)
-- Name: conversas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversas ALTER COLUMN id SET DEFAULT nextval('public.conversas_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 16489)
-- Name: imagens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagens ALTER COLUMN id SET DEFAULT nextval('public.imagens_id_seq'::regclass);


--
-- TOC entry 4825 (class 2604 OID 16566)
-- Name: integracoes_externas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integracoes_externas ALTER COLUMN id SET DEFAULT nextval('public.integracoes_externas_id_seq'::regclass);


--
-- TOC entry 4813 (class 2604 OID 16474)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- TOC entry 4811 (class 2604 OID 16459)
-- Name: mensagens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensagens ALTER COLUMN id SET DEFAULT nextval('public.mensagens_id_seq'::regclass);


--
-- TOC entry 4804 (class 2604 OID 16405)
-- Name: perfis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfis ALTER COLUMN id SET DEFAULT nextval('public.perfis_id_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 16519)
-- Name: preferencias_usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencias_usuarios ALTER COLUMN id SET DEFAULT nextval('public.preferencias_usuarios_id_seq'::regclass);


--
-- TOC entry 4806 (class 2604 OID 16433)
-- Name: servidores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servidores ALTER COLUMN id SET DEFAULT nextval('public.servidores_id_seq'::regclass);


--
-- TOC entry 4823 (class 2604 OID 16551)
-- Name: tarefas_agendadas id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarefas_agendadas ALTER COLUMN id SET DEFAULT nextval('public.tarefas_agendadas_id_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 16535)
-- Name: tokens_sessoes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens_sessoes ALTER COLUMN id SET DEFAULT nextval('public.tokens_sessoes_id_seq'::regclass);


--
-- TOC entry 4802 (class 2604 OID 16393)
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- TOC entry 4805 (class 2604 OID 16416)
-- Name: usuarios_perfis id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_perfis ALTER COLUMN id SET DEFAULT nextval('public.usuarios_perfis_id_seq'::regclass);


--
-- TOC entry 4850 (class 2606 OID 16509)
-- Name: audios audios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audios
    ADD CONSTRAINT audios_pkey PRIMARY KEY (id);


--
-- TOC entry 4842 (class 2606 OID 16449)
-- Name: conversas conversas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversas
    ADD CONSTRAINT conversas_pkey PRIMARY KEY (id);


--
-- TOC entry 4848 (class 2606 OID 16494)
-- Name: imagens imagens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagens
    ADD CONSTRAINT imagens_pkey PRIMARY KEY (id);


--
-- TOC entry 4862 (class 2606 OID 16571)
-- Name: integracoes_externas integracoes_externas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integracoes_externas
    ADD CONSTRAINT integracoes_externas_pkey PRIMARY KEY (id);


--
-- TOC entry 4846 (class 2606 OID 16479)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4844 (class 2606 OID 16464)
-- Name: mensagens mensagens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensagens
    ADD CONSTRAINT mensagens_pkey PRIMARY KEY (id);


--
-- TOC entry 4832 (class 2606 OID 16411)
-- Name: perfis perfis_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfis
    ADD CONSTRAINT perfis_nome_key UNIQUE (nome);


--
-- TOC entry 4834 (class 2606 OID 16409)
-- Name: perfis perfis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.perfis
    ADD CONSTRAINT perfis_pkey PRIMARY KEY (id);


--
-- TOC entry 4852 (class 2606 OID 16523)
-- Name: preferencias_usuarios preferencias_usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencias_usuarios
    ADD CONSTRAINT preferencias_usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4854 (class 2606 OID 16525)
-- Name: preferencias_usuarios preferencias_usuarios_usuario_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencias_usuarios
    ADD CONSTRAINT preferencias_usuarios_usuario_id_key UNIQUE (usuario_id);


--
-- TOC entry 4838 (class 2606 OID 16440)
-- Name: servidores servidores_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servidores
    ADD CONSTRAINT servidores_nome_key UNIQUE (nome);


--
-- TOC entry 4840 (class 2606 OID 16438)
-- Name: servidores servidores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servidores
    ADD CONSTRAINT servidores_pkey PRIMARY KEY (id);


--
-- TOC entry 4860 (class 2606 OID 16556)
-- Name: tarefas_agendadas tarefas_agendadas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarefas_agendadas
    ADD CONSTRAINT tarefas_agendadas_pkey PRIMARY KEY (id);


--
-- TOC entry 4856 (class 2606 OID 16539)
-- Name: tokens_sessoes tokens_sessoes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens_sessoes
    ADD CONSTRAINT tokens_sessoes_pkey PRIMARY KEY (id);


--
-- TOC entry 4858 (class 2606 OID 16541)
-- Name: tokens_sessoes tokens_sessoes_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens_sessoes
    ADD CONSTRAINT tokens_sessoes_token_key UNIQUE (token);


--
-- TOC entry 4828 (class 2606 OID 16400)
-- Name: usuarios usuarios_login_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_login_key UNIQUE (login);


--
-- TOC entry 4836 (class 2606 OID 16418)
-- Name: usuarios_perfis usuarios_perfis_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_perfis
    ADD CONSTRAINT usuarios_perfis_pkey PRIMARY KEY (id);


--
-- TOC entry 4830 (class 2606 OID 16398)
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 16510)
-- Name: audios audios_conversa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audios
    ADD CONSTRAINT audios_conversa_id_fkey FOREIGN KEY (conversa_id) REFERENCES public.conversas(id) ON DELETE CASCADE;


--
-- TOC entry 4865 (class 2606 OID 16450)
-- Name: conversas conversas_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.conversas
    ADD CONSTRAINT conversas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE SET NULL;


--
-- TOC entry 4868 (class 2606 OID 16495)
-- Name: imagens imagens_conversa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.imagens
    ADD CONSTRAINT imagens_conversa_id_fkey FOREIGN KEY (conversa_id) REFERENCES public.conversas(id) ON DELETE CASCADE;


--
-- TOC entry 4873 (class 2606 OID 16572)
-- Name: integracoes_externas integracoes_externas_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.integracoes_externas
    ADD CONSTRAINT integracoes_externas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4867 (class 2606 OID 16480)
-- Name: logs logs_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE SET NULL;


--
-- TOC entry 4866 (class 2606 OID 16465)
-- Name: mensagens mensagens_conversa_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mensagens
    ADD CONSTRAINT mensagens_conversa_id_fkey FOREIGN KEY (conversa_id) REFERENCES public.conversas(id) ON DELETE CASCADE;


--
-- TOC entry 4870 (class 2606 OID 16526)
-- Name: preferencias_usuarios preferencias_usuarios_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.preferencias_usuarios
    ADD CONSTRAINT preferencias_usuarios_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4872 (class 2606 OID 16557)
-- Name: tarefas_agendadas tarefas_agendadas_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tarefas_agendadas
    ADD CONSTRAINT tarefas_agendadas_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4871 (class 2606 OID 16542)
-- Name: tokens_sessoes tokens_sessoes_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens_sessoes
    ADD CONSTRAINT tokens_sessoes_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


--
-- TOC entry 4863 (class 2606 OID 16424)
-- Name: usuarios_perfis usuarios_perfis_perfil_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_perfis
    ADD CONSTRAINT usuarios_perfis_perfil_id_fkey FOREIGN KEY (perfil_id) REFERENCES public.perfis(id) ON DELETE CASCADE;


--
-- TOC entry 4864 (class 2606 OID 16419)
-- Name: usuarios_perfis usuarios_perfis_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios_perfis
    ADD CONSTRAINT usuarios_perfis_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id) ON DELETE CASCADE;


-- Completed on 2025-06-11 22:08:16

--
-- PostgreSQL database dump complete
--

