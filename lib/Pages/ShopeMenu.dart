import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/EditMenuScreen.dart';
import 'package:food_delivery/Utils/BackButton.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomRichText.dart';
import 'package:hexcolor/hexcolor.dart';

import 'AddMenuScreen.dart';
import 'CreateShopPage.dart';

final FirebaseAuth getUid = FirebaseAuth.instance;
final ref =  FirebaseFirestore.instance
    .collection("Shop Users")
    .doc(getUid.currentUser.uid)
    .collection('Shop Menus');
String docId;
class ShopMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
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
                customRichText("Your", " Menu"),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                    child: StreamBuilder(
                        stream: ref
                            .snapshots(),
                        builder: (context, snapshot) {
                          String menuName, menuAmount, menuQuantity, menuImage;

                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.data.docs.length == 0) {
                            return Center(
                              child: Text("Please add a Menu"),
                            );
                          }

                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              menuName = snapshot.data.docs[index]["Menu Name"];
                              menuAmount =
                                  snapshot.data.docs[index]["Menu Amount"];
                              menuQuantity =
                                  snapshot.data.docs[index]["Menu Quantity"];
                              menuImage =
                                  snapshot.data.docs[index]["Menu Image"];
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: HexColor('#F4F4F4'),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: MediaQuery.of(context).size.height / 7,
                                      width: MediaQuery.of(context).size.width / 3,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                          child: Image.network(
                                        menuImage,
                                        fit: BoxFit.fill,
                                      )),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          menuName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "$menuAmount Rs. per $menuQuantity kg",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => EditMenu()),
                                                );
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'lib/Images/edt_icon.png'),
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                                                  await myTransaction.delete(snapshot.data.docs[index].reference);

                                                });

                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            'lib/Images/dlt_icon.png'),
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.cover)),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                margin: EdgeInsets.only(bottom: 15),
                              );
                            },
                          );
                        }),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                customElevatedButton("Add Menu", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddMenu()),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
