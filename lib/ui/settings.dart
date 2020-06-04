import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:march/ui/account_settings.dart';
import 'package:march/ui/edit.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';


class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool switchVal1=false;
  bool switchVal2=false;


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    onSwitched_1(bool newval){
      setState(() {
        switchVal1=newval;
      });
    }
    onSwitched_2(bool newval){
      setState(() {
        switchVal2=newval;
      });
    }

    BoxDecoration myBoxDecoration() {
      return BoxDecoration(
        border: Border.all(
            width: 1.0,
            color: Colors.deepPurple
        ),
        borderRadius: BorderRadius.all(
            Radius.circular(45.0) //         <--- border radius here
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),

        title: Text("Settings",
          style: TextStyle(
              color: Colors.black,fontSize: 18,fontFamily: 'montserrat'
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body:SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: size.height,
          color: Colors.grey.withAlpha(30),


          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 30,right: 30,top: 15),
                width: size.width/0.5,
                height: size.height/1.4,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white
                ),
                child: Column(
                  children: <Widget>[
                    // Edit Profile 1st
                    InkWell(
                      child: Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0, top: 10),
                              child: Center(
                                child: Text("Edit Profile",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87
                                  ),),
                              ),
                            ),
                            Expanded(child: Container(
                              width: size.width,
                            ),),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              iconSize: 20,
                              onPressed: null,
                            )
                          ],
                        ),
                        height: 50,
                        width: double.infinity,
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Edit_Profile()),
                        );
                      },
                    ),
                    Divider(thickness: 1,),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Center(
                                child: Text("Account Settings",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87
                                  ),),
                              ),
                            ),
                            Expanded(child: Container(
                              width: size.width,
                            ),),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              iconSize: 20, onPressed: () {  },
                            )
                          ],
                        ),
                        height: 50,
                        width: double.infinity,
                      ),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Account_Settings()),
                        );
                      }
                    ),
                    Divider(thickness: 1,),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Center(
                              child: Text("Push Notification",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87
                                ),),
                            ),
                          ),
                          Expanded(child: Container(
                            width: size.width,
                          ),),
                          Switch(
                            value: switchVal1,
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.white,
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.red,
                            onChanged: (newval){
                              onSwitched_1(newval);
                            },
                          )
                        ],
                      ),
                      height: 50,
                      width: double.infinity,
                    ),
                    Divider(thickness: 1,),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Center(
                              child: Text("Allow My Location",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87
                                ),),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: size.width,
                            ),
                          ),
                          Switch(
                            activeColor: Colors.white,
                            inactiveThumbColor: Colors.white,
                            activeTrackColor: Colors.green,
                            inactiveTrackColor: Colors.red,
                            value: switchVal2,
                            onChanged: (newval){
                              onSwitched_2(newval);
                            },
                          )
                        ],
                      ),
                      height: 50,
                      width: double.infinity,
                    ),
                    Divider(thickness: 1,),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Center(
                                child: Text("Privacy Policies",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black87
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container(
                              width: size.width,
                            ),),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              iconSize: 20, onPressed: () {  },
                            )
                          ],
                        ),
                        height: 50,
                        width: double.infinity,
                      ),
                      onTap: ()=>debugPrint("Privacy Policies"),
                    ),
                    Divider(thickness: 1,),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Center(
                                child: Text("Terms of Use",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87
                                  ),),
                              ),
                            ),
                            Expanded(child: Container(
                              width: size.width,
                            ),),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              iconSize: 20, onPressed: () {  },
                            )
                          ],
                        ),
                        height: 50,
                        width: double.infinity,
                      ),
                      onTap: ()=>debugPrint("Terms Of Use"),
                    ),
                    Divider(thickness: 1,),
                    InkWell(
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Center(
                                child: Text("FAQ's",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black87
                                  ),
                                ),
                              ),
                            ),
                            Expanded(child: Container(
                              width: size.width,
                            ),
                          ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              iconSize: 20, onPressed: () {},
                            )
                          ],
                        ),
                        height: 50,
                        width: double.infinity,
                      ),
                      onTap: ()=>debugPrint("FAQ's"),
                    ),

                  ],
                ),
              ),

              Container(height: size.height/28 ,width: double.infinity),
              // LogOut Button
              InkWell(
                child: Container(
                  width: size.width/2,
                  height:size.height/12,
                  decoration: myBoxDecoration(),
                  child: Center(
                    child: Text("LOG OUT",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          letterSpacing: 1,
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16
                      ),),
                  ),
                ),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setInt('log', 0);
                  prefs.remove('token');
                  prefs.remove('uid');
                  var db = new DataBaseHelper();
                  await db.deleteUser(1);
                  int cnt=await db.getGoalCount();
                  if(cnt>2){
                    await db.deleteGoal(3);
                    await db.deleteGoal(2);
                    await db.deleteGoal(1);
                  }
                  else if(cnt>1){
                    await db.deleteGoal(2);
                    await db.deleteGoal(1);
                  }
                  else{
                    await db.deleteGoal(1);
                  }
                  Navigator.pop(context,true);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);

                },
              )
            ],
          ),

        ),
      ),
    );
  }

}

