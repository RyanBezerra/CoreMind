import streamlit as st
import requests
import json

# Configurar a chave da API do Gemini
GEMINI_API_KEY = "AIzaSyC7GVXgEb8jVnLHYPDrKM2hI2bD8RsjO7E"
API_URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={GEMINI_API_KEY}"

# Configurar a página
st.set_page_config(
    page_title="ChatBot CoreMind",
    page_icon="🤖",
    layout="centered"
)

# Título e descrição
st.title("🤖 ChatBot CoreMind")
st.markdown("""
    Bem-vindo ao ChatBot CoreMind! 
    Faça suas perguntas e eu tentarei ajudar da melhor forma possível.
""")

# Inicializar o histórico de chat na sessão
if "messages" not in st.session_state:
    st.session_state["messages"] = [
        {"role": "system", "content": "Você é um assistente virtual que deve responder APENAS em português do Brasil (pt-BR). Use linguagem formal mas amigável, e mantenha suas respostas claras e objetivas."}
    ]

# Exibir o histórico de mensagens
for message in st.session_state["messages"]:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Campo de entrada para o usuário
if prompt := st.chat_input("Digite sua mensagem aqui..."):
    # Adicionar mensagem do usuário ao histórico
    st.session_state["messages"].append({"role": "user", "content": prompt})
    
    # Exibir mensagem do usuário
    with st.chat_message("user"):
        st.markdown(prompt)
    
    # Gerar resposta do chatbot
    with st.chat_message("assistant"):
        try:
            # Preparar os dados para a requisição
            data = {
                "contents": [
                    {
                        "parts": [
                            {
                                "text": prompt
                            }
                        ]
                    }
                ]
            }
            
            # Fazer a requisição para a API
            response = requests.post(
                API_URL,
                headers={"Content-Type": "application/json"},
                json=data,
                timeout=30
            )
            
            if response.status_code == 401:
                st.error("Erro de autenticação. Por favor, verifique se a chave API está correta.")
            else:
                response.raise_for_status()
                response_data = response.json()
                
                if "candidates" in response_data and len(response_data["candidates"]) > 0:
                    assistant_response = response_data["candidates"][0]["content"]["parts"][0]["text"]
                    st.markdown(assistant_response)
                    
                    # Adicionar resposta do assistente ao histórico
                    st.session_state["messages"].append({"role": "assistant", "content": assistant_response})
                else:
                    st.error("Resposta inesperada da API")
                    st.json(response_data)
            
        except requests.exceptions.RequestException as e:
            st.error(f"Erro na requisição: {str(e)}")
            if hasattr(e.response, 'text'):
                st.json(e.response.json())
        except Exception as e:
            st.error(f"Ocorreu um erro: {str(e)}")
            st.info("Por favor, verifique se a chave API está correta e se o serviço está disponível.")

# Adicionar um botão para limpar o chat
if st.button("Limpar Chat"):
    st.session_state["messages"] = []
    st.rerun() 