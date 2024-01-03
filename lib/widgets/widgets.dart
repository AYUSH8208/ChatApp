import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.black),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 26, 117, 222), width: 2),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromARGB(255, 1, 12, 19), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color.fromRGBO(221, 111, 15, 1), width: 2),
  ),
);

void nextscreeen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void replacementscreeen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void showSnackbar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 13),
      ),
      backgroundColor: color,
      duration:Duration(seconds: 2),
      action: SnackBarAction(label: "OK",onPressed: (){},textColor: Colors.white,),));
}
