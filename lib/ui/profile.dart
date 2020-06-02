import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:march/models/goal.dart';
import 'package:march/models/user.dart';
import 'package:march/support/back_profile.dart';
import 'package:march/ui/edit_goals.dart';
import 'package:march/utils/database_helper.dart';
import 'dart:convert' as convert;
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
  String uid;
  int age;
  String profession;
  var db = new DataBaseHelper();
  User user;
  Goal goal1,goal2,goal3;

  List goals=["Add goal","Add goal","Add goal"];
  List time=["Add time","Add time","Add time"];
  List target=["Add target","Add target","Add target"];
  List names=["Rajamouli","Samantha Akinneni"];
  List profile=["https://w0.pngwave.com/png/914/653/silhouette-avatar-business-people-silhouettes-png-clip-art.png","https://w0.pngwave.com/png/914/653/silhouette-avatar-business-people-silhouettes-png-clip-art.png"];
  List data=[" SS Rajamouli, who never shies ,","Samantha is outstanding Samantha is outstanding Samantha is outstanding"];

  @override
  void initState() {
    // TODO: implement initState
    _load();
    super.initState();
  }

  PageController _controller = PageController(
      initialPage: 0,
      viewportFraction: 0.85
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Widget slide1(){
    return Card(

      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            /*Padding(
              padding: const EdgeInsets.only(top:12.0,left: 8.0),
              child: Text(goals[0]!=""?goals[0]:"",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontFamily: 'montserrat',fontWeight: FontWeight.bold),),
            ),*/
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(goals[0],style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat'),),
                    ))),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                IconButton(icon: Icon(Icons.edit,size: 16,color: Color.fromRGBO(63, 92, 200, 1),),
                    onPressed:(){

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditGoal("1", uid)),
                      );

                    }),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:0,left: 15.0),
                  child: Text("Target :"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,top:0),
                  child: AutoSizeText(target[0],style: TextStyle(color: Colors.grey),maxLines: 2,),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,top:8.0),
              child: Row(
                children: <Widget>[
                  Text("Time Frame : "),
                  Text(time[0])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget slide2(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(goals[1],style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat'),),
                    ))),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                IconButton(icon: Icon(Icons.edit,size: 16,color: Color.fromRGBO(63, 92, 200, 1),),
                    onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditGoal("2", uid)),
                      );
                    }),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:0,left: 15.0),
                  child: Text("Target :"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,top:0),
                  child: AutoSizeText(target[1],style: TextStyle(color: Colors.grey),maxLines: 2,),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,top:8.0),
              child: Row(
                children: <Widget>[
                  Text("Time Frame : "),
                  Text(time[1])
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget slide3(){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Center(child: Padding(
                      padding: const EdgeInsets.only(left: 0),
                      child: Text(goals[2],style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat'),),
                    ))),
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                IconButton(icon: Icon(Icons.edit,size: 16,color: Color.fromRGBO(63, 92, 200, 1),),
                    onPressed:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditGoal("3", uid)),
                      );
                    }),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top:0,left: 15.0),
                  child: Text("Target :"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:15.0,top:0),
                  child: AutoSizeText(target[2],style: TextStyle(color: Colors.grey),maxLines: 2,),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left:15.0,top:8.0),
              child: Row(
                children: <Widget>[
                  Text("Time Frame : "),
                  Text(time[2])
                ],
              ),
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

              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height*0.3,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      painter: BackProfile(),
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height*0.28,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6,top: 6),
                            child:Container(
                              width: 80.0,
                              height: 80.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(pic!=null?pic:"https://w7.pngwing.com/pngs/861/726/png-transparent-computer-icons-professional-avatar-avatar-heroes-public-relations-monochrome.png")
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.transparent,
                              ),
                            ),

                          ),
                        ),
                        Center(child: Text(name!=null?name:"",style: TextStyle(fontSize: 16,color: Colors.white),)),
                        Center(child: Text(profession!=null?profession:"",style: TextStyle(fontSize: 16,color: Colors.white),)),
                        Padding(
                          padding: const EdgeInsets.only(bottom:12.0),
                          child: Center(child: Text(age!=null?age.toString()+" Years old":"",style: TextStyle(fontSize: 14,color: Colors.white),)),
                        ),

                      ],
                    ),
                  )

                ],
              ),

              Padding(
                padding: const EdgeInsets.only(left:25.0,right: 15.0,top:10),
                child: Center(child: AutoSizeText(bio!=null?bio:"",style: TextStyle(color: Colors.black,fontSize: 13),maxLines: 3,)),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Text("Your Goals".toUpperCase(),style: TextStyle(fontSize: 16,color: Color.fromRGBO(63, 92, 200, 1) ,fontFamily: 'montserrat'),),
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
                indicatorColor: Color.fromRGBO(63, 92, 200, 1),
                color: Color.fromRGBO(63, 92, 200, 0.4),
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

   var now = new DateTime.now();
   user= await db.getUser(1);
   goal1= await db.getGoal(1);
   int gCount= await db.getGoalCount();
   if(gCount>1){
     goal2= await db.getGoal(2);
   }
   if(gCount>2){
     goal3= await db.getGoal(3);
   }
   setState(() {
     pic=user.userPic;
     bio=user.userBio;
     name=user.username;
     profession=user.userProfession;
     dob = user.userDob.substring(6,);
     age = int.parse(now.toString().substring(0, 4)) - int.parse(dob);
     goals[0]=goal1.goalName;
     time[0]=goal1.timeFrame;
     target[0]=goal1.target;
     if(gCount>2){
       goals[2]=goal3.goalName;
       time[2]=goal3.timeFrame;
       target[2]=goal3.target;
       goals[1]=goal2.goalName;
       time[1]=goal2.timeFrame;
       target[1]=goal2.target;
     }
     else if(gCount>1){
       goals[1]=goal2.goalName;
       time[1]=goal2.timeFrame;
       target[1]=goal2.target;
     }
     uid=user.userId;
   });

   /*  SharedPreferences prefs = await SharedPreferences.getInstance();
    String profile_pic = prefs.getString('pic')??"";
    String profile_name = prefs.getString('name')??"";
    String profile_bio = prefs.getString('bio')??"";
    int profile_age = prefs.getInt('age')??0;
    String uid = prefs.getString('uid')??"";
*/

  /*  var url = 'https://march.lbits.co/app/api/goals.php?uid=' + uid;
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
    }*/

/*
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
*//*
          prefs.setString('dob', dob);
          prefs.setString('gender', jsonResponse["sex"]);
*//*
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }


    }*/
  }
}