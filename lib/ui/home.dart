import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:march/ui/MessagesScreen.dart';
import 'package:march/ui/find_screen.dart';
// import 'package:march/ui/inbox.dart';
// import 'package:march/ui/notify.dart';
import 'package:march/ui/profile.dart';
import 'package:march/ui/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io/socket_io.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentindex=0;
  String title="Find People";
  List<String> t=["Find People","Inbox","Profile"];
  final tabs=[
    FindScreen(),
    //Notify(),
    //Inbox(),
    MessagesScreen(),
    Profile(),
  ];

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
        backgroundColor:_currentindex==2? Color.fromRGBO(63, 92, 200, 1):Color(0xFFFFFFFF),
        title: _currentindex==2?Padding(
          padding: const EdgeInsets.only(left:45.0),
          child: Center(child: Text(title,style: TextStyle(color: Colors.white,fontSize: 18,fontFamily: 'montserrat'),)),
        ):Center(child: Text(title,style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'montserrat'),)),
        actions: <Widget>[
          //if added change it to 3
         _currentindex==2? IconButton(
            icon: Icon(Icons.tune,color: Colors.white,),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Settings()),
              );
            },
          ):Container(),
        ],
      ),
      body:Center(child: tabs[_currentindex],) ,
      bottomNavigationBar:   BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 20,
            elevation: 0,
            backgroundColor: Color(0xFFFFFFFF),
            currentIndex: _currentindex,
            items:
            [
              new BottomNavigationBarItem(icon: new Icon(Icons.group,size: 30,),title: Text("Find People")),
           //   new BottomNavigationBarItem(icon: new Icon(Icons.date_range,size: 30,),title: Text("")),
              new BottomNavigationBarItem(icon: new Icon(Icons.chat_bubble,size: 30,),title: Text("Chats")),
              new BottomNavigationBarItem(icon: new Icon(Icons.person,size: 30,),title: Text("Profile")),
            ],
            unselectedItemColor: Color.fromRGBO(63, 92, 200, 0.4),
            selectedItemColor: Color.fromRGBO(63, 92, 200, 1),
            onTap:(index){
              setState(() {
                _currentindex=index;
                title=t[_currentindex];
              });
            }
        ),
    );
  }
  void _load() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('log', 1);
    FirebaseAuth.instance.currentUser().then((val) async {
      String uid = val.uid;
      prefs.setString('uid', uid);
    });
  }
}