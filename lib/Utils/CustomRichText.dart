import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

Widget customRichText(String primaryText,String secText){
  return RichText(
    text: TextSpan(
      text: primaryText,
      style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w900,
          color: Colors.black),
      children: <TextSpan>[
        TextSpan(
            text: secText,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: HexColor('#7AC301'))),
      ],
    ),
  );
}