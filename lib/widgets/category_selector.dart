import 'package:flutter/material.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex;
  List<String> categories = ['Chats', 'Requests'];
  bool chats;

  @override
  void initState() {
    // selectedIndex = 0;
    chats = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 310.0,
      // decoration: BoxDecoration(boxShadow: [
      //   BoxShadow(
      //       color: Color(0xffe0e0e0), spreadRadius: 1.0, blurRadius: 15.0),
      // ]),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() {
                chats = true;
              });
            },
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Center(child: Text("Chats")),
              width: 120.0,
            ),
            color: (chats == true) ? Color(0xFFFFFFFF) : Color(0xFFE2E3ED),
            // shape: RoundedRectangleBorder(side: BorderSide(width: 1.0)),
          ),
          FlatButton(
            onPressed: () {
              chats = false;
            },
            child: Container(
              padding: EdgeInsets.all(15.0),
              child: Center(child: Text("Requests")),
              width: 120.0,
            ),
            color: (chats == false) ? Color(0xFFFFFFFF) : Color(0xFFE2E3ED),
            // shape: RoundedRectangleBorder(side: BorderSide(width: 1.0)),
          )
        ],
      ),
    );
  }
}
