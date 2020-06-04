// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './VerifyScreen.dart';
import 'package:march/support/PhoneAuthCode.dart' show FirebasePhoneAuth;

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

 /* @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,

        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }*/


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
          child: Icon(Icons.arrow_back_ios),
          color: Colors.white,
          elevation: 0,
        )
      ),
      body: SingleChildScrollView(
        child: Container(
          height: _height,
          width: _width,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Phone Number",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 34.0,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "To Verify your account,\nPlease enter your phone number",
                          style: TextStyle(fontSize: 16.0, color: Colors.black45),textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                  TextField(
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                    onChanged: (value) {
                      this.phoneNo = value;
                    },
                    controller: _phoneNumberController,

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0x33E0E7FF),
                      hintText: '000 000 0000',
                      labelText: "Phone Number",
                      prefix: Text("+91 "),
                      contentPadding: const EdgeInsets.all(15),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black38),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'VERIFY',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'montserrat'
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        padding: const EdgeInsets.all(15),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          startPhoneAuth();
                        },
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

    Navigator.of(context).pushReplacement(CupertinoPageRoute(
        builder: (BuildContext context) => PhoneAuthVerify()));
  }
}
