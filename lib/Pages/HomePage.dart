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
import 'LoginScreen.dart';
import 'OrderDetailsScreen.dart';
import 'ShopeMenu.dart';

String shopName, newAddress, newContact;
var shopImage;
String url = '';

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
      _signOut();
    }
  }

  Future<void> getUserInfo() async {
    print(widget.uid);
    await FirebaseFirestore.instance
        .collection('Shop Users')
        .doc(widget.uid)
        .collection("Shop info")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        shopName = result.data()['Shop Name'];
        shopImage = result.data()['Shop Image'];
      });
    }).whenComplete(() {
      setState(() {});
    });
  }

  @override
  void initState() {
    getUserInfo();
    setState(() {
      print("user id =======> ${widget.uid}");
    });
    // TODO: implement initState
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
      shopImage = url;
      var docRef = await FirebaseFirestore.instance
          .collection("Shop Users")
          .doc(widget.uid)
          .collection("Shop info")
          .get();
      docRef.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection('Shop Users')
            .doc(widget.uid)
            .collection("Shop info")
            .doc(result.id)
            .update({"Shop Image": url});
      });

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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      shopName != null
                          ? Text(
                              shopName,
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.w700),
                            )
                          : CircularProgressIndicator(),
                      SizedBox(
                        height: 20,
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 3.25,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: shopImage != null
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    child: CachedNetworkImage(
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          Center(
                                              child: CircularProgressIndicator(
                                                  value: downloadProgress
                                                      .progress)),
                                      imageUrl: shopImage.toString(),
                                      fit: BoxFit.fill,
                                    ))
                                : Image.asset("lib/Images/background.png"),
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
                          setState(() {
                            getUserInfo();
                          });
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
                      customButton('Sign Out', () => _confirmSignOut(context)),
                    ],
                  ),
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
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailsScreen(
                                                    time: formatDate(
                                                        snapshot
                                                            .data
                                                            .docs[index]
                                                                ["Order Date"]
                                                            .toDate(),
                                                        [
                                                          hh,
                                                          ':',
                                                          nn,
                                                          ' ',
                                                          am
                                                        ]).toString(),
                                                    date: formatDate(
                                                        snapshot
                                                            .data
                                                            .docs[index]
                                                                ["Order Date"]
                                                            .toDate(),
                                                        [
                                                          dd,
                                                          '-',
                                                          mm,
                                                          '-',
                                                          yyyy
                                                        ]).toString(),
                                                    address: snapshot
                                                            .data.docs[index]
                                                        ["Customer Address"],
                                                    note: snapshot.data
                                                        .docs[index]["Notes"],
                                                    docId: snapshot
                                                        .data.docs[index].id,
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
                                                        ["Customer name"]),
                                                    Text(
                                                        "${formatDate(snapshot.data.docs[index]["Order Date"].toDate(), [
                                                      dd,
                                                      '-',
                                                      mm,
                                                      '-',
                                                      yyyy
                                                    ])}"),
                                                    Text(
                                                        "${formatDate(snapshot.data.docs[index]["Order Date"].toDate(), [
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
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0, bottom: 4.0, top: 4.0),
                              child: GestureDetector(
                                // onTap: () {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             OrderDetailsScreen()),
                                //   );
                                // },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 125,
                                  child: Card(
                                    color: customButtonColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
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
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text("Ali Haider"),
                                              Text("10-8-2021"),
                                              Text("10:30 a.m")
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
                        ),
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
