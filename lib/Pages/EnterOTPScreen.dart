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
            if (value.user != null) {
              FirebaseFirestore.instance.collection("Shop Users").doc(FirebaseAuth.instance.currentUser.uid).update({
                'New user?' : value.additionalUserInfo.isNewUser,
                'Account Type?': "Phone",
              });

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => CheckUser(auth: widget.auth,)),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          _scaffoldkey.currentState
              .showSnackBar(SnackBar(content: Text(e.message)));
        },
        codeSent: (String verificationId, int resendToken) {
          setState(() {
            _verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;

          });
        },
        timeout: Duration(seconds: 60));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}



// import 'CreateShopPage.dart';
//
// class PinCodeVerificationScreen extends StatefulWidget {
//   final String phoneNumber;
//
//   PinCodeVerificationScreen(this.phoneNumber);
//
//   @override
//   _PinCodeVerificationScreenState createState() =>
//       _PinCodeVerificationScreenState();
// }
//
// class _PinCodeVerificationScreenState extends State<PinCodeVerificationScreen> {
//   TextEditingController textEditingController = TextEditingController();
//
//   // ..text = "123456";
//
//   // ignore: close_sinks
//   StreamController<ErrorAnimationType> errorController;
//   String _verificationId;
//   bool hasError = false;
//   String currentText = "";
//   final formKey = GlobalKey<FormState>();
//
//   @override
//   void initState() {
//     errorController = StreamController<ErrorAnimationType>();
//     super.initState();
//     _verifyPhone();
//   }
//
//   @override
//   void dispose() {
//     errorController.close();
//
//     super.dispose();
//   }
//
//   // snackBar Widget
//   snackBar(String message) {
//     return ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         duration: Duration(seconds: 2),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Color(0xffFBFBFB),
//         body: GestureDetector(
//           onTap: () {},
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: ListView(
//               children: <Widget>[
//                 topArea(context, "Enter OTP"),
//                 SizedBox(height: 8),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
//                   child: RichText(
//                     text: TextSpan(
//                         text: "Enter the code sent to ",
//                         children: [
//                           TextSpan(
//                               text: "${widget.phoneNumber}",
//                               style: TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 15)),
//                         ],
//                         style: TextStyle(color: Colors.black54, fontSize: 15)),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Form(
//                   key: formKey,
//                   child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 5.0, horizontal: 30),
//                       child: PinCodeTextField(
//                         appContext: context,
//                         pastedTextStyle: TextStyle(
//                           color: Colors.green.shade600,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         length: 6,
//                         obscureText: true,
//                         obscuringCharacter: '*',
//                         blinkWhenObscuring: true,
//                         animationType: AnimationType.fade,
//                         validator: (v) {
//                           if (v.length < 3) {
//                             return "err";
//                           } else {
//                             return null;
//                           }
//                         },
//                         pinTheme: PinTheme(
//                             shape: PinCodeFieldShape.box,
//                             borderRadius: BorderRadius.circular(5),
//                             fieldHeight: 50,
//                             fieldWidth: 40,
//                             activeFillColor: Colors.white,
//                             disabledColor: HexColor('#DEDEDE'),
//                             activeColor: HexColor('#DEDEDE'),
//                             inactiveFillColor: HexColor('#DEDEDE'),
//                             selectedFillColor: HexColor('#DEDEDE'),
//                             inactiveColor: HexColor('#DEDEDE'),
//                             selectedColor: HexColor('#DEDEDE')),
//                         cursorColor: Colors.black,
//                         animationDuration: Duration(milliseconds: 300),
//                         enableActiveFill: true,
//                         errorAnimationController: errorController,
//                         controller: textEditingController,
//                         keyboardType: TextInputType.number,
//                         boxShadows: [
//                           BoxShadow(
//                             offset: Offset(0, 1),
//                             color: HexColor('#DEDEDE'),
//                             blurRadius: 10,
//                           )
//                         ],
//                         onCompleted: (v) {
//                           print("Completed");
//                         },
//                         // onTap: () {
//                         //   print("Pressed");
//                         // },
//                         onChanged: (value) {
//                           print(value);
//                           setState(() {
//                             currentText = value;
//                           });
//                         },
//                         beforeTextPaste: (text) {
//                           print("Allowing to paste $text");
//                           //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
//                           //but you can show anything you want here, like your pop up saying wrong paste format or etc
//                           return true;
//                         },
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                   child: Text(
//                     hasError ? "*Please fill up all the cells properly" : "",
//                     style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 12,
//                         fontWeight: FontWeight.w400),
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text(
//                       "Didn't receive the code? ",
//                       style: TextStyle(color: Colors.black54, fontSize: 15),
//                     ),
//                     TextButton(
//                         onPressed: () => snackBar("OTP resend!!"),
//                         child: Text(
//                           "RESEND",
//                           style: TextStyle(
//                               color: HexColor('#CDDC39'),
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16),
//                         ))
//                   ],
//                 ),
//                 SizedBox(
//                   height: 14,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: customElevatedButton("Verify", () {
//                     formKey.currentState.validate();
//                     // conditions for validating
//                     if (currentText.length != 6) {
//                       errorController.add(ErrorAnimationType.shake);
//                       // Triggering error shake animation
//                       setState(() {
//                         hasError = true;
//                       });
//                     } else if (currentText == _verificationId) {
//                       setState(
//                         () async {
//                           await FirebaseAuth.instance
//                               .signInWithCredential(
//                                   PhoneAuthProvider.credential(
//                                       verificationId: _verificationId,
//                                       smsCode: currentText))
//                               .then((value) async {
//                             if (value.user != null) {
//                               print('pass to home');
//                             }
//                           });
//                           hasError = false;
//                           snackBar("OTP Verified!!");
//                         },
//                       );
//
//                       // Navigator.push(
//                       //   context,
//                       //   MaterialPageRoute(
//                       //       builder: (context) => CreateShopPage()),
//                       // );
//                     } else {
//                       hasError = true;
//                       snackBar("wrong OTP!!");
//                       print(_verificationId);
//                       print(currentText);
//                     }
//                   }),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Flexible(
//                         child: TextButton(
//                       child: Text(
//                         "Clear",
//                         style: TextStyle(color: HexColor('#CDDC39')),
//                       ),
//                       onPressed: () {
//                         textEditingController.clear();
//                       },
//                     )),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   _verifyPhone() async {
//     await FirebaseAuth.instance.verifyPhoneNumber(
//         phoneNumber: '+92${widget.phoneNumber}',
//         verificationCompleted: (PhoneAuthCredential credential) async {
//           await FirebaseAuth.instance
//               .signInWithCredential(credential)
//               .then((value) async {
//             if (value.user != null) {
//               print('user logged in! ');
//             }
//           });
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           print(e.message);
//         },
//         codeSent: (String verificationID, int resendToken) async {
//           PhoneAuthCredential credential = PhoneAuthProvider.credential(
//               verificationId: verificationID, smsCode: currentText);
//
//           await FirebaseAuth.instance.signInWithCredential(credential);
//           setState(() {
//             _verificationId = verificationID;
//             print("verificatoin code is $verificationID");
//           });
//         },
//         codeAutoRetrievalTimeout: (String verificationID) {
//           setState(() {
//             _verificationId = verificationID;
//           });
//         },
//         timeout: Duration(seconds: 60));
//   }
// }