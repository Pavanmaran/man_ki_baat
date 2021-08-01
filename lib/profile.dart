import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:flutter/rendering.dart';
import 'package:the_hidden_writters/admin.dart';
import 'package:the_hidden_writters/editprofile.dart';
import 'package:the_hidden_writters/signup.dart';
import 'package:the_hidden_writters/tasks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:the_hidden_writters/home.dart';
import 'package:the_hidden_writters/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_hidden_writters/tasks.dart';
import 'package:google_sign_in/google_sign_in.dart';


class profilePage extends StatefulWidget {


  @override
  _profilePageState createState() =>
      _profilePageState();
}

class _profilePageState extends State<profilePage> {
  String pic='https://firebasestorage.googleapis.com/v0/b/the-hidden-writters.appspot.com/o/files%2FXfCqF-2021-07-17%2022%3A46%3A52.146436-img.png?alt=media&token=3fb25a41-9b1d-4e5c-9cf7-72d241b9db40';
  String birth = 'Birthday';
  String bio = 'bio';
  String link = 'http://mybooks.in';
  final FirebaseFirestore fb = FirebaseFirestore.instance;
  String name = '';
  String uid = '';


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user();
    getdetails();
  }
  Future<DocumentSnapshot> getdetails() async {
    print(uid);
    var ref1= await fb.collection("users_writters").doc(uid);
    var doc = ref1.get();
    return doc;
  }
  Future<QuerySnapshot> getImages() {
    return fb.collection("data_quotes").where('userkiid',isEqualTo: uid).get();
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
                  Text(name),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),

            ListTile(
              title: Text('Admin'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) {
                    return addpost() ;}),);
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
        "Vibes Quotes",
        style: TextStyle(
          fontFamily: "tepeno",
          fontWeight: FontWeight.w600,
        ),
      ),
      ),
      body: Container(
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 310,
              width: 500,
              padding: EdgeInsets.only(bottom: 10,top: 10,right: 10,left: 20),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: Image.network(pic,
                                errorBuilder: (BuildContext context,
                                    Object exception,
                                    StackTrace? stackTrace) {
                                  return const Text('😢');
                                },
                              ).image,
                              fit: BoxFit.fill),
                        ),
                      ),
                      SizedBox(width: 180),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          iconSize: 20,
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) {
                              print("data: $name $bio");
                              return EditProfle(name:name, bio:bio,birth:birth,link:link);
                            }),),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.black26),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],),
                  SizedBox(height: 5),
                  FutureBuilder(
                    future: getdetails(),
                    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if(snapshot.hasData && !snapshot.data!.exists){
                        return InkWell(
                          child: Container(
                            width: 200,
                            height: 30,
                            color: Colors.deepOrangeAccent,
                              child: Center(child: Text("Create profile",style: TextStyle(fontSize: 19,color: Colors.white,fontWeight: FontWeight.bold)))),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) {
                                print("data: $name $bio");
                                return EditProfle(name:name, bio:bio,birth:birth,link:link);
                              }),);
                          },
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.done) {
                        birth =  snapshot.data!["birth"];
                        name =snapshot.data!["userkanam"];
                        bio = snapshot.data!["bio"];
                        link = snapshot.data!["link"];
                        return Row(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Text(name,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, color: Colors.brown)),
                                  SizedBox(height: 10),
                                  Text(birth,
                                      //snapshot.data!["birth"],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black45)),
                                  SizedBox(height: 5),
                                  Text(bio,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.black)),

                                  SizedBox(height: 1),
                                  InkWell(
                                    child: Text(link,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.indigo)),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ) ;
                      }
                      else return CircularProgressIndicator();
                    },
                  ),


                ],
              ),
            ),
             Container(
              height: 600,
              child: Scaffold(
                body: Container(
                  child: SingleChildScrollView(
                     child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           FutureBuilder(
                              future: getImages(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                               // print(snapshot.data!);
                                if (snapshot.connectionState == ConnectionState.done) {
                                  var size = MediaQuery.of(context).size;
                                  final double itemheight = (size.height-kToolbarHeight-24)/2;
                                  final double itemwidth = size.width/2;
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    physics: ScrollPhysics(),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (BuildContext context, int index) {

                                      return GestureDetector(
                                        child: InkWell(
                                          onTap:(){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) {
                                                return singleitem(
                                                    url:snapshot.data!.docs[index].data()["url"],
                                                    name:snapshot.data!.docs[index].data()["name"],
                                                    picurl:snapshot.data!.docs[index].data()["picurl"]
                                                    ) ;}),);
                                          },
                                          child: Container(

                                            padding : EdgeInsets.all(3),
                                                  child: Center(
                                                    child: Image.network(
                                                        snapshot.data!.docs[index].data()["url"],
                                                        errorBuilder: (BuildContext context,
                                                            Object exception,
                                                            StackTrace? stackTrace) {
                                                          return Icon(Icons.do_not_disturb);
                                                        }, fit: BoxFit.cover),),),
                                        ),
                                      );
                                    }, gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,

                                  ),);
                                } else return CircularProgressIndicator();
                              },),],),)
                ),
              ),
            ),
          ],
        )
        ),
      ),
    );
    //TasksPage(uid1: user.uid, email: user.email, Name: user.displayName,pic: user.photoURL);
  }



  Future<User?> user() async {
    User? user = await FirebaseAuth.instance.currentUser;
     setState(() {
       name = user!.displayName!;
       pic = user.photoURL!;
       uid = user.uid;
     });

    return user;
  }
}

