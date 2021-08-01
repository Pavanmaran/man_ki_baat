//@dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_hidden_writters/home.dart';
import 'package:the_hidden_writters/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_hidden_writters/tasks.dart';
import 'package:google_sign_in/google_sign_in.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        primarySwatch: Colors.purple,
        accentColor: Colors.redAccent,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

   @override
  Widget build(BuildContext context) {
     return FutureBuilder <User>(
       builder: (context, snapshot) {
         if (snapshot.hasData) {User user = snapshot.data;
         print(user.photoURL);
           return homePage(uid1: user.uid, email: user.email, Name: user.displayName,pic: user.photoURL);
             //TasksPage(uid1: user.uid, email: user.email, Name: user.displayName,pic: user.photoURL);
         } else {
           return LoginScreen();
         }
       },
       future:user(),
     );
  }

  Future<User> user() async {
    User user = await FirebaseAuth.instance.currentUser;
    return user;
  }
}