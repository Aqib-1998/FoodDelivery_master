import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

Widget customTextField(String hintText, TextInputType textInputType,
    TextEditingController controller) {
  return Theme(
    data: ThemeData(primaryColor: HexColor('#DEDEDE')),
    child: TextField(
      controller: controller,
      cursorColor: Colors.blueGrey,
      keyboardType: textInputType,
      textInputAction: TextInputAction.next,
      autofocus: false,
      style: TextStyle(fontSize: 18.0, color: Colors.black),
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          filled: true,
          fillColor: HexColor('#e6e6e6'),
          hintText: hintText,
          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16)),
    ),
  );
}

Widget customTextFieldPhoneNo(String hintText, TextInputType textInputType,
    TextEditingController controller) {
  return Theme(
    data: ThemeData(primaryColor: HexColor('#DEDEDE')),
    child: TextField(
      controller: controller,
      cursorColor: Colors.blueGrey,
      keyboardType: textInputType,
      autofocus: false,
      style: TextStyle(fontSize: 18.0, color: Colors.black),
      maxLength: 10,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        filled: true,
        fillColor: HexColor('#e6e6e6'),
        hintText: hintText,
        hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16),
        prefixText: "+92 - ",
        prefixStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
      ),
    ),
  );
}
