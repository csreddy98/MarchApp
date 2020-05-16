import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:march/ui/find_screen.dart';
import 'package:march/ui/inbox.dart';
import 'package:march/ui/notify.dart';
import 'package:march/ui/profile.dart';
import 'package:march/ui/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentindex=0;
  String title="Find People";
  List<String> t=["Find People","Track Goals","Inbox","Profile"];
  final tabs=[
    FindScreen(),
    Notify(),
    Inbox(),
    Profile(),
  ];

  @override
  void initState() {
    // TODO: implement initState
    _load();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        title: _currentindex==3?Padding(
          padding: const EdgeInsets.only(left:45.0),
          child: Center(child: Text(title,style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'montserrat'),)),
        ):Center(child: Text(title,style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'montserrat'),)),
        actions: <Widget>[
         _currentindex==3? IconButton(
            icon: Icon(Icons.list,color: Color.fromRGBO(63, 92, 200, 1),),
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
              new BottomNavigationBarItem(icon: new Image.asset("assets/images/find.png"),title: Text("")),
              new BottomNavigationBarItem(icon: new Image.asset("assets/images/calendar.png"),title: Text("")),
              new BottomNavigationBarItem(icon: new Image.asset("assets/images/inbox.png"),title: Text("")),
              new BottomNavigationBarItem(icon: new Icon(Icons.person,size: 30,color: Color.fromRGBO(63, 92, 200, 0.4),),title: Text("")),
            ],
            selectedItemColor: Colors.deepPurple,
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