import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

final String _apiKey = dotenv.env['API_KEY'] ?? '';
final String _apiUrl = dotenv.env['API_URL'] ?? '';


class ChatBotWidget extends StatefulWidget {
  const ChatBotWidget({super.key});

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _onTap() {
    _scaleController.forward().then((_) {
      _scaleController.reverse();
    });

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const ChatBotScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeInOutCubic;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: GestureDetector(
        onTap: _onTap,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pulseAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.4),
                      blurRadius: 20 * _pulseAnimation.value,
                      spreadRadius: 5 * _pulseAnimation.value,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.smart_toy_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;
  bool _isRecording = false;
  bool _isRecordingLocked = false;
  bool _showVoiceUI = false;
  double _recordingDuration = 0.0;

  late AnimationController _typingController;
  late AnimationController _recordingController;
  late AnimationController _waveController;
  late Animation<double> _typingAnimation;
  late Animation<double> _recordingScaleAnimation;
  late Animation<double> _waveAnimation;


  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _addWelcomeMessage();
  }

  void _initializeAnimations() {
    _typingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _typingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _typingController, curve: Curves.easeInOut),
    );
    _recordingScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _recordingController, curve: Curves.elasticOut),
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingController.dispose();
    _recordingController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        text: "Hey there! 👋 I'm your AI assistant, ready to help with anything you need. Ask me questions, get creative, or just chat - I'm here for you!",
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    HapticFeedback.lightImpact();
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();
    _typingController.repeat();

    try {
      final response = await _sendToGrok(text);
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
      });
    } catch (e) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          text: "Oops! I'm having trouble connecting right now. Could you try again? 🔄",
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
      });
    }

    _typingController.reset();
    _scrollToBottom();
  }

  Future<String> _sendToGrok(String message) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    };

    final body = json.encode({
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful, friendly AI assistant. Use emojis occasionally to make conversations more engaging. Keep responses conversational and helpful.'
        },
        {
          'role': 'user',
          'content': message,
        }
      ],
      'model': 'grok-beta',
      'stream': false,
      'temperature': 0.7,
    });


    final response = await http.post(
      Uri.parse(dotenv.env['API_URL']!),
      headers: {
        'Authorization': 'Bearer ${dotenv.env['API_KEY']}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message},
        ],
      }),
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get response from Grok API');
    }
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

  void _startRecording() {
    HapticFeedback.mediumImpact();
    setState(() {
      _isRecording = true;
      _recordingDuration = 0.0;
    });
    _recordingController.forward();
    _waveController.repeat();

    // Simulate recording duration
    _simulateRecording();
  }

  Future<String> _sendAudioToVoiceToTextAPI() async {
    // TODO: Implement your voice recording file processing here.
    // Example:
    // - You may record using flutter_sound / record package
    // - Then upload audio file to your API
    // - And parse text from response

    // This is a mock response
    await Future.delayed(Duration(seconds: 2));
    return "Hello, this is a real transcription from your API.";
  }



  void _simulateRecording() async {
    // ⛳ Step 1: Send voice recording to your custom API
    // You will replace the below code with actual file/audio data and endpoint

    try {
      // TODO: Replace this with your actual API call
      final String voiceText = await _sendAudioToVoiceToTextAPI();

      if (voiceText.isNotEmpty) {
        _sendMessage(voiceText);
      } else {
        setState(() {
          _messages.add(ChatMessage(
            text: "Sorry, I couldn't understand your voice input. 🎤",
            isUser: false,
            timestamp: DateTime.now(),
            isError: true,
          ));
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: "Something went wrong while processing your voice input. ❌",
          isUser: false,
          timestamp: DateTime.now(),
          isError: true,
        ));
      });
    }

    // Stop recording UI state
    setState(() {
      _isRecording = false;
      _isRecordingLocked = false;
    });
    _recordingController.reverse();
    _waveController.reset();
  }


  void _stopRecording() {
    HapticFeedback.lightImpact();
    setState(() {
      _isRecording = false;
      _isRecordingLocked = false;
    });
    _recordingController.reverse();
    _waveController.reset();

    // Simulate voice message
    if (_recordingDuration > 0.5) {
      _sendMessage("🎤 Voice message: Hello, this is a simulated voice recording of ${_recordingDuration.toStringAsFixed(1)} seconds");
    }
  }

  void _lockRecording() {
    HapticFeedback.heavyImpact();
    setState(() {
      _isRecordingLocked = true;
    });
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment:
        message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: message.isError
                      ? [Colors.red.shade400, Colors.red.shade600]
                      : [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (message.isError ? Colors.red : Theme.of(context).primaryColor).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                gradient: message.isUser
                    ? LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                )
                    : null,
                color: !message.isUser
                    ? (message.isError ? Colors.red.shade50 : Colors.grey.shade50)
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(message.isUser ? 20 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white
                          : message.isError
                          ? Colors.red.shade700
                          : Colors.grey.shade800,
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatTime(message.timestamp),
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white.withOpacity(0.8)
                          : Colors.grey.shade500,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey.shade300, Colors.grey.shade400],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.person_rounded,
                color: Colors.grey.shade600,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.smart_toy_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _typingAnimation,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTypingDot(0),
                    const SizedBox(width: 6),
                    _buildTypingDot(1),
                    const SizedBox(width: 6),
                    _buildTypingDot(2),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    final delay = index * 0.2;
    return AnimatedBuilder(
      animation: _typingAnimation,
      builder: (context, child) {
        final value = (_typingAnimation.value - delay).clamp(0.0, 1.0);
        return Transform.translate(
          offset: Offset(0, -8 * (1 - (value - 0.5).abs() * 2).clamp(0.0, 1.0)),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Assistant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text('Online', style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey.shade800,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        actions: [

          PopupMenuButton(
            icon: const Icon(Icons.more_vert_rounded),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Clear Chat'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline_rounded, size: 20),
                    SizedBox(width: 12),
                    Text('Help & Tips'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'clear') {
                setState(() {
                  _messages.clear();
                  _addWelcomeMessage();
                });
              } else if (value == 'help') {
                _sendMessage('What can you help me with?');
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < _messages.length) {
                  return _buildMessageBubble(_messages[index]);
                } else {
                  return _buildTypingIndicator();
                }
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Voice recording button
          GestureDetector(
            onLongPressStart: (_) => _startRecording(),
            onLongPressEnd: (_) {
              if (!_isRecordingLocked) {
                _stopRecording();
              }
            },
            onLongPressMoveUpdate: (details) {
              if (_isRecording && !_isRecordingLocked && details.offsetFromOrigin.dy < -50) {
                _lockRecording();
              }
            },
            child: AnimatedBuilder(
              animation: _recordingScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _recordingScaleAnimation.value,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: _isRecording
                            ? [Colors.red.shade400, Colors.red.shade600]
                            : [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isRecording ? Colors.red : Theme.of(context).primaryColor).withOpacity(0.4),
                          blurRadius: _isRecording ? 16 : 8,
                          spreadRadius: _isRecording ? 2 : 0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.mic_rounded : Icons.mic_none_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),

          // Text input or recording UI
          Expanded(
            child: _isRecording ? _buildRecordingUI() : _buildTextInput(),
          ),

          const SizedBox(width: 12),

          // Send button
          if (!_isRecording)
            GestureDetector(
              onTap: () => _sendMessage(_messageController.text),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor, Theme.of(context).primaryColor.withOpacity(0.8)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),

          // Stop/Send recording button
          if (_isRecording && _isRecordingLocked)
            GestureDetector(
              onTap: _stopRecording,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade400, Colors.green.shade600],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _messageController,
        decoration: const InputDecoration(
          hintText: 'Type a message...',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
        onSubmitted: _sendMessage,
        textInputAction: TextInputAction.send,
        maxLines: null,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

  Widget _buildRecordingUI() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _waveAnimation,
            builder: (context, child) {
              return Row(
                children: List.generate(4, (index) {
                  final height = 4.0 + (12.0 * (0.5 + 0.5 *
                      ((_waveAnimation.value + index * 0.2) % 1.0).clamp(0.0, 1.0)));
                  return Container(
                    width: 3,
                    height: height,
                    margin: const EdgeInsets.only(right: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isRecordingLocked ? 'Recording locked' : 'Recording...',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _isRecordingLocked ? 'Tap send to finish' : 'Slide up to lock',
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${_recordingDuration.toStringAsFixed(1)}"',
            style: TextStyle(
              color: Colors.red.shade600,
              fontWeight: FontWeight.w600,
              fontSize: 14,
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
  final DateTime timestamp;
  final bool isError;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isError = false,
  });
}