import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileTop extends StatelessWidget {
  ProfileTop(
      {@required this.name,
      @required this.picUrl,
      @required this.profession,
      this.location});
  final String name;
  final String picUrl;
  final String profession;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
              border: Border.all(width: 5, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: "$picUrl",
                fit: BoxFit.cover,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "$name",
            style: TextStyle(fontSize: 18, fontFamily: 'montserrat'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            "$profession",
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'montserrat',
                fontWeight: FontWeight.normal),
          ),
        ),
        (location != null)
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on),
                    Text(
                      "$location",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontFamily: 'montserrat',
                          fontSize: 13),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
