
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_hidden_writters/home.dart';
import 'package:the_hidden_writters/login.dart';
import 'package:the_hidden_writters/tasks.dart';
import 'package:form_field_validator/form_field_validator.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late String email;
  late String password;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Future<User> signUp (
      String email, String password, BuildContext context) async {
    try {
      UserCredential  result = await auth.createUserWithEmailAndPassword(
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
  void handleSignup() {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      signUp(email, password, context).then((value) {
        if (value != null) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>homePage(uid1: value.uid, email: email, Name: '',pic:''),));
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
              FlutterLogo(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Text(
                  "Signup Here",
                  style: TextStyle(
                    fontSize: 30.0,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.90,
                child: Form(
                  key: formkey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), labelText: "Email"),
                        validator: (_val) {
                          if (_val!.isEmpty) {
                            return "Can't be empty";
                          } else {
                            return null;
                          }
                        },
                        onChanged: (val) {
                          email = val;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Password"),
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: "This Field Is Required."),
                            MinLengthValidator(6,
                                errorText: "Minimum 6 Characters Required.")
                          ]),
                          onChanged: (val) {
                            password = val;
                          },
                        ),
                      ),
                      RaisedButton(
                        onPressed: handleSignup,
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Sign Up",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () => googleSignIn().whenComplete(() async {
                  User? user = await FirebaseAuth.instance.currentUser;

                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => homePage(uid1: user!.uid, email: this.email, Name: '',pic:'')));
                }),
                child:  Text(
                  "Sign In with Google",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                  ),
                )

                /* Image(
                  image: AssetImage('assets/google_sign.jpeg'),
                  width: 200.0,
                  height: 50,
                ), */
              ),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                onTap: () {
                  // send to login screen
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginScreen()));
                },
                child: Text(
                  "Login Here",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}