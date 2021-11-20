import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';
  String _password = '';

  checkAuthenication() {
    _auth.authStateChanges().listen((event) {
      if (event != null) {
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  signUp() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        UserCredential user = await _auth.createUserWithEmailAndPassword(
            email: _email, password: _password);
        if (user != null) {
          setState(() {
            _auth.currentUser!.updateDisplayName(_name);
          });
        }
      } catch (e) {
        showError('Enter valid details');
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
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthenication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/signin.png',
              height: 200.0,
              width: 200.0,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: RequiredValidator(errorText: 'Required'),
                      onSaved: (value) => _name = value!,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator:
                          EmailValidator(errorText: 'Enter a valid Email Id'),
                      onSaved: (value) => _email = value!,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                      validator: MultiValidator([
                        RequiredValidator(errorText: 'Required'),
                        MinLengthValidator(8,
                            errorText:
                                'Password should be atleast 8 characters long')
                      ]),
                      onSaved: (value) => _password = value!,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10.0,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          )),
                      onPressed: signUp,
                      child: Text(
                        'Create Account',
                        style: TextStyle(fontSize: 15.0),
                      ),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Text(
                      'Already have a account?',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/signin');
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(fontSize: 20.0),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
