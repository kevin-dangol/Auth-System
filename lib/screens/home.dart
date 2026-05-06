import 'package:basic_auth_app/Services/auth.dart';
import 'package:basic_auth_app/constants/Input_decorations.dart';
import 'package:basic_auth_app/constants/button_decorations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuthServices auth = FirebaseAuthServices();
  final _formKey = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String email = '';
  String pass = '';
  String error = '';

  late String userID;
  late String userEmail;
  late bool emailVerified;
  String? userPfpURL;
  String? base64Image;

  // Separate FocusNodes for email and password
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();  // Dispose the focus nodes
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          auth.logout();
        },
        child: Icon(Icons.logout),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: Center(
            child: FutureBuilder<DocumentSnapshot>(
              future: auth.userData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Text('No data available.');
                }

                var data = snapshot.data!.data() as Map<String, dynamic>;

                userID = data['UserID'];
                userEmail = data['UserEmail'];
                emailVerified = data['IsEmailVerified'];

                String? profilePicture = data['UserPfpUrl'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile and User Data
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'UserID:\n',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: userID,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'UserEmail:\n',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: userEmail,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Is Email Verified: ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '$emailVerified',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: ' Verify?',
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 24, 57, 118),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                auth.currentUser?.sendEmailVerification();
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Profile Picture: ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.black,
                          child: ClipOval(
                            child: Image.memory(
                              base64Decode(profilePicture!),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: SizedBox(
                            width: 30,
                            height: 30,
                            child: FloatingActionButton(
                              onPressed: () async {
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);

                                if (image != null) {
                                  Uint8List imageBytes = await image.readAsBytes();

                                  await auth.uploadProfilePicture(
                                      base64Encode(imageBytes));
                                }
                              },
                              child: Icon(Icons.camera_alt, size: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Forgot Password? ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Reset',
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color.fromARGB(255, 24, 57, 118),
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                auth.reserPassword(userEmail);
                              },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Text('Change Email: ',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Email Input Field
                          TextFormField(
                            focusNode: _emailFocusNode,
                            controller: _emailController,
                            decoration: singupInputdecoration(
                                icon: Icons.mail,
                                labelText: 'Email',
                                hintText: 'JohnDoe@gmail.com'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter an Email.';
                              }
                              if (!RegExp(
                                      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                                  .hasMatch(value)) {
                                return 'Enter a valid email.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          // Password Input Field
                          TextFormField(
                            focusNode: _passFocusNode,
                            controller: _passController,
                            obscureText: true,
                            decoration: singupInputdecoration(
                                icon: Icons.password,
                                labelText: 'Password',
                                hintText: 'JohnDoe'),
                            onChanged: (value) {
                              setState(() {
                                pass = value;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter a password.';
                              }
                              return null;
                            },
                          ),
                          Center(child: Text(error)),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                try {
                                  bool  result = await auth.resetEmail(
                                      _emailController.text.trim(),
                                      _passController.text.trim());

                                  if (result) {
                                    setState(() {
                                      error = 'Email verification Link Sent.';
                                    });
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              }
                            },
                            style: signupButton(),
                            child: Text('Reset'),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}