
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_hidden_writters/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
class details extends StatefulWidget {
  final String Title;
  final String Description;
  final String Name;
  const details({Key? key, required this.Title, required this.Description, required this.Name, }) : super(key: key);

  @override
  _detailsState createState() => _detailsState();
}

class _detailsState extends State<details> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
