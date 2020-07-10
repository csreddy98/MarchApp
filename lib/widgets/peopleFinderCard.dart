import 'package:flutter/material.dart';
import 'package:march/widgets/ProfileWidget.dart';

class PeopleFinderCard extends StatefulWidget {
  const PeopleFinderCard({Key key}) : super(key: key);

  @override
  _PeopleFinderCardState createState() => _PeopleFinderCardState();
}

class _PeopleFinderCardState extends State<PeopleFinderCard> {
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

  @override
  Widget build(BuildContext context) {
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
}
