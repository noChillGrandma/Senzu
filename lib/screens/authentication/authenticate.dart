import 'package:senzu_app/screens/authentication/loginpage.dart';
import 'package:senzu_app/screens/authentication/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView(){
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      // return SignIn(toggleView: toggleView);
      return LoginPage();
    } else {
      return Register(toggleView: toggleView);
    }
  }
}