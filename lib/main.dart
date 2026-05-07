// ignore_for_file: unused_import
import 'package:basic_auth_app/Services/auth.dart';
import 'package:basic_auth_app/firebase_options.dart';
import 'package:basic_auth_app/screens/Authentication/authentication.dart';
import 'package:basic_auth_app/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 174, 252, 227),
        // brightness: Brightness.dark,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          final user = snapshot.data;

          if (user == null) {
            return AuthScreen();
          }

          return FutureBuilder(
            future: FirebaseAuthServices().ensureUserDocumentExists(user),
            builder: (context, fireSnapshot) {

              if (fireSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return HomePage();
            },
          );
        },
      ),

      // home: HomePage(),
    );
  }
}
