import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/EditMenuScreen.dart';
import 'package:food_delivery/Utils/BackButton.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomRichText.dart';
import 'package:food_delivery/Utils/platform_alert_dialog.dart';
import '../main.dart';
import 'AddMenuScreen.dart';

TextStyle subTitleStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 11);
TextStyle titleStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 14);



class ShopMenu extends StatefulWidget {
  final String uid;

  const ShopMenu({Key key,@required this.uid}) : super(key: key);
  @override
  _ShopMenuState createState() => _ShopMenuState();
}


Future<void> _confirmDelete(BuildContext context,delete()) async {
  final deleteRequest = await PlatformAlertDialog(
    title:  'Delete' ,
    content: 'Are you sure?',
    defaultActionText:  'Delete' ,
    cancelActionText: 'Cancel',
  ).show(context);
  if (deleteRequest == true) {
    delete();
  }
}


class _ShopMenuState extends State<ShopMenu> {

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
                        stream: FirebaseFirestore.instance
                            .collection("Shop Users")
                            .doc(widget.uid)
                            .collection('Shop Menus').snapshots(),
                        builder: (context, snapshot) {
                          List<String> menuName = [],
                              menuAmount = [],
                              menuQuantity = [],
                              menuImage = [],
                              docId = [];

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
                              menuName
                                  .add(snapshot.data.docs[index]["Menu Name"]);
                              docId.add(snapshot.data.docs[index].id);
                              menuAmount.add(
                                  snapshot.data.docs[index]["Menu Amount"]);
                              menuQuantity.add(
                                  snapshot.data.docs[index]["Menu Quantity"]);
                              menuImage
                                  .add(snapshot.data.docs[index]["Menu Image"]);
                              return Card(
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: customButtonColor,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height /
                                          7,
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .width / 3,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15)),
                                      ),
                                      child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12.0),
                                          child:  CachedNetworkImage(
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                            imageUrl: menuImage[index],
                                            fit: BoxFit.fill,

                                          )
                                      ),
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
                                          menuName[index],
                                          style: titleStyle,
                                        ),
                                        Text(
                                          "${menuAmount[index]} Rs. per ${menuQuantity[index]} kg",
                                          style:subTitleStyle,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditMenu(
                                                            menuName:
                                                            menuName[index],
                                                            menuAmount:
                                                            menuAmount[
                                                            index],
                                                            menuImage:
                                                            menuImage[
                                                            index],
                                                            menuQuantity:
                                                            menuQuantity[
                                                            index],
                                                            docId: docId[index],
                                                          )),
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
                                                _confirmDelete(context,() async {
                                                  await FirebaseFirestore.instance
                                                      .runTransaction((Transaction
                                                  myTransaction) async {
                                                    await myTransaction.delete(
                                                        snapshot.data.docs[index]
                                                            .reference);
                                                  });

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
                    MaterialPageRoute(builder: (context) => AddMenu(uid: widget.uid,)),
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
