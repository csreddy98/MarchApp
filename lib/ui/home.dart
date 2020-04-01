import 'package:flutter/material.dart';
import 'package:march/ui/find.dart';
import 'package:march/ui/inbox.dart';
import 'package:march/ui/notify.dart';
import 'package:march/ui/profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentindex=0;
  String title="Profile";
  List<String> t=["Profile","Find People","Notifications","Inbox"];
  final tabs=[
    Profile(),
    Find(),
    Notify(),
    Inbox(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
        title: Center(child: Text(title,style: TextStyle(color: Colors.deepPurple,fontSize: 25),)),
      ),
      body:Center(child: tabs[_currentindex],) ,
      bottomNavigationBar:  ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
        child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            iconSize: 20,
            backgroundColor: Color(0xFFFFFFFF),
            currentIndex: _currentindex,
            items:
            [
              new BottomNavigationBarItem(icon: new Icon(Icons.person,size: 30,),title: Text("")),
              new BottomNavigationBarItem(icon: new Icon(Icons.people,size: 30,),title: Text("")),
              new BottomNavigationBarItem(icon: new Icon(Icons.notifications,size: 30,),title: Text("")),
              new BottomNavigationBarItem(icon: new Icon(Icons.message,size: 30,),title: Text("")),
            ],
            selectedItemColor: Colors.deepPurple,
            onTap:(index){
              setState(() {
                _currentindex=index;
                title=t[_currentindex];
              });
            }
        ),
      ),
    );
  }
}
