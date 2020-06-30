import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Slider_container extends StatefulWidget {
  final List goalList;

  Slider_container(this.goalList);

  @override
  _SlidercontainerState createState() => _SlidercontainerState();
}

class Level {
  int id;
  String level;

  Level(this.id, this.level);

  static List<Level> getLevel() {
    return <Level>[
      Level(1, 'None'),
      Level(2, 'Beginner'),
      Level(3, 'Amateur'),
      Level(4, 'Intermediate'),
      Level(5, 'Professional'),
    ];
  }
}

class _SlidercontainerState extends State<Slider_container> {
  static int ageRangeMin = 18;
  int ageRangeMax = 100;
  int maxDistance = 0;
  RangeValues values = RangeValues(18, 100);
  bool goal_1 = false;
  bool goal_2 = false;
  bool goal_3 = false;
  // List<Level> _level = Level.getLevel();
  String level = "None";
  String levelChange = "";
  int maxAgeVal = 0, minAgeVal = 0, distanceVal = 0;

  onChangeDropDownLevel(Level selectedLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('level', level);
      levelChange = level;
    });
  }

  @override
  void initState() {
    dataReader();
    super.initState();
  }

  dataReader() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ageRangeMax = prefs.getInt('maxAge') ?? 100;
      ageRangeMin = prefs.getInt('minAge') ?? 18;
      maxDistance = prefs.getInt('distanceVal') ?? 0;
      goal_1 = prefs.getBool('goal1') ?? false;
      goal_2 = prefs.getBool('goal2') ?? false;
      goal_3 = prefs.getBool('goal3') ?? false;
      level = prefs.getString('level');
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Filters",
          style: TextStyle(
              color: Colors.black, fontSize: 22, fontFamily: 'montserrat'),
        ),
        centerTitle: true,
      ),
      body: Container(
          width: size.width,
          height: size.height,
          child: Column(children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 25),
                  child: Text(
                    "Age Range",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 0.4,
                      fontSize: 18,
//                    fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width / 2.9,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
                  child: Text("$ageRangeMin-$ageRangeMax",
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 0.4,
                        fontSize: 18,
//                    fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),

            //Range Slider
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 20),
              child: RangeSlider(
                activeColor: Theme.of(context).primaryColor,
                inactiveColor: Color.fromRGBO(63, 92, 200, 0.4),
                min: 18,
                max: 100,
                values:
                    RangeValues(ageRangeMin.toDouble(), ageRangeMax.toDouble()),
                onChanged: (value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    ageRangeMin = value.start.toInt();
                    prefs.setInt('minAge', ageRangeMin);
                    ageRangeMax = value.end.toInt();
                    prefs.setInt('maxAge', ageRangeMax);
                    values = value;
                    print(values);
                  });
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 15, right: 20),
                  child: Text(
                    "Max Distance",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 0.4,
                      fontSize: 18,
//                        fontWeight: FontWeight.w600
                    ),
                  ),
                ),
                SizedBox(
                  width: size.width / 4,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 15, right: 20),
                  child: Text("${maxDistance}kms",
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 0.4,
                        fontSize: 18,
//                        fontWeight: FontWeight.w600,
                      )),
                ),
              ],
            ),
            //Slider

            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, right: 15),
              child: Slider(
                value: maxDistance.toDouble(),
                min: 0,
                max: 100,
                activeColor: Color.fromRGBO(63, 92, 200, 1),
                inactiveColor: Color.fromRGBO(63, 92, 200, 0.4),
                divisions: 100,
                onChanged: (val) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  setState(() {
                    prefs.setInt('distanceVal', val.toInt());
                    maxDistance = val.toInt();
                  });
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25.0, 15, 20.0, 0),
              child: Row(
                children: <Widget>[
                  Text('Level : '),
                  SizedBox(
                    width: 20,
                  ),
                  // DropdownButton(
                  //   value: _selectedLevel,
                  //   items: _dropdownMenuLevels,
                  //   onChanged: onChangeDropDownLevel,
                  // ),
                  new DropdownButton<String>(
                      value: level,
                      icon: Icon(Icons.arrow_drop_down),
                      onChanged: (String newVal) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        setState(() {
                          level = newVal;
                          prefs.setString('level', level);
                        });
                      },
                      items: <String>[
                        'none',
                        'Beginner',
                        'Intermediate',
                        'Advanced'
                      ].map<DropdownMenuItem<String>>((String val) {
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                        );
                      }).toList())
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30, top: 20, right: 20),
              child: Text(
                "Show me people with goals",
                style: TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.4,
                  fontSize: 18,
//                fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 30, top: 10, right: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 40,
                            //padding: const EdgeInsets.all(8.2),
                            child: Material(
                              color: goal_1
                                  ? Color.fromRGBO(63, 92, 200, 1)
                                  : Colors.white,
                              child: InkWell(
                                //padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                child: Center(
                                  child: Text(
                                    widget.goalList[0],
                                    style: TextStyle(
                                      color: goal_1
                                          ? Colors.white
                                          : Color.fromRGBO(63, 92, 200, 1),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  setState(() {
                                    goal_1 = !goal_1;
                                    prefs.setBool('goal1', goal_1);
                                  });
                                },
                              ),
                            ),
                            decoration: BoxDecoration(
                              border: new Border.all(
                                  color: Color.fromRGBO(63, 92, 200, 1),
                                  width: 3.0),
                              borderRadius: new BorderRadius.circular(3.0),
                              color: goal_1
                                  ? Color.fromRGBO(63, 92, 200, 1)
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      widget.goalList.length > 1
                          ? Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  //padding: const EdgeInsets.all(8.2),
                                  child: Material(
                                    color: goal_2
                                        ? Color.fromRGBO(63, 92, 200, 1)
                                        : Colors.white,
                                    child: InkWell(
                                        //padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                        child: Center(
                                          child: Text(
                                            widget.goalList[1],
                                            style: TextStyle(
                                              color: goal_2
                                                  ? Colors.white
                                                  : Color.fromRGBO(
                                                      63, 92, 200, 1),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          setState(() {
                                            goal_2 = !goal_2;
                                            prefs.setBool('goal2', goal_2);
                                          });
                                        }),
                                  ),
                                  decoration: BoxDecoration(
                                    border: new Border.all(
                                        color: Color.fromRGBO(63, 92, 200, 1),
                                        width: 3.0),
                                    borderRadius:
                                        new BorderRadius.circular(3.0),
                                    color: goal_2
                                        ? Color.fromRGBO(63, 92, 200, 1)
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(),
                            ),
                      widget.goalList.length > 2
                          ? Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,
                                  //padding: const EdgeInsets.all(8.2),
                                  child: Material(
                                    color: goal_3
                                        ? Color.fromRGBO(63, 92, 200, 1)
                                        : Colors.white,
                                    child: InkWell(
                                      child: Center(
                                        child: Text(
                                          widget.goalList[2],
                                          style: TextStyle(
                                            color: goal_3
                                                ? Colors.white
                                                : Color.fromRGBO(
                                                    63, 92, 200, 1),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      onTap: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        setState(() {
                                          goal_3 = !goal_3;
                                          prefs.setBool('goal3', goal_3);
                                        });
                                      },
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    border: new Border.all(
                                        color: Color.fromRGBO(63, 92, 200, 1),
                                        width: 3.0),
                                    borderRadius:
                                        new BorderRadius.circular(3.0),
                                    color: goal_3
                                        ? Color.fromRGBO(63, 92, 200, 1)
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(),
                            ),
                    ]),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(25, 100, 25, 50),
              child: GestureDetector(
                onTap: () {
                  String n = "";
                  print(goal_1.toString() +
                      goal_2.toString() +
                      goal_3.toString());
                  if (goal_1 == true) {
                    n = widget.goalList[0];
                  }
                  if (goal_2 == true) {
                    if (n != "") {
                      n = n + "," + widget.goalList[1];
                    } else {
                      n = widget.goalList[1];
                    }
                  }
                  if (goal_3 == true) {
                    if (n != "") {
                      n = n + "," + widget.goalList[2];
                    } else {
                      n = widget.goalList[2];
                    }
                  }
                  print(n);
                  print(levelChange);
                  Navigator.pop(context,
                      [ageRangeMin, ageRangeMax, maxDistance, n, levelChange]);
                },
                child: Container(
                  width: size.width / 3,
                  height: size.height / 15,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(63, 92, 200, 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Submit",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ])),
    );
  }
}
