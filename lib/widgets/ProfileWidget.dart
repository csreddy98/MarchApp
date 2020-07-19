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
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          width: size.width / 4,
          height: size.width / 4,
          decoration: BoxDecoration(
              // border: Border.all(width: 5, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: "$picUrl",
                fit: BoxFit.cover,
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "$name",
            style: TextStyle(fontSize: size.height / 38,fontWeight: FontWeight.w600),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            "$profession",
            style: TextStyle(
                fontSize: size.height / 45,
                fontFamily: 'montserrat',
                fontWeight: FontWeight.w500),
          ),
        ),
        (location != null)
            ? Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.location_on, size: 15,),
                    Text(
                      "$location",
                      style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontFamily: 'montserrat',
                          fontSize: size.height / 48),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
