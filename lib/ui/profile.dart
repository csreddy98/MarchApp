import 'package:flutter/material.dart';
import 'package:march/models/goal.dart';
import 'package:march/models/user.dart';
import 'package:march/ui/settings.dart';
import 'package:march/utils/database_helper.dart';
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
        appBar: AppBar(
          centerTitle: true,
          title: Text("Your Profile"),
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
                      horizontal: 10.0, vertical: 13.0),
                  child: Text(
                    "Age: $age",
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
                    "Here’s what others are saying about Mason",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                Container(
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
      dob = user.userDob.substring(
        6,
      );
      age = prefs.getString('age');
      uid = user.userId;
    });
  }
}
