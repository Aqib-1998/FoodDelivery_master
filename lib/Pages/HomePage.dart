import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/Utils/BottomSheet.dart';
import 'package:food_delivery/Utils/CustomButton.dart';
import 'package:food_delivery/Utils/CustomRichText.dart';
import 'package:food_delivery/Utils/auth.dart';
import 'package:food_delivery/Utils/platform_alert_dialog.dart';
import 'package:food_delivery/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'LoginScreen.dart';
import 'OrderDetailsScreen.dart';
import 'ShopeMenu.dart';

String newAddress, newContact;
String url = '';
String tokenId,shopName ;
class HomePage extends StatefulWidget {
  final AuthBase auth;
  final String uid;

  const HomePage({Key key, @required this.auth, @required this.uid})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<void> _signOut() async {
    try {
      newUserBool = null;
      await widget.auth.signOut().then((res) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyApp()),
            ModalRoute.withName('/'));
      });
      phoneController.clear();
    } catch (e) {}
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Sign out',
      content: 'Are you sure?',
      defaultActionText: 'Sign out',
      cancelActionText: 'Cancel',
    ).show(context);
    if (didRequestSignOut == true) {
      OneSignal.shared.disablePush(true);
      _signOut();
    }
  }
  String appId = "ebb451e6-249d-4e68-9b16-7a04100a8edb";
  String _debugLabelString = "";
  Future<void> initOneSignal(BuildContext context) async {
    await OneSignal.shared.setAppId(appId);
    final status = await OneSignal.shared.getDeviceState().then((value) async {
     final String osUserID = value.userId;
     await FirebaseFirestore.instance.collection("Shop Users").doc(widget.uid).update({
             'token Id': osUserID
           });
    });

    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
      print('FOREGROUND HANDLER CALLED WITH: $event');
      /// Display Notification, send null to not display
      event.complete(event.notification);

      this.setState(() {
        _debugLabelString = "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });

    });

  }



  @override
  void initState() {
    setState(() {
      print("user id =======> ${widget.uid}");
    });
    OneSignal.shared.disablePush(false);
    initOneSignal(context);
    setState(() {

    });
    print(tokenId);
    super.initState();
  }

  File imageFile;
  final picker = ImagePicker();

  chooseImage(ImageSource source) async {
    final pickedImage = await picker.getImage(source: source);
    setState(() {
      imageFile = File(pickedImage.path);
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(widget.uid);
    UploadTask uploadTask = ref.putFile(imageFile);

    //url = await ref.getDownloadURL();
    uploadTask.then((res) async {
      url = await res.ref.getDownloadURL();
      print(url);
    }).whenComplete(() async {
      FirebaseFirestore.instance
          .collection('Shop Users')
          .doc(widget.uid)
          .update({"Shop Image": url});

      setState(() {});
    });
    print(url);
  }


  Future getDocs() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("Shop Users")
        .doc(widget.uid)
        .collection("New User?")
        .get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      print(a);
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15)),
                color: defaultColor,
              ),
              child: TabBar(indicatorColor: Colors.transparent, tabs: [
                Tab(
                  child: Text(
                    'My Shop',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Tab(
                  child: Text(
                    'Queued Orders',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                Tab(
                  child: Text(
                    'Completed Orders',
                    style: TextStyle(fontSize: 14),
                  ),
                )
              ]),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 8.0, left: 14, right: 14),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('Shop Users')
                          .doc(widget.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        shopName = snapshot.data["Shop Name"];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              shopName ,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w700),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height / 3.25,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  ),
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      child: CachedNetworkImage(
                                        progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                            Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        value: downloadProgress
                                                            .progress)),
                                        imageUrl: snapshot.data["Shop Image"],
                                        fit: BoxFit.fill,
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          chooseImage(ImageSource.gallery);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'lib/Images/edt_icon.png'),
                                                  alignment: Alignment.center,
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            customButton('Shop Menu', () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopMenu(
                                          uid: widget.uid,
                                        )),
                              );
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            customButton('Shop Address', () {
                              bottomSheet(
                                  context,
                                  "Shop Address",
                                  "Shop",
                                  "Address",
                                  "Change Address.",
                                  "Enter new Address",
                                  widget.uid, () {
                                setState(() {});
                              }, () {
                                setState(() {});
                              }, newAddress, "Shop Address");
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            customButton('Contact Number', () {
                              bottomSheet(
                                  context,
                                  "Shop Contact",
                                  "Contact",
                                  "Number",
                                  "Change Contact No.",
                                  "Enter new Contact no.",
                                  widget.uid, () {
                                setState(() {});
                              }, () {
                                setState(() {});
                              }, newContact, "Shop Contact");
                            }),
                            SizedBox(
                              height: 10,
                            ),
                            customButton(
                                'Reviews',
                                () => reviewBottomSheet(
                                    context, "Shop", "Reviews", widget.uid)),
                            SizedBox(
                              height: 10,
                            ),
                            customButton(
                                'Sign Out', () => _confirmSignOut(context)),
                          ],
                        );
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: customRichText("Queued", " Orders"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Shop Users")
                                .doc(widget.uid)
                                .collection('Queued Orders')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.data.docs.length == 0) {
                                return Center(
                                  child: Text("No Order in Queue! "),
                                );
                              }
                              return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        bottom: 4.0,
                                        top: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        List<String> productName = [], productNote = [],productUnit= [];
                                        List<int> productKg = [], productPao = [],productPrice=[];
                                        String orderId = snapshot.data.docs[index].id;
                                        String customerTokenId = snapshot.data.docs[index]["Customer TokenId"];
                                        String customerName = snapshot.data.docs[index]["Customer Name"];
                                        String customerId = snapshot.data.docs[index]["Customer Id"];
                                        for (int i = 0; i < snapshot.data.docs[index]['Product Name'].length; i++) {
                                          productName.add(snapshot.data.docs[index]['Product Name'][i]);
                                          productNote.add(snapshot.data.docs[index]['Product Note'][i]);
                                          productKg.add(snapshot.data.docs[index]['kg'][i]);
                                          productPao.add(snapshot.data.docs[index]['pao'][i]);
                                          productPrice.add(snapshot.data.docs[index]['Product Price'][i]);
                                          productUnit.add(snapshot.data.docs[index]['Product Unit'][i]);
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailsScreen(
                                                    time: formatDate(snapshot.data.docs[index]["TimeStamp"].toDate(),
                                                        [hh, ':', nn, ' ', am]).toString(),
                                                    date: formatDate(snapshot.data.docs[index]["TimeStamp"].toDate(), [dd, '-', mm, '-', yyyy]).toString(),
                                                    address: snapshot.data.docs[index]["location"],
                                                    orderId: orderId,
                                                    productName: productName,
                                                    productNote: productNote,
                                                    productKg: productKg,
                                                    productPao: productPao,
                                                    productPrice: productPrice,
                                                    productUnit: productUnit,
                                                    total: snapshot.data.docs[index]["Total Price"],
                                                    long: snapshot.data.docs[index]["long"] ,
                                                    lat: snapshot.data.docs[index]["lat"],
                                                    customerTokenId: customerTokenId,
                                                    uid: widget.uid,
                                                    customerName: customerName,
                                                    shopTokenId: tokenId,
                                                    shopName: shopName,
                                                    showButton: true, customerId: customerId,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 125,
                                        child: Card(
                                          color: customButtonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          elevation: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  height: 55,
                                                  child: Image.asset(
                                                      'lib/Images/Cart.png')),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(snapshot
                                                            .data.docs[index]
                                                        ["Customer Name"]),
                                                    Text(
                                                        "${formatDate(snapshot.data.docs[index]["TimeStamp"].toDate(), [
                                                      dd,
                                                      '-',
                                                      mm,
                                                      '-',
                                                      yyyy
                                                    ])}"),
                                                    Text(
                                                        "${formatDate(snapshot.data.docs[index]["TimeStamp"].toDate(), [
                                                      hh,
                                                      ':',
                                                      nn,
                                                      ' ',
                                                      am
                                                    ])}"),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  height: 20,
                                                  child: Image.asset(
                                                      'lib/Images/redclock.png')),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: customRichText("Completed", " Orders"),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection("Shop Users")
                                .doc(widget.uid)
                                .collection('Completed Orders')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.data.docs.length == 0) {
                                return Center(
                                  child: Text("No Completed Orders! "),
                                );
                              }
                              return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0,
                                        right: 8.0,
                                        bottom: 4.0,
                                        top: 4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        List<String> productName = [], productNote = [],productUnit=[];
                                        List<int> productKg = [], productPao = [],productPrice=[];
                                        String orderId = snapshot.data.docs[index]["Order Id"];
                                        String customerTokenId = snapshot.data.docs[index]["Customer TokenId"];
                                        String customerName = snapshot.data.docs[index]["Customer Name"];
                                        String customerId = snapshot.data.docs[index]["Customer Id"];
                                        for (int i = 0; i < snapshot.data.docs[index]['Product Name'].length; i++) {
                                          productName.add(snapshot.data.docs[index]['Product Name'][i]);
                                          productNote.add(snapshot.data.docs[index]['Product Note'][i]);
                                          productKg.add(snapshot.data.docs[index]['kg'][i]);
                                          productPao.add(snapshot.data.docs[index]['pao'][i]);
                                          productPrice.add(snapshot.data.docs[index]['Product Price'][i]);
                                          productUnit.add(snapshot.data.docs[index]['Product Unit'][i]);
                                        }
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailsScreen(
                                                    time: formatDate(snapshot.data.docs[index]["TimeStamp"].toDate(),
                                                        [hh, ':', nn, ' ', am]).toString(),
                                                    date: formatDate(snapshot.data.docs[index]["TimeStamp"].toDate(), [dd, '-', mm, '-', yyyy]).toString(),
                                                    address: snapshot.data.docs[index]["location"],
                                                    orderId: orderId,
                                                    productName: productName,
                                                    productNote: productNote,
                                                    productKg: productKg,
                                                    customerId: customerId,
                                                    productUnit:productUnit ,
                                                    productPao: productPao,
                                                    productPrice: productPrice,
                                                    total: snapshot.data.docs[index]["Total Price"],
                                                    long: snapshot.data.docs[index]["long"] ,
                                                    lat: snapshot.data.docs[index]["lat"],
                                                    customerTokenId: customerTokenId,
                                                    uid: widget.uid,
                                                    customerName: customerName,
                                                    shopTokenId: tokenId,
                                                    shopName: shopName,
                                                    showButton: false,
                                                  )),
                                        );
                                      },
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width,
                                        height: 125,
                                        child: Card(
                                          color: customButtonColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(15.0),
                                          ),
                                          elevation: 3,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                  height: 55,
                                                  child: Image.asset(
                                                      'lib/Images/Cart.png')),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceEvenly,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                                  children: [
                                                    Text(snapshot
                                                        .data.docs[index]
                                                    ["Customer Name"]),
                                                    Text(
                                                        "${formatDate(snapshot.data.docs[index]["TimeStamp"].toDate(), [
                                                          dd,
                                                          '-',
                                                          mm,
                                                          '-',
                                                          yyyy
                                                        ])}"),
                                                    Text(
                                                        "${formatDate(snapshot.data.docs[index]["TimeStamp"].toDate(), [
                                                          hh,
                                                          ':',
                                                          nn,
                                                          ' ',
                                                          am
                                                        ])}"),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                  height: 20,
                                                  child: Image.asset(
                                                      'lib/Images/tick.png')),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
