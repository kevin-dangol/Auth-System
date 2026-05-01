import 'package:basic_auth_app/Services/auth.dart';
import 'package:basic_auth_app/constants/InputDecorations.dart';
import 'package:basic_auth_app/constants/buttonDecorations.dart';
import 'package:basic_auth_app/screens/Authentication/authentication.dart';
import 'package:flutter/material.dart';

class PasswordReset extends StatefulWidget {

  final Function togglePage;
  const PasswordReset({super.key, required this.togglePage});

  @override
  State<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {
  
  final FirebaseAuthServices auth = FirebaseAuthServices();
  final _formKey = GlobalKey<FormState>();

  String email = '';
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
                  text: 'Password Reset',
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

                  Text(error),

                  ElevatedButton(

                    onPressed: () {
                      if(_formKey.currentState!.validate()){
                        try{

                          dynamic result = auth.reserPassword(email);
                          
                          if(result){
                            setState(() {
                              error = 'Password Reset Link Sent.';
                            });
                          }

                        } catch(e){

                          debugPrint(e.toString());

                        }
                      }
                    },

                    style: signupButton(),

                    child: Text(
                      'Reset',
                    ),
                  ),

                  SizedBox(height: 10),

                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(

                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                            return AuthScreen();
                          })
                        );
                      },

                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 12, 76, 129),
                          fontWeight: FontWeight.bold,
                        ),
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