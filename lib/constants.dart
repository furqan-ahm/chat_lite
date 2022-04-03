import 'package:flutter/material.dart';


class Constants{
  static String? myName='';
  static String? myEmail='';
}




var textInputDecoration=InputDecoration(
  filled: true,
  fillColor:Colors.white12,
  hintStyle: const TextStyle(
    color: Colors.white
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(100),
    borderSide: BorderSide(color: Colors.redAccent, width: 2)
  ),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(color: Colors.orangeAccent, width: 2)
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(color: Colors.blueGrey, width: 2)
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(color: Colors.black12, width: 2)
  ),
);

var appBarMain=AppBar(
  title: Text("Chat Me"),
);

var simpleTextStyle=TextStyle(color: Colors.white, fontSize: 16);
var mediumTextStyle=TextStyle(color: Colors.white, fontSize: 17);
