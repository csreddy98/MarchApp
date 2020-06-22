import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:march/models/user.dart';
import 'package:march/models/goal.dart';
import 'package:march/ui/PhoneAuthScreen.dart';
import 'package:march/ui/gregistration.dart';
import 'package:march/ui/select.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';



import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  GoogleSignIn google = new GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future _signIn() async{
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

    var url= 'https://march.lbits.co/api/worker.php';
    var resp=await http.post(url,
      body: json.encode(<String, dynamic>
      {
        'serviceName': "generatetoken",
        'work': "get user",
        'uid':user.uid,
      }),
    );

    print(resp.body.toString());
    var result = json.decode(resp.body);
    if (result['response'] == 200) {

      var db = new DataBaseHelper();

      int savedUser =
      await db.saveUser(new User(
          user.uid,
          result['result']['user_info']['fullName'],
          result['result']['user_info']['bio'],
          result['result']['user_info']['email'],
          result['result']['user_info']['DOB'][8]+result['result']['user_info']['DOB'][9]
              +"-"+result['result']['user_info']['DOB'][5]+result['result']['user_info']['DOB'][6]
              +"-"+result['result']['user_info']['DOB'].toString().substring(0,4),
          result['result']['user_info']['sex'],
          result['result']['user_info']['profession'],
          result['result']['user_info']['profile_pic'],
          result['result']['user_info']['mobile']));


      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token',result['result']['token']);
      prefs.setString('id',result['result']['user_info']['id']);
      prefs.setString('age', result['result']['user_info']['age']);
      print("user saved :$savedUser");

      var res=await http.post(url,
        headers: {
          'Content-Type':
          'application/json',
          'Authorization':
          'Bearer '+result['result']['token']
        },
        body: json.encode(<String, dynamic>
        {
          'serviceName': "",
          'work': "get goals",
          'uid':user.uid,
        }),
      );
      print(res.body.toString());
      var resultx = json.decode(res.body);
      if(resultx['response'] == 200){
        int cnt=resultx['result'].length;
        for(var i=0;i<cnt;i++){

          int savedGoal =
          await db.saveGoal(new Goal(
              user.uid,
              resultx['result'][i]['goal'],
              resultx['result'][i]['target'],
              resultx['result'][i]['time_frame'],
              resultx['result'][i]['goal_number']));

          print("goal saved :$savedGoal");
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('log', 1);

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home('')),
                (Route<dynamic> route) => false);

      }
      else{

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Select()),
                (Route<dynamic> route) => false);

      }

    }
    else{

      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => GRegister()),
            (Route<dynamic> route) => false,);

    }



  }
  
  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context,width: 750, height: 1300, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Color(0xff241332),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Center(
              child: new Image.asset(
                'assets/images/image.png',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:100.0),
                  child: Center(child: Text("Welcome \nto March",style: TextStyle(fontFamily: 'montserrat' ,fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)),
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
                    height: 52.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                          side: BorderSide(color: Color(0xffD47FA6))),
                      onPressed: () {

                       /* FirebaseAuth.instance.currentUser().then((val) async {
                          print(val.uid);});*/
                        Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => PhoneAuthScreen()),
                              (Route<dynamic> route) => true,
                        );

                        },
                      color: Color(0xffD47FA6),
                      textColor: Colors.white,
                      child: Text("PHONE",
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0,0,50,5),
                  child: ButtonTheme(
                    minWidth: size.width,
                    height: 52.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {
                        _signIn();
                      },
                      color: Color(0xFFDB4A39),
                      textColor: Colors.white,
                      child: Text("GOOGLE",
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0,0,50,5),
                  child: ButtonTheme(
                    minWidth: size.width,
                    height: 52.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0)),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => Home('')),
                              (Route<dynamic> route) => false,);

                      },
                      color: Color(0xFF4267B2),
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
                      Text("By Signing up you agree to the",style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,color: Colors.white),),
                      GestureDetector(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => Select()),
                            (Route<dynamic> route) => false,);

                          },
                          child: Text("terms of use",
                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.normal,decoration: TextDecoration.underline,color: Colors.white),)),
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
