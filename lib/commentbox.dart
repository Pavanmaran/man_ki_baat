
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:date_time_format/date_time_format.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:the_hidden_writters/detailed.dart';
import 'package:the_hidden_writters/fire_api.dart';
import 'package:the_hidden_writters/home.dart';
import 'package:the_hidden_writters/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as pth;
import 'dart:ui' as ui;
import 'package:like_button/like_button.dart';
import 'package:the_hidden_writters/signup.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:comment_box/comment/comment.dart';
import 'package:flutter/material.dart';
import 'package:the_hidden_writters/tasks.dart';
class combox extends StatefulWidget {
  final String uid1;
  final String email;
  final String Name;
  final String pic;
  final String commenturl;
  combox({required this.email, required this.uid1, required this.Name, required this.pic, required this.commenturl,});

  @override
  _comboxState createState() => _comboxState(this.email,this.uid1,this.Name,this.pic,this.commenturl,);
}

class _comboxState extends State<combox> {
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  final String uid1;
  final String email;
  final String Name;
  final String pic;
  final String commenturl;
  var ref;
  var ref1;
  int newcout=0;
  int totalitem= 1;
  _comboxState(this.email,this.uid1,this.Name,this.pic,this.commenturl);

  void initState() {
    super.initState();
    String newcomstr = commenturl.replaceAll('.', '_');
    print(newcomstr);
    ref1 =
        FirebaseDatabase.instance.reference().child('comments').child(newcomstr);
    ref1.once().then((DataSnapshot snapshot) {
      setState(() {});
      totalitem = snapshot.value.length;
    });
    ref= FirebaseFirestore.instance
        .collection("comments").doc(commenturl.toString());
  }
  final formKey = GlobalKey<FormState>();
  final TextEditingController commentController = TextEditingController();

  Widget commentChild() {

    return FirebaseAnimatedList(
      query: ref1,
      itemBuilder: (BuildContext context, DataSnapshot snapshot,
          Animation<double> animation, int index) {
        Map contact = snapshot.value;
        String pkey=snapshot.key;

        if(contact ==null){
          return Center(
            child: Text(
              "Loading..",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color : Colors.brown
              ),
            ),
          );
        }
        else{
          return Container(
                  padding: EdgeInsets.only(top: 13),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: Image.network(contact["pic"],
                                    errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                                      return const Text('?');
                                    },).image,
                                  // image: Utility.imageFromBase64String(imgString).image ,
                                  fit: BoxFit.fill
                              ),
                            ),),
                          SizedBox(width: 20,),
                          Expanded(child:
                          SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                                  child: RichText(
                                    text: TextSpan(
                                      children:[
                                        TextSpan(text:contact["name"]+" : ", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
                                        TextSpan(text:contact["message"],style: TextStyle(color: Colors.black)),
                                      ]
                                    ),
                                  )

                          ),),
                        ],
                      ),
                      SizedBox(height: 3,),
                    ],
                  ),
                );
                /*
                      ListView(
                      children: [
                        for (var i = 0; i < data.length; i++)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2.0, 8.0, 2.0, 0.0),
                            child: ListTile(
                              leading: GestureDetector(
                                onTap: () async {
                                  // Display the image in large form.
                                  print("Comment Clicked");
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 50.0,
                                  decoration: new BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: new BorderRadius.all(Radius.circular(50))),
                                  child: CircleAvatar(
                                      radius: 50,
                                      backgroundImage: NetworkImage(' https://lh3.googleusercontent.com/a-/AOh14GjYEHOMctlDLuSogYiBwGZQyiDe7udLJtwZTvpUd4k=s96-c')),
                                ),
                              ),
                              title: Text(
                                data[i]['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(data[i]['message']),
                            ),
                          )

                      ],
                    );
                    */
        }
      },);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment Page"),
        backgroundColor: Colors.pink,
      ),
      body: Container(
        child: CommentBox(
          userImage:
          pic,
          child: commentChild(),
          labelText: 'Write a comment...',
          withBorder: false,
          errorText: 'Comment cannot be blank',
          sendButtonMethod: () {
            if (formKey.currentState!.validate()) {
              print(commentController.text);
              setState(() async {
                var value = {
                  'name': Name,
                  'pic':pic,
                  'message': commentController.text,

                };

                ref1.push().set(value).then((value) {
                  print(totalitem);
                  Navigator.pop(context,totalitem);
                });
                ref.set(value);
                print('Yay! Success');
              });
              commentController.clear();
              //FocusScope.of(context).unfocus();
            } else {
              print("Not validated");
            }
          },
          formKey: formKey,
          commentController: commentController,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          sendWidget: Icon(Icons.send_sharp, size: 30, color: Colors.white),
        ),
      ),
    );
  }
  Future < QuerySnapshot > getImages() {
    return fb.collection("comments").get();
  }
}