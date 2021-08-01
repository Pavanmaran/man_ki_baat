
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:the_hidden_writters/admin.dart';
import 'package:the_hidden_writters/create1.dart';
import 'package:the_hidden_writters/login.dart';
import 'package:the_hidden_writters/profile.dart';
import 'package:the_hidden_writters/signup.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:the_hidden_writters/tasks.dart';
class homePage extends StatefulWidget {
  final String uid1;
  final String email;
  final String Name;
  final String pic;
  homePage({required this.email, required this.uid1, required this.Name, required this.pic,});
  @override
  _homePageState createState() => _homePageState(this.uid1, this.email,this.Name,this.pic);
}
class _homePageState extends State<homePage> {

  int _currentIndex = 0;
  late PageController _pageController;
  final String uid1;
  final String Name;
  final String email;
  final String pic;
  _homePageState(this.uid1, this.email, this.Name,this.pic);

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
        TasksPage(uid1:this.uid1, email:this.email, Name:this.Name,pic:pic),
            MyHomePage(),
            Container(color: Colors.blue,child: Center(child:Text("Stories"))),
            profilePage(),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              title: Text('Home'),
              icon: Icon(Icons.home)
          ),
          BottomNavyBarItem(
              title: Text('Create'),
              icon: Icon(Icons.add_circle)
          ),
          BottomNavyBarItem(
              title: Text('Chat'),
              icon: Icon(Icons.chat_bubble)
          ),
          BottomNavyBarItem(
              title: Text('Profile'),
              icon: Icon(Icons.account_circle_outlined)
          ),
        ],
      ),
    );
  }
}
