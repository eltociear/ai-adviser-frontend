import 'package:flutter/material.dart'; // Flutterのマテリアルデザインライブラリをインポート
import 'speech_service.dart'; // 音声認識サービスをインポート
import 'chatgpt_service.dart'; // ChatGPTサービスをインポート
import 'package:flutter_tts/flutter_tts.dart'; // テキストを音声に変換するライブラリをインポート

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState(); // ステートを作成
}

class _HomePageState extends State<HomePage> {
  final SpeechService _speechService = SpeechService(); // 音声サービスのインスタンスを作成
  final ChatGptService _chatGptService = ChatGptService(); // ChatGPTサービスのインスタンスを作成
  final FlutterTts _flutterTts = FlutterTts(); // テキスト音声変換サービスのインスタンスを作成
  String _recognizedText = ''; // 認識されたテキストを保持する変数
  String _responseText = ''; // ChatGPTからの応答を保持する変数

  @override
  void initState() {
    super.initState(); // ステートの初期化
    _speechService.initialize(); // 音声サービスを初期化
  }

  void _startListening() {
    // 音声認識を開始するメソッド
    _speechService.startListening((text) {
      // 音声認識結果を受け取るコールバック
      setState(() {
        _recognizedText = text; // 認識されたテキストを更新
      });
    });
  }

  void _sendToChatGpt() async {
    // ChatGPTにテキストを送信するメソッド
    await Future.delayed(Duration(seconds: 3)); // 3秒待機
    String response = await _chatGptService.getResponse(_recognizedText); // ChatGPTからの応答を取得
    setState(() {
      _responseText = response; // 応答テキストを更新
    });
    _speak(response); // 応答を音声で出力
  }

  void _speak(String text) async {
    // テキストを音声で出力するメソッド
    await _flutterTts.speak(text); // テキストを音声に変換して再生
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Chat App')), // アプリバーにタイトルを表示
      body: Column(
        children: [
          Text('Recognized Text: $_recognizedText'), // 認識されたテキストを表示
          Text('ChatGPT Response: $_responseText'), // ChatGPTからの応答を表示
          ElevatedButton(
            onPressed: () {
              _startListening(); // 音声認識を開始
              _sendToChatGpt(); // ChatGPTに送信
            },
            child: Text('Start Listening'), // ボタンのテキスト
          ),
        ],
      ),
    );
  }
}
