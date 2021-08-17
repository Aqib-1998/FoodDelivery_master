import 'package:flutter/material.dart';
import '../main.dart';

Widget customButton(String text, onPressed){
  return   ButtonTheme(
    minWidth: double.infinity,
    child: MaterialButton(onPressed: onPressed,
      height: 83,
      child: Row(
        children: [
          Text(text,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
          Flexible(child: SizedBox(width: double.infinity,))
        ],
      ),
      color: customButtonColor,
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
  );

}