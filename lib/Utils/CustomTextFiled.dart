import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';

OutlineInputBorder outlineBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.transparent));

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
          border:outlineBorder,
          focusedBorder: outlineBorder,
          enabledBorder: outlineBorder,
          errorBorder: outlineBorder,
          disabledBorder:outlineBorder,
          filled: true,
          fillColor:textFieldFillColor ,
          hintText: hintText,
          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16)),
    ),
  );
}

Widget locationTextField(String hintText, TextInputType textInputType,
    TextEditingController controller,onTap) {
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
          border:outlineBorder,
          focusedBorder: outlineBorder,
          enabledBorder: outlineBorder,
          errorBorder: outlineBorder,
          disabledBorder:outlineBorder,
          filled: true,
          fillColor:textFieldFillColor ,
          hintText: hintText,
          suffixIcon: InkWell(child: Container(child: Icon(Icons.add_location,color: Colors.black,),),onTap: onTap,),
          hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16)
      ),
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
        border: outlineBorder,
        focusedBorder: outlineBorder,
        enabledBorder: outlineBorder,
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.red)),
        disabledBorder: outlineBorder,
        filled: true,
        fillColor: textFieldFillColor,
        hintText: hintText,
        hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16),
        prefixText: "+92 - ",
        prefixStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
      ),
    ),
  );
}


Widget customPriceDropDown(List<int> list,int price,void function(price) ){
  return  InputDecorator(
    decoration:InputDecoration(
        border:outlineBorder,
        focusedBorder: outlineBorder,
        enabledBorder: outlineBorder,
        errorBorder: outlineBorder,
        disabledBorder:outlineBorder,
        filled: true,
        fillColor:textFieldFillColor ,
        hintText: "Select Price",
        hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<int>(
        // value: gender,
        isDense: true,
        isExpanded: true,
        items: list.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        hint: Text("Select Price",style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15,color: Colors.black),
        onChanged: (newValue) {
          function(newValue);
          price = newValue;
        },
        value: price,
      ),
    ),
  );
}




Widget customQuantityUnitDropDown(List<String> list,String unit,void function(unit) ){
  return  InputDecorator(
    decoration:InputDecoration(
        border:outlineBorder,
        focusedBorder: outlineBorder,
        enabledBorder: outlineBorder,
        errorBorder: outlineBorder,
        disabledBorder:outlineBorder,
        filled: true,
        fillColor:textFieldFillColor ,
        hintText: "Select Unit",
        hintStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 22.0, horizontal: 16)),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        // value: gender,
        isDense: true,
        isExpanded: true,
        items: list.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        hint: Text("Select Unit",style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12)),
        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15,color: Colors.black),
        onChanged: (newValue) {
          function(newValue);
          unit = newValue;
        },
        value: unit,
      ),
    ),
  );
}