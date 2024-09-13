import 'package:flutter/material.dart';

class SpeechRecognitionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SpeechRecognitionButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: Icon(Icons.mic),
    );
  }
}
