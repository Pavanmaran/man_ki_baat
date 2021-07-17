import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:the_hidden_writters/home.dart';
import 'package:the_hidden_writters/tasks.dart';
import 'package:the_hidden_writters/signup.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();
String user1 = '';

showErrDialog(BuildContext context, String err) {
  // to hide the keyboard, if it is still p
  FocusScope.of(context).requestFocus(new FocusNode());
  return showDialog(

    context: context,
    builder: (_) =>
    new AlertDialog(
      title: Text("Error"),
      content: Text(err),
      actions: <Widget>[
        OutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    ),
  );
}

googleSignIn() async {
  GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);

    User? user = await FirebaseAuth.instance.currentUser;
    user1 = (await result.user!.displayName)!;
    print(user1);
    print(user!.uid);

    return Future.value(true);
  }
}

// instead of returning true or false
// returning user to directly access UserID
signin(String email, String password, BuildContext context) async {
  try {
    UserCredential result =
    await auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return Future.value(user);
  } catch (e) {
    // simply passing error code as a message
    print(e);
    switch (e) {
      case 'ERROR_INVALID_EMAIL':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_WRONG_PASSWORD':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_USER_NOT_FOUND':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_USER_DISABLED':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        showErrDialog(context, e.toString());
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        showErrDialog(context, e.toString());
        break;
    }
    // since we are not actually continuing after displaying errors
    // the false value will not be returned
    // hence we don't have to check the valur returned in from the signin function
    // whenever we call it anywhere
    return Future.value(null);
  }
}

// change to Future<FirebaseUser> for returning a user
Future<User> signUp(String email, String password, BuildContext context) async {
  try {
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: email);
    User? user = result.user;
    return Future.value(user);
    // return Future.value(true);
  } catch (error) {
    switch (error.toString()) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        showErrDialog(context, "Email Already Exists");
        break;
      case 'ERROR_INVALID_EMAIL':
        showErrDialog(context, "Invalid Email Address");
        break;
      case 'ERROR_WEAK_PASSWORD':
        showErrDialog(context, "Please Choose a stronger password");
        break;
    }
    return Future.value(null);
  }
}

Future<bool> signOutUser() async {
  User? user = FirebaseAuth.instance.currentUser;
  print(user!.providerData[0].providerId);
  if (user.providerData[0].providerId == 'google.com') {
    await FirebaseAuth.instance.signOut();
    await gooleSignIn.disconnect();
  }
  await auth.signOut();
  return Future.value(true);
}


class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void login() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      signin(email, password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    homePage(email: email, uid1: 'jh', Name: '', pic: ''),
              ));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FlutterLogo(
                size: 50.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Login Here",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
              /*
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "This Field Is Required"),
                          EmailValidator(errorText: "Invalid Email Address"),
                        ]),
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "Password Is Required"),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required"),
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      RaisedButton(
                        // passing an additional context parameter to show dialog boxs
                        onPressed: login,
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Login",
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              */
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () => googleSignIn().whenComplete(() async {
                  User? user = FirebaseAuth.instance.currentUser;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => homePage(
                          uid1: user!.uid,
                          email: user.email.toString(),
                          Name: user.displayName.toString(),
                          pic: user.photoURL.toString())));
                }),
                child: Image(
                  image: AssetImage('assets/images/sign_google.png'),
                  width: 260.0,
                  height: 100,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "By sign in you are accepting our ",
                    ),
                  ),
                  InkWell(
                      child: Text ("terms and conditions.",
                        style: TextStyle(color:Colors.blueAccent),)
                  , onTap: (){},
                  )
                ],
              ),
    ],
    ),
    ),
    )
    ,
    );
  }
}

