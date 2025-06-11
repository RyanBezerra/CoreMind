# 🤖 Assistente Virtual Híbrido

Este projeto propõe um assistente virtual híbrido que:

- Integra múltiplas IAs via APIs (DeepSeek, Gemini, Mistral, GPT‑4…).
- Mantém contexto e histórico sincronizados entre sessões.
- Executa comandos e automações no desktop (abrir apps, gerenciar arquivos, executar scripts).
- Suporta plugins/agents externos para expandir capacidades (voz, IoT, notificações, etc.).
- Oferece arquitetura desktop e app mobile (Flutter / React Native / WebView).
---

## 🧩 Funcionalidades

- 🧠 **Multi-IA**: seleção/configuração dinâmica do modelo por tipo de tarefa.
- 🧵 **Histórico persistente**: conversas salvas com sincronização e resgate de contexto.
- ⚙️ **Automação local**: execute comandos do sistema operacional com linguagem natural.
- 🧩 **Sistema de plugins**: Suporta plugins/agents externos para expandir capacidades (voz, IoT, notificações, etc.).
- 📡 **Interface universal**: disponível via desktop (Electron), app mobile (Flutter/WebView) e API local.

### 🔧 Arquitetura do Projeto

┌──────────────┐
│ Interface UI │
└──────┬───────┘
│
WebSocket / HTTP
▼
┌────────────────────┐
│ Core Engine │
├────────────────────┤
│ 🔁 Histórico │
│ 🧠 Seleção IA │
│ ⚙️ Comandos locais │
│ 🔌 Plugins │
└────────────────────┘
│
▼
┌─────────────┐ ┌─────────────┐
│ Modelos LLM │ │ Comandos OS │
│ (GPT, etc.) │ │ Bash, Win32 │
└─────────────┘ └─────────────┘
---

## ❓ FAQ

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

#### ❓ Como eu crio um plugin?

Você cria um diretório dentro de plugins/, com:

plugin.json: metadados e triggers

main.py: função handle_event(event, context)

Exemplo:

json
Copiar
Editar
{
  "name": "gerador_de_poema",
  "trigger": ["escreve um poema"],
  "description": "Gera poemas com GPT"
}---

## 🔐 Variáveis de Ambiente

Crie um .env na raiz do projeto com as chaves de API:

OPENAI_API_KEY = suachave
DEEPSEEK_API_KEY = suachave
GEMINI_API_KEY = suachave
MISTRAL_API_KEY = suachave
## 🤝 Contribuindo

Adoramos novas ideias, bugs corrigidos ou maluquices implementadas 🧪

Faça fork

Crie uma branch: feature/minha-ideia-top

Commit com mensagens claras

Envie um PR com:

O que você fez

Por que fez

Como testar

## Autores

- [@RyanBezerra](https://www.github.com/RyanBezerra)
- [@MatheusFarias](https://www.github.com/MatheusFarias)
- [@OtavioFMiranda](https://www.github.com/OtavioFMiranda)
- [@LuizMamadissimo](https://www.github.com/LuizMamadissimo)
---

## 💾 Instalação

### 1. Clonar o repositório

```bash
git clone "blablabla"
cd assistente-virtual