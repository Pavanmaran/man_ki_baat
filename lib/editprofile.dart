import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:the_hidden_writters/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfle extends StatefulWidget {
  final String name;
  final String birth;
  final String bio;
  final String link;
  EditProfle({ required this.name, required this.birth, required this.bio, required this.link});
  @override
  _EditProfleState createState() => _EditProfleState(this.name,this.birth, this.bio,this.link);
}

class _EditProfleState extends State<EditProfle> {
  String pic = 'https://firebasestorage.googleapis.com/v0/b/the-hidden-writters.appspot.com/o/files%2FXfCqF-2021-07-17%2022%3A46%3A52.146436-img.png?alt=media&token=3fb25a41-9b1d-4e5c-9cf7-72d241b9db40';

  late TextEditingController _namecontroller;
  late TextEditingController birthdaycontroller;
  late TextEditingController biocontroller;
  late TextEditingController linkcontroller;
  late Map<String, dynamic>  updateMap;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late final String name;
  final String birth;
  final String bio;
  final String link;
  _EditProfleState(this.name,this.birth, this.bio,this.link);
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    user();
    print("$birth");
  }

  Future<User?> user() async {
    User? user = await FirebaseAuth.instance.currentUser;
    setState(() {
      pic = user!.photoURL!;
    });
  }
    Future<User?> updateProfile() async {
      User? user = await FirebaseAuth.instance.currentUser;
      user!.updateDisplayName(_namecontroller.text);
      updateMap= {
        'userkiid':user.uid,
        'userkanam':_namecontroller.text,
       'birth':birthdaycontroller.text,
       'bio': biocontroller.text,
       'link':linkcontroller.text,
     };
      if (updateMap != null) {
        try{
          await FirebaseFirestore.instance
              .collection("users_writters").doc(user.uid)
              .update(updateMap);
          print('Yay! Success , User ka mobile no.: '+ user.phoneNumber.toString());
        } on FirebaseException catch (e){

          print("Shayad account nhi tha Tera");
          try{
            await FirebaseFirestore.instance
                .collection("users_writters").doc(user.uid)
                .set(updateMap);
            print('Yay! Success , User ka mobile no.: '+ user.phoneNumber.toString());
          } on FirebaseException catch (e){

            print("Bhau kuch error he idhar");
          }
        }

        //  final snackBar =
        // SnackBar(content: Text('Yay! Success'));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      else {
        print(
            'Error from image repo');
        throw ('This file is not an image');
      }
      Navigator.pop(context,updateMap);
      return user;
    }
    String? validatePassword(String value) {
      if (value.isEmpty) {
        return "* Required";
      } else if (value.length < 6) {
        return "Password should be atleast 6 characters";
      } else if (value.length > 15) {
        return "Password should not be greater than 15 characters";
      } else
        return null;
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Edit Profile"),
        ),
        body: SingleChildScrollView(
          child: Form(
            autovalidate: true, //check for validation while typing
            key: formkey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, left: 100),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: Image
                                  .network(pic,
                                errorBuilder: (BuildContext context,
                                    Object exception,
                                    StackTrace? stackTrace) {
                                  return const Text('😢');
                                },
                              )
                                  .image,
                              fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(width: 1),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          iconSize: 20,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {}
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black26),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),

                ), SizedBox(height: 10,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    controller: _namecontroller=TextEditingController(text: name),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        hintText: 'Enter your name as you want to display on documents'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                      controller: birthdaycontroller=TextEditingController(text:birth),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'BirthDay',
                          hintText: 'Enter Date of as 19/01/1999'),
                      validator: MultiValidator([

                        MaxLengthValidator(15,
                            errorText:
                            "Date of birth should not be greater than 15 characters")
                      ])
                    //validatePassword,        //Function to check validation
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextFormField(
                      maxLines: 3,
                      controller: biocontroller=TextEditingController(text:bio),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'bio',
                      ),
                      validator: MultiValidator([

                        MaxLengthValidator(75,
                            errorText:
                            "Bio should not be greater than 75 characters")
                      ])
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: TextFormField(
                      controller: linkcontroller=TextEditingController(text:link),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'link',
                        // hintText: 'Enter your name as you want to display on documents'
                      ),
                      validator: MultiValidator([

                        MaxLengthValidator(75,
                            errorText:
                            "Link should not be greater than 75 characters")
                      ])
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20)),
                  child: FlatButton(
                    onPressed: () {
                      if (formkey.currentState!.validate()) {
                        updateProfile();
                        //Navigator.pop(context, "totalitem");
                        print("Validated");
                      } else {
                        print("Not Validated");
                      }
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Text('New User? Create Account')
              ],
            ),
          ),
        ),
      );
    }
  }