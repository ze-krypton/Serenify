import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mind_mate/constants/app_constants.dart';
import 'package:mind_mate/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:math';

// Define enums at the top level, not inside a class
enum MessageSender {
  user,
  bot,
}

enum MessageType {
  text,
  quick_replies,
  resource,
  exercise,
  assessment,
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  
  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
  
  factory ChatMessage.user(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
  }
  
  factory ChatMessage.bot(String text) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: false,
      timestamp: DateTime.now(),
    );
  }
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      text: map['text'],
      isUser: map['isUser'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}

class ChatSession {
  final String id;
  final String userId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? topic;
  final int messageCount;
  
  ChatSession({
    required this.id,
    required this.userId,
    required this.startedAt,
    this.endedAt,
    this.topic,
    this.messageCount = 0,
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'topic': topic,
      'messageCount': messageCount,
    };
  }
  
  factory ChatSession.fromMap(Map<String, dynamic> map) {
    return ChatSession(
      id: map['id'],
      userId: map['userId'],
      startedAt: DateTime.parse(map['startedAt']),
      endedAt: map['endedAt'] != null ? DateTime.parse(map['endedAt']) : null,
      topic: map['topic'],
      messageCount: map['messageCount'] ?? 0,
    );
  }
}

class ChatbotService {
  final String projectId = AppConstants.dialogflowProjectId;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final CollectionReference _messagesCollection = FirebaseService.getCollection('chat_messages');
  final CollectionReference _sessionsCollection = FirebaseService.getCollection('chat_sessions');

  static const String _greeting = "Hello! I'm Serenify AI. How can I help you today?";
  
  // Keywords and their responses for basic matching
  static final Map<List<String>, List<String>> _responses = {
    ['hello', 'hi', 'hey', 'greetings']: [
      "Hello! How are you feeling today?",
      "Hi there! What's on your mind?",
      "Hey! How can I support you today?",
    ],
    
    ['feeling', 'feel', 'felt']: [
      "I understand how you feel. Would you like to talk more about it?",
      "Emotions are important signals. Have you tried tracking them in the Mood Tracker?",
      "Thank you for sharing how you're feeling. Is there anything specific that triggered this emotion?",
    ],
    
    ['stress', 'stressed', 'anxiety', 'anxious', 'worry', 'worried']: [
      "I'm sorry to hear you're feeling stressed. Have you tried any breathing exercises?",
      "Anxiety can be challenging. The app has some breathing exercises that might help calm your mind.",
      "When feeling anxious, it can help to focus on things within your control. Would you like some coping strategies?",
    ],
    
    ['sad', 'depression', 'depressed', 'unhappy', 'low']: [
      "I'm sorry you're feeling down. Remember that it's okay to not be okay sometimes.",
      "Depression can make things seem overwhelming. Have you spoken with a mental health professional?",
      "When you're feeling low, sometimes small self-care acts can help. Would you like some suggestions?",
    ],
    
    ['help', 'support', 'assistance']: [
      "I'm here to help! You can use the app to track your mood, try mental wellness exercises, or take assessments.",
      "I can help in several ways. Would you like to explore coping strategies, relaxation techniques, or resources?",
      "I'm your mental wellness assistant. What specific area would you like support with today?",
    ],
    
    ['sleep', 'insomnia', 'tired']: [
      "Sleep is crucial for mental health. Have you tried establishing a regular sleep routine?",
      "Trouble sleeping can affect your well-being. The app has some relaxation exercises that might help.",
      "Poor sleep can impact mood and energy. Would you like some tips for better sleep hygiene?",
    ],
    
    ['exercise', 'exercises', 'breathing', 'meditate', 'meditation']: [
      "Exercise and meditation can be great for mental well-being. Have you checked the Exercises section?",
      "Deep breathing can help calm your mind. Would you like to try a guided breathing exercise?",
      "Meditation is a powerful tool for mental clarity. The app has some guided meditations you might find helpful.",
    ],
    
    ['assessment', 'test', 'evaluate', 'check']: [
      "Self-assessments can help you understand your mental state better. You can find them in the Assessments section.",
      "Regular mental health check-ins are important. Have you taken any of the assessments recently?",
      "The app offers various assessments for different aspects of mental health. Would you like to try one?",
    ],
  };
  
