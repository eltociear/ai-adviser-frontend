import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/chat_service.dart';
import '../widgets/chat_message.dart';
import '../widgets/voice_input_button.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Chat')),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ChatService>(
              builder: (context, chatService, child) {
                return ListView.builder(
                  itemCount: chatService.messages.length,
                  itemBuilder: (context, index) {
                    return ChatMessage(message: chatService.messages[index]);
                  },
                );
              },
            ),
          ),
          VoiceInputButton(),
        ],
      ),
    );
  }
}
