// ignore_for_file: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:basic_auth_app/models/user.dart';

class FirebaseAuthServices {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;
  User? get currentUser => auth.currentUser;

  Users? userFromFirebaseUser(User? user) {

    if(user != null){
      return Users(
        uid: user.uid,
        email: user.email,
        photoURL: user.photoURL,
        emailVerified: user.emailVerified,
      );
    }

    return null;
  }

  Stream<Users?> get user {
    return auth.authStateChanges().map(userFromFirebaseUser);
  }

  Future<Users?> signupWithEmailAndPass(String email, String pass) async {
    try {

      final userData = await auth.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      User? user = userData.user;
      if (user == null) return null;

      String? userProfileUrl = user.photoURL ?? 'https://i.pinimg.com/236x/dd/f0/11/ddf0110aa19f445687b737679eec9cb2.jpg';

      await store.collection('Users').doc(user.uid).set({
        'UserID': user.uid,
        'UserEmail': user.email,
        'UserPfpUrl': userProfileUrl,
        'IsEmailVerified': user.emailVerified,
      }, SetOptions(merge: true));

      return userFromFirebaseUser(user);

    } on FirebaseAuthException catch (e) {

      throw e.message ?? 'Sign Up Failed';

    }
  }

  Future loginWithEmailAndPass(String email, String pass) async {

    try{

      final userData = await auth.signInWithEmailAndPassword(
        email: email,
        password: pass
      );

      return userData;

    } on FirebaseAuthException catch (e) {

      return e.message;

    }

  }

  Future userData(String email, String pass) async {

    try{

      final User? currentUser = auth.currentUser;
      if (currentUser == null) return null;

      Users user = Users(uid: currentUser.uid, emailVerified: currentUser.emailVerified);

      return userFromFirebaseUser(user as User?);

    } on FirebaseAuthException catch (e) {

      return e.message;

    }

  }

  Future logout() async{

    try {

      return await auth.signOut();

    } on FirebaseAuthException catch (e) {

      return e.message;

    }

  }

}