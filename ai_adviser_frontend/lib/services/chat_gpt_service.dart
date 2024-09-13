import 'package:dio/dio.dart';

class ChatGptService {
  final Dio _dio = Dio();  // HTTPリクエストを送信するためのDioクライアント

  // OpenAI APIの基本設定。ここにAPIエンドポイントを設定する
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';  // OpenAI APIのエンドポイント
  final String apiKey = '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';  // OpenAI APIキー

  Future<String> fetchResponse(String prompt) async {
    try {
      // APIに対してPOSTリクエストを送信
      final response = await _dio.post(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $apiKey'},  // 認証ヘッダーを設定
        ),
        data: {
          'model': 'text-davinci-003',  // 使用するモデルを指定
          'prompt': prompt,  // ユーザーの入力をプロンプトとして送信
          'max_tokens': 150,  // 応答で使用する最大トークン数
        },
      );
      return response.data['choices'][0]['text'].toString().trim();  // 応答テキストを整形して返す
    } catch (e) {
      return 'Error fetching response: $e';  // エラー時のメッセージ
    }
  }
}
