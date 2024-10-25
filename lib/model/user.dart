
class User {
  final int id;
  final String name;
  final String desc;
  final String avatar;
  final String role;
  final String account;
  final int state;
  final DateTime createdAt;
  final int subscribe;

  User({
    required this.id,
    required this.name,
    required this.desc,
    required this.avatar,
    required this.role,
    required this.account,
    required this.state,
    required this.createdAt,
    required this.subscribe,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      desc: json['desc'] ?? '',
      avatar: json['avatar'] ?? '',
      role: json['role'] ?? '',
      account: json['account'] ?? '',
      state: json['state'],
      createdAt: DateTime.parse(json['createdAt']),
      subscribe: json['subscribe'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'avatar': avatar,
      'role': role,
      'account': account,
      'state': state,
      'createdAt': createdAt.toIso8601String(),
      'subscribe': subscribe,
    };
  }
}