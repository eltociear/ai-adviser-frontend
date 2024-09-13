import 'package:flutter/material.dart';
import '../services/speech_recognition_service.dart';
import '../services/chatgpt_service.dart';
import '../services/text_to_speech_service.dart';
import '../widgets/speech_recognition_button.dart';
import '../widgets/chat_message_bubble.dart';
import '../models/chat_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SpeechRecognitionService _speechService = SpeechRecognitionService();
  final ChatGPTService _chatGPTService = ChatGPTService();
  final TextToSpeechService _ttsService = TextToSpeechService();

  List<ChatMessage> _messages = [];
  String _currentSpeech = '';

  @override
  void initState() {
    super.initState();
    _speechService.initialize();
  }

  void _startListening() {
    _speechService.startListening(
      (text) {
        setState(() {
          _currentSpeech = text;
        });
      },
      _onSilenceDetected,
    );
  }

  void _onSilenceDetected() async {
    if (_currentSpeech.isNotEmpty) {
      setState(() {
        _messages.add(ChatMessage(text: _currentSpeech, isUser: true));
      });

      final response = await _chatGPTService.generateResponse(_currentSpeech);
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });

      await _ttsService.speak(response);

      setState(() {
        _currentSpeech = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI Assistant')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatMessageBubble(message: _messages[index]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_currentSpeech),
          ),
          SpeechRecognitionButton(onPressed: _startListening),
        ],
      ),
    );
  }
}
