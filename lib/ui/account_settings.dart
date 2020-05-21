import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class Account_Settings extends StatefulWidget {
  @override
  _Account_SettingsState createState() => _Account_SettingsState();
}

class _Account_SettingsState extends State<Account_Settings> {

  TextEditingController _controller_number;
  String number;

  @override
  void initState() {
    _controller_number = new TextEditingController(text: "+919090909090");

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
          title:  Center(child: Text("Account Settings",style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'montserrat'),)),
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
                    controller: _controller_number,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18
                    ),
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                    ),
                    onChanged: (String value) {
                      try {
                        number = value;
                      } catch (exception) {
                        number="";
                      }
                    },
                  ),
                ),
              ),
            ),


            Padding(
              padding: const EdgeInsets.only(top:50.0),
              child: GestureDetector(
                  onTap: (){

                  },
                  child: Text("Delete Account",style: TextStyle(fontSize: 18,color: Colors.red),)),
            ),


          ],
        ),

      ),
    );
  }

  void _load() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uid = prefs.getString('uid')??"";
      print(uid);
/*

    var url = 'https://march.lbits.co/app/api/index.php?uid=' + uid;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        number = jsonResponse["mobile"];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    _controller_number = new TextEditingController(text: number);

*/
  }
}
