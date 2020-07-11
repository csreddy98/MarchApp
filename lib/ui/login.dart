import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:march/models/user.dart';
import 'package:march/models/goal.dart';
import 'package:march/support/functions.dart';
import 'package:march/ui/PhoneAuthScreen.dart';
import 'package:march/ui/gregistration.dart';
import 'package:march/ui/select.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignIn google = new GoogleSignIn();
  FirebaseAuth _auth = FirebaseAuth.instance;
  FacebookLogin fbLogin = new FacebookLogin();
  String yourClientId = "374789033499464";
  String yourRedirectUrl =
      "https://www.facebook.com/connect/login_success.html";
  String _message = 'Log in/out by pressing the buttons below.';

  void _showMessage(String message) {
    setState(() {
      _message = message;
      print(_message);
    });
  }

  Future _signIn() async {
    GoogleSignInAccount googleSignInAccount = await google.signIn();
    GoogleSignInAuthentication gsa = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: gsa.accessToken,
      idToken: gsa.idToken,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    print(user.displayName);
    print(user.uid);

    var url = 'https://march.lbits.co/api/worker.php';
    http
        .post(
      url,
      body: json.encode(<String, dynamic>{
        'serviceName': "generatetoken",
        'work': "get user",
        'uid': user.uid,
      }),
    )
        .then((resp) {
      print('${resp.body}');
      var result = json.decode(resp.body);
      if (result['response'] == 300) {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => Login()));
      }
      if (result['response'] == 200) {
        var db = new DataBaseHelper();
        db.deleteUserInfo().then((x) async {
          int savedUser = await db.saveUser(new User(
              user.uid,
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
            'uid': user.uid,
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
                  user.uid,
                  resultx['result'][i]['goal'],
                  resultx['result'][i]['level'],
                  resultx['result'][i]['remindEveryDay'],
                  resultx['result'][i]['everyDayRemindTime'],
                  resultx['result'][i]['goal_number'],
                ));
                print("goal saved :$savedGoal");
              }
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('log', 1);

              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home('')),
                  (Route<dynamic> route) => false);
            });
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
          MaterialPageRoute(builder: (context) => GRegister()),
          (Route<dynamic> route) => false,
        );
      }
    });
  }

  loginWithFacebook() async {
    String result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CustomWebView(
                  selectedUrl:
                      'https://www.facebook.com/dialog/oauth?client_id=$yourClientId&redirect_uri=$yourRedirectUrl&response_type=token&scope=email,public_profile,',
                ),
            maintainState: true));
    if (result != null) {
      try {
        final facebookAuthCred =
            FacebookAuthProvider.getCredential(accessToken: result);
        final user = await _auth.signInWithCredential(facebookAuthCred);
        print("${user.additionalUserInfo.profile}");
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ScreenUtil.init(context, width: 750, height: 1300, allowFontScaling: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            /*Center(
              child: new Image.asset(
                'assets/images/image.png',
                width: size.width,
                height: size.height,
                fit: BoxFit.cover,
              ),
            ),*/
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Center(
                      child: Text(
                    "Welcome ",
                    style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "to ",
                      style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      "March",
                      style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 180.0),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Text(
                        "The best way to meet people who have",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                            color: Colors.black),
                      ),
                      Text(
                        "goals as you. Let's get Started!",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w200,
                            color: Colors.black),
                      ),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                  child: Center(
                      child: Text(
                    "CONTINUE WITH",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 5, 50, 3),
                  child: ButtonTheme(
                    minWidth: size.width,
                    height: 52.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.grey[100])),
                      onPressed: () {
                        /* FirebaseAuth.instance.currentUser().then((val) async {
                          print(val.uid);});*/
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneAuthScreen()),
                          (Route<dynamic> route) => true,
                        );
                      },
                      color: Colors.grey[100],
                      textColor: Colors.black,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Image.asset(
                            'assets/images/phone.png',
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text("Continue With Phone",
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 50, 5),
                  child: ButtonTheme(
                    minWidth: size.width,
                    height: 52.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.grey[100])),
                      onPressed: () {
                        _signIn();
                      },
                      color: Colors.grey[100],
                      textColor: Colors.black,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Image.asset(
                            'assets/images/google.png',
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text("Continue With Google",
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 50, 5),
                  child: ButtonTheme(
                    minWidth: size.width,
                    height: 52.0,
                    child: RaisedButton(
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(50.0)),
                      onPressed: () {
                        loginWithFacebook();
                        // fbLogin.logIn(['email']).then((result) {
                        //   switch (result.status) {
                        //     case FacebookLoginStatus.loggedIn:
                        //       final FacebookAccessToken accessToken =
                        //           result.accessToken;
                        //       _showMessage('''
                        //              Logged in!
                        //            Token: ${accessToken.token}
                        //            User id: ${accessToken.userId}
                        //            Expires: ${accessToken.expires}
                        //            Permissions: ${accessToken.permissions}
                        //             Declined permissions: ${accessToken.declinedPermissions}
                        //             ''');
                        //       break;
                        //     case FacebookLoginStatus.cancelledByUser:
                        //       _showMessage('Login cancelled by the user.');
                        //       break;
                        //     case FacebookLoginStatus.error:
                        //       _showMessage(
                        //           'Something went wrong with the login process.\n'
                        //           'Here\'s the error Facebook gave us: ${result.errorMessage}');
                        //       break;
                        //   }
                        // }).catchError((e) {
                        //   print(e);
                        // });
                      },
                      color: Colors.grey[100],
                      textColor: Colors.black,
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Image.asset(
                            'assets/images/fb.png',
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Center(
                            child: Text("Continue With Facebook",
                                style: TextStyle(fontSize: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                      child: Column(
                    children: <Widget>[
                      Text(
                        "By Signing up you agree to the",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Select()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            "terms of use",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.underline,
                                color: Colors.black),
                          )),
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

class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("#access_token")) {
        succeed(url);
      }

      if (url.contains(
          "https://www.facebook.com/connect/login_success.html?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied")) {
        denied();
      }
    });
  }

  denied() {
    Navigator.pop(context);
  }

  succeed(String url) {
    var params = url.split("access_token=");

    var endparam = params[1].split("&");

    Navigator.pop(context, endparam[0]);
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
        url: widget.selectedUrl,
        appBar: new AppBar(
          backgroundColor: Color.fromRGBO(66, 103, 178, 1),
          title: new Text("Facebook login"),
        ));
  }
}
