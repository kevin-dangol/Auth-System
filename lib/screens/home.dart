// ignore_for_file: use_build_context_synchronously

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
  final _emailForm = GlobalKey<FormState>();
  final _deleteform = GlobalKey<FormState>();
  final ImagePicker picker = ImagePicker();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _deletePassController = TextEditingController();

  bool? emailVerified;

  String error = '';

  late String userID;
  late String userEmail;
  String? userPfpURL;
  String? base64Image;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    _deletePassController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    syncEmail();
    loadVerificationStatus();
  }

  
  Future<void> syncEmail() async {

    await auth.syncUserEmailToFirestore();
    if (!mounted) return;
    setState(() {});

  }

  Future<void> loadVerificationStatus() async {

    await auth.currentUser?.reload();
    if (!mounted) return;
    setState(() {
      emailVerified = auth.currentUser?.emailVerified;
    });

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
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection("Users").doc(auth.currentUser!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Creating user profile..."));
                }

                final rawData = snapshot.data!.data();

                if (rawData == null) {
                  return const Center(
                    child: Text("User data not found"),
                  );
                }

                final data = rawData as Map<String, dynamic>;

                userID = data['UserID'];
                userEmail = data['UserEmail'];

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
                          if(emailVerified!=null && emailVerified==false)
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
                            child: profilePicture==null?
                              CircleAvatar(radius: 50, child: Icon(Icons.person)):
                              Image.memory(
                                base64Decode(profilePicture),
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

                                  await auth.uploadProfilePicture(base64Encode(imageBytes));
                                  setState(() {});
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
                                auth.resetPassword(userEmail);
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
                      key: _emailForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Email Input Field
                          TextFormField(
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
                            controller: _passController,
                            obscureText: true,
                            decoration: singupInputdecoration(
                                icon: Icons.password,
                                labelText: 'Password',
                                hintText: 'JohnDoe'),

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
                              if (_emailForm.currentState!.validate()) {
                                try {
                                  final result = await auth.resetEmail(
                                      _emailController.text.trim(),
                                      _passController.text.trim());

                                  if (result) {

                                    if (!mounted) return;

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          icon: const Icon(Icons.check),
                                          title: const Text('Success'),
                                          content: const Text(
                                            'Successfully sent verification email in your new mail. Check it to change email.',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                auth.logout();
                                              },
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
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

                    SizedBox(height: 30),

                    Text('Delete Account: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    ),

                    SizedBox(height: 30),

                    Form(
                      key: _deleteform,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [

                          TextFormField(
                            controller: _deletePassController,
                            obscureText: true,
                            decoration: singupInputdecoration(
                                icon: Icons.password,
                                labelText: 'Password',
                                hintText: 'JohnDoe'),

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
                              if (_deleteform.currentState!.validate()) {
                                try {

                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        icon: const Icon(Icons.delete),
                                        title: const Text('Are you sure?'),
                                        content: const Text('Are you sure you want to delete the account?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Yes'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('No'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm != true){
                                    return;
                                  }
                                  else{
                                    auth.delete(_deletePassController.text.trim());
                                  }

                                } catch (e) {
                                  debugPrint(e.toString());
                                }
                              }
                            },
                            style: signupButton(),
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 60),
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