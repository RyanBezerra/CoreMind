# ChatBot CoreMind

Um chatbot interativo construído com Streamlit e OpenAI GPT-3.5.

## Requisitos

- Python 3.8 ou superior
- Conta na OpenAI com acesso à API

## Instalação

1. Clone este repositório
2. Instale as dependências:
```bash
pip install -r requirements.txt
```

3. Crie um arquivo `.env` na raiz do projeto e adicione sua chave API da OpenAI:
```
OPENAI_API_KEY=sua_chave_api_aqui
```

## Como executar

Execute o seguinte comando no terminal:
```bash
streamlit run app.py
```

O chatbot estará disponível em `http://localhost:8501`

## Funcionalidades

- Interface amigável com Streamlit
- Histórico de conversas
- Botão para limpar o chat
- Integração com GPT-3.5
- Tratamento de erros
- Design responsivo 