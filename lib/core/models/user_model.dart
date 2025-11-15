class UserModel {
  final String id; // Back4App objectId
  String fullName; // userFullName
  String email; // username (email)
  String phone; // userMobileNo
  String? profileImage; // optional
  String? role; // optional (if you set manually)
  DateTime createdAt;
  DateTime? updatedAt;
  bool isActive; // default true
  String? sessionToken; // Back4App sessionToken

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage,
    this.role,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.sessionToken,
  });

  // -----------------------------------------------------
  //  SAFE DATE PARSER
  // -----------------------------------------------------
  static DateTime parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    if (value is Map && value["iso"] != null) {
      return DateTime.tryParse(value["iso"]) ?? DateTime.now();
    }
    return DateTime.now();
  }

  // -----------------------------------------------------
  //  FROM JSON (Back4App login + user fetch compatible)
  // -----------------------------------------------------
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["objectId"] ?? json["id"] ?? "",
      fullName: json["userFullName"] ?? "",
      email: json["username"] ?? json["email"] ?? "",
      phone: json["userMobileNo"] ?? "",
      profileImage: json["profileImage"],
      role: json["role"], // optional
      createdAt: parseDate(json["createdAt"]),
      updatedAt: json["updatedAt"] != null
          ? parseDate(json["updatedAt"])
          : null,
      isActive: json["isActive"] ?? true,
      sessionToken: json["sessionToken"],
    );
  }

  // -----------------------------------------------------
  //  TO JSON (Only the valid fields)
  // -----------------------------------------------------
  Map<String, dynamic> toJson() {
    return {
      "objectId": id,
      "userFullName": fullName,
      "username": email,
      "userMobileNo": phone,
      "profileImage": profileImage,
      "role": role,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      "isActive": isActive,
      "sessionToken": sessionToken,
    };
  }

  // -----------------------------------------------------
  //  COPY WITH
  // -----------------------------------------------------
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
    String? sessionToken,
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
      sessionToken: sessionToken ?? this.sessionToken,
    );
  }

  @override
  String toString() {
    return "UserModel(id: $id, fullName: $fullName, email: $email, phone: $phone, role: $role, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, sessionToken: $sessionToken)";
  }
}
