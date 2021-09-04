import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/HomePage.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomTextFiled.dart';
import 'package:food_delivery/Utils/TopArea.dart';

class NamePage extends StatefulWidget {
  final String uid;
  final auth;

  const NamePage({Key key,@required this.uid,@required this.auth}) : super(key: key);

  @override
  _NamePageState createState() => _NamePageState();
}
 final nameController = TextEditingController();
class _NamePageState extends State<NamePage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                topAreaLoginScreen(context, "Username"),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: customTextField("Enter Username", TextInputType.name, nameController),
                ),
                SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: customElevatedButton("Continue", (){
                    if(nameController.text.isEmpty){
                      final snackBar = SnackBar(
                          content: Text('Please enter UserName!'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                    }else if(nameController.text.isNotEmpty){
                      FirebaseFirestore.instance.collection("Shop Users").doc(widget.uid).update({
                        'Username' : nameController.text,
                        'New user?' : false
                      }).whenComplete((){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(auth: widget.auth,uid: widget.uid,)
                            // PinCodeVerificationScreen(
                            //     phoneController.text)
                          ),
                        );

                      });
                    }

                  }),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
