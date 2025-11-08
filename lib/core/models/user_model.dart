import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImage;
  final String? role;  
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage,
    this.role,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
  });

  ///  Converts JSON to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'],
      role: json['role'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      isActive: json['isActive'] ?? true,
    );
  }

  /// ✅ Converts UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'isActive': isActive,
    };
  }

  ///  Copy with new values (immutable pattern)
  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? profileImage,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profileImage: profileImage ?? this.profileImage,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, fullName: $fullName, email: $email, phone: $phone, role: $role, createdAt: $createdAt, isActive: $isActive)';
  }
}
