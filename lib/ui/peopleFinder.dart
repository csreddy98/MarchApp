import 'package:flutter/material.dart';
import 'package:march/ui/profileScreen.dart';
import 'package:march/widgets/ProfileWidget.dart';

class PeopleFinder extends StatefulWidget {
  PeopleFinder({Key key}) : super(key: key);

  @override
  _PeopleFinderState createState() => _PeopleFinderState();
}

class _PeopleFinderState extends State<PeopleFinder> {
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xffFFBF46),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 40,
                      child: Center(
                        child: Text(
                          "All",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                              width: 1, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15))),
                    ),
                    Container(
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
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 1, color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15),
                              bottomRight: Radius.circular(15))),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onVerticalDragUpdate: (x) {
                  if (x.delta.dy <= -6) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                  }
                },
                child: SizedBox(
                  width: size.width,
                  child: peopleCard(),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  Widget peopleCard() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Hero(
              flightShuttleBuilder: _flightShuttleBuilder,
              tag: "CSR",
              child: ProfileTop(
                  name: "Victor Miyata",
                  picUrl:
                      "https://images.pexels.com/photos/1845534/pexels-photo-1845534.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                  profession: "Front-End Developer",
                  location: "14 Km away"),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 14.0),
              child: Text(
                "By the same illusion which lifts the horizon of the sea to the level of the spectator on",
                style: TextStyle(
                    fontFamily: 'montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w100),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Victor Miyata's Goals",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ],
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(child: goalBox('Swimming', 0)),
                    Expanded(child: goalBox('Gymnastics', 1)),
                    Expanded(child: goalBox('Kick Boxing', 2))
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "Skip",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    width: 130,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        border: Border.all(
                            width: 1, color: Theme.of(context).primaryColor),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Center(
                      child: Text(
                        "Connect",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget goalBox(String goalName, int goalNumber) {
    List<Map<String, Color>> goalColors = [
      {'itemColor': Color(0xFFCCEEED), "textColor": Color(0xFF00ACA3)},
      {'itemColor': Color(0xFFF1D3B5), "textColor": Color(0xFF926D51)},
      {'itemColor': Color(0xFFF2C5D3), "textColor": Color(0xFF98596B)},
    ];
    return Container(
      decoration: BoxDecoration(
          color: goalColors[goalNumber]['itemColor'],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          goalName,
          style: TextStyle(
              color: goalColors[goalNumber]['textColor'], fontSize: 14),
        ),
      ),
    );
  }
}
