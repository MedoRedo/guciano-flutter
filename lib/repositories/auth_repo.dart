import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(final String email, final String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      print(user);
      return user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return "0";
    }
  }

  Future signOut() {
    return firebaseAuth.signOut();
  }
}
