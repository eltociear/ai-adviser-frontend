import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:async';

class SpeechRecognitionService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';
  Timer? _silenceTimer;

  Future<bool> initialize() async {
    return await _speech.initialize();
  }

  void startListening(Function(String) onResult, Function() onSilence) async {
    if (!_isListening) {
      _isListening = true;
      await _speech.listen(
        onResult: (result) {
          _text = result.recognizedWords;
          onResult(_text);
          _resetSilenceTimer(onSilence);
        },
      );
    }
  }

  void stopListening() {
    _speech.stop();
    _isListening = false;
    _silenceTimer?.cancel();
  }

  void _resetSilenceTimer(Function() onSilence) {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(Duration(seconds: 2), () {
      stopListening();
      onSilence();
    });
  }
}
