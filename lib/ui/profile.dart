import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name;
  String bio;
  String pic;


  @override
  void initState() {
    // TODO: implement initState
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
/*
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0,25.0,15.0,8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text("Raja Mouli",style: TextStyle(fontSize: 18,),),
                          Text("35 Years Old",style: TextStyle(color: Colors.grey,fontSize: 14),),
                          Padding(
                            padding: const EdgeInsets.only(top:5.0),
                            child: Text("Bio:",style: TextStyle(fontSize: 18,),),
                          ),
                          Text("Koduri Srisaila Sri Rajamouli, professionally known as S. S. Rajamouli, is an Indian film director, screenwriter, and stunt choreographer",style: TextStyle(color: Colors.grey,fontSize: 14),),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CircleAvatar(
                              radius: 43.0,
                              backgroundImage:
                              NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/S._S._Rajamouli_at_the_trailer_launch_of_Baahubali.jpg/220px-S._S._Rajamouli_at_the_trailer_launch_of_Baahubali.jpg"),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom:25.0),
                            child: Text("Edit Profile",style: TextStyle(color: Colors.deepPurple,fontSize: 16,decoration: TextDecoration.underline),),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
*/


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: CircleAvatar(
                    radius: 43.0,
                    backgroundImage:
                    NetworkImage(pic!=null?pic:"https://thumbs.dreamstime.com/t/man-woman-silhouette-icons-pare-business-business-people-abstract-avatar-person-face-couple-58191914.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Center(child: Text(name!=null?name:"",style: TextStyle(fontSize: 18,),)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom:25.0,top:15),
                  child: Text("Edit Profile",style: TextStyle(color: Colors.deepPurple,fontSize: 16,decoration: TextDecoration.underline),),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Millions of people take ‘items requested by someone else’ with them as a gift when they travel, from local chocolate to perfume to clothes etc. You only answer ‘Yes’ if you didn’t buy and pack the item yourself. You should of course be certain that what you’re taking with you is permitted",style: TextStyle(color: Colors.grey,fontSize: 14),),
              ),


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:50.0),
                  child: Text("Track Goals".toUpperCase(),style: TextStyle(fontSize: 16,color: Colors.deepPurple),),
                ),
              ),




            ],
          ),
        ),
      ),
    );
  }

  void _load() async{
   /* FirebaseAuth.instance.currentUser().then((val) async {
       String uid=val.uid;
        var url = 'http://march.lbits.co/app/api/index.php?uid='+uid;
        var response = await http.get(url);
        if (response.statusCode == 200) {
          print(response.body);
          var jsonResponse = convert.jsonDecode(response.body);
           setState(() {
             name = jsonResponse["fullName"];
             bio=jsonResponse["bio"];
           });
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
    });
*/
  }
}