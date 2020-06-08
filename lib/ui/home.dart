import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  final pageName;
  Home(this.pageName);
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
  String chatsPage;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final db = DataBaseHelper();
  List tabs;
  @override
  void initState() {
    tabs = [
      FindScreen(),
      //Notify(),
      //Inbox(),
      MessagesScreen('$chatsPage'),
      Profile(),
    ];
    _load();
    socketIO = SocketIOManager().createSocketIO(
      'https://glacial-waters-33471.herokuapp.com',
      '/',
    );
    socketIO.init();
    socketIO.connect();

    // socketIO.sendMessage('update my status',
    //     json.encode({"uid": "$id", "time": "${DateTime.now()}"}));
    socketIO.subscribe('new message', (data) {
      updateStatus().then((value) {
        socketIO.sendMessage('update my status', json.encode(value));
      });
      print("$data");
    });
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
          var datax = json.decode(value.body);
          print('datax: $datax');
          Map<String, dynamic> messageMap = {
            DataBaseHelper.messageSender: data['sender'],
            DataBaseHelper.messageReceiver: data['receiver'],
            DataBaseHelper.messageText: data['message'],
            DataBaseHelper.messageContainsImage: false,
            DataBaseHelper.messageImage: null,
            DataBaseHelper.messageTime: data['time']
          };
          _showNotification('${datax['result']['user_info']['fullName']}',
              'You have a new request from ${datax['result']['user_info']['fullName']}.\nMessage: ${data['message']}');
          db.addMessage(messageMap);
        });
      }
    });
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    // await Navigator.push(context, MaterialPageRoute(builder: (context) => Home('requests'))).then((value) {
    setState(() {
      _currentindex = 1;
      title = t[1];
      chatsPage = "requests";
    });
    // });
  }

  Future<Map<String, String>> updateStatus() async {
    var prefs = await SharedPreferences.getInstance();
    Map myMap = {
      'uid': prefs.getString('id'),
      'time': DateTime.now().toString()
    };
    return myMap;
  }

  Widget appBar() {
    return AppBar(
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
                  color: Colors.black, fontSize: 18, fontFamily: 'montserrat'),
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
    );
  }

  Widget bottomNavBar() {
    return BottomNavigationBar(
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
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Center(
        child: tabs[_currentindex],
      ),
      bottomNavigationBar: bottomNavBar(),
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

  Future _showNotification(name, message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      '$name',
      '$message',
      platformChannelSpecifics,
      payload: 'Custom_Sound',
    );
  }
}
