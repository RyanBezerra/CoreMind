import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mensagem.dart';

class DeepSeekService {
  static const String _baseUrl = 'https://openrouter.ai/api/v1';
  static const String _apiKey = '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';

  Future<String> sendMessage(String message, List<Mensagem> historico) async {
    try {
      List<Map<String, String>> mensagens = [
        {
          'role': 'system',
          'content': 'Responda sempre em português, a menos que o usuário peça para responder em outro idioma.'
        },
      ];
      for (var m in historico) {
        mensagens.add({
          'role': m.eUsuario ? 'user' : 'assistant',
          'content': m.texto,
        });
      }
      mensagens.add({
        'role': 'user',
        'content': message,
      });

      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'deepseek/deepseek-chat-v3-0324:free',
          'messages': mensagens,
          'temperature': 0.7,
          'max_tokens': 1000,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        print('Erro na resposta da API: ${response.statusCode}');
        print('Corpo da resposta: ${response.body}');
        throw Exception('Erro na requisição: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao enviar mensagem: $e');
      rethrow;
    }
  }

  Future<void> limparConversasVazias(int usuarioId) async {
    // Implemente a lógica para limpar conversas vazias
  }
} 