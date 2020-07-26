// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './VerifyScreen.dart';
import 'package:march/support/PhoneAuthCode.dart' show FirebasePhoneAuth;
import 'package:flutter_icons/flutter_icons.dart';

class PhoneAuthScreen extends StatefulWidget {
  final Color cardBackgroundColor = Color(0xFF6874C2);

  @override
  _PhoneAuthGetPhoneState createState() => _PhoneAuthGetPhoneState();
}

class _PhoneAuthGetPhoneState extends State<PhoneAuthScreen> {
  // int _currentPage = 0;
  String phoneNo;
  String smsCode;
  String verificationId;
  // final PageController _pageController = PageController(initialPage: 0);
  TextEditingController _phoneNumberController = TextEditingController();
  // bool _isTyping = false;
  double _height, _width;

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: RaisedButton(
          onPressed: ()=>Navigator.pop(context),
          child: Icon(Ionicons.ios_arrow_back),
          color: Colors.white,
          elevation: 0,
        ),
        title: Text('Verify Phone Number'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20,5,20,20),
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20,0,20,20),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top:15.0),
                          child: Text(
                            // To Verify your account, Please enter your phone number
                            "Please enter your phone number,\n to verify your account",
                            style: TextStyle(fontSize: _height/55 , color: Colors.black),textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:10,right: 10),
                    child: TextField(
                      style: TextStyle(fontSize: 20, color: Colors.black, letterSpacing: 1.5),
                      onChanged: (value) {
                        this.phoneNo = value;
                      },
                      controller: _phoneNumberController,
                      maxLength: 10,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        // fillColor: Colors.grey[200],
                        // filled: true,
                        labelText: "Enter Phone Number",
                        labelStyle: TextStyle(fontSize: 16, letterSpacing: 0),
                        prefix: Text("+91 ",style: TextStyle(color: Colors.black),),
                        contentPadding: const EdgeInsets.fromLTRB(15,20,20,10),
                        focusColor: Colors.green,
                        hoverColor: Colors.green,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300] ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                    
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10,10,10,0),
                        child: FlatButton(
                          child: Text(
                            'VERIFY',
                            style: Theme.of(context).textTheme.button,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.all(15),
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          onPressed: () {
                            startPhoneAuth();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  startPhoneAuth() {
    FirebasePhoneAuth.instantiate(
        phoneNumber: "+91" + _phoneNumberController.text);

    /*Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (BuildContext context) => ));*/

    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) =>PhoneAuthVerify('+91'+_phoneNumberController.text.toString())),
          (Route<dynamic> route) => true,);
    
  }
}
