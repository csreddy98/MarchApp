import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:march/models/goal.dart';
import 'package:march/models/user.dart';
import 'package:march/support/PhoneAuthCode.dart';
import 'package:http/http.dart' as http;
import 'package:march/ui/login.dart';
import 'package:march/ui/registration.dart';
import 'package:march/ui/select.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:march/support/functions.dart';

import 'home.dart';

class PhoneAuthVerify extends StatefulWidget {
  final Color cardBackgroundColor = Color(0xFFFCA967);
  final String appName = "Flowance app";
  String number;

  PhoneAuthVerify(this.number);

  @override
  _PhoneAuthVerifyState createState() => _PhoneAuthVerifyState();
}

class _PhoneAuthVerifyState extends State<PhoneAuthVerify> {
  TextEditingController _controller = new TextEditingController();
  String code = "";
  int maxLength = 6;

  @override
  void initState() {
    FirebasePhoneAuth.phoneAuthState.stream
        .listen((PhoneAuthState state) async {
      print("Hello There $state");
      if (state == PhoneAuthState.Verified) {
        FirebaseAuth.instance.currentUser().then((val) async {
          _onLoading(context);
          var url = 'https://march.lbits.co/api/worker.php';
          http
              .post(
            url,
            body: json.encode(<String, dynamic>{
              'serviceName': "generatetoken",
              'work': "get user",
              'uid': val.uid,
            }),
          )
              .then((resp) {
            print('${resp.body}');
            var result = json.decode(resp.body);
            if (result['response'] == 300) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Login()));
            }
            if (result['response'] == 200) {
              var db = new DataBaseHelper();
              db.deleteUserInfo().then((x) async {
                int savedUser = await db.saveUser(new User(
                    val.uid,
                    result['result']['user_info']['fullName'],
                    result['result']['user_info']['bio'],
                    result['result']['user_info']['email'],
                    result['result']['user_info']['DOB'][8] +
                        result['result']['user_info']['DOB'][9] +
                        "-" +
                        result['result']['user_info']['DOB'][6] +
                        result['result']['user_info']['DOB'][7] +
                        "-" +
                        result['result']['user_info']['DOB']
                            .toString()
                            .substring(0, 4),
                    result['result']['user_info']['sex'],
                    result['result']['user_info']['profession'],
                    result['result']['user_info']['profile_pic'],
                    result['result']['user_info']['mobile']));
                print("user saved :$savedUser");
              });
              db.deleteFriendsInfo().then((x) {
                var chatList = result['result']['chats_info'];
                chatList.forEach((val) {
                  imageSaver(val['profile_pic']).then((value) {
                    db.addUser(<String, String>{
                      DataBaseHelper.friendId: val['userId'],
                      DataBaseHelper.friendName: val['fullName'],
                      DataBaseHelper.friendSmallPic: "${value['small_image']}",
                      DataBaseHelper.friendPic: "${value['image']}",
                      DataBaseHelper.friendNetworkPic: "${val['profile_pic']}",
                      DataBaseHelper.friendLastMessage: "",
                      DataBaseHelper.friendLastMessageTime:
                          DateTime.parse(val['time']).toString()
                    }).then((value) => print(value));
                  });
                });
              });
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString('token', result['result']['token']);
                prefs.setString('id', result['result']['user_info']['id']);
                prefs.setString('age', result['result']['user_info']['age']);
              });

              http
                  .post(
                url,
                headers: {
                  'Content-Type': 'application/json',
                  'Authorization': 'Bearer ' + result['result']['token']
                },
                body: json.encode(<String, dynamic>{
                  'serviceName': "",
                  'work': "get goals",
                  'uid': val.uid,
                }),
              )
                  .then((res) async {
                print(res.body.toString());
                var resultx = json.decode(res.body);
                if (resultx['response'] == 200) {
                  db.deleteGoalsInfo().then((value) async {
                    int cnt = resultx['result'].length;
                    if (cnt == 0) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Select()),
                          (route) => false);
                    }
                    for (var i = 0; i < cnt; i++) {
                      int savedGoal = await db.saveGoal(new Goal(
                          val.uid,
                          resultx['result'][i]['goal'],
                          resultx['result'][i]['target'],
                          resultx['result'][i]['time_frame'],
                          resultx['result'][i]['goal_number']));
                      print("goal saved :$savedGoal");
                    }
                  });
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt('log', 1);

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home('')),
                      (Route<dynamic> route) => false);
                } else {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Select()),
                      (Route<dynamic> route) => false);
                }
              });
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Register(val.phoneNumber)),
                (Route<dynamic> route) => false,
              );
            }
          });
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Verification',
            style: TextStyle(color: Colors.black),
          ),
          leading: RaisedButton(
            onPressed: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            elevation: 0,
          )),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: _getBody(),
          ),
        ),
      ),
    );
  }

  void _onLoading(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Center(
            child: Image.asset(
              "assets/images/animat-rocket-color.gif",
              height: 125.0,
              width: 125.0,
            ),
          ),
        );
      },
    );
  }

  Widget _getBody() => Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: <Widget>[
            Text(widget.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700)),
            //  Info text
            Center(
              child: Text(
                "SMS with code has been sent",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Text(
                "to " + widget.number,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 46.0),
            Container(
              width: MediaQuery.of(context).size.width / 1.8,
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _controller,
                    onChanged: (String newVal) {
                      if (newVal.length <= maxLength) {
                        code = newVal;
                      } else {
                        _controller.text = code;
                      }
                    },
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    decoration: InputDecoration(border: InputBorder.none),
                    textAlign: TextAlign.center,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        letterSpacing: 23,
                        fontSize: 25.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  LinearProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor),
                  )
                ],
              ),
            ),

            SizedBox(height: 10.0),
            Center(
                child: Row(
              children: <Widget>[
                SizedBox(width: 150.0),
                Text("0:01 "),
                Text("Resend"),
              ],
            )),
            SizedBox(height: 32.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 0),
                  child: FlatButton(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'montserrat'),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.all(15),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      signIn();
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 275.0)
          ],
        ),
      );

  signIn() {
    // if (code.length != 6) {
    //   //   show error
    // }
    FirebasePhoneAuth.signInWithPhoneNumber(smsCode: code);
  }
}
