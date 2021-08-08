import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'BackButton.dart';

Widget topArea(context, String text) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 4.25,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        color: HexColor('#7AC301')),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: backButton()),
            Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    ),
  );
}



Widget topAreaLoginScreen(context, String text) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 4.25,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25)),
        color: HexColor('#7AC301')),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(),
            Text(
              text,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    ),
  );
}
