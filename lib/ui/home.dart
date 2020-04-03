import 'package:flutter/material.dart';
import 'package:march/ui/find.dart';
import 'package:march/ui/inbox.dart';
import 'package:march/ui/notify.dart';
import 'package:march/ui/profile.dart';
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
    Find(),
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
        backgroundColor: Color(0xFFFFFFFF),
        title: Center(child: Text(title,style: TextStyle(color: Colors.black,fontSize: 18),)),
      ),
      body:Center(child: tabs[_currentindex],) ,
      bottomNavigationBar:   BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 20,
            backgroundColor: Color(0xFFFFFFFF),
            currentIndex: _currentindex,
            items:
            [
              new BottomNavigationBarItem(icon: new Icon(Icons.people,size: 30,),title: Text("")),
              new BottomNavigationBarItem(icon: new Icon(Icons.calendar_today,size: 30,),title: Text("")),
              new BottomNavigationBarItem(icon: new Icon(Icons.message,size: 30,),title: Text("")),
              new BottomNavigationBarItem(icon: new Icon(Icons.person,size: 30,),title: Text("")),
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
  }
}