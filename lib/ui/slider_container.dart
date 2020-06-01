import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Slider_container extends StatefulWidget {
  String goal1;
  String goal2;
  String goal3;

  Slider_container(this.goal1, this.goal2, this.goal3);

  @override
  _Slider_containerState createState() => _Slider_containerState();
}

class _Slider_containerState extends State<Slider_container> {
  static int age_range_min = 18;
  int age_range_max = 100;
  int maxDistance = 0;
  RangeValues values = RangeValues(18, 100);
  bool goal_1 = false;
  bool goal_2 = false;
  bool goal_3 = false;

  @override
  Widget build(BuildContext context) {
    Size size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("Filters",
          style: TextStyle(color: Colors.black,fontSize: 22,fontFamily: 'montserrat'),),
        centerTitle: true,
      ),
      body: Container(
          width: size.width,
          height: size.height,
          child: Column(
              children: <Widget>[

                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets
                          .only(left: 30,top: 25),
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
                    activeColor: Color.fromRGBO(63, 92, 200, 1),
                    inactiveColor: Color.fromRGBO(63, 92, 200, 0.4),
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
                    SizedBox(width: size.width/4,),
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
                  padding: const EdgeInsets.only(left:10,top: 5,right: 15),
                  child: Slider(
                    value: maxDistance.toDouble(),
                    min: 0,
                    max: 100,
                    activeColor: Color.fromRGBO(63, 92, 200, 1),
                    inactiveColor: Color.fromRGBO(63, 92, 200, 0.4),
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
                                color: goal_1
                                    ? Color.fromRGBO(63, 92, 200, 1)
                                    : Colors.white,
                                child: InkWell(
                                  //padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                  child: Center(
                                    child: Text(widget.goal1,
                                      style: TextStyle(
                                        color: goal_1
                                            ? Colors.white
                                            : Color.fromRGBO(63, 92, 200, 1),
                                        fontSize: 14,
                                      ),),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      goal_1 =
                                      !goal_1;
                                    });
                                  },
                                ),),
                              decoration: BoxDecoration(
                                border: new Border.all(color: Color.fromRGBO(63, 92, 200, 1), width: 3.0),
                                borderRadius: new BorderRadius.circular(3.0),
                                color: goal_1
                                    ? Color.fromRGBO(63, 92, 200, 1)
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
                                color: goal_2
                                    ? Color.fromRGBO(63, 92, 200, 1)
                                    : Colors.white,
                                child: InkWell(
                                  //padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                    child: Center(
                                      child: Text(
                                        widget.goal2,
                                        style: TextStyle(
                                          color: goal_2
                                              ? Colors
                                              .white
                                              : Color.fromRGBO(63, 92, 200, 1),
                                          fontSize: 14,
                                        ),),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        goal_2 =
                                        !goal_2;
                                      });
                                    }
                                ),),
                              decoration: BoxDecoration(
                                border: new Border.all(color: Color.fromRGBO(63, 92, 200, 1), width: 3.0),
                                borderRadius: new BorderRadius.circular(3.0),
                                color: goal_2
                                    ? Color.fromRGBO(63, 92, 200, 1)
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
                                color: goal_3
                                    ? Color.fromRGBO(63, 92, 200, 1)
                                    : Colors.white,
                                child: InkWell(
                                  child: Center(
                                    child: Text(
                                      widget.goal3,
                                      style: TextStyle(
                                        color: goal_3
                                            ? Colors.white
                                            : Color.fromRGBO(63, 92, 200, 1),
                                        fontSize: 14,
                                      ),),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      goal_3 =
                                      !goal_3;
                                    });
                                  },
                                ),),
                              decoration: BoxDecoration(
                                border: new Border.all(color: Color.fromRGBO(63, 92, 200, 1), width: 3.0),
                                borderRadius: new BorderRadius.circular(3.0),
                                color: goal_3
                                    ? Color.fromRGBO(63, 92, 200, 1)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),



                      ]),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 100, 25, 50),
                  child: GestureDetector(
                    onTap: (){
                      List n=[];
                      if(goal_1==true){
                        n.add(widget.goal1);
                      }
                      if(goal_2==true){
                        n.add(widget.goal2);
                      }
                      if(goal_3==true){
                        n.add(widget.goal3);
                      }

                      Navigator.pop(context,[age_range_min,age_range_max,maxDistance,n]);
                    },
                    child:  Container(
                      width: size.width/3,
                      height: size.height/15,
                      decoration:BoxDecoration(
                          color: Color.fromRGBO(63, 92, 200, 1),
                          borderRadius: BorderRadius.circular(15)
                      ) ,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Submit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w600
                          ),),
                      ),),
                  ),
                ),


              ])
      ),
    );
  }
}