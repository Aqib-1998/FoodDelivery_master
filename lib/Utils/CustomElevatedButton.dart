import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget customElevatedButton(String text,onPressed){
  return SizedBox(
    height: 59,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        primary: HexColor('#7AC301'),
        padding: EdgeInsets.symmetric(
            horizontal: 20, vertical: 10),
        elevation: 5,
        textStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
      child: Center(
        child: Text(
          text,style: TextStyle(fontSize: 24,fontWeight: FontWeight.w400),

        ),
      ),
    ),
  );

}