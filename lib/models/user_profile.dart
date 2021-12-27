class UserProfile {
  String name;
  String phoneNumber;
  num availableBalance;
  bool isDormStudent;
  String? dormId;
  String image;

  UserProfile({
    required this.name,
    required this.phoneNumber,
    required this.isDormStudent,
    this.dormId,
    required this.availableBalance,
    required this.image,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'],
      phoneNumber: json['phone_number'],
      isDormStudent: json['is_dorm_student'],
      availableBalance: json['available_balance'],
      dormId: json['dorm_id'],
      image: json['image'],
    );
  }
}
