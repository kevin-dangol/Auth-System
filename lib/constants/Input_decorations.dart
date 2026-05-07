// ignore_for_file: file_names

import 'package:flutter/material.dart';

InputDecoration singupInputdecoration({
  required IconData icon,
  required String labelText,
  required String hintText,
}){
  
  return InputDecoration(
    
    prefixIcon: Icon(icon),

    hintText: hintText,

    label: Text(labelText),

    labelStyle: TextStyle(
      fontWeight: FontWeight.w500,
    ),

    floatingLabelStyle: TextStyle(
      color: Colors.black
    ),

    enabledBorder: OutlineInputBorder(

      borderRadius: BorderRadius.all(Radius.circular(14)),

      borderSide: BorderSide(

        strokeAlign: BorderSide.strokeAlignOutside,
        width: 1

      ),

    ),

    focusedBorder: OutlineInputBorder(

      borderRadius: BorderRadius.all(Radius.circular(14)),

      borderSide: BorderSide(

        strokeAlign: BorderSide.strokeAlignCenter,
        width: 2,

      ),

    ),

    errorBorder: OutlineInputBorder(

      borderRadius: BorderRadius.all(Radius.circular(14)),

      borderSide: BorderSide(

        strokeAlign: BorderSide.strokeAlignCenter,
        color: Colors.red,
        width: 2,

      ),
    ),

    focusedErrorBorder: OutlineInputBorder(

      borderRadius: BorderRadius.all(Radius.circular(14)),

      borderSide: BorderSide(

        strokeAlign: BorderSide.strokeAlignCenter,
        color: Colors.red,
        width: 2,

      ),
    ),
  );
}