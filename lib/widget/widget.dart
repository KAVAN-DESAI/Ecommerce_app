import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: const Text('Collegial'),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black),
      focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)));
}

TextStyle textStyle() {
  return TextStyle(color: Colors.black, fontSize: 14);
}

TextStyle textStyle1() {
  return TextStyle(color: Colors.black, fontSize: 18);
}