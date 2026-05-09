import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/constants/app_constants.dart';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({super.key});

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> {
  final List<AIChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  bool _showConfetti = false;
  
  final List<String> _quickReplies = [
    "I need motivation",
    "Task feels too hard",
    "I'm procrastinating",
    "Give me a tiny task",
  ];

  @override
  void initState() {
    super.initState();
    // Add initial welcome message
    _messages.add(AIChatMessage(
      text: _getWelcomeMessage(),
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  String _getWelcomeMessage() {
    final messages = [
      "Hey! I'm your AI Coach. I'm here to help you stay focused and build momentum. What's on your mind today?",
      "Welcome back! Let's keep your momentum going. What would you like to work on?",
      "Ready to make progress? I'm here to help break things down into tiny actions. What do you need?",
    ];
    return messages[DateTime.now().minute % messages.length];
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    // Add user message
    setState(() {
      _messages.add(AIChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isTyping = true;
    });
    
    _inputController.clear();
    _scrollToBottom();
    
    // Simulate AI response
    Timer(const Duration(milliseconds: 1500), () {
      _processUserInput(text);
    });
  }

  void _processUserInput(String input) {
    String response;
    final lowerInput = input.toLowerCase();
    
    // Analyze input and generate response
    if (lowerInput.contains('hard') || lowerInput.contains('difficult') || lowerInput.contains('overwhelm')) {
      response = _generateBreakDownResponse();
    } else if (lowerInput.contains('procrastinat') || lowerInput.contains('delay') || lowerInput.contains('put off')) {
      response = _generateProcrastinationResponse();
    } else if (lowerInput.contains('motivation') || lowerInput.contains('encourage')) {
      response = _generateMotivationResponse();
    } else if (lowerInput.contains('tired') || lowerInput.contains('exhausted') || lowerInput.contains('energy')) {
      response = _generateEnergyResponse();
    } else if (lowerInput.contains('help') || lowerInput.contains('what should')) {
      response = _generateHelpResponse();
    } else {
      response = _generateGeneralResponse(input);
    }
    
    setState(() {
      _messages.add(AIChatMessage(
        text: response,
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isTyping = false;
    });
    
    _scrollToBottom();
  }

  String _generateBreakDownResponse() {
    final suggestions = [
      "Let's break this into smaller pieces. What's the absolute smallest first step? Just 2 minutes of work?",
      "I hear you. Let's make this easier. Can you do just 5 minutes? That's it. Set a timer and stop when it goes off.",
      "Overwhelmed? Let's simplify. What's one tiny action you could do right now? Just one.",
      "Big tasks are just many small tasks. Let's start with just 10 minutes. You can do anything for 10 minutes.",
    ];
    return suggestions[DateTime.now().second % suggestions.length];
  }

  String _generateProcrastinationResponse() {
    final suggestions = [
      "Procrastination often means the task feels too big. Let's make it tiny. What's the smallest version of this task?",
      "You know what? Just start for 2 minutes. That's all. If you want to stop after 2 minutes, you can. But you won't.",
      "The hardest part is starting. Let's do just 5 minutes of work. That's all. Deal?",
      "Our brains sometimes resist, but we can outsmart them. Let's do just ONE small action right now.",
    ];
    return suggestions[DateTime.now().second % suggestions.length];
  }

  String _generateMotivationResponse() {
    final suggestions = [
      "You've got this! Every expert was once a beginner. Just take the next small step.",
      "Remember: progress, not perfection. You're building momentum one action at a time.",
      "Future you will thank you for starting today. Let's make it easy - what's one tiny action?",
      "Your potential is unlimited. You just need to start. Let's begin with something small.",
    ];
    return suggestions[DateTime.now().second % suggestions.length];
  }

  String _generateEnergyResponse() {
    final suggestions = [
      "Low energy? That's okay. Let's do something gentle. Just 5 minutes of light work?",
      "Rest is productive too. But let's keep the streak alive with just ONE tiny action?",
      "Listen to your body. How about a 2-minute task? Something super easy to maintain momentum?",
      "Energy comes from action. Let's do the smallest possible task to get the momentum going.",
    ];
    return suggestions[DateTime.now().second % suggestions.length];
  }

  String _generateHelpResponse() {
    return "Tell me more about what you're working on, and I'll help you break it down into tiny actions. What's the task?";
  }

  String _generateGeneralResponse(String input) {
    final responses = [
      "I understand. Let's keep building momentum. What's the next small action you could take?",
      "Great to hear from you. How can I help you make progress today?",
      "I'm here to support you. What do you need right now - motivation, break it down, or just a push?",
      "Let's make today count. What's one small win you could achieve?",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: _buildMessageList()),
              _buildQuickReplies(),
              _buildInputArea(),
            ],
          ),
          if (_showConfetti)
            Positioned.fill(
              child: IgnorePointer(
                child: ConfettiOverlay(
                  show: _showConfetti,
                  onComplete: () => setState(() => _showConfetti = false),
                ),
              ),
            ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.surface,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
              boxShadow: AppTheme.glowShadow(AppTheme.primary, intensity: 0.5),
            ),
            child: const Icon(Icons.psychology, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Coach',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Text(
                'Always here for you',
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (_isTyping && index == _messages.length) {
          return _buildTypingIndicator();
        }
        if (index >= _messages.length) return const SizedBox.shrink();
        
        final message = _messages[index];
        final showDate = index == 0 || 
            _messages[index].timestamp.difference(_messages[index - 1].timestamp).inMinutes > 5;
        
        return Column(
          children: [
            if (showDate)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  _formatTimestamp(message.timestamp),
                  style: const TextStyle(fontSize: 12, color: AppTheme.textTertiary),
                ),
              ),
            _buildMessageBubble(message),
          ],
        ).animate().fadeIn(delay: 50.ms).slideX(begin: message.isUser ? 0.1 : -0.1);
      },
    );
  }

  Widget _buildMessageBubble(AIChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        margin: EdgeInsets.only(
          left: message.isUser ? 48 : 0,
          right: message.isUser ? 0 : 48,
          bottom: 8,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: message.isUser ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isUser ? 20 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 20),
          ),
          boxShadow: message.isUser ? AppTheme.glowShadow(AppTheme.primary, intensity: 0.3) : null,
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isUser ? AppTheme.background : AppTheme.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
      margin: const EdgeInsets.only(left: 0, right: 48, bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDot(0),
          const SizedBox(width: 4),
          _buildDot(1),
          const SizedBox(width: 4),
          _buildDot(2),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: Duration(milliseconds: 600 + index * 200),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primary.withAlpha((value * 255).toInt()),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }

  Widget _buildQuickReplies() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: _quickReplies.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PremiumGlassCard(
              onTap: () => _sendMessage(entry.value),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                entry.value,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
          ).animate().fadeIn(delay: (entry.key * 100).ms);
        }).toList(),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border(
          top: BorderSide(color: Colors.white.withAlpha(10)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                decoration: InputDecoration(
                  hintText: 'Message AI Coach...',
                  hintStyle: const TextStyle(color: AppTheme.textTertiary),
                  filled: true,
                  fillColor: AppTheme.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                ),
                style: const TextStyle(color: AppTheme.textPrimary),
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: AppTheme.glowShadow(AppTheme.primary),
              ),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => _sendMessage(_inputController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    if (timestamp.day == now.day) {
      return 'Today';
    } else if (timestamp.day == now.day - 1) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
}

class AIChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  AIChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
