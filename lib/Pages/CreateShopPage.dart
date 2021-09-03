import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/HomePage.dart';
import 'package:food_delivery/Utils/BackButton.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomTextFiled.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'NamePage.dart';

var imageDir;
String accType,userName;
bool name,newUser,buttonEnable;
String url = '';


class CreateShopPage extends StatefulWidget {
  final auth;
  final String uid;

  const CreateShopPage({Key key, @required this.auth,@required this.uid}) : super(key: key);

  @override
  _CreateShopPageState createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  final shopNameController = TextEditingController();
  final shopAddressController = TextEditingController();
  final shopContactController = TextEditingController();

  Future<void> getAccountType()async{
    await FirebaseFirestore.instance.collection("Shop Users").doc(widget.uid).get().then((value){
      accType = value.data()["Account Type?"];
      userName = value.data()["Username"];
      newUser = value.data()["New user?"];
      if(accType == "Facebook" || accType == "Google"){
        name = false;
      }else if(accType == "Phone"){
        name = true;
      }
      print(accType);
      print(name);
    } );

  }

  var locationMessage = "";
  String _currentAddress = "";
  final geo = Geoflutterfire();
  GeoFirePoint myLocation;
  Future getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    var longitude = position.longitude, latitude = position.latitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    Placemark place = placemarks[0];

    setState(() {
      locationMessage = "$latitude , $longitude";
      _currentAddress = "${place.street}, ${place.locality},${place.administrativeArea}, ${place.country}";
      myLocation = geo.point(latitude: latitude, longitude: longitude,);
      print(locationMessage);
      print(_currentAddress);
    });
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
    }).whenComplete(() {
      setState(() {});
    });
    print(url);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: backButton(),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Create Your Shop",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      chooseImage(ImageSource.gallery);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3.25,
                      width: MediaQuery.of(context).size.width,
                      child: imageFile != null
                          ? Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  image: DecorationImage(
                                      image: FileImage(imageFile),
                                      fit: BoxFit.fill)),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15)),
                                  border: Border.all(color: Colors.grey),
                                  image: DecorationImage(
                                      alignment: Alignment.center,
                                      image: AssetImage(
                                          "lib/Images/chooseimage.png"),
                                      fit: BoxFit.cover)),
                            ),
                    ),
                  ),

                  // Container(
                  //   height: MediaQuery.of(context).size.height / 3.25,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //     border: Border.all(color: Colors.grey),
                  //       image: DecorationImage(
                  //         alignment: Alignment.center,
                  //         image: AssetImage("lib/Images/chooseimage.png"),
                  //         fit: BoxFit.cover
                  //       )),
                  // ),
                  SizedBox(
                    height: 10,
                  ),

                  customTextField("Enter Shop Name", TextInputType.text,
                      shopNameController),
                  SizedBox(
                    height: 10,
                  ),
                  locationTextField("Enter Shop Address", TextInputType.text,
                      shopAddressController, () async {
                    await getCurrentLocation().whenComplete((){
                      shopAddressController.text = _currentAddress;
                      setState(() {

                      });
                    });

                  }),
                  SizedBox(
                    height: 10,
                  ),
                  customTextFieldPhoneNo("3333333333  (no 0 at start)",
                      TextInputType.number, shopContactController),
                  SizedBox(
                    height: 10,
                  ),
                  customElevatedButton("Create Shop", buttonEnable?() async {
                    // var status = await OneSignal.shared.getPermissionSubscriptionState();
                    // String tokenId = status.subscriptionStatus.userId;
                    print(1);
                    if (shopContactController.text.isNotEmpty && shopContactController.text.length == 10 &&
                        shopAddressController.text.isNotEmpty &&
                        shopNameController.text.isNotEmpty &&
                        url.isNotEmpty) {
                      setState(() {
                        buttonEnable = false;
                      });
                      await getCurrentLocation();
                      if(name == false){
                        await FirebaseFirestore.instance
                            .collection("Shop Users")
                            .doc(widget.uid)
                            .set({
                          "Shop Name": shopNameController.text,
                          "Shop Address": shopAddressController.text,
                          "Shop Contact": shopContactController.text,
                          "Shop Image": url,
                          'position': myLocation.data,
                          "Username": userName,
                          "Account Type?": accType,
                          "New user?": false,
                          "token Id": ""
                          //your data which will be added to the collection and collection will be created after this
                        }).then((_) {
                          print("collection created");
                        }).catchError((e) {
                          print(e);
                        });
                      }
                      if(name == true){
                        await FirebaseFirestore.instance
                            .collection("Shop Users")
                            .doc(widget.uid)
                            .set({
                          "Shop Name": shopNameController.text,
                          "Shop Address": shopAddressController.text,
                          "Shop Contact": shopContactController.text,
                          "Shop Image": url,
                          "Username": "",
                          'position': myLocation.data,
                          "Account Type?": accType,
                          "New user?": false,
                          "token Id": ""
                          //your data which will be added to the collection and collection will be created after this
                        }).then((_) {
                          print("collection created");
                        }).catchError((e) {
                          print(e);
                        });
                      }


                      await FirebaseFirestore.instance
                          .collection("Shop Users")
                          .doc(widget.uid)
                          .collection("Shop Reviews")
                          .add({
                        //your data which will be added to the collection and collection will be created after this
                      }).then((_) {
                        print("Review Collection Created!");
                      }).catchError((e) {
                        print(e);
                      }).whenComplete(() async {
                        await FirebaseFirestore.instance
                            .collection("Shop Users")
                            .doc(widget.uid)
                            .collection("Shop Reviews").get().then((snapshot){
                              for(DocumentSnapshot ds in snapshot.docs){
                                ds.reference.delete();
                              }
                        });
                      }
                      );

                      await FirebaseFirestore.instance
                          .collection("Shop Users")
                          .doc(widget.uid)
                          .collection("Queued Orders")
                          .add({
                        //your data which will be added to the collection and collection will be created after this
                      }).then((_) {
                        print("Queued Orders Collection Created!");
                      }).catchError((e) {
                        print(e);
                      }).whenComplete(()async{
                        await FirebaseFirestore.instance
                            .collection("Shop Users")
                            .doc(widget.uid)
                            .collection("Queued Orders").get().then((snapshot){
                          for(DocumentSnapshot ds in snapshot.docs){
                            ds.reference.delete();
                          }
                        });
                      });

                      await FirebaseFirestore.instance
                          .collection("Shop Users")
                          .doc(widget.uid)
                          .collection("Completed Orders")
                          .add({
                        //your data which will be added to the collection and collection will be created after this
                      }).then((_) {
                        print("Completed Orders Collection Created!");
                      }).catchError((e) {
                        print(e);
                      }).whenComplete(()async{
                       await  FirebaseFirestore.instance
                            .collection("Shop Users")
                            .doc(widget.uid)
                            .collection("Completed Orders").get().then((snapshot){
                          for(DocumentSnapshot ds in snapshot.docs){
                            ds.reference.delete();
                          }
                        });

                      });


                      Navigator.push(context, MaterialPageRoute(builder: (context) => name?NamePage(uid: widget.uid,auth: widget.auth,):HomePage(
                                  auth: widget.auth,
                              uid: widget.uid,
                                )),
                      );
                    } else {

                      final snackBar = SnackBar(
                          content: Text('Please fill all three fields completely!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }:null)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void initState()  {
     getAccountType();
     buttonEnable =true;
    super.initState();
  }
}

