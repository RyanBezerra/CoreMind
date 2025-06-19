# 🤖 Assistente Virtual Híbrido

![Contributors](https://img.shields.io/badge/contributors-5-red)
[![Ryan](https://img.shields.io/badge/@RyanBezerra-100000?style=flat&logo=github&logoColor=white)](https://github.com/RyanBezerra)
[![Matheus](https://img.shields.io/badge/@Matheusota2k-100000?style=flat&logo=github&logoColor=white)](https://github.com/Matheusota2k)
[![Otavio](https://img.shields.io/badge/@otav--io-100000?style=flat&logo=github&logoColor=white)](https://github.com/otav-io)
[![Luiz](https://img.shields.io/badge/@luizmont5-100000?style=flat&logo=github&logoColor=white)](https://github.com/luizmont5)
[![Lauro](https://img.shields.io/badge/@L4ur--o-100000?style=flat&logo=github&logoColor=white)](https://github.com/L4ur-o)

---

# 📦Sumário

- [Projeto](#Sobre-o-projeto)
- [Funcionalidades](#Funcionalidades)
- [Perguntas Frenquentes](#FAQ)
- [Variáveis de Ambiente](#Variáveis-de-Ambiente)
- [Contribuindo](#Contribuindo)
- [Roadmap](#Roadmap)
- [Autores](#Autores)
- [Instalação](#Instalação)

---

# 🛠️Sobre o projeto

[(Voltar ao topo)](#Sumário)

Este projeto propõe um assistente virtual híbrido que:

- Integra múltiplas IAs via APIs (DeepSeek, Gemini, Mistral, GPT‑4…).
- Mantém contexto e histórico sincronizados entre sessões.
- Executa comandos e automações no desktop (abrir apps, gerenciar arquivos, executar scripts).
- Suporta plugins/agents externos para expandir capacidades (voz, IoT, notificações, etc.).
- Oferece arquitetura desktop e app mobile (Flutter / React Native / WebView).

### Desenvolvido com:

Nesta seção estão algumas tecnologias que usamos para desenvolver a aplicação.

- Flutter  
- Postgres  
- Dart  
- C++  
- CMake  
- SQL  

---

# 📌Funcionalidades

[(Voltar ao topo)](#Sumário)

- 🧠 **Multi-IA**: seleção/configuração dinâmica do modelo por tipo de tarefa.
- 🧵 **Histórico persistente**: conversas salvas com sincronização e resgate de contexto.
- ⚙️ **Automação local**: execute comandos do sistema operacional com linguagem natural.
- 🧩 **Sistema de plugins**: Suporta plugins/agents externos para expandir capacidades (voz, IoT, notificações, etc.).
- 📡 **Interface universal**: disponível via desktop (Electron), app mobile (Flutter/WebView) e API local.

---

## ❓FAQ

[(Voltar ao topo)](#Sumário)


#### ❓ É gratuito?

Depende dos modelos utilizados. Alguns oferecem camadas gratuitas com limites. Ex:

OpenAI: $5 no início (plano gratuito)

DeepSeek: limitado por uso

Gemini: possui versão gratuita

Você pode optar por modelos open-source locais (ex: Ollama, Mistral) para fugir de taxas.

#### ❓ Funciona offline?

Parcialmente. Com IA local e sem TTS/STT por nuvem, o sistema pode funcionar offline. Funções de API exigem internet.

#### ❓ Que sistema operacional é compatível?

✅ Windows 10+

✅ Android (via app)

✅ Web compatível (em breve)

---

# 🔐Variáveis de Ambiente

[(Voltar ao topo)](#Sumário)

Crie um .env na raiz do projeto com as chaves de API:

OPENAI_API_KEY = suachave

DEEPSEEK_API_KEY = suachave

GEMINI_API_KEY = suachave

MISTRAL_API_KEY = suachave

---

# 🤝Contribuindo

Adoramos novas ideias, bugs corrigidos e feedbacks!

Faça fork

Crie uma branch: feature/minha-ideia-top

Commit com mensagens claras

Envie um PR com:

O que você fez

Por que fez

Como testar

---

# 🗺️Roadmap

[(Voltar ao topo)](#Sumário)

- [x] README detalhado e organizado 📘  
- [x] Integração com múltiplas IAs via API (GPT, DeepSeek, etc.)
- [x] Histórico sincronizado entre dispositivos
- [x] Protótipo visual no Figma com fluxos principais
- [ ] Interface desktop funcional com automações básicas
- [ ] Aplicativo mobile conectado ao backend principal
- [ ] Sistema de plugins com suporte à criação por usuários

---

# 👨‍💻Autores

[(Voltar ao topo)](#Sumário)

- [Ryan Bezerra](https://www.github.com/RyanBezerra)
- [Matheus Farias](https://github.com/Matheusota2k)
- [Otavio Fernando](https://github.com/otav-io)
- [Luiz Ramalho](https://github.com/luizmont5)

---

# 🔧Instalação

### 1. Clonar o repositório

```bash
git clone "https://github.com/RyanBezerra/CoreMind.git"
cd CoreMind

---

