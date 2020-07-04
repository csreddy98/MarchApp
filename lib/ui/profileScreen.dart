import 'package:flutter/material.dart';
import 'package:march/widgets/ProfileWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFBFCFE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("Victor Miyata"),
          centerTitle: true,
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.close),
            ),
          ),
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
                      // Navigator.canPop(context);
                    }
                  },
                  child: Hero(
                    tag: "CSR",
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: ProfileTop(
                          name: "Victor Miyata",
                          picUrl:
                              "https://images.pexels.com/photos/1845534/pexels-photo-1845534.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
                          profession: "Front-End Developer",
                          location: "14 Km away"),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 13.0),
                  child: Text(
                    "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car",
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
                        "Victor Miyata's Goals",
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
                    children: <Widget>[
                      Expanded(child: goalCardGenerator("Cricket", 1)),
                      Expanded(child: goalCardGenerator("Swimming", 3)),
                      Expanded(child: goalCardGenerator("Archery", 4)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "Here’s what others are saying about Mason",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        testimonial(
                            "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                            "Emily",
                            "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car"),
                        testimonial(
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

  Widget testimonial(String image, String name, String description) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    image: DecorationImage(
                        image: NetworkImage("$image"), fit: BoxFit.cover)),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                width: MediaQuery.of(context).size.width - 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("$name"),
                    ),
                    Text(
                      "$description",
                      maxLines: 4,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'montserrat',
                        fontSize: 14,
                        height: 1.2,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              )
            ]));
  }

  Widget goalCardGenerator(String goalName, int goalLevel) {
    List<Map> goalAssets = [
      {
        'name': 'Newbie',
        'image': 'assets/images/newbie.png',
        'bgColor': Color(0xFFCCEEED),
        'textColor': Color(0xFF00ACA3)
      },
      {
        'name': 'Skilled',
        'image': 'assets/images/skilled.png',
        'bgColor': Color(0xFFB1D1DF),
        'textColor': Color(0xFF4D6874)
      },
      {
        'name': 'Proficient',
        'image': 'assets/images/proficient.png',
        'bgColor': Color(0xFFE35E64),
        'textColor': Color(0xFF74272A)
      },
      {
        'name': 'Experienced',
        'image': 'assets/images/experienced.png',
        'bgColor': Color(0xFFF2C5D3),
        'textColor': Color(0xFF926D51)
      },
      {
        'name': 'Expert',
        'image': 'assets/images/expert.png',
        'bgColor': Color(0xFFF1D3B5),
        'textColor': Color(0xFF926D51)
      },
    ];
    return Card(
      elevation: 10,
      child: Container(
        height: 130,
        decoration: BoxDecoration(
          color: goalAssets[goalLevel]['bgColor'],
          // border: Border.all(
          //     width: 1, color: goalAssets[goalLevel]['textColor'])
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.asset(
                "${goalAssets[goalLevel]['image']}",
                height: 80,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: AutoSizeText(
                  "$goalName",
                  maxLines: 1,
                  style: TextStyle(
                      color: goalAssets[goalLevel]['textColor'],
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
