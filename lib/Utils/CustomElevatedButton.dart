import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';

Widget customElevatedButton(String text,onPressed){
  return SizedBox(
    height: 59,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          primary: defaultColor,
          padding: EdgeInsets.symmetric(
              horizontal: 20, vertical: 10),
          elevation: 5,
          textStyle: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
        child: Center(
          child: Text(
            text,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w400),

          ),
        ),
      ),
    ),
  );

}