import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  bool isSignedIn = false;
  checkAuthentication() {
    _auth.authStateChanges().listen((event) {
      if (event == null) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  getUser() async {
    User? firebaseUser = _auth.currentUser!;
    await firebaseUser.reload();
    firebaseUser = _auth.currentUser!;
    if (firebaseUser != null) {
      setState(() {
        user = firebaseUser;
        isSignedIn = true;
      });
    }
  }

  signOut() {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    checkAuthentication();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Center(
                    child: Image.asset(
                  'assets/landing.png',
                  height: 200.0,
                  width: 200.0,
                )),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Hey, ${user!.displayName} you are successfully logged in, ${user!.email}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  onPressed: signOut,
                  child: Text(
                    'Sign Out',
                    style: TextStyle(fontSize: 15.0),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 15.0),
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0))),
                )
              ],
            ),
    );
  }
}
