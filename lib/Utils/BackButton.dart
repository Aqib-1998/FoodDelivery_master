import 'package:flutter/material.dart';

Widget backButton (){
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
        borderRadius:
        BorderRadius.all(Radius.circular(15)),
        color: Colors.white),
    child: Center(
      child: Icon(
        Icons.arrow_back_ios_rounded,
        color: Colors.black,
      ),
    ),
  );
}