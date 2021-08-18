import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/LoginScreen.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/TopArea.dart';
import 'package:food_delivery/Utils/auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final AuthBase auth;
  OTPScreen({@required this.phone,@required this.auth});
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: HexColor('#DEDEDE'),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: HexColor('#DEDEDE'),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }},
        child: Scaffold(
          key: _scaffoldkey,

          body: SingleChildScrollView(
            child: Column(
              children: [

                topArea(context,"Enter OTP"),
                Padding(
                  padding: const EdgeInsets.all(26.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Enter the verification code that we've sent on ",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: "+92- ${widget.phone}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: PinPut(
                    fieldsCount: 6,
                    textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
                    eachFieldWidth: 40.0,
                    eachFieldHeight: 55.0,
                    focusNode: _pinPutFocusNode,
                    controller: _pinPutController,
                    submittedFieldDecoration: pinPutDecoration,
                    selectedFieldDecoration: pinPutDecoration,
                    followingFieldDecoration: pinPutDecoration,
                    pinAnimationType: PinAnimationType.fade,
                    // onSubmit: (pin) async {
                    //   await submit(pin, context);
                    // },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: customElevatedButton("Continue", ()=>submit(_pinPutController.text, context)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit(String pin, BuildContext context) async {
     try {
      await phoneVerification(pin, context);
    } catch (e) {
      verificationFailedError(context);
    }
  }

  void verificationFailedError(BuildContext context) {
    FocusScope.of(context).unfocus();
    _scaffoldkey.currentState
        .showSnackBar(SnackBar(content: Text('invalid OTP')));
    _pinPutController.clear();
  }

  Future<void> phoneVerification(String pin, BuildContext context) async {
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: _verificationCode, smsCode: pin))
        .then((value) async {
      if (value.user != null) {
        if(value.additionalUserInfo.isNewUser){
        FirebaseFirestore.instance.collection("Shop Users").doc(value.user.uid).set({
          'New user?' : value.additionalUserInfo.isNewUser,
          'Account Type?': "Phone",
        });
        }
        if(!value.additionalUserInfo.isNewUser){
          FirebaseFirestore.instance.collection("Shop Users").doc(value.user.uid).update({
            'New user?' : value.additionalUserInfo.isNewUser,
            'Account Type?': "Phone",
          });
          print(value.user.uid);
        }
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => CheckUser(auth: widget.auth,)),
                (route) => false);
      }
    });
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+92${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
                print("user value ==== ${value.user}");
            if (value.user != null) {
                FirebaseFirestore.instance.collection("Shop Users").doc(value.user.uid).set({
                  'New user?' : value.additionalUserInfo.isNewUser,
                  'Account Type?': "Phone",
                });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CheckUser(auth: widget.auth,)),
                      (route) => false);
            }
            print("user = ${value.user}");
          });
        },

        verificationFailed: (FirebaseAuthException e) {
          _scaffoldkey.currentState
              .showSnackBar(SnackBar(content: Text(e.message)));
        },
        codeSent: (String verificationId, int resendToken) {
          if(mounted){setState(() {
            _verificationCode = verificationId;
          });
        }},
        codeAutoRetrievalTimeout: (String verificationID) {
          if(mounted) {
            setState(() {
              _verificationCode = verificationID;
            });
          }},
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
