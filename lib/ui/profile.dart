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

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name, bio, pic, dob, uid, age, profession;
  var db = new DataBaseHelper();
  User user;
  Goal goal1, goal2, goal3;

  List goals = ["Add goal", "Add goal", "Add goal"];
  List time = ["Add time", "Add time", "Add time"];
  List target = ["Add target", "Add target", "Add target"];
  List names = ["Rajamouli", "Samantha Akinneni"];
  List profile = [
    "https://w0.pngwave.com/png/914/653/silhouette-avatar-business-people-silhouettes-png-clip-art.png",
    "https://w0.pngwave.com/png/914/653/silhouette-avatar-business-people-silhouettes-png-clip-art.png"
  ];
  List data = [
    " SS Rajamouli, who never shies ,",
    "Samantha is outstanding Samantha is outstanding Samantha is outstanding"
  ];

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

  Widget slide1() {
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: AutoSizeText(
                        goals[0],
                        maxLines: 1,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'montserrat'),
                      ),
                    )),
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditGoal("1", uid)),
                      );
                    }),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 15.0),
                  child: Text("Target :"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 0),
                    child: AutoSizeText(
                      target[0],
                      style: TextStyle(color: Colors.grey),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8.0),
              child: Row(
                children: <Widget>[Text("Time Frame : "), Text(time[0])],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slide2() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: AutoSizeText(
                        goals[1],
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'montserrat'),
                        maxLines: 1,
                      ),
                    )),
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditGoal("2", uid)),
                      );
                    }),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 15.0),
                  child: Text("Target :"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 0),
                    child: AutoSizeText(
                      target[1],
                      style: TextStyle(color: Colors.grey),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8.0),
              child: Row(
                children: <Widget>[Text("Time Frame : "), Text(time[1])],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget slide3() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: AutoSizeText(
                        goals[2],
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'montserrat'),
                        maxLines: 1,
                      ),
                    )),
                IconButton(
                    icon: Icon(
                      Icons.edit,
                      size: 16,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditGoal("3", uid)),
                      );
                    }),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 15.0),
                  child: Text("Target :"),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 0),
                    child: AutoSizeText(
                      target[2],
                      style: TextStyle(color: Colors.grey),
                      maxLines: 2,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 8.0),
              child: Row(
                children: <Widget>[Text("Time Frame : "), Text(time[2])],
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Image.asset(
                      "assets/images/backDrop.png",
                      fit: BoxFit.fitHeight,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.tune,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Settings()),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 6, top: 20),
                              child: InkWell(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => FullScreenImage(pic))),
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: Container(
                                        width: 90.0,
                                        height: 90.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 5, color: Colors.white),
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(pic ??
                                                  "https://assets.biola.edu/4396738754672012438/article/594aa2118eca317ac8dd0588/large_jobs__1_.jpg")),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                    Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                            width: 100.0,
                                            height: 115.0,
                                            decoration: null),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                            child: Text(
                          name != null
                              ? name[0].toUpperCase() + name.substring(1)
                              : "",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        )),
                        Center(
                            child: Text(
                          profession != null
                              ? profession[0].toUpperCase() +
                                  profession.substring(1)
                              : "",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Center(
                              child: Text(
                            age != null ? age.toString() + " Years old" : "",
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 10, 0),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Text(
                      //   "Bio :   ",
                      //   style: TextStyle(
                      //       fontWeight: FontWeight.w600, fontSize: 14),
                      // ),
                      Expanded(
                        child: Text(
                          bio != null
                              ? bio[0].toUpperCase() + bio.substring(1)
                              : "",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          maxLines: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Your Goals",
                    style: TextStyle(
                        fontSize: 15,
                        color: Theme.of(context).primaryColor,
                        fontFamily: 'montserrat'),
                  ),
                ),
              ),
              SizedBox(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: PageView(
                  controller: _controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 3.0, top: 8.0, bottom: 15.0),
                      child: slide1(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 8.0, bottom: 15.0),
                      child: slide2(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 8.0, bottom: 15.0),
                      child: slide3(),
                    ),
                  ],
                ),
              ),
              WormIndicator(
                indicatorColor: Theme.of(context).primaryColor,
                color: Theme.of(context).disabledColor,
                length: 3,
                controller: _controller,
                shape: Shape(
                    size: 6,
                    spacing: 3,
                    shape: DotShape.Circle // Similar for Square
                    ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  "Testimonials",
                  style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).primaryColor,
                      fontFamily: 'montserrat'),
                )),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 0.75,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 5, 15, 5),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 30.0,
                                  backgroundImage: NetworkImage(profile[i]),
                                  backgroundColor: Colors.transparent,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: AutoSizeText(
                                            names[i],
                                            maxLines: 1,
                                          ),
                                        ),
                                        AutoSizeText(
                                          data[i],
                                          style: TextStyle(fontSize: 12),
                                          maxLines: 2,
                                        )
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

  void _load() async {
    user = await db.getUser(1);
    goal1 = await db.getGoal(1);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int gCount = await db.getGoalCount();
    if (gCount > 1) {
      goal2 = await db.getGoal(2);
    }
    if (gCount > 2) {
      goal3 = await db.getGoal(3);
    }
    setState(() {
      pic = user.userPic;
      bio = user.userBio;
      name = user.username;
      profession = user.userProfession;
      //  dob = user.userDob.substring(6,);
      // age = int.parse(now.toString().substring(0, 4)) - int.parse(dob);
      age = prefs.getString('age');
      goals[0] = goal1.goalName;
      time[0] = goal1.timeFrame;
      target[0] = goal1.target;
      if (gCount > 2) {
        goals[2] = goal3.goalName;
        time[2] = goal3.timeFrame;
        target[2] = goal3.target;
        goals[1] = goal2.goalName;
        time[1] = goal2.timeFrame;
        target[1] = goal2.target;
      } else if (gCount > 1) {
        goals[1] = goal2.goalName;
        time[1] = goal2.timeFrame;
        target[1] = goal2.target;
      }
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
