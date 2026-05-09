import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

class AICoachService {
  static final AICoachService _instance = AICoachService._internal();
  factory AICoachService() => _instance;
  AICoachService._internal();

  final String? _apiKey = const String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  final String _model = 'gpt-3.5-turbo';
  
  // System prompt for the AI Coach
  final String _systemPrompt = '''
You are Momentum, an emotionally intelligent AI coach helping users overcome procrastination and build consistent habits. 

Your personality:
- Supportive, calm, and motivating
- You break big tasks into tiny actions (2-5 minutes)
- You emphasize progress over perfection
- You detect procrastination patterns and adapt
- You provide emotional support during setbacks
- You remind users of their "WHY"

Key behaviors:
1. When user feels overwhelmed → suggest smaller steps
2. When user procrastinates → use the "2-minute rule"
3. When user lacks motivation → remind of their goals
4. When user fails → encourage restart without guilt
5. When user succeeds → celebrate and encourage consistency

Keep responses concise, warm, and actionable.
''';

  // Analyze user input and generate response
  Future<String> generateResponse({
    required String userMessage,
    required String userId,
    Map<String, dynamic>? userContext,
  }) async {
    // If no API key, use intelligent local responses
    if (_apiKey == null || _apiKey!.isEmpty) {
      return _generateLocalResponse(userMessage, userContext);
    }

    try {
      // Build conversation history
      final messages = [
        {'role': 'system', 'content': _systemPrompt},
        if (userContext != null) ...[
          {'role': 'system', 'content': _buildContextPrompt(userContext)},
        ],
        {'role': 'user', 'content': userMessage},
      ];

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': messages,
          'max_tokens': 500,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        
        // Save to history
        await _saveToHistory(userId, userMessage, content);
        return content;
      } else {
        return _generateLocalResponse(userMessage, userContext);
      }
    } catch (e) {
      return _generateLocalResponse(userMessage, userContext);
    }
  }

  String _buildContextPrompt(Map<String, dynamic> context) {
    final buffer = StringBuffer('User context:\n');
    if (context['name'] != null) buffer.writeln('- Name: ${context['name']}');
    if (context['goals'] != null) buffer.writeln('- Goals: ${context['goals']}');
    if (context['streak'] != null) buffer.writeln('- Current streak: ${context['streak']} days');
    if (context['momentum'] != null) buffer.writeln('- Momentum score: ${context['momentum']}');
    if (context['lastTask'] != null) buffer.writeln('- Last task: ${context['lastTask']}');
    if (context['struggles'] != null) buffer.writeln('- Struggles with: ${context['struggles']}');
    return buffer.toString();
  }

  // Local intelligent responses (fallback)
  String _generateLocalResponse(String input, Map<String, dynamic>? context) {
    final lowerInput = input.toLowerCase();
    final name = context?['name'] ?? 'there';
    
    // Detect intent
    if (_contains(lowerInput, ['hard', 'difficult', 'overwhelm', 'big', 'too much'])) {
      return _getBreakDownResponse(name);
    } else if (_contains(lowerInput, ['procrastinat', 'delay', 'avoid', 'put off', 'lazy'])) {
      return _getProcrastinationResponse(name);
    } else if (_contains(lowerInput, ['motivation', 'encourage', 'need push', 'no energy', 'tired'])) {
      return _getMotivationResponse(name);
    } else if (_contains(lowerInput, ['stuck', 'blocked', 'problem', 'issue'])) {
      return _getStuckResponse(name);
    } else if (_contains(lowerInput, ['help', 'what should', 'suggest', 'advice'])) {
      return _getHelpResponse(name, context);
    } else if (_contains(lowerInput, ['fail', 'missed', 'didn\'t', 'couldn\'t'])) {
      return _getFailureResponse(name);
    } else if (_contains(lowerInput, ['success', 'done', 'completed', 'finished'])) {
      return _getSuccessResponse(name);
    } else {
      return _getGeneralResponse(name, context);
    }
  }

  bool _contains(String text, List<String> words) {
    return words.any((w) => text.contains(w));
  }

  String _getBreakDownResponse(String name) {
    final responses = [
      "Hey $name! Let's break this into smaller pieces. What's the absolute smallest first step? Just 2 minutes?",
      "I hear you. Let's make it easier - can you do just 5 minutes? Set a timer and stop when it goes off.",
      "Overwhelmed? Let's simplify. What's ONE tiny action you could do right now?",
      "Big tasks = many small tasks. Let's start with just 10 minutes. You can do anything for 10 minutes!",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  String _getProcrastinationResponse(String name) {
    final responses = [
      "Hey $name, procrastination often means the task feels too big. What's the smallest version?",
      "The hardest part is starting. Just 2 minutes. That's all. If you want to stop after, you can. But you won't.",
      "Our brains resist, but we can outsmart them. What's ONE small action you could do right now?",
      "You're not lazy - you just need a smaller starting point. What's the tiny version of this task?",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  String _getMotivationResponse(String name) {
    final streak = (DateTime.now().second % 7) + 1;
    final responses = [
      "Hey $name! You've got this. Every expert was once a beginner. Just take the next small step.",
      "Remember: progress, not perfection. You're building momentum one action at a time.",
      "Future you will thank you for starting today, $name. What's one tiny action?",
      "Your potential is unlimited. You've been consistent for $streak days - keep going!",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  String _getStuckResponse(String name) {
    final responses = [
      "Let's figure this out together, $name. What specifically is blocking you?",
      "I hear you. Sometimes we get stuck. Let's try something different - what's the simplest next step?",
      "Being stuck is temporary. Let's break the problem down into smaller pieces.",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  String _getHelpResponse(String name, Map<String, dynamic>? context) {
    final goals = context?['goals'] as String? ?? '';
    if (goals.isNotEmpty) {
      return "Based on your goal to $goals, I'd suggest starting with a tiny action today. What's one small step you could take?";
    }
    return "I'm here to help, $name! Tell me what you're working on and I'll help you break it down.";
  }

  String _getFailureResponse(String name) {
    final responses = [
      "Hey $name, missing a day doesn't define you. What matters is getting back up. Let's start with one small win.",
      "That's okay! Everyone has setbacks. The important thing is to restart. What's one tiny action you could do today?",
      "Don't beat yourself up. A missed day is just a pause, not the end. Let's get back to building momentum!",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  String _getSuccessResponse(String name) {
    final responses = [
      "That's amazing, $name! You're building real momentum. Keep this going! 🎉",
      "Wow, $name! That's a win. Celebrate it, then ask: what's the next small action?",
      "Incredible work, $name! You're proving to yourself what you're capable of.",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  String _getGeneralResponse(String name, Map<String, dynamic>? context) {
    final streak = context?['streak'] ?? 0;
    final momentum = context?['momentum'] ?? 50;
    
    if (streak > 5) {
      return "You're on a $streak-day streak, $name! That's incredible. Protect this momentum.";
    } else if (momentum < 30) {
      return "Let's rebuild that momentum, $name. What's one tiny action you could do right now?";
    }
    
    final responses = [
      "I'm here for you, $name. What do you need - motivation, breaking down a task, or just someone to listen?",
      "Let's make progress today, $name. What's one small action you could take?",
      "Every action builds momentum. What would you like to work on, $name?",
    ];
    return responses[DateTime.now().second % responses.length];
  }

  // Save conversation to Firestore
  Future<void> _saveToHistory(String userId, String userMessage, String aiResponse) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('aiChats')
          .add({
        'userMessage': userMessage,
        'aiResponse': aiResponse,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silent fail - don't interrupt user experience
    }
  }

  // Get user's AI conversation history
  Future<List<Map<String, dynamic>>> getChatHistory(String userId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('aiChats')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return snapshot.docs
          .map((doc) => doc.data())
          .toList();
    } catch (e) {
      return [];
    }
  }
}
