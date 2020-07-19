import 'package:flutter/material.dart';
import 'package:march/models/goal.dart';
import 'package:march/models/user.dart';
import 'package:march/support/Api/api.dart';
import 'package:march/ui/settings.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:march/widgets/ProfileWidget.dart';
import 'package:march/widgets/functions.dart';
// import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name, bio, pic, dob, uid, age, profession, id;
  var db = new DataBaseHelper();
  User user;

  List goals = [];
  List testimonials = [];
  Api api = Api();

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

  _getTestimonials() async {
    api.getUserTestimonials({
      'serviceName': '',
      'work': 'get user profile',
      'profileId': '$id',
      'uid': '$uid'
    }).then((val) {
      print(val);
      setState(() {
        testimonials.addAll(val['result']['testimonials']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Your Profile",
          style: TextStyle(
          fontSize: size.height / 32,
          fontWeight: FontWeight.w600,
          ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            InkWell(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Settings()));
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  child: Icon(Icons.tune),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy >= 6) {
                      Navigator.pop(context);
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
                        // location: "Age",
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10.0),
                  child: Text(
                    "Age: $age",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: size.height / 45,
                      height: 1.2,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 13.0),
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
                        "Your Goals",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
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
                    "Here’s what others are saying about you",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                Container(
                    child: testimonials.length > 0
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                testimonials.length,
                                (index) => testimonial(
                                    context,
                                    testimonials[index]['profile_pic'],
                                    testimonials[index]['fullName'],
                                    testimonials[index]['message'])))
                        : Center(
                            child: Text(
                                "Ughh Nobody wrote about you.\nTry Socializing more...",
                                style: TextStyle(fontSize: size.height / 48),
                                ),
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
      dob = user.userDob.substring(
        6,
      );
      age = prefs.getString('age');
      uid = user.userId;
      id = prefs.getString('id');
    });
    _getTestimonials();
  }
}
