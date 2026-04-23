import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mc_project/consts.dart';
// ADD THIS IMPORT to fix the "Undefined name DefaultFirebaseOptions" error
import 'firebase_options.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Content> _chatHistory = [
    Content.text(
        "Your name is Dawn. You are a cool, modern mental health advisor. "
            "Keep replies punchy and short. No long paragraphs. Use emojis occasionally. "
            "English only. Max 50 words. Be friendly but chill."
    ),
    Content.model([TextPart("Hi! I'm Dawn. I'm here to keep it real and help you out. What's up?")]),
  ];

  final List<Map<String, String>> _displayMessages = [
    {'role': 'model', 'text': "Hi! I'm Dawn. I'm here to keep it real and help you out. What's up?"}
  ];

  late GenerativeModel _model;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initModel(); // Calling the async init method exactly like your image
  }

  // UPDATED: This method now matches your provided image exactly
  Future<void> _initModel() async {
    const apiKey = GOOGLE_API_KEY;
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // Use 1.5-flash for the best free performance in 2025
      apiKey: apiKey,
    );
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    setState(() {
      _chatHistory.add(Content.text(text));
      _displayMessages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await _model.generateContent(_chatHistory);
      final responseText = response.text ?? "I'm drawing a blank, try again?";

      setState(() {
        _chatHistory.add(Content.model([TextPart(responseText)]));
        _displayMessages.add({'role': 'model', 'text': responseText.trim()});
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _displayMessages.add({'role': 'model', 'text': "My bad, something went wrong. Check your connection!"});
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Dawn AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple.shade700,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/thirdpage.png"),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(15),
                itemCount: _displayMessages.length,
                itemBuilder: (context, index) {
                  final msg = _displayMessages[index];
                  final isUser = msg['role'] == 'user';

                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.purple.shade400 : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft: Radius.circular(isUser ? 15 : 0),
                          bottomRight: Radius.circular(isUser ? 0 : 15),
                        ),
                        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(2, 2))],
                      ),
                      child: isUser
                          ? Text(msg['text']!, style: const TextStyle(color: Colors.white))
                          : MarkdownBody(
                        data: msg['text']!,
                        styleSheet: MarkdownStyleSheet(p: const TextStyle(color: Colors.black87)),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: LinearProgressIndicator()),

            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: 'Talk to Dawn...',
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.purple.shade700,
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _handleSendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}