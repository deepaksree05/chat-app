import 'package:chatapp/widget/auth_form.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
      String email, String password, String username, bool isLogin) async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (isLogin) {
        // Sign in with email and password
        UserCredential authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        print('Logged in: ${authResult.user?.email}');
      } else {
        // Sign up with email and password
        UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Save user information to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'createdAt': Timestamp.now(),
        });

        print('Registered user: ${authResult.user?.email}');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred, please try again later.';

      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email address is already in use.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'This is not a valid email address.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'No user found for this email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Invalid password. Please try again.';
      }

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.black,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor:Colors.black,
        ),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        _submitAuthForm,
        _isLoading,
      ),
    );
  }
}
