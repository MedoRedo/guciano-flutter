class User {
  String name;
  String phoneNumber;
  double availableBalance;
  bool isDormStudent;
  String? dormId;

  User({
    required this.name,
    required this.phoneNumber,
    required this.isDormStudent,
    this.dormId,
    required this.availableBalance,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      phoneNumber: json['phone_number'],
      isDormStudent: json['is_dorm_student'],
      availableBalance: json['available_balance'],
      dormId: json['dorm_id'],
    );
  }
}
