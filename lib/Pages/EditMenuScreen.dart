import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/ShopeMenu.dart';
import 'package:food_delivery/Utils/BackButton.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomRichText.dart';
import 'package:food_delivery/Utils/CustomTextFiled.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
final ref = FirebaseFirestore.instance.collection("Shop Users").doc(uid).collection("Shop Menus");


String uploadEditedImage='';
bool newImage = false;


class EditMenu extends StatefulWidget {
  final String menuName,menuAmount,menuQuantity,menuImage,docId;

  const EditMenu({Key key, @required this.menuName, this.menuAmount, this.menuQuantity, this.menuImage, this.docId}) : super(key: key);

  @override
  _EditMenuState createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  final menuNameController = TextEditingController();
  final menuAmountController = TextEditingController();
  final menuQuantityController = TextEditingController();
  @override
  void initState() {
    newImage = false;
    setState(() {

    });
    // TODO: implement initState
    super.initState();
  }

  File imageFile;
  final picker = ImagePicker();
  chooseImage(ImageSource source) async{

    final pickedImage = await picker.getImage(source: source);
    String path =  basename(pickedImage.path);
    setState(() {
      imageFile = File(pickedImage.path);
    });

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("$uid'/ $path ");
    UploadTask uploadTask = ref.putFile(imageFile);
    //url = await ref.getDownloadURL();
    uploadTask.then((res) async {
      uploadEditedImage =  await res.ref.getDownloadURL();
      print(uploadEditedImage);
    }).whenComplete((){
      setState(() {
        newImage = true;

      });
    });
    print(uploadEditedImage);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(child: backButton(),onTap: (){Navigator.pop(context);},),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: customRichText("Edit", " Menu" ),
                  ),
                  SizedBox(height: 30,),
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
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            image: DecorationImage(
                                image: FileImage(imageFile),fit: BoxFit.fill)),
                      )
                          : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                              child: ClipRRect(borderRadius: BorderRadius.all(Radius.circular(15)),child: Image.network(widget.menuImage,fit: BoxFit.fill,)),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  customTextField("${widget.menuName}",TextInputType.text,menuNameController),
                  SizedBox(height: 10,),
                  customTextField("${widget.menuAmount}",TextInputType.number,menuAmountController),
                  SizedBox(height: 10,),
                  customTextField("${widget.menuQuantity}",TextInputType.number,menuQuantityController),
                  SizedBox(height: 50,),
                  customElevatedButton("Done",() async {

                    if(menuNameController.text.isNotEmpty && menuQuantityController.text.isNotEmpty && menuAmountController.text.isNotEmpty){
                      await ref.doc(widget.docId).update({
                        "Menu Name":menuNameController.text,
                        "Menu Amount":menuAmountController.text,
                        "Menu Quantity":menuQuantityController.text ,
                        "Menu Image": newImage?uploadEditedImage??widget.menuImage:widget.menuImage//your data which will be added to the collection and collection will be created after this
                      }).then((_){
                        final snackBar = SnackBar(content: Text('Menu edited!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                        uploadEditedImage = null;
                      }).catchError((e){
                        print(e);
                      });

                    }else{
                      final snackBar = SnackBar(content: Text('Please fill all the fields!'));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
