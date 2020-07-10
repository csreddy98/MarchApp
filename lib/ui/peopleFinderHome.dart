import 'package:flutter/material.dart';
import 'package:march/ui/profileScreen.dart';
import 'package:march/widgets/allPeople.dart';
import 'package:march/widgets/nearMePeople.dart';

class PeopleFinderHome extends StatefulWidget {
  PeopleFinderHome({Key key}) : super(key: key);

  @override
  _PeopleFinderHomeState createState() => _PeopleFinderHomeState();
}

class _PeopleFinderHomeState extends State<PeopleFinderHome> {
  int pageNo = 0;
  List<Widget> pages = [
    NearMePeople(
      peopleFinderType: "all",
    ),
    NearMePeople(
      peopleFinderType: "nearme",
    )
  ];

  BoxDecoration selected() {
    return BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        borderRadius: (pageNo == 0)
            ? BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
            : BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)));
  }

  BoxDecoration unSelected() {
    return BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Theme.of(context).primaryColor),
        borderRadius: (pageNo == 1)
            ? BorderRadius.only(
                topLeft: Radius.circular(15), bottomLeft: Radius.circular(15))
            : BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15)));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: size.width,
                height: size.width / 2.2,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.elliptical(250, 110))),
                      ),
                    ),
                    Positioned(
                        top: 20,
                        right: 0,
                        child: Image.asset(
                          "assets/images/HomeGoal.png",
                          width: 130,
                          height: 130,
                        )),
                    Positioned(
                      top: 40,
                      left: 25,
                      child: RichText(
                        text: TextSpan(
                            text: "A New Great Day,\n",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 22,
                                color: Colors.black,
                                wordSpacing: 1,
                                letterSpacing: 0,
                                height: 1.5,
                                fontFamily: 'montserrat'),
                            children: [
                              TextSpan(
                                  text: "Krishna!",
                                  style:
                                      TextStyle(fontWeight: FontWeight.normal))
                            ]),
                      ),
                    ),
                    Container(
                      child: Positioned(
                          bottom: 25,
                          left: 25,
                          child: Text(
                            "March towards your goal\nwith like minded souls",
                            style: TextStyle(
                                color: Colors.black,
                                textBaseline: TextBaseline.alphabetic,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          setState(() {
                            pageNo = 0;
                          });
                        },
                        child: Container(
                          width: 120,
                          height: 40,
                          child: Center(
                            child: Text(
                              "All",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                          decoration: (pageNo == 0) ? selected() : unSelected(),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            pageNo = 1;
                          });
                        },
                        child: Container(
                          width: 120,
                          height: 40,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(Icons.my_location),
                                Text(
                                  "Near Me",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          decoration: (pageNo == 1) ? selected() : unSelected(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: size.width,
                child: pages[pageNo],
              ),
            ],
          ),
        ));
  }
}
