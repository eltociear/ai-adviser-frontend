import 'package:dio/dio.dart';

class ChatGPTService {
  final Dio _dio = Dio();
  final String _apiKey = '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';

  ChatGPTService() {
    _dio.options.headers['Authorization'] = 'Bearer $_apiKey';
    _dio.options.baseUrl = 'https://api.openai.com/v1';
  }

  Future<String> generateResponse(String prompt) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-4o-2024-05-13',
          'messages': [
            {'role': 'system', 'content': 'あなたは有能なアシスタントです。ユーザーの興味を分析し、それに関連する情報を提供してください。'},
            {'role': 'user', 'content': prompt},
          ],
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to generate response');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
