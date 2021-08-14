import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../main.dart';



Widget customTextField(String hintText, TextInputType textInputType,
    TextEditingController controller) {
  return Theme(
    data: ThemeData(primaryColor: textFieldColor),
    child: TextField(
      controller: controller,
      cursorColor: Colors.blueGrey,
      keyboardType: textInputType,
      textInputAction: TextInputAction.next,
      autofocus: false,

      style: TextStyle(fontSize: 18.0, color: Colors.black),
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
          filled: true,
          fillColor:textFieldFillColor ,
          hintText: hintText,
          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16)),
    ),
  );
}


Widget customTextFieldPhoneNo(String hintText, TextInputType textInputType,
    TextEditingController controller) {
  return Theme(
    data: ThemeData(primaryColor: textFieldColor),
    child: TextField(
      controller: controller,
      cursorColor: Colors.blueGrey,
      keyboardType: textInputType,
      autofocus: false,
      style: TextStyle(fontSize: 18.0, color: Colors.black),
      maxLength: 10,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.red)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent)),
        filled: true,
        fillColor: textFieldFillColor,
        hintText: hintText,
        hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16),
        prefixText: "+92 - ",
        prefixStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
    ),
  );
}
