
// apiKey: "AIzaSyCeslFgcC_9Thuad4EuFZIl8AkdybRfF-E",
//         appId: "1:401709358196:android:9987edecb3841e1036c521",
//         messagingSenderId: "401709358196",
//         projectId: "fir-1-163b4",


import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if Firebase is already initialized before calling it again
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCeslFgcC_9Thuad4EuFZIl8AkdybRfF-E",
        appId: "1:401709358196:android:9987edecb3841e1036c521",
        messagingSenderId: "401709358196",
        projectId: "fir-1-163b4",
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return const ChatScreen(); // User is signed in
          } else {
            return const AuthScreen(); // User is not signed in
          }
        },
      ),
    );
  }
}
