import 'package:flutter/material.dart';
import 'package:march/ui/message.dart';

class Inbox extends StatefulWidget {
  @override
  _InboxState createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[

            GestureDetector(
              onTap: (){

                String x="https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Prabhas_at_MAMI_18th_Mumbai_film_festival.jpg/240px-Prabhas_at_MAMI_18th_Mumbai_film_festival.jpg";
                String v="Prabhas";
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) => Message(x,v)),
                        (Route<dynamic> route) => true);

              },
              child: Container(
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
                        subtitle: Text('Shall we meet today?',style: TextStyle(fontSize: 14),),
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
                    ),

                  ],
                ),
              ),
            ),



            GestureDetector(
              child: Container(
                child: Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(top:15.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                          NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/1/17/RanaDaggubati.jpg/220px-RanaDaggubati.jpg"),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text('Rana',style: TextStyle(fontSize: 18,),),
                        subtitle: Text('HaHaHa',style: TextStyle(fontSize: 14),),
                        trailing: Text("09:50 PM",style: TextStyle(color: Colors.grey,fontSize: 14),),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:20.0,right: 18.0,top: 5),
                      child: Container(
                        color: Colors.black12,
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                      ),
                    ),


                  ],
                ),
              ),
            ),

            GestureDetector(
              child: Container(
                child: Column(
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.only(top:15.0),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30.0,
                          backgroundImage:
                          NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Samantha_At_The_Irumbu_Thirai_Trailer_Launch.jpg/220px-Samantha_At_The_Irumbu_Thirai_Trailer_Launch.jpg"),
                          backgroundColor: Colors.transparent,
                        ),
                        title: Text('Samantha',style: TextStyle(fontSize: 18,),),
                        subtitle: Text('Great Work',style: TextStyle(fontSize: 14),),
                        trailing: Text("08:10 AM",style: TextStyle(color: Colors.grey,fontSize: 14),),
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
            ),





          ],
        ),
      ),
    );
  }
}
