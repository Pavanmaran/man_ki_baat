import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_hidden_writters/commentbox.dart';
import 'package:the_hidden_writters/detailed.dart';
import 'package:the_hidden_writters/fire_api.dart';
import 'package:the_hidden_writters/fire_widget.dart';
import 'package:the_hidden_writters/home.dart';
import 'package:the_hidden_writters/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart' as pth;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:the_hidden_writters/signup.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as pth;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:async';


class addpost extends StatefulWidget {
  @override
  _addpostState createState() => _addpostState();

}

class _addpostState extends State<addpost> {

  bool flag1 = true;
  String filename ='';
  var taskcollections = FirebaseFirestore.instance.collection('tasks');
  late String project_name;
  late Color tcolor ;
  var ref1;
  UploadTask? task;
  File? file;

  bool valuefirst = false;
  bool valuesecond = false;
  late Map<String,bool> value1;
  var tmpArray = [];
  var msg;
  void initState() {
    super.initState();
    value1 = {
      'Quotes': false,
      "Memes":false,
      "Sayri": false,
      "joke": false,
      "Love": false,
      "poem": false,
      "feelings": false,
    };
    tcolor = Colors.teal;
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
    stream: task.snapshotEvents,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        final snap = snapshot.data!;
        final progress = snap.bytesTransferred / snap.totalBytes;
        final percentage = (progress * 100).toStringAsFixed(2);

        return Text(
          '$percentage %',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        );
      } else {
        return Container();
      }
    },

  );
  getCheckboxItems() {

    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) =>
    //     home(text: msg, age: _selectedLocation, other: others)));
  }
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? pth.basename(file!.path) : 'No File Selected';
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Themes"),
      ),

      body: Container(
        margin: EdgeInsets.all(15),
            child :Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                  Expanded(
                    child: Container(
                      height: 300,
                      width:500,
                      child: ListView(
                        children: value1.keys.map((String key) {
                          return new CheckboxListTile(
                            title: new Text(key),
                            value: value1[key],
                            activeColor: Colors.pink,
                            checkColor: Colors.white,
                            onChanged: (bool? value) {
                              setState(() {
                                value1[key] = value!;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                SizedBox(height: 8),
                ButtonWidget(
                  text: 'Select File',
                  icon: Icons.attach_file,
                  onClicked: selectFile,
                ),
                SizedBox(height: 8),
                Text(
                  fileName,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      RaisedButton(child: Text('Save Post',style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,

                      ),),

                        onPressed: (){
                          uploadFile();
                        },
                        color: Theme.of(context).primaryColor,
                      ),
                      SizedBox(height: 20),
                      task != null ? buildUploadStatus(task!) : Container()
                    ],
                  ),
                ),
              ],
            ),
          ),);
  }
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path!;
    setState(() => file = File(path));
  }
  Future uploadFile() async {
    tmpArray.clear();
    if (file == null) return;
    DateTime now = DateTime.now();
    String imgname = pth.basename(file!.path);
    String strdate = now.toString();
    final fileName = "$imgname$strdate-img.png";
    final destination = 'themes/$fileName';
    task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});
    if (task == null) return;
    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download-Link: $urlDownload');
//--------------------------------------------------------------
    value1.forEach((key, value) {
      if (value == true) {
        tmpArray.add(key);
        //data1.add(key);
      }
    });
    // Printing all selected items on Terminal screen.
    print(tmpArray);
    print(tmpArray.length);

//---------------------------------------------------------------
    if (urlDownload != null) {
      print(tmpArray);
      await FirebaseFirestore.instance
          .collection("themes")
          .add({
        'url': urlDownload,
        'categories':tmpArray
      });
      print('Yay! Success');
    }
    else {
      print(
          'Error from image repo ${snapshot.state.toString()}');
      throw ('This file is not an image');
    }
  }
}


