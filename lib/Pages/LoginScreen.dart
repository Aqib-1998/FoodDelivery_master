import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/Pages/CreateShopPage.dart';
import 'package:food_delivery/Pages/HomePage.dart';
import 'package:food_delivery/Utils/CustomElevatedButton.dart';
import 'package:food_delivery/Utils/CustomTextFiled.dart';
import 'package:food_delivery/Utils/TopArea.dart';
import 'package:food_delivery/Utils/auth.dart';
import 'package:food_delivery/Utils/auth_bloc.dart';
import 'package:provider/provider.dart';
import 'EnterOTPScreen.dart';
final phoneController = TextEditingController();
final firestore = FirebaseFirestore.instance;
bool newUserBool ;
class CheckUser extends StatefulWidget {
  final AuthBase auth;

  const CheckUser({Key key,@required this.auth}) : super(key: key);
  @override
  _CheckUserState createState() => _CheckUserState();
}



class _CheckUserState extends State<CheckUser> {


  @override
  Widget build(BuildContext context) {


    return StreamBuilder<giveUser>(
      stream: widget.auth.onAuthStateChanged,
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          giveUser user = snapshot.data;
          if(user == null){
            return LoginScreen(
              auth: widget.auth,
            );
          }
          var firebaseUser =  FirebaseAuth.instance.currentUser;
          void getdata()async{
            FirebaseFirestore.instance.collection("Shop Users").doc(firebaseUser.uid).get().then((value){
              newUserBool = value.data()["New user?"];
              print(newUserBool);
              setState(() {
              });
            } );

          }
          if(newUserBool == null){

            getdata();
            return Container(color: Colors.white,child: Center(child: CircularProgressIndicator()));
          }
         return newUserBool?CreateShopPage(auth: widget.auth):HomePage(auth: widget.auth);
        }else{
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );

  }
}








class LoginScreen extends StatefulWidget {
  final AuthBase auth;

  const LoginScreen({Key key,@required this.auth}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User user;

  Future<void> _signInWithGoogle() async{
    try {
      await widget.auth.signInWithGoogle();
      phoneController.clear();
    } catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthBloc>(context);

    return SafeArea(
      child: GestureDetector(
        onTap: () {
      FocusScopeNode currentFocus = FocusScope.of(context);

      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }},
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                topAreaLoginScreen(context, "Log in"),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: _signInWithGoogle,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 2), // changes position of shadow
                              ),
                            ],
                            color: Colors.white),
                        child: Center(
                          child: Image.asset('lib/Images/google.png'),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: (){
                        authBloc.loginFacebook();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 1,
                                offset: Offset(1, 2), // changes position of shadow
                              ),
                            ],
                            color: Colors.white),
                        child: Image.asset('lib/Images/facebk.png',fit: BoxFit.cover,),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "or Login with Phone No",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Center(
                      child: Container(
                        // width: MediaQuery.of(context).size.width,
                        // height: MediaQuery.of(context).size.height/4,
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            customTextFieldPhoneNo("Enter Phone Number",
                                TextInputType.number, phoneController),
                            SizedBox(
                              height: 10,
                            ),
                            customElevatedButton("Continue", () {
                              if (phoneController.text.isNotEmpty && phoneController.text.length == 10) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OTPScreen(phone: phoneController.text,auth: widget.auth)
                                    // PinCodeVerificationScreen(
                                          //     phoneController.text)
                                  ),
                                );
                                // phoneController.clear();
                              }
                              if(phoneController.text.length <10 && phoneController.text.length >0){
                                final snackBar = SnackBar(
                                    content: Text('Please enter a valid Phone no.!'));

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }else{
                                final snackBar = SnackBar(
                                    content: Text('Please enter a Phone no!'));

                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//

//
// Future<dynamic> getData() async {
//
//   final DocumentReference document =   FirebaseFirestore.instance.collection("Shop Users").doc(_auth.currentUser.uid);
//
//   await document.get().then<dynamic>(( DocumentSnapshot snapshot) async{
//     setState(() {
//       newgoogleuser =snapshot.data.toString();
//     });
//   });
// }