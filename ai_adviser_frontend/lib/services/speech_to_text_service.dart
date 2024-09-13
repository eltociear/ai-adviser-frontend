import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToTextService {
  final stt.SpeechToText _speech = stt.SpeechToText();  // 音声認識ライブラリのインスタンスを作成

  Future<String> listen() async {
    bool available = await _speech.initialize();  // 音声認識の初期化
    if (!available) {
      return 'Speech recognition not available.';  // 初期化失敗時のメッセージ
    }

    String transcription = '';
    await _speech.listen(
      onResult: (result) {
        transcription = result.recognizedWords;  // 音声をテキストに変換
      },
      listenFor: Duration(seconds: 5),  // 認識を続ける時間
    );

    await Future.delayed(Duration(seconds: 5));  // タイムアウトまで待つ
    _speech.stop();  // 音声認識を停止
    return transcription;  // 変換されたテキストを返す
  }
}
