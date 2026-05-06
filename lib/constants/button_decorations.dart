import 'package:flutter/material.dart';

ButtonStyle signupButton(){

  return ElevatedButton.styleFrom(

    minimumSize: Size(double.infinity, 50),

    textStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),

    shape: RoundedRectangleBorder(

      borderRadius: BorderRadiusGeometry.all(Radius.circular(14)),

    ),

    backgroundColor: const Color.fromARGB(255, 19, 58, 91),
    foregroundColor: Colors.white,

  );

}