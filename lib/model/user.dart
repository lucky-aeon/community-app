// 用于文章的用户信息
class User {
  final int id;
  final String name;
  final String avatar;

  User({
    required this.id,
    required this.name,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }
}

// 用于个人资料的用户信息
class UserInfo {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  String name;
  final String account;
  final String desc;
  final String avatar;
  int subscribe;
  UserInfo({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.name,
    required this.account,
    required this.desc,
    required this.avatar,
    required this.subscribe,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? 0,
      createdAt: DateTime.parse(json['createdAt'] ?? '1970-01-01'),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      name: json['name'] ?? '',
      account: json['account'] ?? '',
      desc: json['desc'] ?? '',
      avatar: json['avatar'] == null || json['avatar'].toString().length > 5
          ? "/file/singUrl?fileKey=${json['avatar']}"
          : '',
      subscribe: json['subscribe'] ?? 0,
    );
  }
}

class ChangePassword {
  final String oldPassword;
  final String newPassword;
  final String confirmPassword;

  ChangePassword(
      {required this.oldPassword,
      required this.newPassword,
      required this.confirmPassword});

  bool isNotEmpty() {
    return oldPassword.isNotEmpty && newPassword.isNotEmpty && confirmPassword.isNotEmpty;
  }

  bool validate() {
    return isNotEmpty() && newPassword == confirmPassword;
  }
}
