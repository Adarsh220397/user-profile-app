const String tableNotes = 'notes';

class TableDetails {
  static final List<String> values = [
    /// Add all fields
    userId, userName, email, mobile, password, imagePath
  ];

  static const String imagePath = 'imagePath';
  static const String userName = 'userName';
  static const String email = 'email';
  static const String mobile = 'mobile';
  static const String password = 'password';
  static const String userId = 'userId';
}

class UserDetails {
  String imagePath;
  String userName;
  String email;
  String mobile;
  String password;
  num userId;

  UserDetails({
    required this.imagePath,
    required this.userName,
    required this.email,
    required this.mobile,
    required this.password,
    required this.userId,
  });

  UserDetails copy({
    String? imagePath,
    String? userName,
    String? email,
    String? mobile,
    String? password,
    num? userId,
  }) =>
      UserDetails(
        imagePath: imagePath ?? this.imagePath,
        userName: userName ?? this.userName,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        password: password ?? this.password,
        userId: userId ?? this.userId,
      );
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['imagePath'] = imagePath;
    data['userName'] = userName;
    data['email'] = email;
    data['mobile'] = mobile;
    data['password'] = password;
    data['userId'] = userId;
    return data;
  }

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      imagePath: json['imagePath'] == null ? '' : json['imagePath'] as String,
      userName: json['userName'] == null ? '' : json['userName'] as String,
      email: json['email'] == null ? '' : json['email'] as String,
      mobile: json['mobile'] == null ? '' : json['mobile'] as String,
      password: json['password'] == null ? '' : json['password'] as String,
      userId: json['userId'] == null ? 0 : json['userId'] as num,
    );
  }
}
