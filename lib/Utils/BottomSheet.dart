import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../main.dart';
import 'CustomRichText.dart';

var firebaseUser = FirebaseAuth.instance.currentUser;
final _auth = FirebaseAuth.instance;

void bottomSheet(
    context,
    String data,
    String mainTitle,
    String subTitle,
    String alertDialogueTitle,
    String alertDialogueHintText,
    String uid,
    dOnChanged,
    dOnSubmit,
    String changedString,
    String whatValue) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: 250.0,
          color: Color(0xFF737373), //could change this to Color(0xFF737373),
          //so you don't have to change MaterialApp canvasColor
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customRichText(mainTitle, " $subTitle"),
                        InkWell(
                          onTap: () {
                            displayTextInputDialog(
                                context,
                                alertDialogueTitle,
                                alertDialogueHintText,
                                uid,
                                dOnChanged,
                                dOnSubmit,
                                changedString,
                                whatValue);
                          },
                          child: Container(
                              height: 44,
                              width: 42,
                              child: Image.asset("lib/Images/editicon.png")),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("Shop Users")
                            .doc(uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return Center(child: CircularProgressIndicator(),);
                          }
                          return Text(
                            snapshot.data[data],
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 18,
                                color: Colors.black54),
                          );
                        }
                      ),
                    )
                  ],
                ),
              )),
        );
      });
}

final _textFieldController = TextEditingController();

Future<void> displayTextInputDialog(
    BuildContext context,
    String title,
    String hintText,
    String uid,
    onChanged,
    onSubmit,
    String changedString,
    String whatValue) async {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            onChanged: (value) {
              onChanged;
              changedString = value;
            },
            controller: _textFieldController,
            decoration: InputDecoration(hintText: hintText),
          ),
          actions: <Widget>[
            FlatButton(
              color: defaultColor,
              textColor: Colors.white,
              child: Text('OK'),
              onPressed: () async {

                  FirebaseFirestore.instance
                      .collection('Shop Users')
                      .doc(uid)
                      .update({whatValue: changedString});
                  print(uid);

                onSubmit;
                Navigator.pop(context);
                _textFieldController.clear();
              },
            ),
          ],
        );
      });
}

void reviewBottomSheet(
    context, String mainTitle, String subTitle,String uid) {
  showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.15,
          color: Color(0xFF737373), //could change this to Color(0xFF737373)
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        customRichText(mainTitle, " $subTitle"),
                        Container(
                            height: 44,
                            width: 42,
                            child: Image.asset("lib/Images/editicon.png"))
                      ],
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
                              .doc(uid)
                              .collection('Shop Reviews').snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(child: CircularProgressIndicator(),);
                            }
                            if (snapshot.data.docs.length == 0) {
                              return Center(
                                child: Text("No Reviews yet!"),
                              );
                            }
                            return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,

                                    child: Card(
                                      color: customButtonColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "${snapshot.data.docs[index]["Reviewer name"]}",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600),
                                                ),
                                                Text(
                                                  "${formatDate(snapshot.data.docs[index]["Review Date"].toDate(), [dd, '-', M, '-', yyyy])}",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w200),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5,),
                                            Text(
                                              "${snapshot.data.docs[index]["Review"]}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w200),
                                            ),
                                            SizedBox(height: 5,),
                                            RatingBar.builder(
                                              initialRating: double.parse(snapshot.data.docs[index]["Review Rating"].toString()) ,
                                              itemSize: 16,
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 3.0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: ratingColor,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        ),
                      ),
                    )
                  ],
                ),
              )),
        );
      });
}
