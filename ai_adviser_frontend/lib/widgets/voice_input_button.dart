import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';

class VoiceInputButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatService>(
      builder: (context, chatService, child) {
        return FloatingActionButton(
          onPressed: () {
            if (chatService.isListening) {
              chatService.stopListening();
            } else {
              chatService.startListening();
            }
          },
          child: Icon(chatService.isListening ? Icons.mic : Icons.mic_none),
        );
      },
    );
  }
}
