import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mc_project/consts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DiaryEntryScreen extends StatefulWidget {
  const DiaryEntryScreen({super.key});

  @override
  _DiaryEntryScreenState createState() => _DiaryEntryScreenState();
}

class _DiaryEntryScreenState extends State<DiaryEntryScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isGenerating = false;
  late Future<void> _initFuture;
  late GenerativeModel _model;

  String _formattedDate = '';
  String _report = "";

  @override
  void initState() {
    super.initState();
    _initFuture = _initModel();
    _updateDate();
  }

  // PRESERVED API LOGIC
  Future<void> _initModel() async {
    const apiKey = GOOGLE_API_KEY;
    if (apiKey.isEmpty) {
      throw Exception("API Key constant is empty.");
    }
    _model = GenerativeModel(
      model: 'gemini-2.5-flash', // Updated to a stable identifier
      apiKey: apiKey,
    );
  }

  // PRESERVED API LOGIC
  Future<String> _callGeminiDirect(String diaryEntry) async {
    if (_model == null) {
      throw Exception("AI model not initialized.");
    }

    const promptTemplate = """
      Analyze the following diary entry for:
      - Emotional tone
      - Potential signs of stress or mental health indicators
      - A short, single actionable suggestion
      Format response in clean markdown.
    """;

    final response = await _model.generateContent([
      Content.text("$promptTemplate\n\nDiary Entry: \"$diaryEntry\"")
    ]);

    return response.text ?? "No analysis generated.";
  }

  Future<void> _saveEntry() async {
    // Check if the initialization future is done
    if (_initFuture != null) {
      await _initFuture;
    }

    final diaryEntry = _textController.text;

    if (diaryEntry.trim().isEmpty) {
      setState(() {
        _report = "Please enter some text to generate a report.";
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _report = ""; // Clear previous report
    });

    try {
      String reportText = await _callGeminiDirect(diaryEntry);
      setState(() {
        _report = reportText;
      });
    } catch (e) {
      setState(() {
        _report = "Network connection failed or API issue occurred. Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  void _updateDate() {
    setState(() {
      _formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFFFFFAEC),
            body: Center(child: CircularProgressIndicator(color: Colors.purple)),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Initialization Error: ${snapshot.error}')),
          );
        }
        return _buildDiaryContent();
      },
    );
  }

  Widget _buildDiaryContent() {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('My Journal', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/chatbg3.png"),
            fit: BoxFit.cover,
            opacity: 0.5, // Softened background to make text readable
          ),
          color: Color(0xFFFFFAEC), // Cream fallback matching dashboard
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(25, 120, 25, 40),
          child: Column(
            children: [
              Text(
                'Today is $_formattedDate',
                style: const TextStyle(fontSize: 16, color: Colors.purple, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              const SizedBox(height: 30),

              // STYLIZED INPUT BOX
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.purple.withOpacity(0.1), width: 2),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: 15,
                  style: const TextStyle(color: Color(0xFF2D3142), fontSize: 17, fontWeight: FontWeight.w500),
                  decoration: const InputDecoration(
                    hintText: 'Share your thoughts with Dawn...',
                    hintStyle: TextStyle(color: Colors.black38),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(25),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // ACTION BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isGenerating ? null : _saveEntry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5D6D4E), // Mossy Green from Dashboard
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 0,
                  ),
                  child: _isGenerating
                      ? const SizedBox(width: 25, height: 25, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                      : const Text('Generate Vibe Check', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),

              const SizedBox(height: 30),

              // REPORT DISPLAY
              if (_report.isNotEmpty && !_isGenerating)
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
                  ),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: _report.split('\n').map((line) {
                            if (line.startsWith('**')) {
                              return TextSpan(
                                text: '${line.replaceAll('**', '')}\n',
                                style: const TextStyle(fontWeight: FontWeight.w900, color: Colors.purple, fontSize: 18, height: 2),
                              );
                            } else if (line.trim().startsWith('*')) {
                              return TextSpan(
                                text: '• ${line.replaceAll('*', '')}\n',
                                style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                              );
                            } else {
                              return TextSpan(
                                text: '$line\n',
                                style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
                              );
                            }
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _report));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report copied!')));
                        },
                        icon: const Icon(Icons.copy_rounded, color: Colors.purple),
                        label: const Text("Copy to Clipboard", style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}