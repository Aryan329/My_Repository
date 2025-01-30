import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:studycloud/authenticate/login_screen.dart'; // Import the login screen
import 'firebase_options.dart'; // Firebase configuration file
import 'package:studycloud/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Add this import for User class


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DiceGameApp());
}

class DiceGameApp extends StatelessWidget {
  const DiceGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stake Dice Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginCheck(), // This widget will check if the user is logged in
    );
  }
}

class LoginCheck extends StatefulWidget {
  const LoginCheck({super.key});

  @override
  LoginCheckState createState() => LoginCheckState();
}

class LoginCheckState extends State<LoginCheck> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data != null) {
          // User is logged in
          return HomeScreen(user: snapshot.data!);
        } else {
          // User is not logged in, show login screen
          return LoginScreen();
        }
      },
    );
  }

  Future<User?> _checkLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
}
