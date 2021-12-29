import 'package:flutter/material.dart';
import 'package:guciano_flutter/models/user_profile.dart';
import 'package:guciano_flutter/pages/login_page.dart';
import 'package:guciano_flutter/repositories/auth_repo.dart';
import 'package:guciano_flutter/repositories/user_repo.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameTextController = TextEditingController();

  final _emailTextController = TextEditingController();

  final _mobileTextController = TextEditingController();

  final _balanceTextController = TextEditingController();

  late final authRepo;
  late final userRepo;

  late Future<UserProfile> data;

  @override
  void initState() {
    authRepo = AuthRepo();
    userRepo = UserRepo();
    data = userRepo.getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: data,
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        UserProfile user = snapshot.data!;
        _nameTextController.text = user.name;
        _emailTextController.text = user.email;
        _mobileTextController.text = user.phoneNumber;
        _balanceTextController.text = user.availableBalance.toString();

        return ListView(
          padding: EdgeInsets.all(8.0),
          children: [
            Center(
              child: Container(
                height: 140.0,
                width: 140.0,
                margin: EdgeInsets.symmetric(vertical: 16.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(user.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Account Information',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Card(
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full Name',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _nameTextController,
                      readOnly: true,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Email',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _emailTextController,
                      readOnly: true,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Phone',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _mobileTextController,
                      readOnly: true,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      'Available Balance',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                    TextField(
                      controller: _balanceTextController,
                      readOnly: true,
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                authRepo.signOut().then((_) => Navigator.of(context)
                    .pushNamedAndRemoveUntil(
                        LoginPage.tag, (Route<dynamic> route) => false));
              },
              child: Text('Log Out', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
