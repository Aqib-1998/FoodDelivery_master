import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/HomePage.dart';
import 'package:food_delivery/Utils/BackButton.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomTextFiled.dart';
import 'package:image_picker/image_picker.dart';
var imageDir;
final fireStore = FirebaseFirestore.instance;
final FirebaseAuth getUid = FirebaseAuth.instance;
String url= '';


class CreateShopPage extends StatefulWidget {
  final auth;

  const CreateShopPage({Key key, @required this.auth}) : super(key: key);

  @override
  _CreateShopPageState createState() => _CreateShopPageState();
}

class _CreateShopPageState extends State<CreateShopPage> {
  final shopNameController = TextEditingController();
  final shopAddressController = TextEditingController();
  final shopContactController = TextEditingController();


  File imageFile;
  final picker = ImagePicker();
  chooseImage(ImageSource source) async{
     final pickedImage = await picker.getImage(source: source);
     setState(() {
       imageFile = File(pickedImage.path);
     });

     FirebaseStorage storage = FirebaseStorage.instance;
     Reference ref = storage.ref().child(getUid.currentUser.uid);
     UploadTask uploadTask = ref.putFile(imageFile);

     //url = await ref.getDownloadURL();
     uploadTask.then((res) async {
       url =  await res.ref.getDownloadURL();
       print(url);
     }).whenComplete((){
       setState(() {
       });
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
                    onTap: (){
                      chooseImage(ImageSource.gallery);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3.25,
                      width: MediaQuery.of(context).size.width,
                      child: imageFile != null
                          ? Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(

                                      image: FileImage(imageFile),fit: BoxFit.fill)),
                            )
                          : Container(
                              decoration: BoxDecoration(
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
                  customTextField("Enter Shop Address", TextInputType.text,
                      shopAddressController),
                  SizedBox(
                    height: 10,
                  ),
                  customTextField("Enter Shop Contact Number",
                      TextInputType.number, shopContactController),
                  SizedBox(
                    height: 10,
                  ),
                  customElevatedButton("Create Shop", () async {
                    if(shopContactController.text.isNotEmpty && shopAddressController.text.isNotEmpty && shopNameController.text.isNotEmpty && url.isNotEmpty){

                   await FirebaseFirestore.instance.collection("Shop Users").doc(getUid.currentUser.uid).collection("Shop info").add({
                     "Shop Name":shopNameController.text,
                     "Shop Address":shopAddressController.text,
                     "Shop Contact":shopContactController.text ,
                     "Shop Image": url//your data which will be added to the collection and collection will be created after this
                    }).then((_){
                      print("collection created");
                    }).catchError((e){
                      print(e);
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                auth: widget.auth,
                              )),
                    );}
                    else{
                      final snackBar = SnackBar(content: Text('Please fill all three fields!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


}
// try {
//   await FirebaseFirestore.instance
//       .collection("users")
//       .doc(getUid.currentUser.uid)
//       .collection("User details")
//       .add({
//     'Shop Name': getUid.currentUser.uid,
//   });
// }catch(e){
//   print(e);
// }