import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

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

class ChatMessage extends Equatable {
  final String id;
  final String userId;
  final String content;
  final MessageSender sender;
  final MessageType type;
  final DateTime timestamp;
  final Map<String, dynamic>? metadata;
  final List<String>? quickReplies;

  const ChatMessage({
    required this.id,
    required this.userId,
    required this.content,
    required this.sender,
    this.type = MessageType.text,
    required this.timestamp,
    this.metadata,
    this.quickReplies,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        content,
        sender,
        type,
        timestamp,
        metadata,
        quickReplies,
      ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'content': content,
      'sender': sender.index,
      'type': type.index,
      'timestamp': timestamp,
      'metadata': metadata,
      'quickReplies': quickReplies,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      sender: MessageSender.values[map['sender'] ?? 0],
      type: MessageType.values[map['type'] ?? 0],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      metadata: map['metadata'],
      quickReplies: map['quickReplies'] != null
          ? List<String>.from(map['quickReplies'])
          : null,
    );
  }

  ChatMessage copyWith({
    String? id,
    String? userId,
    String? content,
    MessageSender? sender,
    MessageType? type,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
    List<String>? quickReplies,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      sender: sender ?? this.sender,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
      quickReplies: quickReplies ?? this.quickReplies,
    );
  }
}

class ChatSession extends Equatable {
  final String id;
  final String userId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? topic;
  final int messageCount;

  const ChatSession({
    required this.id,
    required this.userId,
    required this.startedAt,
    this.endedAt,
    this.topic,
    this.messageCount = 0,
  });

  @override
  List<Object?> get props => [id, userId, startedAt, endedAt, topic, messageCount];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'startedAt': startedAt,
      'endedAt': endedAt,
      'topic': topic,
      'messageCount': messageCount,
    };
  }

  factory ChatSession.fromMap(Map<String, dynamic> map) {
    return ChatSession(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      startedAt: (map['startedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endedAt: (map['endedAt'] as Timestamp?)?.toDate(),
      topic: map['topic'],
      messageCount: map['messageCount'] ?? 0,
    );
  }

  ChatSession copyWith({
    String? id,
    String? userId,
    DateTime? startedAt,
    DateTime? endedAt,
    String? topic,
    int? messageCount,
  }) {
    return ChatSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      topic: topic ?? this.topic,
      messageCount: messageCount ?? this.messageCount,
    );
  }
} 