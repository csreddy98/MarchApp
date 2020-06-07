import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:march/ui/MessagesScreen.dart';
import 'package:march/ui/find_screen.dart';
import 'package:march/ui/profile.dart';
import 'package:march/ui/settings.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentindex = 0;
  String title = "Find People";
  List<String> t = ["Find People", "Inbox", "Profile"];
  SocketIO socketIO;
  String token, uid;
  String myId;
  final db = DataBaseHelper();
  final tabs = [
    FindScreen(),
    //Notify(),
    //Inbox(),
    MessagesScreen(),
    Profile(),
  ];

  @override
  void initState() {
    _load();
    
    socketIO = SocketIOManager().createSocketIO(
      'https://glacial-waters-33471.herokuapp.com',
      '/',
    );
    socketIO.init();
    socketIO.connect();
    socketIO.subscribe('new message', (data) => print("$data"));
    socketIO.subscribe('New user Request', (jsonData) {
      var data = json.decode(jsonData);
      print(data['receiver']);
      if (data['receiver'] == myId) {
        http.post('https://march.lbits.co/api/worker.php',
            body: json.encode({
              'serviceName': '',
              'work': 'get user info',
              'userId': data['sender']
            }),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json'
            }).then((value) {
          Map<String, dynamic> messageMap = {
            DataBaseHelper.messageSender: data['sender'],
            DataBaseHelper.messageReceiver: data['receiver'],
            DataBaseHelper.messageText: data['message'],
            DataBaseHelper.messageContainsImage: false,
            DataBaseHelper.messageImage: null,
            DataBaseHelper.messageTime: data['time']
          };
          db.addMessage(messageMap);
        });
      }
    });
    // socketIO = SocketIOManager().createSocketIO(
    //   'https://glacial-waters-33471.herokuapp.com',
    //   '/',
    // );
    // socketIO.init();
    // socketIO.connect();
    // socke
    // socketIO.subscribe('New user Request', (jsonData) async {
    //   var data = json.decode(jsonData);
    //   print(data['receiver']);
    //   if (data['receiver'] == myId) {
    //     http.post('https://march.lbits.co/api/worker.php',
    //         body: json.encode({
    //           'serviceName': '',
    //           'work': 'get user info',
    //           'userId': data['sender']
    //         }),
    //         headers: {
    //           'Authorization': 'Bearer $token',
    //           'Content-Type': 'application/json'
    //         }).then((value) {
    //       Map<String, dynamic> messageMap = {
    //         DataBaseHelper.messageSender: data['sender'],
    //         DataBaseHelper.messageReceiver: data['receiver'],
    //         DataBaseHelper.messageText: data['message'],
    //         DataBaseHelper.messageContainsImage: false,
    //         DataBaseHelper.messageImage: null,
    //         DataBaseHelper.messageTime: data['time']
    //       };
    //       db.addMessage(messageMap);
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: _currentindex == 2
            ? Color.fromRGBO(63, 92, 200, 1)
            : Color(0xFFFFFFFF),
        title: _currentindex == 2
            ? Padding(
                padding: const EdgeInsets.only(left: 45.0),
                child: Center(
                    child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'montserrat'),
                )),
              )
            : Center(
                child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'montserrat'),
              )),
        actions: <Widget>[
          //if added change it to 3
          _currentindex == 2
              ? IconButton(
                  icon: Icon(
                    Icons.tune,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings()),
                    );
                  },
                )
              : Container(),
        ],
      ),
      body: Center(
        child: tabs[_currentindex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          iconSize: 20,
          elevation: 0,
          backgroundColor: Color(0xFFFFFFFF),
          currentIndex: _currentindex,
          items: [
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.group,
                  size: 30,
                ),
                title: Text("Find People")),
            //   new BottomNavigationBarItem(icon: new Icon(Icons.date_range,size: 30,),title: Text("")),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.chat_bubble,
                  size: 30,
                ),
                title: Text("Chats")),
            new BottomNavigationBarItem(
                icon: new Icon(
                  Icons.person,
                  size: 30,
                ),
                title: Text("Profile")),
          ],
          unselectedItemColor: Color.fromRGBO(63, 92, 200, 0.4),
          selectedItemColor: Color.fromRGBO(63, 92, 200, 1),
          onTap: (index) {
            setState(() {
              _currentindex = index;
              title = t[_currentindex];
            });
          }),
    );
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    myId = prefs.getString('id');
    uid = prefs.getString('uid');
    prefs.setInt('log', 1);
    FirebaseAuth.instance.currentUser().then((val) async {
      String uid = val.uid;
      prefs.setString('uid', uid);
    });
  }
}
