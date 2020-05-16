import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:march/ui/edit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worm_indicator/shape.dart';


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

  List goals=["","",""];
  List time=["","",""];
  List target=["","",""];
  List names=["Rajamouli","Samantha Akinneni"];
  List profile=["https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/S._S._Rajamouli_at_the_trailer_launch_of_Baahubali.jpg/220px-S._S._Rajamouli_at_the_trailer_launch_of_Baahubali.jpg","https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Samantha_At_The_Irumbu_Thirai_Trailer_Launch.jpg/220px-Samantha_At_The_Irumbu_Thirai_Trailer_Launch.jpg"];
  List data=[" SS Rajamouli, who never shies ,","Samantha is outstanding Samantha is outstanding Samantha is outstanding"];

  @override
  void initState() {
    // TODO: implement initState
    _load();
    super.initState();
  }

  PageController _controller = PageController(
      initialPage: 0,
      viewportFraction: 0.95
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget slide1(){
    return Card(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text(goals[0]!=""?goals[0]:"",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontFamily: 'montserrat'),)),
            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 8.0),
              child: Text("Target :"),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,top:3.0),
              child: Text(target[0]!=""?target[0]:"",style: TextStyle(color: Colors.grey),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,top:3.0),
              child: Text("Time Frame : "+time[0]!=""?time[0]:""),
            ),
          ],
        ),
      ),
    );
  }


  Widget slide2(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text(goals[1]!=""?goals[1]:"",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontFamily: 'montserrat'),)),
            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 8.0),
              child: Text("Target :"),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,top:3.0),
              child: Text(target[1]!=""?target[1]:"",style: TextStyle(color: Colors.grey),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,top:3.0),
              child: Text("Time Frame : "+time[1]!=""?time[1]:""),
            ),
          ],
        ),
      ),
    );
  }

  Widget slide3(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: Text(goals[2]!=""?goals[2]:"",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontFamily: 'montserrat'),)),
            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 8.0),
              child: Text("Target :"),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,top:3.0),
              child: Text(target[2]!=""?target[2]:"",style: TextStyle(color: Colors.grey),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,top:3.0),
              child: Text("Time Frame : "+time[2]!=""?time[2]:""),
            ),
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
                  child:Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(pic!=null?pic:"https://thumbs.dreamstime.com/t/man-woman-silhouette-icons-pare-business-business-people-abstract-avatar-person-face-couple-58191914.jpg")
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.transparent,
                    ),
                  ),

                ),
              ),
              Center(child: Text(name!=null?name:"",style: TextStyle(fontSize: 18,),)),
              Center(child: Text(age!=null?age.toString()+" Years old":"",style: TextStyle(fontSize: 14,color: Colors.grey),)),
              Padding(
                padding: const EdgeInsets.only(left:25.0,top: 15.0),
                child: AutoSizeText(bio!=null?bio:"",style: TextStyle(color: Colors.black,fontSize: 13),maxLines: 3,),
              ),


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Text("Goals".toUpperCase(),style: TextStyle(fontSize: 16,color: Color.fromRGBO(63, 92, 200, 1) ,fontFamily: 'montserrat'),),
                ),
              ),

              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: _controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:3.0,top: 8.0,bottom: 15.0),
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

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text("Testimonials",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontFamily: 'montserrat'),)),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height*0.6,
                width: MediaQuery.of(context).size.width*0.75,
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, i) {
                    return  Padding(
                      padding: const EdgeInsets.fromLTRB(15.0,5,15,5),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              children: <Widget>[

                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage:
                                  NetworkImage(profile[i]),
                                  backgroundColor: Colors.transparent,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left:30.0),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width*0.6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(bottom:3.0),
                                          child: AutoSizeText(names[i],maxLines: 1,),
                                        ),
                                        AutoSizeText(data[i],style: TextStyle(fontSize: 12),maxLines: 2,)
                                      ],
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )



            ],
          ),
        ),
      ),
    );
  }

  void _load() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profile_pic = prefs.getString('pic')??"";
    String profile_name = prefs.getString('name')??"";
    String profile_bio = prefs.getString('bio')??"";
    int profile_age = prefs.getInt('age')??0;
    String uid = prefs.getString('uid')??"";


    var url = 'https://march.lbits.co/app/api/goals.php?uid=' + uid;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      for(var i=0;i<3;i++){
        setState(() {
          goals[i]=jsonResponse[i]['goal'];
          time[i]=jsonResponse[i]['time_frame'];
          target[i]=jsonResponse[i]['target'];
        });
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }


    if(profile_pic!="" && profile_name!=""&&profile_bio!="" &&profile_age!=0){
      setState(() {
        pic=profile_pic;
        bio=profile_bio;
        age=profile_age;
        name=profile_name;
      });
    }
    else {
      var now = new DateTime.now();

        var url = 'https://march.lbits.co/app/api/index.php?uid=' + uid;
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var jsonResponse = convert.jsonDecode(response.body);
          setState(() {
            name = jsonResponse["fullName"];
            bio = jsonResponse["bio"];
            pic = jsonResponse["profile_pic"];
            dob = jsonResponse["DOB"].toString().substring(6,);
            age = int.parse(now.toString().substring(0, 4)) - int.parse(dob);
          });
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('pic', pic);
          prefs.setString('name', name);
          prefs.setString('bio', bio);
          prefs.setInt('age', age);
/*
          prefs.setString('dob', dob);
          prefs.setString('gender', jsonResponse["sex"]);
*/
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }


    }
  }
}