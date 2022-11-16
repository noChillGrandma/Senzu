import 'package:firebase_auth/firebase_auth.dart';
import 'package:senzu_app/screens/authentication/authenticate.dart';
import 'package:senzu_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    
    // return either the Home or Authenticate widget
    if (user != null){
      return Home();
    } else {
      return Authenticate();
    }
    
  }
}