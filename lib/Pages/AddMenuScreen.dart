import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Utils/BackButton.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomRichText.dart';
import 'package:food_delivery/Utils/CustomTextFiled.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';



String uploadImage='';
class AddMenu extends StatefulWidget {
  final String uid;

  const AddMenu({Key key,@required this.uid}) : super(key: key);
  @override
  _AddMenuState createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  final menuNameController = TextEditingController();
  final menuAmountController = TextEditingController();
  final menuQuantityController = TextEditingController();
  @override
  File imageFile;
  final picker = ImagePicker();
  chooseImage(ImageSource source) async{
    final pickedImage = await picker.getImage(source: source);
    String path =  basename(pickedImage.path);
    setState(() {
      imageFile = File(pickedImage.path);
    });

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("${widget.uid}'/ $path ");
    UploadTask uploadTask = ref.putFile(imageFile);

    //url = await ref.getDownloadURL();
    uploadTask.then((res) async {
      uploadImage =  await res.ref.getDownloadURL();
      print(uploadImage);
    }).whenComplete((){
      setState(() {
      });
    });
    print(uploadImage);
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
                    child: customRichText("Add", " Menu" ),
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
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                  alignment: Alignment.center,
                                  image: AssetImage(
                                      "lib/Images/chooseimage.png"),
                                  fit: BoxFit.cover)),
                        ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  customTextField("Enter Name",TextInputType.text,menuNameController),
                  SizedBox(height: 10,),
                  customTextField("Enter Amount",TextInputType.number,menuAmountController),
                  SizedBox(height: 10,),
                  customTextField("Enter Quantity",TextInputType.number,menuQuantityController),
                  SizedBox(height: 50,),
                  customElevatedButton("Add to Menu",() async {
                    if(menuNameController.text.isNotEmpty && menuQuantityController.text.isNotEmpty && menuAmountController.text.isNotEmpty && uploadImage.isNotEmpty){
                      await FirebaseFirestore.instance.collection("Shop Users").doc(widget.uid).collection("Shop Menus").add({
                      "Menu Name":menuNameController.text,
                      "Menu Amount":menuAmountController.text,
                      "Menu Quantity":menuQuantityController.text ,
                      "Menu Image": uploadImage//your data which will be added to the collection and collection will be created after this
                    }).then((_){
                        final snackBar = SnackBar(content: Text('Menu added!'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.pop(context);
                        uploadImage = null;
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
