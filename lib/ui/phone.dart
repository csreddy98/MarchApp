import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:march/ui/registration.dart';

class Phone extends StatefulWidget {
  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {

  String phoneNo;
  String smsCode;
  String verificationId;
  final GlobalKey<ScaffoldState> _sk=GlobalKey<ScaffoldState>();

  Future<void> verifyPhone() async{

    final PhoneCodeAutoRetrievalTimeout autoRetrieve =(String verId){
      this.verificationId=verId;
    };

    final PhoneCodeSent smsCodeSent =(String verId,[int forceCodeResend]){
      this.verificationId=verId;
      smsCodeDialog(context).then((value){
        print('Signed In');
      });
    };

   final PhoneVerificationCompleted verifiedSuccess =(AuthCredential phoneAuthCredential){
     print("verified");
   };

   final PhoneVerificationFailed verifiFailed=(AuthException exception){
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

  Future<bool> smsCodeDialog(BuildContext context){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
       return new AlertDialog(
         title: Text('Enter Sms Code'),
         content: TextField(
           onChanged: (value){
             this.smsCode = value;
           },
         ),
         contentPadding: EdgeInsets.all(10.0),
         actions: <Widget>[
           new FlatButton(onPressed: (){
             FirebaseAuth.instance.currentUser().then((user){
               if(user!=null){
                 Navigator.of(context).pop();
                 Navigator.pushAndRemoveUntil(context,
                   MaterialPageRoute(builder: (context) => Register(this.phoneNo)),
                       (Route<dynamic> route) => false,
                 );


               }
               else{
                 Navigator.of(context).pop();
                 signIn();
               }
             });
           }, child: Text('Done'))
         ],
       );
      }
    );
  }

  signIn() async{

  AuthCredential  _authCredential = await PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);

     FirebaseAuth.instance.signInWithCredential(_authCredential).then((user){
       Navigator.pushAndRemoveUntil(context,
         MaterialPageRoute(builder: (context) => Register(this.phoneNo)),
             (Route<dynamic> route) => false,
       );
     }).catchError((e){
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

  String code="+91";
  String number="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sk,
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:30.0),
              child: Center(child: Text("Phone Number",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),)),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                   Expanded(
                     flex:1,
                     child: CountryPickerDropdown(
                        initialValue: 'in',
                        itemBuilder: _buildDropdownItem,
                        onValuePicked: (Country country) {
                          setState(() {
                            this.code="+"+country.phoneCode;
                          });

                        },
                      ),
                   ),

                  Expanded(
                    flex:2,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Phone Number',
                      ),
                      onChanged: (value){
                       setState(() {
                         this.phoneNo=code+value;
                         this.number=value;
                       });
                      },
                    ),
                  ),

                ],
              ),
            ),


            Padding(
              padding: const EdgeInsets.fromLTRB(0,50,0,0),
              child: InkWell(
                child: Container(
                  margin: EdgeInsets.only(top: 5, left: 10,right: 15),
                  width: MediaQuery.of(context).size.width*0.8,
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
                        if(phoneNo==null){
                          _sk.currentState.showSnackBar(SnackBar(
                            content: Text("Enter Phone Number",
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

                        }else if(number.length!=10){
                          _sk.currentState.showSnackBar(SnackBar(
                            content: Text("Enter Correct Number",
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
                        }
                        else{
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
