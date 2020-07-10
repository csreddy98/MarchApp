import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:march/models/goal.dart';
import 'package:march/models/user.dart';
import 'package:march/support/back_profile.dart';
import 'package:march/ui/edit_goals.dart';
import 'package:march/ui/settings.dart';
import 'package:march/ui/view_profile.dart';
import 'package:march/utils/database_helper.dart';
import 'package:worm_indicator/shape.dart';
import 'package:worm_indicator/worm_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:march/widgets/ProfileWidget.dart';
import 'package:march/widgets/functions.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name, bio, pic, dob, uid, age, profession;
  var db = new DataBaseHelper();
  User user;
  Goal goal1, goal2, goal3;

  List goals = [];
  List testimonials = [];

  PageController _controller =
      PageController(initialPage: 0, viewportFraction: 0.85);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy >= 6) {
                  Navigator.pop(context);
                  // Navigator.canPop(context);
                }
              },
              child: Hero(
                tag: "$name",
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Colors.transparent,
                  child: ProfileTop(
                    name: "$name",
                    picUrl: "$pic",
                    profession: "$profession",
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 13.0),
              child: Text(
                "$bio",
                maxLines: 4,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'montserrat',
                  fontSize: 14,
                  height: 1.2,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "$name's Goals",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    this.goals.length,
                    (index) => Expanded(
                        child: goalCardGenerator(
                            context,
                            "${this.goals[index]['goalName']}",
                            int.parse(this.goals[index]['level'])))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Here’s what others are saying about Mason",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
            Container(
                // padding: const EdgeInsets.symmetric(vertical: 0),
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                testimonial(
                    context,
                    "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                    "Emily",
                    "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car"),
                testimonial(
                    context,
                    "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                    "Emily",
                    "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car")
              ],
            )),
          ],
        ),
      ),
    ));
  }

  void _load() async {
    user = await db.getUser(1);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    db.getGoal(1).then((value) {
      goals.addAll(value);
    });
    setState(() {
      pic = user.userPic;
      bio = user.userBio;
      name = user.username;
      profession = user.userProfession;
      //  dob = user.userDob.substring(6,);
      // age = int.parse(now.toString().substring(0, 4)) - int.parse(dob);
      // age = prefs.getString('age');
      // goals[0] = goal1.goalName;
      // time[0] = goal1.timeFrame;
      // target[0] = goal1.target;
      // if (gCount > 2) {
      //   goals[2] = goal3.goalName;
      //   time[2] = goal3.timeFrame;
      //   target[2] = goal3.target;
      //   goals[1] = goal2.goalName;
      //   time[1] = goal2.timeFrame;
      //   target[1] = goal2.target;
      // } else if (gCount > 1) {
      //   goals[1] = goal2.goalName;
      //   time[1] = goal2.timeFrame;
      //   target[1] = goal2.target;
      // }
      uid = user.userId;
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
*/ /*
          prefs.setString('dob', dob);
          prefs.setString('gender', jsonResponse["sex"]);
*/ /*
        } else {
          print('Request failed with status: ${response.statusCode}.');
        }


    }*/
  }

  calculateAge(String birthDate) {
    DateTime currentDate = DateTime.now(); //27-06-1997
    int age = currentDate.year - int.parse(birthDate.substring(6));
    int month1 = currentDate.month;
    int month2 = int.parse(birthDate.substring(3, 5));
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = int.parse(birthDate.substring(0, 2));
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }
}
