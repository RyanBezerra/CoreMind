import streamlit as st
import requests
import json

API_KEY = "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"
API_URL = "https://openrouter.ai/api/v1/chat/completions"

st.set_page_config(
    page_title="ChatBot CoreMind",
    page_icon="🤖",
    layout="centered"
)

st.title("🤖 ChatBot CoreMind")
st.markdown("""
    Bem-vindo ao ChatBot CoreMind! 
    Faça suas perguntas e eu tentarei ajudar da melhor forma possível.
""")

if "messages" not in st.session_state:
    st.session_state["messages"] = [
        {"role": "system", "content": "Você é um assistente virtual que deve responder APENAS em português do Brasil (pt-BR). Use linguagem formal mas amigável, e mantenha suas respostas claras e objetivas."}
    ]

for message in st.session_state["messages"]:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

if prompt := st.chat_input("Digite sua mensagem aqui..."):
    st.session_state["messages"].append({"role": "user", "content": prompt})
    
    with st.chat_message("user"):
        st.markdown(prompt)
    
    with st.chat_message("assistant"):
        try:
            headers = {
                "Authorization": f"Bearer {API_KEY}",
                "Content-Type": "application/json",
                "HTTP-Referer": "http://localhost:8501",
                "X-Title": "CoreMind ChatBot"
            }
            
            data = {
                "model": "deepseek/deepseek-r1-0528-qwen3-8b:free",
                "messages": [
                    {"role": m["role"], "content": m["content"]}
                    for m in st.session_state["messages"]
                ],
                "temperature": 0.7,
                "max_tokens": 2000
            }
            
            response = requests.post(
                API_URL,
                headers=headers,
                json=data,
                timeout=30
            )
            
            if response.status_code == 401:
                st.error("Erro de autenticação. Por favor, verifique se a chave API está correta.")
                st.info("A chave API deve começar com 'sk-or-v1-'")
            else:
                response.raise_for_status()
                
                response_data = response.json()
                if "choices" in response_data and len(response_data["choices"]) > 0:
                    assistant_response = response_data["choices"][0]["message"]["content"]
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

if st.button("Limpar Chat"):
    st.session_state["messages"] = []
    st.rerun() 