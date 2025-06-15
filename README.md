# �� ChatBot CoreMind

## 📝 Descrição
O ChatBot CoreMind é uma aplicação web interativa desenvolvida com Streamlit que utiliza a API do Google Gemini para fornecer respostas inteligentes às perguntas dos usuários. O chatbot é projetado para responder em português do Brasil, mantendo um tom formal mas amigável.

## ✨ Funcionalidades
- Interface de chat intuitiva e responsiva
- Integração com a API do Google Gemini
- Respostas em português do Brasil (pt-BR)
- Histórico de conversas mantido durante a sessão
- Botão para limpar o histórico do chat
- Tratamento de erros robusto
- Design moderno e amigável

## 🛠️ Tecnologias Utilizadas
- Python 3.x
- Streamlit (Framework web)
- Google Gemini API (IA generativa)
- Requests (Para chamadas HTTP)
- Python-dotenv (Gerenciamento de variáveis de ambiente)
- Cryptography (Segurança)

## 🚀 Como Executar o Projeto

### Pré-requisitos
- Python 3.x instalado
- pip (gerenciador de pacotes Python)
- Chave de API do Google Gemini

### Instalação

1. Clone o repositório:
```bash
git clone [URL_DO_REPOSITÓRIO]
cd CoreMind
```

2. Crie e ative um ambiente virtual:
```bash
python -m venv venv
# No Windows:
venv\Scripts\activate
# No Linux/Mac:
source venv/bin/activate
```

3. Instale as dependências:
```bash
pip install -r requirements.txt
```

4. Configure a chave da API:
   - Substitua a variável `GEMINI_API_KEY` no arquivo `app.py` com sua chave de API do Google Gemini

5. Execute a aplicação:
```bash
streamlit run app.py
```

## 💻 Uso
1. Acesse a aplicação através do navegador (geralmente em http://localhost:8501)
2. Digite sua pergunta no campo de entrada
3. Aguarde a resposta do chatbot
4. Use o botão "Limpar Chat" para reiniciar a conversa

## 🔒 Segurança
- A aplicação utiliza HTTPS para comunicação segura
- A chave da API está protegida
- Implementação de tratamento de erros para falhas de API
- Validação de respostas da API

## 👥 Equipe de Desenvolvimento
- Matheus Farias
- Ryan do Nascimento
- Otávio Fernandes
- Luiz Fernando
- Lauro Michel





# 🤖 ChatBot CoreMind

Um chatbot inteligente construído com Streamlit e Google Gemini API.

## 🔐 Configuração Segura

Para configurar o projeto de forma segura, siga estes passos:

1. Instale as dependências:
```bash
pip install -r requirements.txt
```

2. Execute o script de criptografia para gerar as configurações seguras:
```bash
python encrypt_key.py
```

3. Crie um arquivo `.env` na raiz do projeto e adicione as configurações geradas pelo script.

4. Compartilhe a senha de criptografia (`ENCRYPTION_PASSWORD`) de forma segura com sua equipe.

## ⚠️ Importante

- Nunca compartilhe o arquivo `.env`
- Nunca compartilhe a chave API original
- Mantenha a senha de criptografia em um local seguro
- O arquivo `.env` está no `.gitignore` por segurança

## 🚀 Executando o Projeto

```bash
streamlit run app.py
```

## 📝 Estrutura do Projeto

- `app.py`: Aplicação principal do chatbot
- `crypto_utils.py`: Utilitários de criptografia
- `encrypt_key.py`: Script para criptografar a chave API
- `.env`: Arquivo de configuração (não versionado)
- `requirements.txt`: Dependências do projeto 
