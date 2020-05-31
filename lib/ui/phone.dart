import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:march/ui/registration.dart';
import 'package:march/ui/select.dart';
import 'package:http/http.dart' as http;
import 'home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:march/models/user.dart';
import 'package:march/models/goal.dart';
import 'package:march/utils/database_helper.dart';



class Phone extends StatefulWidget {
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  String phoneNo;
  String smsCode;
  String verificationId;
  final GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsCodeDialog(context).then((value) {
        print('Signed In');
      });
    };

    final PhoneVerificationCompleted verifiedSuccess =
        (AuthCredential phoneAuthCredential) {
      print("verified");
    };

    final PhoneVerificationFailed verifiFailed = (AuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: this.phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifiFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);
  }

  Future<bool> smsCodeDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter Sms Code'),
            content: TextField(
              onChanged: (value) {
                this.smsCode = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    FirebaseAuth.instance.currentUser().then((user) async {
                      if (user != null) {

                        Navigator.of(context).pop();

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
                              "28-04-1998",
                              result['result']['user_info']['sex'],
                              result['result']['user_info']['profession'],
                              result['result']['user_info']['profile_pic'],
                              result['result']['user_info']['mobile']));


                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('token',result['result']['token']);
                          User x= await db.getUser(1);
                          print(x.userPic);
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
                                MaterialPageRoute(builder: (context) => Home()),
                                    (Route<dynamic> route) => false);

                          }
                          else{

                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => Select()),
                                    (Route<dynamic> route) => false);

                          }

                        }
                        else{

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register(this.phoneNo)),
                                (Route<dynamic> route) => false,
                          );
                        }

                      } else {
                        Navigator.of(context).pop();
                        signIn();
                      }
                    });
                  },
                  child: Text('Done'))
            ],
          );
        });
  }

  signIn() async {
    AuthCredential _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

    FirebaseAuth.instance.signInWithCredential(_authCredential).then((user) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Register(this.phoneNo)),
        (Route<dynamic> route) => false,
      );
    }).catchError((e) {
      print(e);
    });
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}"),
          ],
        ),
      );

  String code = "+91";
  String number = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sk,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Center(
                  child: Text(
                "Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CountryPickerDropdown(
                      initialValue: 'in',
                      itemBuilder: _buildDropdownItem,
                      onValuePicked: (Country country) {
                        setState(() {
                          this.code = "+" + country.phoneCode;
                        });
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                      ),
                      onChanged: (value) {
                        setState(() {
                          this.phoneNo = code + value;
                          this.number = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: InkWell(
                child: Container(
                  margin: EdgeInsets.only(top: 5, left: 10, right: 15),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: ScreenUtil().setHeight(80),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.red, Colors.deepPurple]),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFF6078ea).withOpacity(.3),
                            offset: Offset(0.0, 8.0),
                            blurRadius: 8.0)
                      ]),
                  child: Container(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.grey,
                      onTap: () {
                        if (phoneNo == null) {
                          _sk.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Enter Phone Number",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0))),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.lightBlueAccent,
                          ));
                        } else if (number.length != 10) {
                          _sk.currentState.showSnackBar(SnackBar(
                            content: Text(
                              "Enter Correct Number",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12.0),
                                    topRight: Radius.circular(12.0))),
                            duration: Duration(seconds: 3),
                            backgroundColor: Colors.lightBlueAccent,
                          ));
                        } else {
                          verifyPhone();
                        }
                      },
                      child: Center(
                        child: Text("VERIFY",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
