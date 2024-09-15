import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ChatService extends ChangeNotifier {
  final List<String> messages = [];
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool isListening = false;
  String currentSpeech = '';
  Timer? _silenceTimer;

  ChatService() {
    _initializeSpeech();
    _initializeTts();
  }

  Future<void> _initializeSpeech() async {
    await _speech.initialize();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
  }

  void startListening() {
    if (!isListening) {
      _speech.listen(
        onResult: (result) {
          currentSpeech = result.recognizedWords;
          _resetSilenceTimer();
          notifyListeners();
        },
        localeId: "en-US",
      );
      isListening = true;
      notifyListeners();
    }
  }

  void stopListening() {
    _speech.stop();
    isListening = false;
    notifyListeners();
  }

  void stopSpeaking() async {
    await _flutterTts.stop();
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(Duration(seconds: 3), () {
      if (currentSpeech.isNotEmpty) {
        sendMessageToChatGPT(currentSpeech);
      }
      stopListening();
    });
  }

  Future<void> sendMessageToChatGPT(String message) async {
    messages.add("User: $message");
    notifyListeners();

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer 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',
      },
      body: jsonEncode({
        "model": "gpt-4-turbo-2024-04-09",
        "messages": [
          {"role": "system", "content": "You are a helpful assistant."},
          {
            "role": "user",
            "content":
                "Understand the user's conversation and provide advice as an expert in three lines. {$message}"
          },
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final reply = data['choices'][0]['message']['content'];
      messages.add("Assistant: $reply");
      notifyListeners();
      speakResponse(reply);
    } else {
      print('Failed to get response from ChatGPT');
    }
  }

  Future<void> speakResponse(String response) async {
    await _flutterTts.speak(response);
  }

  void resetChat() {
    messages.clear();
    notifyListeners();
  }
}
