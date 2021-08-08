import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Utils/BackButton.dart';
import 'package:food_delivery/Utils/CustomRichText.dart';
import 'package:hexcolor/hexcolor.dart';

final orderDetailTextStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 16);
final firstRowTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.bold);
final rowTextStyle = TextStyle(fontSize: 16,fontWeight: FontWeight.w300);

class OrderDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: backButton(),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    customRichText("Order", " Details"),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0),
                              ),
                              primary: HexColor('#F4F4F4')),
                          onPressed: () {},
                          label: Image.asset(
                            'lib/Images/location.png',
                            height: 19,
                            width: 19,
                          ),
                          icon: Text(
                            'Direction',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        )),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 3.0,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: HexColor('#F4F4F4'),
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 12.0, right: 12.0, bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Date : 20-5-2020",
                              style: orderDetailTextStyle,
                            ),
                            Text(
                              "Time : 12 : 30 a.m",
                              style: orderDetailTextStyle,
                            ),
                            Text(
                              "Address : North Nazimabad",
                              style: orderDetailTextStyle,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Note:",
                              style: orderDetailTextStyle,
                            ),
                            Flexible(
                                child: Text(
                              "Vegetables must be fresh and neat and clean",
                              style: orderDetailTextStyle,
                            )),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(

                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: HexColor('#F4F4F4'),
                          borderRadius:
                          BorderRadius.only(topRight: Radius.circular(12),topLeft: Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 12.0, right: 12.0, bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Bill",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Item",style: firstRowTextStyle,),
                                  Text("Quantity",style: firstRowTextStyle,),
                                  Text("Price",style:firstRowTextStyle),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (context,index){
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Aloo",style: rowTextStyle,),
                                    Text("1 KG",style: rowTextStyle,),
                                    Text("30 Rs.",style:rowTextStyle),
                                  ],
                                ),
                              );
                              }
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Container(
                            //     color: HexColor('#C4C4C4'),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Text("Item",style: firstRowTextStyle,),
                            //         Text("Quantity",style: firstRowTextStyle,),
                            //         Text("Price",style:firstRowTextStyle),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/15,
                      decoration: BoxDecoration(
                          color: HexColor('#C4C4C4'),
                          borderRadius:
                          BorderRadius.only(bottomRight: Radius.circular(12),bottomLeft: Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 20.0, right: 20.0, bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                  Text("Total",style: firstRowTextStyle,),
                                  Text("90 Rs.",style:firstRowTextStyle),
                                ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
