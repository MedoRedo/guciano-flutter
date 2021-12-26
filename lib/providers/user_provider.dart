import 'package:flutter/cupertino.dart';
import 'package:guciano_flutter/models/user.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';

class UserProvider with ChangeNotifier {
  late final UserRepo _userRepo;
  late User user;
  UserProvider(String userId) {
    _userRepo = UserRepo(userId: userId);
  }

  Future<void> getUserProfile() async {
    user = await _userRepo.getUserProfile();
    notifyListeners();
  }
}
