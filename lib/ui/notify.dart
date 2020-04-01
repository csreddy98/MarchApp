import 'package:flutter/material.dart';

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[

            Padding(
              padding: const EdgeInsets.only(top:15.0),
              child: ListTile(
                  leading: CircleAvatar(
                    radius: 30.0,
                    backgroundImage:
                    NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Prabhas_at_MAMI_18th_Mumbai_film_festival.jpg/240px-Prabhas_at_MAMI_18th_Mumbai_film_festival.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                  title: Text('Prabhas',style: TextStyle(fontSize: 18,),),
                  subtitle: Text('Added You',style: TextStyle(fontSize: 14),),
                  trailing: Text("09:24 PM",style: TextStyle(color: Colors.grey,fontSize: 14),),
                ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:20.0,right: 18.0,top: 5),
              child: Container(
                color: Colors.black12,
                width: MediaQuery.of(context).size.width,
                height: 2,
              ),
            )

          ],
        ),
      ),
    );
  }
}