  // Fallback responses when no keyword matches
  static final List<String> _fallbackResponses = [
    "I'm not sure I understand completely. Could you tell me more?",
    "I'm still learning. Could you rephrase that or tell me more about what you're experiencing?",
    "Thank you for sharing. While I'm a supportive companion, remember I'm not a replacement for professional help if you need it.",
    "I'm here to listen. Would you like to tell me more about that?",
    "That's interesting. How does that make you feel?",
  ];
  
  // Emergency detection keywords
  static final List<String> _emergencyKeywords = [
    'suicide', 'kill myself', 'want to die', 'end my life', 'hurt myself',
    'self-harm', 'cutting', 'emergency', 'crisis', 'dangerous', 'overdose',
  ];
  
  // Emergency response
  static const String _emergencyResponse = 
    "I'm concerned about what you've shared. If you're in crisis or thinking about harming yourself, "
    "please reach out to emergency services immediately (call 911 or your local emergency number) or "
    "contact a crisis helpline. You can find crisis resources in the Emergency section of the app. "
    "Remember, you're not alone, and help is available.";
  
  // Get the initial greeting message
  static ChatMessage getGreeting() {
    return ChatMessage.bot(_greeting);
  }
  
  // Generate a response based on user input
  static Future<ChatMessage> getResponse(String userMessage) async {
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 500 + Random().nextInt(1000)));
    
    // Convert to lowercase for matching
    final lowerCaseMessage = userMessage.toLowerCase();
    
    // Check for emergency keywords first
    if (_emergencyKeywords.any((keyword) => lowerCaseMessage.contains(keyword))) {
      return ChatMessage.bot(_emergencyResponse);
    }
    
    // Check for keyword matches
    List<String> possibleResponses = [];
    
    for (final entry in _responses.entries) {
      final keywords = entry.key;
      if (keywords.any((keyword) => lowerCaseMessage.contains(keyword))) {
        possibleResponses.addAll(entry.value);
      }
    }
    
    // If no matches found, use fallback responses
    if (possibleResponses.isEmpty) {
      possibleResponses = _fallbackResponses;
    }
    
    // Select a random response from the possible ones
    final randomIndex = Random().nextInt(possibleResponses.length);
    return ChatMessage.bot(possibleResponses[randomIndex]);
  }
  
  // Get response for a specific intent (for more advanced implementations)
  static Future<ChatMessage> getResponseForIntent(String intent, {Map<String, dynamic>? parameters}) async {
    // Simulating intent-based response (could be expanded with a full NLP system)
    switch (intent) {
      case 'greeting':
        return ChatMessage.bot("Hello! How can I help you today?");
      case 'mood_tracking':
        return ChatMessage.bot("Tracking your mood can help you understand patterns. Would you like to record how you're feeling today?");
      case 'exercise_recommendation':
        return ChatMessage.bot("Based on what you've shared, a breathing exercise might help. Would you like to try one?");
      default:
        return getResponse(intent); // Fallback to keyword matching
    }
  }

  // Create a new chat session
  Future<ChatSession?> createChatSession(String userId, {String? topic}) async {
    try {
      final String id = const Uuid().v4();
      final DateTime startedAt = DateTime.now();
      
      final ChatSession session = ChatSession(
        id: id,
        userId: userId,
        startedAt: startedAt,
        topic: topic,
      );
      
      await _sessionsCollection.doc(id).set(session.toMap());
      return session;
    } catch (e) {
      if (kDebugMode) {
        print('Error creating chat session: $e');
      }
      return null;
    }
  }

  // End a chat session
  Future<bool> endChatSession(String sessionId) async {
    try {
      await _sessionsCollection.doc(sessionId).update({
        'endedAt': DateTime.now(),
      });
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error ending chat session: $e');
      }
      return false;
    }
  }

  // Get all chat sessions for a user
  Future<List<ChatSession>> getChatSessions(String userId) async {
    try {
      final QuerySnapshot snapshot = await _sessionsCollection
          .where('userId', isEqualTo: userId)
          .orderBy('startedAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) {
        return ChatSession.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting chat sessions: $e');
      }
      return [];
    }
  }

  // Get chat messages for a session
  Stream<List<ChatMessage>> getChatMessages(String sessionId) {
    try {
      return _messagesCollection
          .where('sessionId', isEqualTo: sessionId)
          .orderBy('timestamp')
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) {
          return ChatMessage.fromMap(doc.data() as Map<String, dynamic>);
        }).toList();
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error getting chat messages: $e');
      }
      return Stream.value([]);
    }
  }

  // Save a chat message
  Future<ChatMessage?> saveChatMessage({
    required String userId,
    required String sessionId,
    required String content,
    required MessageSender sender,
    MessageType type = MessageType.text,
    Map<String, dynamic>? metadata,
    List<String>? quickReplies,
  }) async {
    try {
      final String id = const Uuid().v4();
      final DateTime timestamp = DateTime.now();
      
      final ChatMessage message = ChatMessage(
        id: id,
        text: content,
        isUser: sender == MessageSender.user,
        timestamp: timestamp,
      );
      
      await _messagesCollection.doc(id).set({
        ...message.toMap(),
        'sessionId': sessionId,
      });
      
      // Update the message count in the session
      await _sessionsCollection.doc(sessionId).update({
        'messageCount': FieldValue.increment(1),
      });
      
      return message;
    } catch (e) {
      if (kDebugMode) {
        print('Error saving chat message: $e');
      }
      return null;
    }
  }

  // Get Dialogflow response to a user message
  Future<Map<String, dynamic>?> getDialogflowResponse(
    String sessionId,
    String message,
    String languageCode,
  ) async {
    try {
      // Get Dialogflow API key from secure storage
      final String? apiKey = await _secureStorage.read(key: 'dialogflow_api_key');
      
      if (apiKey == null) {
        throw Exception('Dialogflow API key not found');
      }
      
      // Make API request to Dialogflow
      final http.Response response = await http.post(
        Uri.parse(
          'https://dialogflow.googleapis.com/v2/projects/$projectId/agent/sessions/$sessionId:detectIntent',
        ),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'queryInput': {
            'text': {
              'text': message,
              'languageCode': languageCode,
            },
          },
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        if (kDebugMode) {
          print('Dialogflow API error: ${response.statusCode} - ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting Dialogflow response: $e');
      }
      return null;
    }
  }

  // Process Dialogflow response and extract relevant information
  ChatMessage processDialogflowResponse(
    String userId,
    Map<String, dynamic> dialogflowResponse,
  ) {
    try {
      final String messageId = const Uuid().v4();
      final String fulfillmentText = dialogflowResponse['queryResult']['fulfillmentText'] ?? 'Sorry, I could not understand that.';
      
      Map<String, dynamic>? metadata;
      List<String>? quickReplies;
      MessageType messageType = MessageType.text;
      
      // Check for payload data
      if (dialogflowResponse['queryResult']['fulfillmentMessages'] != null) {
        final List<dynamic> messages = dialogflowResponse['queryResult']['fulfillmentMessages'];
        
        for (var message in messages) {
          if (message['payload'] != null) {
            final Map<String, dynamic> payload = message['payload'];
            
            // Check for quick replies
            if (payload['quickReplies'] != null) {
              quickReplies = List<String>.from(payload['quickReplies']);
              messageType = MessageType.quick_replies;
            }
            
            // Check for resource recommendation
            if (payload['resourceId'] != null) {
              metadata = {
                'resourceId': payload['resourceId'],
                'resourceType': payload['resourceType'],
              };
              messageType = MessageType.resource;
            }
            
            // Check for exercise recommendation
            if (payload['exerciseId'] != null) {
              metadata = {
                'exerciseId': payload['exerciseId'],
                'exerciseType': payload['exerciseType'],
              };
              messageType = MessageType.exercise;
            }
            
            // Check for assessment recommendation
            if (payload['assessmentId'] != null) {
              metadata = {
                'assessmentId': payload['assessmentId'],
                'assessmentType': payload['assessmentType'],
              };
              messageType = MessageType.assessment;
            }
          }
        }
      }
      
      return ChatMessage(
        id: messageId,
        text: fulfillmentText,
        isUser: false,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error processing Dialogflow response: $e');
      }
      return ChatMessage(
        id: const Uuid().v4(),
        text: 'Sorry, I encountered a problem. Please try again later.',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }
} 