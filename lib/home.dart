
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
      drawer: Drawer(
        child:  ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: Image.network(pic).image,
                          // image: Utility.imageFromBase64String(imgString).image ,
                          fit: BoxFit.fill
                      ),
                    ),),
                  Text(Name),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),

            ListTile(
              title: Text('Home'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) {
                //     return live_home() ;}),);
              },
            ),
            ListTile(
              title: Text('Sign Up'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return SignUpScreen();}),);
              },
            ),
            ListTile(
              title: Text('API'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) {
                //     return fileup() ;}),);
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return LoginScreen();}),);
              },
            ),
            ListTile(
              title: Text('Feedback'),
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (_) {
                //     return live_home() ;}),);
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(   title: Text(
        "Welcome : $Name",
        style: TextStyle(
          fontFamily: "tepeno",
          fontWeight: FontWeight.w600,
        ),
      ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => signOutUser().then((value) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                      (Route<dynamic> route) => false);
            }),
          ),
        ],),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
        TasksPage(uid1:this.uid1, email:this.email, Name:this.Name,pic:pic),
            addtask(uid1:this.uid1, email:this.email, Name:this.Name,pic:pic),
            Container(color: Colors.blue,),
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
