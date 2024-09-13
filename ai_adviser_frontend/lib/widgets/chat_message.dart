import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String message;

  const ChatMessage({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isUserMessage = message.startsWith("User: ");
    return Align(
      alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message.substring(message.indexOf(": ") + 2),
          style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
