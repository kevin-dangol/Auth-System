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
  final defualtpfp = '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';

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

      await user.sendEmailVerification();

      await store.collection('Users').doc(user.uid).set({
        'UserID': user.uid,
        'UserEmail': user.email,
        'UserPfpUrl': defualtpfp,
        'IsEmailVerified': user.emailVerified,
      }, SetOptions(merge: true));

      return userFromFirebaseUser(user);

    } on FirebaseAuthException catch (e) {

      throw e.message ?? 'Sign Up Failed';

    }
  }

  Future<void> uploadProfilePicture(String base64Image) async {

    if (currentUser != null) {

      await FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid).set({
        'UserPfpUrl': base64Image,
      }, SetOptions(merge: true));

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

  Future<DocumentSnapshot<Map<String, dynamic>>> userData() async {

    final User? currentUser = auth.currentUser;

    return FirebaseFirestore.instance.collection('Users').doc(currentUser?.uid).get();

  }

  Future reserPassword(String email) async{

    try{

      await auth.sendPasswordResetEmail(email: email);

      return true;

    } on FirebaseAuthException catch(e){

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