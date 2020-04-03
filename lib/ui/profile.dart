import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:march/ui/edit.dart';
import 'package:worm_indicator/shape.dart';
import 'dart:convert' as convert;

import 'package:worm_indicator/worm_indicator.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name;
  String bio;
  String pic;
  String dob;
  int age;

  @override
  void initState() {
    // TODO: implement initState
    _load();
    super.initState();
  }

  PageController _controller = PageController(
      initialPage: 0,
      viewportFraction: 0.9
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget slide1(){
    return Container(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text("CRICKET")),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("Target :"),
            ),
            Text("this is target",style: TextStyle(color: Colors.grey),),
            Text("Time Frame : 2 years"),
          ],
        ),
      ),
    );
  }


  Widget slide2(){
    return Container(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text("DANCE")),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("Target :"),
            ),
            Text("this is target",style: TextStyle(color: Colors.grey),),
            Text("Time Frame : 2 years"),
          ],
        ),
      ),
    );
  }

  Widget slide3(){
    return Container(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text("SOCCER")),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text("Target :"),
            ),
            Text("this is target",style: TextStyle(color: Colors.grey),),
            Text("Time Frame : 2 years"),
          ],
        ),
      ),
    );
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

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10,top: 15),
                  child: CircleAvatar(
                    radius: 43.0,
                    backgroundImage:
                    NetworkImage(pic!=null?pic:"https://thumbs.dreamstime.com/t/man-woman-silhouette-icons-pare-business-business-people-abstract-avatar-person-face-couple-58191914.jpg"),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              Center(child: Text(name!=null?name:"",style: TextStyle(fontSize: 18,),)),
              Center(child: Text(age!=null?age.toString()+" Years old":"",style: TextStyle(fontSize: 14,color: Colors.grey),)),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(bio!=null?bio:"",style: TextStyle(color: Colors.grey,fontSize: 14),),
              ),


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Text("Goals".toUpperCase(),style: TextStyle(fontSize: 16,color: Colors.blue),),
                ),
              ),

              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: _controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                      child: slide1(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                      child: slide2(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                      child: slide3(),
                    ),
                  ],
                ),
              ),
              WormIndicator(
                length: 3,
                controller: _controller,
                shape: Shape(
                    size: 6,
                    spacing: 3,
                    shape: DotShape.Circle  // Similar for Square
                ),
              ),

              Center(child: Text("Testimonials",style: TextStyle(color: Colors.blue),))




            ],
          ),
        ),
      ),
    );
  }

  void _load() async{
    var now = new DateTime.now();
    FirebaseAuth.instance.currentUser().then((val) async {
       String uid=val.uid;
        var url = 'https://march.lbits.co/app/api/index.php?uid='+uid;
        var response = await http.get(url);
        if (response.statusCode == 200) {
          print(response.body);
          var jsonResponse = convert.jsonDecode(response.body);
           setState(() {
             name = jsonResponse["fullName"];
             bio=jsonResponse["bio"];
             pic=jsonResponse["profile_pic"];
             dob=jsonResponse["DOB"].toString().substring(6,);
             age=int.parse(now.toString().substring(0,4))-int.parse(dob);
           });
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }
    });

  }
}