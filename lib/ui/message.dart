import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final String img;
  final String name;
  Message(this.img, this.name);

  @override
  _MessageState createState() => _MessageState(img,name);
}

class _MessageState extends State<Message> {
  String img;
  String name;
  _MessageState(this.img, this.name);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: ListTile(
          leading: CircleAvatar(
            radius: 23.0,
            backgroundImage:
            NetworkImage(img),
            backgroundColor: Colors.transparent,
          ),
          title: Text(name,style: TextStyle(fontSize: 18,),),
          subtitle: Text('online',style: TextStyle(fontSize: 14),),
        ),

      ),
     body: Container(
     child: Column(
       children: <Widget>[
         Align(
           alignment: Alignment.bottomCenter,
           child: new Text('Bottom'),
         )
       ],
       ),
     ),


    );
  }
}
