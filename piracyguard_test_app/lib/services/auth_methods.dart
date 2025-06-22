import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:piracyguard_test_app/screens/Home/home_screen.dart';
import 'package:uuid/uuid.dart';

import '../screens/Authentiction/login_page.dart';
import '../screens/Authentiction/verification_page.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int totalStars = 0;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? userC = userCredential.user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        await FirebaseFirestore.instance.collection('users').doc(userC!.uid).set({
          'displayName': userC.displayName,
          'email' : userC.email,
          'license': '',
          'isBlocked': false,
          'uid': userC.uid,
          'createdAt': DateTime.now().toString(),
        });
        await FirebaseFirestore.instance.collection('tracking').doc(FirebaseAuth.instance.currentUser!.uid).set({
          'type': 'New User',
          'displayName': userC.displayName,
          'tid' : FirebaseAuth.instance.currentUser!.uid,
          'license':'',
          'isVerified': false,
          'uid': userC.uid,
          'createdAt': DateTime.now().toString(),
          "isBlocked": false
        });
      }
      res = true;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return HomeScreen();
      }));
    } on FirebaseAuthException catch (e) {
      print(e);
      res = false;
    }
    return res;

  }
  //Sign in with email and password
  Future<bool> signInWithEmailAndPass(BuildContext context,String email,String password) async{
    bool res = false;
    try{
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User? userC = userCredential.user;

      if (userC != null) {
        res = true;
      }
    }on FirebaseAuthException catch (e) {
      print(e);
      res = false;
    }
    return res;
  }

  //create User With Email and Password
  Future<bool> createUserWithEmailAndPass(BuildContext context,String email,String password,String name) async{
    bool res = false;
    try{
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = userCredential.user;

      if (user != null) {

        res = true;
      }
    }on FirebaseAuthException catch (e) {
      print(e);
      res = false;
    }
    return res;
  }

  //signOut
  void signOut(BuildContext context) async {
    try {
      _auth.signOut().then((value) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return const LoginScreen();
        }));
      });
    } catch (e) {
      print(e);
    }
  }

  //Send Password Reset Email
  Future<void> sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Password reset emailsent. Please check your inbox.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email address is not valid.';
      } else {
        errorMessage = 'An error occurred: ${e.message}'; // More specific error
      }
      print('Firebase Auth Exception (Password Reset): ${e.message}');
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Unexpected Error (Password Reset): $e');
      // Show generic error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