class singleitem extends StatefulWidget {
  final String url;
  final String picurl;
  final String name;
  singleitem({required this.url,required this.picurl,required this.name});
  @override
  _singleitemState createState() => _singleitemState(this.url,this.picurl,this.name);
}
class _singleitemState extends State<singleitem> {
  final String url;
  final String picurl;
  final String name;
  int like_count=0;
  _singleitemState(this.url,this.picurl,this.name);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(height: 100,),

          Container(
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
                        image: Image.network(picurl,
                          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                            // Appropriate logging or analytics, e.g.
                            // myAnalytics.recordError(
                            //   'An error occurred loading "https://example.does.not.exist/image.jpg"',
                            //   exception,
                            //   stackTrace,
                            // );
                            return const Text('😢');
                          },).image,
                        // image: Utility.imageFromBase64String(imgString).image ,
                        fit: BoxFit.fill
                    ),
                  ),),
                SizedBox(width: 20,),
                Expanded(child:
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(name,style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold
                  ),),
                ),),
              ],
            ),
            SizedBox(height: 3,),
            Container(
              padding: EdgeInsets.all(12),
              height: 300,
              width: 350,
              child: Center(child :Image.network(
                  url,
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace){
                    return Icon(Icons.do_not_disturb);
                  },
                  fit: BoxFit.fill),
              ),
            ),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(width: 2,color: Colors.black12)
                ) ,
                child: Row(
                  children: [
                    SizedBox(width: 20,),
                    LikeButton(
                      size: 20,
                      circleColor:
                      CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Color(0xff33b5e5),
                        dotSecondaryColor: Color(0xff0099cc),
                      ),
                      likeBuilder: (bool isLiked) {
                        return Icon(
                          Icons.favorite_sharp,
                          color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                          size: 20,
                        );
                      },
                      likeCount: like_count,
                      onTap: likecout(),
                      countBuilder: (int? count, bool isLiked, String text) {
                        var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                        Widget result;
                        if (count == 0) {
                          result = Text(
                            "love",
                            style: TextStyle(color: color),
                          );
                        } else
                          result = Text(
                            text,
                            style: TextStyle(color: color),
                          );
                        return result;
                      },
                    ),
                    SizedBox(width: 28,),
                    IconButton(
                        icon: Icon(Icons.comment_sharp),
                        onPressed: (){}),
                    SizedBox(width: 28,),
                    IconButton(
                        icon: Icon(Icons.save_alt_sharp),
                        onPressed: (){}),
                    SizedBox(width: 28,),
                    IconButton(
                        icon:  Icon(Icons.share),
                        onPressed: (){}),
                  ],
                ),
              ),
            )
          ],
        ),
      )
          ],
        ),
      ),)
    );
  }
  likecout(){

  }
}
