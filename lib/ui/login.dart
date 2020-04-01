import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:march/ui/phone.dart';
import 'package:march/ui/registration.dart';
import 'package:march/ui/select.dart';
import 'package:google_sign_in/google_sign_in.dart';


import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GoogleSignIn google = new GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _signIn() async{
    GoogleSignInAccount googleSignInAccount = await google.signIn();
    GoogleSignInAuthentication gsa = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: gsa.accessToken,
      idToken: gsa.idToken,
    );
    final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print(user.displayName);
    print(user.uid);
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => Select()),
          (Route<dynamic> route) => false,);

  }
  
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context,width: 750, height: 1300, allowFontScaling: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Center(
              child: new Image.asset(
                'images/bg.jpg',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:100.0),
                  child: Center(child: Text("Welcome \nto March",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:180.0),
                  child: Center(child: Column(
                    children: <Widget>[
                      Text("The best way to meet people who have",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                      Text("goals as you. Let's get Started!",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Center(child: Text("CONTINUE WITH",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.white54),)),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0,5,50,3),
                  child: ButtonTheme(
                    minWidth: size.width,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.pink)),
                      onPressed: () {

                        String uid="";
                        FirebaseAuth.instance.currentUser().then((val){
                          uid=val.uid;
                          print(val.uid);
                        });

                        Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => Phone()),
                              (Route<dynamic> route) => false,
                        );

                        },
                      color: Colors.pink,
                      textColor: Colors.white,
                      child: Text("PHONE",
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0,0,50,5),
                  child: ButtonTheme(
                    minWidth: size.width,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {
                        _signIn();

                      },
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("GOOGLE",
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0,0,50,5),
                  child: ButtonTheme(
                    minWidth: size.width,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue)),
                      onPressed: () {},
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("FACEBOOK",
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Center(child: Column(
                    children: <Widget>[
                      Text("By Signing up you agree to the",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.deepPurple),),
                      GestureDetector(
                          onTap: (){

                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => Select()),
                            (Route<dynamic> route) => false,);

                          },
                          child: Text("terms of use",
                            style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,decoration: TextDecoration.underline,color: Colors.deepPurple),)),
                    ],
                  )),
                ),


              ],
            ),






          ],
        ),
      ),
    );
  }
}
