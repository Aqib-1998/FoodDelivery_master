import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Utils/BackButton.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomRichText.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart';
import '../main.dart';

final orderDetailTextStyle =
TextStyle(fontWeight: FontWeight.w300, fontSize: 14);
final firstRowTextStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
final rowTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);

class OrderDetailsScreen extends StatelessWidget {
  final String date;
  final String time, customerName;
  final String address, customerTokenId, uid;
  final List<String> productNote, productName;
  final List<int> productKg, productPao, productPrice;
  final String orderId;
  final double total;
  final double lat, long;
  final bool showButton;

  const OrderDetailsScreen({Key key,
    @required this.address,
    @required this.productNote,
    @required this.orderId,
    @required this.date,
    @required this.time,
    @required this.productName,
    @required this.productKg,
    @required this.productPao, @required this.total, @required this.lat,
    @required this.long, @required this.productPrice, @required this.customerTokenId,
    @required this.uid,@required this.customerName,@required this.showButton})
      : super(key: key);

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
                              primary: customButtonColor),
                          onPressed: () {
                            MapUtils.openMap(lat, long);
                          },
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
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 3.0,
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          color: customButtonColor,
                          borderRadius:
                          BorderRadius.all(Radius.circular(12.0))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 12.0, right: 12.0, bottom: 12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Order ID : $orderId",
                                style: orderDetailTextStyle,
                              ),
                              Text(
                                "Date : $date",
                                style: orderDetailTextStyle,
                              ),
                              Text(
                                "Time : $time",
                                style: orderDetailTextStyle,
                              ),
                              Text(
                                "Address : $address",
                                style: orderDetailTextStyle,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Note:",
                                style: orderDetailTextStyle,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: productName.length,
                                  itemBuilder: (BuildContext context,
                                      int index) {
                                    return Text(
                                      "${productNote[index]}",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: orderDetailTextStyle,
                                    );
                                  }
                              )

                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          color: customButtonColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              topLeft: Radius.circular(12))),
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
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Item",
                                    style: firstRowTextStyle,
                                  ),
                                  Text(
                                    "Quantity",
                                    style: firstRowTextStyle,
                                  ),
                                  Text("Price", style: firstRowTextStyle),
                                ],
                              ),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: productName.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          productName[index],
                                          style: rowTextStyle,
                                        ),
                                        Text(
                                          "${productKg[index]} kg ${productPao[index]} pao",
                                          style: rowTextStyle,
                                        ),
                                        Text("${productPrice[index]}",
                                            style: rowTextStyle),
                                      ],
                                    ),
                                  );
                                }),

                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 15,
                      decoration: BoxDecoration(
                          color: totalFieldColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, left: 20.0, right: 20.0, bottom: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: firstRowTextStyle,
                            ),
                            Text("$total Rs.", style: firstRowTextStyle),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    showButton?customElevatedButton("Mark as complete", () async {
                      await FirebaseFirestore.instance.collection('Shop Users')
                          .doc(uid).collection('Completed Orders')
                          .add({
                        'Customer Name':customerName,
                        'location': address,
                        'Product Name': productName,
                        'Product Note': productNote,
                        'Product Price': productPrice,
                        'kg': productKg,
                        'pao': productPao,
                        'Total Price': total,
                        'TimeStamp': DateTime.now(),
                        'lat': lat,
                        'long': long,
                        'Customer token Id': customerTokenId
                      }).whenComplete(()async{
                        FirebaseFirestore.instance
                            .collection("Shop Users")
                            .doc(uid)
                            .collection("Queued Orders").doc(orderId).delete().whenComplete(() async{
                          sendNotification([customerTokenId], "Your order has been finished! Please review the Shop", "notification");
                          final snackBar = SnackBar(
                            content: Text('Order has been marked as completed!'),duration: Duration(seconds: 1),);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.pop(context);
                        });
                      });
                    }):SizedBox(height: 0,)
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

class MapUtils {

  MapUtils._();

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

Future<Response> sendNotification(List<String> tokenIdList, String contents, String heading) async{

  return await post(
    Uri.parse('https://onesignal.com/api/v1/notifications'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>
    {
      "app_id": appId,//kAppId is the App Id that one get from the OneSignal When the application is registered.

      "include_player_ids": tokenIdList,//tokenIdList Is the List of All the Token Id to to Whom notification must be sent.

      // android_accent_color reprsent the color of the heading text in the notifiction
      "android_accent_color":"FF9976D2",

      "small_icon":"ic_stat_onesignal_default",

      "large_icon":"https://www.filepicker.io/api/file/zPloHSmnQsix82nlj9Aj?filename=name.jpg",

      "headings": {"en": heading},

      "contents": {"en": contents},



    }),
  );
}

