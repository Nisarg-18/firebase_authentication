import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _key = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  checkAuthentication() {
    _auth.authStateChanges().listen((event) {
      if (event != null) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Firebase.initializeApp();
    this.checkAuthentication();
  }

  navigateToSignup() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  signin() async {
    if (_key.currentState!.validate()) {
      _key.currentState!.save();
      try {
        UserCredential user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
      } catch (e) {
        showError('Invalid Email or Password');
      }
    }
  }

  showError(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'),
                style: TextButton.styleFrom(
                  primary: Colors.red,
                ),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20.0,
            ),
            Image.asset(
              'assets/signin.png',
              height: 200.0,
              width: 200.0,
            ),
            Form(
                key: _key,
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        onSaved: (value) => _email = value!,
                        validator:
                            EmailValidator(errorText: 'Enter a valid Email Id'),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                        onSaved: (value) => _password = value!,
                        validator: MultiValidator([
                          RequiredValidator(errorText: 'password is required'),
                          MinLengthValidator(8,
                              errorText:
                                  'password must be at least 8 digits long'),
                        ]),
                      ),
                    ],
                  ),
                )),
            ElevatedButton(
              onPressed: signin,
              child: Text(
                'Sign In',
                style: TextStyle(fontSize: 20.0),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 10.0,
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            ),
            SizedBox(
              height: 80.0,
            ),
            Text(
              'Don\'t have a account?',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            TextButton(
              onPressed: () {
                navigateToSignup();
              },
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
