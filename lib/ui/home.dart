import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:march/ui/MessagesScreen.dart';
import 'package:march/ui/find_screen.dart';
import 'package:march/ui/profile.dart';
import 'package:march/ui/settings.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

Future myBackgroundMessageHandler(Map<String, dynamic> message) async {
  DataBaseHelper db = DataBaseHelper();
  if (message['data']['type'] == 'message') {
    db.addMessage(<String, String>{
      DataBaseHelper.messageOtherId: message['data']['sender'],
      DataBaseHelper.messageSentBy: message['data']['sender'],
      DataBaseHelper.messageText: message['data']['message'],
      DataBaseHelper.messageContainsImage: '0',
      DataBaseHelper.messageImage: 'null',
      DataBaseHelper.messageTime: message['data']['time'],
    });
    db.updateLastMessage(<String, String>{
      DataBaseHelper.friendLastMessage: message['data']['message'],
      DataBaseHelper.friendLastMessageTime: message['data']['time'],
      DataBaseHelper.friendId: message['data']['sender']
    });
  }
}

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
  final db = DataBaseHelper();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  var iosSubscription;
  List tabs;
  @override
  void initState() {
    tabs = [
      FindScreen(),
      MessagesScreen('$chatsPage'),
      Profile(),
    ];
    _load();
    super.initState();
    socketIO = SocketIOManager().createSocketIO(
        'https://glacial-waters-33471.herokuapp.com', '/',
        socketStatusCallback: _socketStatus);
    socketIO.init();
    socketIO.sendMessage('update my status',
        json.encode({"uid": "$myId", "time": "${DateTime.now()}"}));
    socketIO.subscribe('new message', (jsonData) {
      var data = json.decode(jsonData);
      if (data['receiver'].toString() == myId ||
          data['sender'].toString() == myId) {
        // loadMessages();
        // print('$data');
        Map newMessage = <String, String>{
          DataBaseHelper.messageOtherId:
              (data['receiver'] != myId) ? data['receiver'] : data['sender'],
          DataBaseHelper.messageSentBy: data['sender'],
          DataBaseHelper.messageText: data['message'],
          DataBaseHelper.messageContainsImage: '0',
          DataBaseHelper.messageImage: "null",
          DataBaseHelper.messageTime: data['time']
        };
        Map updateLastMessage = <String, String>{
          'message': data['message'],
          'messageTime': data['time'],
          'otherId':
              (data['receiver'] != myId) ? data['receiver'] : data['sender']
        };
        db.addMessage(newMessage);
        db.updateLastMessage(updateLastMessage);
      }
    });
    getUserToken().then((value) {
      print("Token: $value");
    });
    _fcm.configure(
        onBackgroundMessage: myBackgroundMessageHandler,
        onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(
                    message['notification']['body'] + "${message['data']}"),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
          // if (message['data']['type'] == 'message') {
          //   db.addMessage(<String, String>{
          //     DataBaseHelper.messageOtherId: message['data']['sender'],
          //     DataBaseHelper.messageSentBy: message['data']['sender'],
          //     DataBaseHelper.messageText: message['data']['message'],
          //     DataBaseHelper.messageContainsImage: '0',
          //     DataBaseHelper.messageImage: 'null',
          //     DataBaseHelper.messageTime: message['data']['time'],
          //   });
          //   db.updateLastMessage(<String, String>{
          //     DataBaseHelper.friendLastMessage: message['data']['message'],
          //     DataBaseHelper.friendLastMessageTime: message['data']['time'],
          //     DataBaseHelper.friendId: message['data']['sender']
          //   });
          // }
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(
                    message['notification']['body'] + "${message['data']}"),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        });
  }

  void checkforIosPermission() async {
    await _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _fcm.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  _socketStatus(data) {
    print("Socket Status: $data");
  }

  Future<String> getUserToken() async {
    var tkn;
    if (Platform.isIOS) checkforIosPermission();
    await _fcm.getToken().then((value) {
      tkn = value;
      if (token != null && uid != null) {
        print("token: $token && UID: $uid");
        http.post('https://march.lbits.co/api/worker.php',
            body: json.encode({
              'serviceName': '',
              'work': 'save token',
              'uid': uid,
              'token': tkn
            }),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token'
            }).then((value) {
          var val = json.decode(value.body);
          print("$val");
        });
      }
    });
    return tkn;
  }

  Future<Map> updateStatus() async {
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
          ? Theme.of(context).primaryColor
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
                Ionicons.ios_people,
                size: 30,
              ),
              title: Text("Find People")),
          //   new BottomNavigationBarItem(icon: new Icon(Icons.date_range,size: 30,),title: Text("")),
          new BottomNavigationBarItem(
              icon: new Icon(
                FontAwesome.send,
                size: 22,
              ),
              title: Text("Chats")),
          new BottomNavigationBarItem(
              icon: new Icon(
                Icons.person,
                size: 30,
              ),
              title: Text("Profile")),
        ],
        unselectedItemColor: Theme.of(context).disabledColor,
        selectedItemColor: Theme.of(context).primaryColor,
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
    if (uid == null) {
      FirebaseAuth.instance.currentUser().then((val) async {
        String uid = val.uid;
        prefs.setString('uid', uid);
      });
    }
    socketIO.sendMessage('update my status',
        json.encode({"uid": "$myId", "time": "${DateTime.now()}"}));
  }
}
