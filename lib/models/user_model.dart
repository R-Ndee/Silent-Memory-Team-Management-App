import 'package:cloud_firestore/cloud_firestore.dart';

/// User model representing Firestore `/users/{userId}` document.
class UserModel {
  final String userId;
  final String email;
  final String displayName;
  final String role;
  final String status;
  final DateTime joinedAt;
  final DateTime? inactiveAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String createdBy;
  final String updatedBy;

  const UserModel({
    required this.userId,
    required this.email,
    required this.displayName,
    required this.role,
    required this.status,
    required this.joinedAt,
    this.inactiveAt,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      userId: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      role: data['role'] as String? ?? 'member',
      status: data['status'] as String? ?? 'active',
      joinedAt: (data['joinedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      inactiveAt: (data['inactiveAt'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdBy: data['createdBy'] as String? ?? '',
      updatedBy: data['updatedBy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'email': email,
      'displayName': displayName,
      'role': role,
      'status': status,
      'joinedAt': Timestamp.fromDate(joinedAt),
      'inactiveAt': inactiveAt != null ? Timestamp.fromDate(inactiveAt!) : null,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'createdBy': createdBy,
      'updatedBy': updatedBy,
    };
  }

  bool get isActive => status == 'active';
  bool get isMember => role == 'member';
  bool get isAdmin => role == 'admin';
  bool get isSuperAdmin => role == 'super_admin';
}
