import 'package:http/http.dart' as http; // HTTPリクエストライブラリをインポート
import 'dart:convert'; // JSONエンコード/デコードライブラリをインポート

class ChatGptService {
  final String _apiKey = 'YOUR_API_KEY'; // ChatGPT APIキーをここに入力

  Future<String> getResponse(String prompt) async {
    // ChatGPTにプロンプトを送信して応答を取得するメソッド
    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'), // APIエンドポイント
      headers: {
        'Content-Type': 'application/json', // リクエストのコンテンツタイプ
        'Authorization': 'Bearer $_apiKey', // APIキーを使用して認証
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo', // 使用するモデル
        'messages': [{'role': 'user', 'content': prompt}], // ユーザーからのメッセージ
      }),
    );

    if (response.statusCode == 200) {
      // ステータスコードが200の場合（成功）
      final data = jsonDecode(response.body); // レスポンスをデコード
      return data['choices'][0]['message']['content']; // 応答メッセージを返す
    } else {
      throw Exception('Failed to load response'); // エラーハンドリング
    }
  }
}
