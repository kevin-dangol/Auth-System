// ignore_for_file: unused_import
import 'package:basic_auth_app/Services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuthServices auth = FirebaseAuthServices();
  
  late String userID;
  late String userEmail;
  late bool userProfile = false;
  late String? userPfpURL;
  late bool emailVerified;
  

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
          child: FutureBuilder(
            future: FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser?.uid).get(),
            builder: (context, snapshot) {

              if(snapshot.connectionState == ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }

              if(!snapshot.hasData){
                return const Text('No data available.');
              }

              var data = snapshot.data!.data();
              
              userID = data?['UserID'];
              userEmail = data?['UserEmail'];
              userPfpURL = data?['UserPfpUrl'];
              if(data?['UserPfpUrl'] == "https://i.pinimg.com/236x/dd/f0/11/ddf0110aa19f445687b737679eec9cb2.jpg"){
                userProfile = true;
              }
              emailVerified = data?['IsEmailVerified'];

              return Column(
                children: [
                  Text(
                    'UserID:\n$userID',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),
              
                  Text(
                    'UserEmail:\n$userEmail',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),
              
                  Text(
                    'UserProfile: $userProfile',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),
              
                  Text(
                    'Is Email verified: $emailVerified',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),

                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Image.network(userPfpURL!),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}