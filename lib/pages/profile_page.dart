import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/user_profile.dart';
import 'package:guciano_flutter/pages/login_page.dart';
import 'package:guciano_flutter/repositories/auth_repo.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';
import 'package:guciano_flutter/utils/images.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameTextController = TextEditingController();

  final _emailTextController = TextEditingController();

  final _mobileTextController = TextEditingController();

  final _balanceTextController = TextEditingController();

  final authRepo = AuthRepo();
  final userRepo = UserRepo();

  late Future<UserProfile> data;

  @override
  void initState() {
    data = userRepo.getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: data,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        UserProfile user = snapshot.data!;
        _nameTextController.text = user.name;
        _emailTextController.text = user.email;
        _mobileTextController.text = user.phoneNumber;
        _balanceTextController.text = user.availableBalance.toString();

        return ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(70),
                child: FadeInImage(
                  width: 140,
                  height: 140,
                  image: NetworkImage(user.image),
                  placeholder: const AssetImage(Images.placeholderImage),
                  imageErrorBuilder: (context, exception, stackTrace) {
                    return Image.asset(
                      Images.placeholderImage,
                      width: 140,
                      height: 140,
                    );
                  },
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.only(top: 16),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Name',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _nameTextController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _emailTextController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text(
                      'Phone',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _mobileTextController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    const Text(
                      'Available Balance',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _balanceTextController,
                      readOnly: true,
                      style: const TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                authRepo.signOut().then((_) => Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                        LoginPage.tag, (Route<dynamic> route) => false));
              },
              child:
                  const Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
