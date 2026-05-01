import 'package:basic_auth_app/constants/InputDecorations.dart';
import 'package:basic_auth_app/constants/buttonDecorations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {

  final Function togglePage;
  const LoginPage({super.key, required this.togglePage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String pass = '';
  String error = '';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [

          Center(
            child: Padding(
              padding: EdgeInsetsGeometry.directional(top: 100),
              child: Text.rich(
                TextSpan(
                  text: 'Login',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 70, 59, 59),
                  ),
                ),
              ),
            ),
          ),

          Form(

            key: _formKey,

            child: Padding(

              padding: const EdgeInsets.all(14),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.end,
                
                children: [
              
                  TextFormField(
                    
                    decoration: singupInputdecoration(icon: Icons.mail, labelText: 'Email', hintText: 'JohnDoe@gmail.com'),

                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },

                    validator: (value) {
                      
                      if(value == null || value.isEmpty){
                        return 'Enter an Email.';
                      }

                      if(!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)){
                        return 'Enter an valid email.';
                      }

                      return null;

                    },

                  ),

                  SizedBox(height: 20),

                  TextFormField(

                    obscureText: true,

                    decoration: singupInputdecoration(icon: Icons.password, labelText: 'Password', hintText: 'JohnDoe'),

                    onChanged: (value) { 
                      setState(() {
                        pass = value;
                      });
                    },

                    validator: (value) {
                      
                      if(value == null || value.isEmpty){
                        return 'Enter a password.';
                      }

                      return null;

                    },

                  ),

                  Text(error),

                  ElevatedButton(

                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        try{

                          debugPrint(email + pass);

                        } catch(e){

                          debugPrint(e.toString());

                        }
                      }
                    },

                    style: signupButton(),

                    child: Text(
                      'Login',
                    ),
                  ),

                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'Signup',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 12, 76, 129),
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                widget.togglePage();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}