import 'dart:convert';
// import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:march/ui/ChatScreen.dart';
import 'package:http/http.dart' as http;
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:intl/intl.dart';

class MessagesScreen extends StatefulWidget {
  final String screenState;
  MessagesScreen(this.screenState);
  @override
  _MessagesScreenState createState() => _MessagesScreenState(this.screenState);
}

class _MessagesScreenState extends State<MessagesScreen> {
  int selectedIndex;
  List<String> categories = ['Chats', 'Requests'];
  bool chats;
  String token, myId, uid;
  final String screenState;
  _MessagesScreenState(this.screenState);
  List newReqs = [];
  List accepted = [];
  DataBaseHelper db = DataBaseHelper();
  List lastMessages = [];
  // List pending = [];
  @override
  void initState() {
    _load();
    super.initState();
    // setState(() {
    //   (widget.screenState == 'requests') ? chats = false : chats = true;
    // });
    chats = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
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
                  color:
                      (chats == true) ? Color(0xFFFCFCFC) : Color(0xFFE2E3ED),
                  // shape: RoundedRectangleBorder(side: BorderSide(width: 1.0)),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      chats = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Center(child: Text("Requests")),
                    width: 120.0,
                  ),
                  color:
                      (chats == false) ? Color(0xFFFCFCFC) : Color(0xFFE2E3ED),
                  // shape: RoundedRectangleBorder(side: BorderSide(width: 1.0)),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: FutureBuilder(
                  future: http.post("https://march.lbits.co/api/worker.php",
                      body: json.encode({
                        'work': 'get my requests',
                        'uid': '$uid',
                        'id': '$myId'
                      }),
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token'
                      }),
                  builder: (_, snapshot) {
                    if (snapshot.data != null) {
                      var data = json.decode(snapshot.data.body);
                      if (data['response'] == 200) {
                        List pending = data['result']['pending'];
                        List accepted = data['result']['accepted'];
                        return chats == true
                            ? accepted.length > 0
                                ? recentChats(accepted)
                                : Center(
                                    child: Text(
                                        "Oops... Seems like you haven't texted anyone yet"),
                                  )
                            : pending.length == 0
                                ? Center(
                                    child: Text(
                                        "Seems like nobody has sent you a Request"),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: pending.length,
                                    itemBuilder: (con, i) {
                                      List goals = pending[i]['goals'];
                                      var goalString = StringBuffer();
                                      List goalsList = [];
                                      goals.forEach((element) {
                                        goalsList.add(element['goal']);
                                      });
                                      goalString.writeAll(goalsList, ', ');
                                      return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            child: Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: ClipRRect(
                                                    child: Image.network(
                                                        pending[i]['user_info']
                                                            ['profile_pic'],
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            4.5,
                                                        // height: MediaQuery.of(_).size.height,
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    RichText(
                                                      text: TextSpan(
                                                          text: "Name: ",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 19),
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "${pending[i]['user_info']['fullName']}",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                ))
                                                          ]),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                          text: "Age: ",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 19),
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "${pending[i]['user_info']['age']}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black))
                                                          ]),
                                                    ),
                                                    RichText(
                                                      text: TextSpan(
                                                          text: "Goals: ",
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor,
                                                              fontSize: 19),
                                                          children: [
                                                            TextSpan(
                                                                text:
                                                                    "$goalString",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black)),
                                                          ]),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    InkWell(
                                                      child: Container(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  5.0),
                                                          child: Text(
                                                            "Show Message",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 3,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            child: AlertDialog(
                                                              title: Text(
                                                                  "${pending[i]['user_info']['fullName']}"),
                                                              content: Text(
                                                                  "${pending[i]['user_info']['message']}"),
                                                              actions: <Widget>[
                                                                RaisedButton(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                  child: Text(
                                                                      "Back"),
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context),
                                                                )
                                                              ],
                                                            ));
                                                      },
                                                    ),
                                                    Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 10.0),
                                                      child: Row(
                                                        children: <Widget>[
                                                          InkWell(
                                                            onTap: () async {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  child: AlertDialog(
                                                                      title: Text("Adding User"),
                                                                      content: Row(
                                                                        children: <
                                                                            Widget>[
                                                                          CircularProgressIndicator(),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text("Please wait"),
                                                                          )
                                                                        ],
                                                                      )));
                                                              await http.post(
                                                                  'https://march.lbits.co/api/worker.php',
                                                                  body: json.encode({
                                                                    'work':
                                                                        "accept request",
                                                                    'sender': pending[i]
                                                                            [
                                                                            'user_info']
                                                                        [
                                                                        'sender_id'],
                                                                    'receiver': pending[i]
                                                                            [
                                                                            'user_info']
                                                                        [
                                                                        'receiver_id']
                                                                  }),
                                                                  headers: {
                                                                    'Content-Type':
                                                                        'application/json',
                                                                    'Authorization':
                                                                        'Bearer $token'
                                                                  }).then(
                                                                  (value) {
                                                                var resp = json
                                                                    .decode(value
                                                                        .body);
                                                                if (resp[
                                                                        'response'] ==
                                                                    200) {
                                                                  setState(() {
                                                                    pending
                                                                        .removeAt(
                                                                            i);
                                                                    chats =
                                                                        true;
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          15),
                                                                  child: Text(
                                                                    "Accept",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )),
                                                            // color: Theme.of(context).primaryColor,
                                                          ),
                                                          SizedBox(width: 40),
                                                          InkWell(
                                                            onTap: () async {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  child: AlertDialog(
                                                                      title: Text("Adding User"),
                                                                      content: Row(
                                                                        children: <
                                                                            Widget>[
                                                                          CircularProgressIndicator(),
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Text("Please wait"),
                                                                          )
                                                                        ],
                                                                      )));
                                                              await http.post(
                                                                  'https://march.lbits.co/api/worker.php',
                                                                  body: json.encode({
                                                                    'work':
                                                                        "reject request",
                                                                    'sender': pending[i]
                                                                            [
                                                                            'user_info']
                                                                        [
                                                                        'sender_id'],
                                                                    'receiver': pending[i]
                                                                            [
                                                                            'user_info']
                                                                        [
                                                                        'receiver_id']
                                                                  }),
                                                                  headers: {
                                                                    'Content-Type':
                                                                        'application/json',
                                                                    'Authorization':
                                                                        'Bearer $token'
                                                                  }).then(
                                                                  (value) {
                                                                var resp = json
                                                                    .decode(value
                                                                        .body);
                                                                if (resp[
                                                                        'response'] ==
                                                                    200) {
                                                                  setState(() {
                                                                    pending
                                                                        .removeAt(
                                                                            i);
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              });
                                                            },
                                                            child: Container(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          15),
                                                                  child: Text(
                                                                    "Reject",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                )),
                                                            // color: Theme.of(context).primaryColor,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ));
                                    });
                      } else {
                        return Center(
                          child: Text("Token Error"),
                        );
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget recentChats(List usersList) {
    _getLastMessages();
    if (usersList.isNotEmpty) {
      // String lastMessage;
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView.builder(
            itemCount: usersList.length,
            itemBuilder: (BuildContext context, int index) {
              return Slidable(
                key: ValueKey(index),
                closeOnScroll: true,
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Clear',
                    color: Color(0xFFA8B2C8),
                    icon: Icons.edit,
                    closeOnTap: true,
                    foregroundColor: Colors.white,
                    onTap: () {
                      Toast.show('cleared', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    },
                  ),
                  IconSlideAction(
                    caption: 'Delete',
                    color: Color(0xFFFF3B30),
                    icon: Icons.delete,
                    closeOnTap: true,
                    onTap: () {
                      Toast.show('Deleted', context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    },
                  ),
                ],
                child: GestureDetector(
                  onTap: () =>
                      Navigator.push(context, _createRoute(usersList[index])),
                  child: Container(
                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              child: Image.network(
                                  usersList[index]['profile_pic'],
                                  height: 55,
                                  width: 55,
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  usersList[index]['fullName'],
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(height: 5.0),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                  child: Text(
                                    '${(lastMessages.isNotEmpty) ? lastMessages[index]['message'] : 'None'}',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w200,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              "${lastMessages.isNotEmpty ? durationCalculator(lastMessages[index]['time']) : ""}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Center(
        child: Text("loading"),
      );
    }
  }

  String durationCalculator(String pastDate) {
    DateTime newDate =
        DateTime.parse(pastDate);
    var diff = newDate.difference(
        DateTime.now());
    String output = "";
    if (diff.inDays > 0) {
      if (diff.inDays > 7) {
        output = "${DateFormat('dd/MM/yy').format(newDate)}";
      } else if (diff.inDays == 1) {
        output = "yesterday";
      } else {
        output = "${DateFormat('EEEE').format(newDate)}";
      }
    } else if (diff.inHours > 0) {
      output = "${diff.inHours}h";
    } else if (diff.inMinutes > 0) {
      output = "${diff.inMinutes}m";
    } else if (diff.inSeconds > 0) {
      output = "now";
    }
    return output;
  }

  Route _createRoute(Map userMap) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TextingScreen(
        user: userMap,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(10.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  _getLastMessages() {
    db.getLastMessage().then((value) {
      // print("${value}");
      setState(() {
        this.lastMessages = value;
      });
    });
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      myId = prefs.getString('id');
      uid = prefs.getString('uid');
    });
    prefs.setInt('log', 1);
    FirebaseAuth.instance.currentUser().then((val) async {
      String uid = val.uid;
      prefs.setString('uid', uid);
    });
  }
}
