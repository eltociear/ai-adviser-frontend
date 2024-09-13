import 'package:speech_to_text/speech_to_text.dart'; // 音声認識ライブラリをインポート

class SpeechService {
  final SpeechToText _speech = SpeechToText(); // SpeechToTextのインスタンスを作成
  bool _isListening = false; // 音声認識中かどうかを示すフラグ

  void initialize() async {
    await _speech.initialize(); // 音声認識を初期化
  }

  void startListening(Function(String) onResult) {
    // 音声認識を開始するメソッド
    _speech.listen(onResult: (result) {
      // 音声認識結果を受け取るコールバック
      if (result.finalResult) {
        // 最終結果の場合
        _isListening = false; // 音声認識中フラグをオフ
        _speech.stop(); // 音声認識を停止
      }
    });
    _isListening = true; // 音声認識中フラグをオン
  }
}
