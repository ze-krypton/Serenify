import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? profilePicture;
  final DateTime createdAt;
  final List<String> completedAssessments;
  final Map<String, dynamic>? preferences;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profilePicture,
    required this.createdAt,
    this.completedAssessments = const [],
    this.preferences,
  });

  // Empty user which represents an unauthenticated user
  static final UserModel empty = UserModel(
    id: '',
    email: '',
    name: '',
    createdAt: DateTime(1970, 1, 1), // Using Unix epoch start date
    completedAssessments: const [],
  );

  // Check if user is empty (unauthenticated)
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'createdAt': createdAt,
      'completedAssessments': completedAssessments,
      'preferences': preferences ?? {},
    };
  }

  // Create UserModel from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePicture: map['profilePicture'],
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedAssessments: List<String>.from(map['completedAssessments'] ?? []),
      preferences: map['preferences'],
    );
  }

  // Create copy of UserModel with some modified fields
  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? profilePicture,
    DateTime? createdAt,
    List<String>? completedAssessments,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      createdAt: createdAt ?? this.createdAt,
      completedAssessments: completedAssessments ?? this.completedAssessments,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [id, email, name, profilePicture, createdAt, completedAssessments, preferences];
} 