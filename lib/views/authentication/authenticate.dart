import 'package:flutter/material.dart';
import 'signin.dart';
import 'signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool isSignIn=true;

  void toggleView() {
    setState(() {
      isSignIn = !isSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isSignIn?SignIn(toggleView: toggleView,):SignUp(toggleView: toggleView,);
  }
}
