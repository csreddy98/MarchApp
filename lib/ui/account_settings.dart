import 'package:flutter/material.dart';
import 'package:march/models/user.dart';
import 'package:march/utils/database_helper.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Account_Settings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<Account_Settings> {
  TextEditingController _controllerNumber;
  String number;

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Center(
            child: Text(
          "Account Settings",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'Nunito'),
        )),
      ),
      body: Container(
        color: Colors.grey.withAlpha(30),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    maxLines: 1,
                    controller: _controllerNumber,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                    ),
                    onChanged: (String value) {
                      try {
                        number = value;
                      } catch (exception) {
                        number = "";
                      }
                    },
                  ),
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(top:50.0),
            //   child: GestureDetector(
            //       onTap: (){

            //       },
            //       child: Text("Delete Account",style: TextStyle(fontSize: 18,color: Colors.red),)),
            // ),
          ],
        ),
      ),
    );
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid') ?? "";
    print(uid);
    var db = new DataBaseHelper();
    User x = await db.getUser(1);
    setState(() {
      _controllerNumber = new TextEditingController(text: x.userPhone);
    });
  }
}
