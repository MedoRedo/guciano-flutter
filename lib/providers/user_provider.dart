import 'package:flutter/cupertino.dart';
import 'package:guciano_flutter/models/user_profile.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';

class UserProvider with ChangeNotifier {
  late final UserRepo _userRepo;
  late UserProfile user;

  UserProvider() {
    _userRepo = UserRepo();
  }

  Future<void> getUserProfile() async {
    user = await _userRepo.getUserProfile();
    notifyListeners();
  }
}
