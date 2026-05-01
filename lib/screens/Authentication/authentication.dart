import 'package:basic_auth_app/screens/Authentication/login.dart';
import 'package:basic_auth_app/screens/Authentication/singup.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  bool isLogin =  false;
  void togglePage(){
    setState(() => isLogin = !isLogin );
  }

  @override
  Widget build(BuildContext context) {
    if(isLogin == false){

      return SignupPage(togglePage: togglePage);

    } else {

      return LoginPage(togglePage: togglePage);

    }
  }
}