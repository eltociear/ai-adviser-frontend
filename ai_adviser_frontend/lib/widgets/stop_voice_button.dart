import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';

class StopVoiceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatService>(
      builder: (context, chatService, child) {
        return FloatingActionButton(
          onPressed: () {
            chatService.stopListening();
          },
          child: Icon(Icons.stop),
        );
      },
    );
  }
}
