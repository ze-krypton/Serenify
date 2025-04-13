import 'package:flutter/material.dart';
import 'dart:math';

class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({Key? key}) : super(key: key);

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  // Color palette
  static const Color warmBeige = Color(0xFFF8D070);
  static const Color warmOrange = Color(0xFFFF9666);
  static const Color warmCoral = Color(0xFFEE6D57);
  static const Color warmRed = Color(0xFFDE3C50);
  static const Color warmTeal = Color(0xFF3A877A);
  static const Color bgColor = Color(0xFFFFF9F0);
  
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;
  
  // Chat messages
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! I\'m your Serenify assistant. How can I help you today?',
      'isUser': false,
      'time': DateTime.now().subtract(const Duration(minutes: 2)),
    },
  ];
  
  // Predefined responses for the chatbot
  final List<String> _botResponses = [
    'I understand how you feel. It\'s normal to experience these emotions.',
    'Taking deep breaths can help when you\'re feeling overwhelmed.',
    'Have you tried our meditation exercises? They can be very helpful for stress relief.',
    'Remember to be kind to yourself. Self-compassion is important for mental well-being.',
    'Would you like to tell me more about what\'s bothering you?',
    'I hear you. Sometimes just expressing how you feel can make a difference.',
    'Consider taking a short break to clear your mind. Even 5 minutes can help.',
    'Our journal feature might help you process these feelings.',
    'That sounds challenging. How have you been coping with this situation?',
    'What are some small steps you could take to address this issue?',
    'It\'s brave of you to share this. Acknowledging our feelings is an important first step.',
    'I\'m here to listen whenever you need support.',
  ];
  
  // Suggestions for the user
  final List<String> _suggestions = [
    'I\'m feeling anxious today',
    'How can I improve my sleep?',
    'Need help with stress',
    'Feeling sad',
    'Meditation tips',
    'How to start journaling',
  ];
  
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    
    setState(() {
      // Add user message
      _messages.add({
        'text': text,
        'isUser': true,
        'time': DateTime.now(),
      });
      
      // Show typing indicator
      _isTyping = true;
    });
    
    // Scroll to bottom
    _scrollToBottom();
    
    // Clear input field
    _messageController.clear();
    
    // Simulate bot typing delay
    Future.delayed(Duration(milliseconds: 500 + Random().nextInt(2000)), () {
      if (!mounted) return;
      
      setState(() {
        _isTyping = false;
        
        // Add bot response
        _messages.add({
          'text': _getBotResponse(text),
          'isUser': false,
          'time': DateTime.now(),
        });
      });
      
      // Scroll to bottom again after response
      _scrollToBottom();
    });
  }
  
  String _getBotResponse(String userMessage) {
    // In a real app, this would be a more sophisticated AI response
    // For this demo, we'll pick a random pre-defined response
    
    // Lower case message for easier matching
    final lowerMessage = userMessage.toLowerCase();
    
    // Try to match some keywords
    if (lowerMessage.contains('anxious') || lowerMessage.contains('anxiety')) {
      return 'Anxiety can be challenging. Have you tried our breathing exercises? Taking slow, deep breaths for a few minutes can help calm your nervous system.';
    } else if (lowerMessage.contains('sleep') || lowerMessage.contains('insomnia')) {
      return "A consistent sleep schedule and a calm bedtime routine can help improve sleep. Our meditation app has a special 'Sleep Well' session you might find helpful.";
    } else if (lowerMessage.contains('stress') || lowerMessage.contains('stressed')) {
      return 'Stress affects us all differently. Regular physical activity, mindfulness practices, and connecting with others are proven ways to manage stress. What works best for you?';
    } else if (lowerMessage.contains('sad') || lowerMessage.contains('depressed')) {
      return "I'm sorry you're feeling this way. Remember that emotions come and go like waves. Would you like to try our mood tracking feature to monitor your feelings over time?";
    } else if (lowerMessage.contains('meditat') || lowerMessage.contains('breath')) {
      return 'Meditation can be transformative with regular practice. Even 5 minutes daily can make a difference. Our app offers guided sessions for beginners through advanced practitioners.';
    } else if (lowerMessage.contains('journal') || lowerMessage.contains('writing')) {
      return 'Journaling is a powerful tool for self-awareness. Try writing for just 5 minutes each day about your thoughts and feelings without judgment.';
    }
    
    // If no keywords match, use a random response
    return _botResponses[Random().nextInt(_botResponses.length)];
  }
  
  void _scrollToBottom() {
    // Scroll to bottom of chat after a short delay to allow rendering
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
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('Chat Support', 
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: warmRed,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              _showChatInfo(context);
            },
            icon: const Icon(Icons.info_outline, color: Colors.white),
            label: const Text('About', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: warmRed,
            ),
            child: Row(
              children: [
                // Bot avatar
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.psychology,
                    color: warmRed,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                // Bot info
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Serenify Assistant',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Here to support your well-being',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                // Status indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    'Online',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Messages
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),
          ),
          
          // Typing indicator
          if (_isTyping)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: const Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(warmRed),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Typing...',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          
          // Suggestions
          if (_messages.length < 3) _buildSuggestions(),
          
          // Message input
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEEE8E2),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFDED5CD),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (text) => _sendMessage(text),
                  ),
                ),
                // Send button
                const SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () => _sendMessage(_messageController.text),
                  backgroundColor: warmRed,
                  elevation: 0,
                  mini: true,
                  child: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;
    final time = message['time'] as DateTime;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Bot avatar (only for bot messages)
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: warmRed,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 18,
              ),
            ),
          
          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isUser ? warmCoral.withOpacity(0.2) : Colors.grey[100],
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomRight: isUser ? const Radius.circular(5) : null,
                  bottomLeft: !isUser ? const Radius.circular(5) : null,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: isUser ? warmCoral : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(time),
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // User avatar (only for user messages)
          if (isUser)
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: warmCoral,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildSuggestions() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _suggestions.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton(
              onPressed: () => _sendMessage(_suggestions[index]),
              style: ElevatedButton.styleFrom(
                backgroundColor: warmRed.withOpacity(0.1),
                foregroundColor: warmRed,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(_suggestions[index]),
            ),
          );
        },
      ),
    );
  }
  
  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
  
  void _showChatInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        title: const Text(
          'About Chat Support',
          style: TextStyle(
            color: Color(0xFF3A3A3A),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is a demonstration of the chat support feature in Serenify. In a full version, this would connect you with:',
              style: TextStyle(color: Color(0xFF4A4A4A)),
            ),
            const SizedBox(height: 16),
            _buildInfoItem(
              icon: Icons.smart_toy,
              title: 'AI Assistant',
              description: 'Get instant support and guidance for common mental wellness questions.',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              icon: Icons.psychology,
              title: 'Wellness Coaches',
              description: 'Chat with trained professionals for personalized support (Premium).',
            ),
            const SizedBox(height: 12),
            _buildInfoItem(
              icon: Icons.people,
              title: 'Community Support',
              description: 'Connect with others on similar wellness journeys (Premium).',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: warmRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: warmRed, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This demo uses pre-defined responses and does not implement actual AI capabilities.',
                      style: TextStyle(
                        color: warmRed,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: warmRed, width: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: warmRed,
              backgroundColor: warmRed.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Got it',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
  
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: warmRed.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: warmRed,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A4A4A),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFF4A4A4A),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
} 