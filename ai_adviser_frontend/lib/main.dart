import 'package:ai_adviser_frontend/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Word Cloud ChatGPT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';

  Future<void> _sendToChatGPT(String message) async {
    final uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    final apiKey = AppConstants.apiKey;

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: json.encode({
        'model': 'gpt-4o',
        'messages': [
          {
            'role': 'system',
            'content':
                "Understand the user's conversation, predict what they're interested in, and output what they're likely to be interested in. {$message}"
          },
        ],
        'max_tokens': 150
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _response = data['choices'][0]['message']['content'];
      });
    } else {
      throw Exception('Failed to communicate with ChatGPT');
    }
  }

  void _analyseText() {
    final text = _controller.text;
    final words = text.split(' ');
    final frequencies = <String, int>{};

    for (var word in words) {
      frequencies[word] = (frequencies[word] ?? 0) + 1;
    }

    // 最も出現頻度の高い単語を抽出
    final sortedEntries = frequencies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final mostCommonWords = sortedEntries.take(5).map((e) => e.key).join(', ');

    _sendToChatGPT(mostCommonWords);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Cloud ChatGPT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: '会話テキストを入力してください',
              ),
              maxLines: null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _analyseText,
              child: const Text('予測してChatGPTに質問'),
            ),
            const SizedBox(height: 16),
            Text(
              'ChatGPTからの応答:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_response),
          ],
        ),
      ),
    );
  }
}
