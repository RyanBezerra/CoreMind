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