import 'package:basic_auth_app/Services/auth.dart';
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

  late String userID;
  late String userEmail;
  late bool emailVerified;
  String? userPfpURL;
  String? base64Image;

  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          auth.logout();
        },
        child: Icon(Icons.logout),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
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

                  RichText(text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'UserID:\n',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      ),
                      TextSpan(
                        text: userID,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ]
                  )),

                  SizedBox(height: 20),

                  RichText(text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'UserEmail:\n',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
                      ),
                      TextSpan(
                        text: userEmail,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ]
                  )),

                  SizedBox(height: 20),

                  RichText(text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Is Email Verified: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
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
                    ]
                  )),

                  SizedBox(height: 20),

                  Text('Profile Picture: ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

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

                              final XFile? image = await picker.pickImage(source: ImageSource.gallery);

                              if (image != null) {

                                Uint8List imageBytes = await image.readAsBytes();

                                await auth.uploadProfilePicture(base64Encode(imageBytes));

                              }
                            },
                            child: Icon(Icons.camera_alt, size: 15),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  RichText(text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Forgot Password? ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )
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
                    ]
                  )),

                ],
              );
            }
          ),
        ),
      ),
    );
  }
}