import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_login/screens/HomePage.dart';
import 'package:firebase_login/screens/Signin.dart';
import 'package:firebase_login/screens/Signup.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: HomePage(),
      routes: {
        '/signup': (BuildContext context) => Signup(),
        '/signin': (BuildContext context) => Signin(),
      },
    );
  }
}
