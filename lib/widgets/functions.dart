import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget testimonial(context, String image, String name, String description) {
  return Container(
      // height: 100,
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

Widget goalCardGenerator(context, String goalName, int goalLevel) {
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
  Size size = MediaQuery.of(context).size;
  print(size.width * 0.26);
  return SizedBox(
    width: size.width * 0.26,
    child: Card(
      elevation: 10,
      child: Container(
        height: 130,
        width: size.width * 0.26,
        decoration: BoxDecoration(
          color: goalAssets[goalLevel]['bgColor'],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                "${goalAssets[goalLevel]['image']}",
                height: 75,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: AutoSizeText(
                  "$goalName",
                  maxLines: 2,
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
    ),
  );
}
