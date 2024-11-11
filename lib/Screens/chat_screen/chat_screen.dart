import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import '../constants/background_video.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  final Gemini gemini = Gemini.instance;

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
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

  void _sendMessage(String message) async {
    if (message.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: message, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    String promptPrefix = "You are a Flutter expert AI assistant. Your task is to answer questions and provide help specifically related to Flutter development. Please focus your responses on Flutter-specific information, best practices, and solutions. Now, please answer the following question: ";
    String fullPrompt = promptPrefix + message;

    try {
      gemini.streamGenerateContent(fullPrompt).listen((event) {
        String response = event.content?.parts?.fold('', (previous, current) => '$previous ${current.text}') ?? '';
        setState(() {
          _messages.add(ChatMessage(text: response, isUser: false));
          _isLoading = false;
        });
        _scrollToBottom();
      }, onDone: () {
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideoWidget(),
          SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return Container(
                        alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        child: ChatBubble(text: message.text, isUser: message.isUser),
                      );
                    },
                  ),
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type your message...',
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.2),
                            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF8A2BE2), Color(0xFF9400D3)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: ImageIcon(AssetImage("lib/Assets/images/icon.png")),
                          onPressed: () {
                            final message = _controller.text.trim();
                            if (message.isNotEmpty) {
                              _controller.clear();
                              _sendMessage(message);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  ChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isUser
              ? [const Color(0xFF80B1BD), const Color(0xFFFBCFD8)]
              : [const Color(0xFFCAA5A5), const Color(0xFFB8AAAA)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(15.0),
          topRight: const Radius.circular(15.0),
          bottomLeft: isUser ? const Radius.circular(15.0) : Radius.zero,
          bottomRight: isUser ? Radius.zero : const Radius.circular(15.0),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}