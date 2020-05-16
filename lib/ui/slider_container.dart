import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Slider_container extends StatefulWidget {
  @override
  _Slider_containerState createState() => _Slider_containerState();
}

class _Slider_containerState extends State<Slider_container> {
  static int age_range_min = 18;
  int age_range_max = 100;
  int maxDistance = 0;
  RangeValues values = RangeValues(18, 100);
  bool goal_cricket = false;
  bool goal_football = false;
  bool goal_basketball = false;

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          width: size.width,
          height: size.height / 2,
          child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Filters",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 0.4,
                          fontSize: 22,)),
                  ],
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets
                          .only(left: 30,),
                      child: Text("Age Range",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 0.4,
                          fontSize: 18,
//                    fontWeight: FontWeight.w600
                        ),),
                    ),
                    SizedBox(width: size.width/2.9,),
                    Padding(
                      padding: const EdgeInsets
                          .only(left: 20,
                          top: 20,
                          right: 20),
                      child: Text(
                          "$age_range_min-$age_range_max",
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0.4,
                            fontSize: 18,
//                    fontWeight: FontWeight.w600,
                          )
                      ),
                    ),
                  ],
                ),

                //Range Slider
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10,  right: 20),
                  child: RangeSlider(
                    min: 18,
                    max: 100,
                    values: values,
                    onChanged: (value) {
                      setState(() {
                        age_range_min =
                            value.start.toInt();
                        age_range_max =
                            value.end.toInt();
                        values = value;


                      });
                    },

                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets
                          .only(left: 30,
                          top: 15,
                          right: 20),
                      child: Text("Max Distance",
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 0.4,
                          fontSize: 18,
//                        fontWeight: FontWeight.w600
                        ),),
                    ),
                    SizedBox(width: size.width/5,),
                    Padding(
                      padding: const EdgeInsets
                          .only(left: 20,
                          top: 15,
                          right: 20),
                      child: Text(
                          "${maxDistance}kms",
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0.4,
                            fontSize: 18,
//                        fontWeight: FontWeight.w600,
                          )
                      ),
                    ),
                  ],
                ),
                //Slider

                Padding(
                  padding: const EdgeInsets.only(left:10,top: 5,),
                  child: Slider(
                    value: maxDistance.toDouble(),
                    min: 0,
                    max: 100,
                    activeColor: Colors.indigoAccent,
                    inactiveColor: Colors.black,
                    divisions: 100,
                    onChanged: (val){
                      setState(() {
                        maxDistance=val.toInt();
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, top: 20, right: 20),
                  child: Text(
                    "Show me people with goals",
                    style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 0.4,
                      fontSize: 18,
//                fontWeight: FontWeight.w600,
                    ),),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                      left: 30, top: 10, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceEvenly,
                      children: <Widget>[


                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              //padding: const EdgeInsets.all(8.2),
                              child: Material(
                                color: goal_cricket
                                    ? Colors.blueAccent
                                    : Colors.white,
                                child: InkWell(
                                  //padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                  child: Center(
                                    child: Text("Cricket",
                                      style: TextStyle(
                                        color: goal_cricket
                                            ? Colors.white
                                            : Colors
                                            .blueAccent,
                                        fontSize: 14,
                                      ),),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      goal_cricket =
                                      !goal_cricket;
                                    });
                                  },
                                ),),
                              decoration: BoxDecoration(
                                border: new Border.all(color: Colors.blueAccent, width: 3.0),
                                borderRadius: new BorderRadius.circular(3.0),
                                color: goal_cricket
                                    ? Colors.blueAccent
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),



                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              //padding: const EdgeInsets.all(8.2),
                              child: Material(
                                color: goal_football
                                    ? Colors.blueAccent
                                    : Colors.white,
                                child: InkWell(
                                  //padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                    child: Center(
                                      child: Text(
                                        "Football",
                                        style: TextStyle(
                                          color: goal_football
                                              ? Colors
                                              .white
                                              : Colors
                                              .blueAccent,
                                          fontSize: 14,
                                        ),),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        goal_football =
                                        !goal_football;
                                      });
                                    }
                                ),),
                              decoration: BoxDecoration(
                                border: new Border.all(color: Colors.blueAccent, width: 3.0),
                                borderRadius: new BorderRadius.circular(3.0),
                                color: goal_football
                                    ? Colors.blueAccent
                                    : Colors.white,
                                ),
                            ),
                          ),
                        ),


                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              //padding: const EdgeInsets.all(8.2),
                              child: Material(
                                color: goal_basketball
                                    ? Colors.blueAccent
                                    : Colors.white,
                                child: InkWell(
                                  //padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                  child: Center(
                                    child: Text(
                                      "Basketball",
                                      style: TextStyle(
                                        color: goal_basketball
                                            ? Colors.white
                                            : Colors
                                            .blueAccent,
                                        fontSize: 14,
                                      ),),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      goal_basketball =
                                      !goal_basketball;
                                    });
                                  },
                                ),),
                              decoration: BoxDecoration(
                                border: new Border.all(color: Colors.blueAccent, width: 3.0),
                                borderRadius: new BorderRadius.circular(3.0),
                                color: goal_basketball
                                    ? Colors.blueAccent
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),



                      ]),
                ),
              ])
      ),
    );
  }
}