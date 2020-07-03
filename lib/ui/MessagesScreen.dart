import 'dart:convert';
import 'dart:io';
import 'dart:ui' show ImageFilter;
import 'dart:async';

import 'package:bubble/bubble.dart';
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
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:march/support/functions.dart';

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
  String token, myId, uid, tptext = "";
  final String screenState;
  List newReqs = [];
  List accepted = [];
  // List accepted = [];
  List pending = [];
  DataBaseHelper db = DataBaseHelper();
  List lastMessages = [];
  List msgCount = [];
  SocketIO socketIO;
  // List pending = [];
  _MessagesScreenState(this.screenState) {
    updateLastMessages();
    Timer(Duration(seconds: 1), () {
      setState(() {
        tptext =
            "Oops... Seems like you don't have anyone to talk to.\n Try Connecting.";
      });
    });
  }

  @override
  void initState() {
    _load();
    dataReceiver();
    super.initState();

    socketIO = SocketIOManager().createSocketIO(
        'https://glacial-waters-33471.herokuapp.com', '/',
        socketStatusCallback: _socketStatus);
    socketIO.init();
    chats = true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  _socketStatus(data) {
    print("THIS IS THE SOCKET STATUS: $data");
  }

  updateLastMessages() {
    db.getUsersList().then((value) {
      setState(() {
        lastMessages = value[1];
        msgCount = value[0];
      });
    });
  }

  dataReceiver() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("This is token ${prefs.getString('token')}");
    http.post("https://march.lbits.co/api/worker.php",
        body: json
            .encode({'work': 'get my requests', 'uid': '$uid', 'id': '$myId'}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}'
        }).then((value) {
      var resp = json.decode(value.body);
      // print("This is Response $resp");
      setState(() {
        accepted = resp['result']['accepted'];
        pending = resp['result']['pending'];
      });
      accepted.forEach((element) async {
        db.getSingleUser(element['userId']).then((v) {
          if (v[0]['networkPic'] != element['profile_pic']) {
            print("Updating");
            imageSaver(element['profile_pic']).then((value) {
              db.updateNamePic({
                'userName': '${element['fullName']}',
                'profile_pic': "${value['image']}",
                'small_pic': "${value['small_image']}",
                'networkImage': "${element['profile_pic']}",
                'userId': '${element['userId']}'
              });
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    updateLastMessages();
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
                    child: Center(
                        child: Text("Chats",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))),
                    width: 120.0,
                  ),
                  color:
                      (chats == true) ? Color(0xFFabb7b7) : Color(0xFFdadfe1),
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
                    child: Center(
                        child: Text("Requests",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600))),
                    width: 120.0,
                  ),
                  color:
                      (chats == false) ? Color(0xFFabb7b7) : Color(0xFFdadfe1),
                  // shape: RoundedRectangleBorder(side: BorderSide(width: 1.0)),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
                child: chats == true
                    ? lastMessages.length > 0
                        ? recentChats(lastMessages)
                        : Center(
                            child: Text("$tptext"),
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
                                          padding: const EdgeInsets.all(12.0),
                                          child: ClipRRect(
                                            child: CachedNetworkImage(
                                                imageUrl: pending[i]
                                                        ['user_info']
                                                    ['profile_pic'],
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    4.5,
                                                // height: MediaQuery.of(_).size.height,
                                                fit: BoxFit.cover),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            RichText(
                                              text: TextSpan(
                                                  text: "Name: ",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 19),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "${pending[i]['user_info']['fullName']}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                        ))
                                                  ]),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "Age: ",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 19),
                                                  children: [
                                                    TextSpan(
                                                        text:
                                                            "${pending[i]['user_info']['age']}",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black))
                                                  ]),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                  text: "Goals: ",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 19),
                                                  children: [
                                                    TextSpan(
                                                        text: "$goalString",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black)),
                                                  ]),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            InkWell(
                                              child: Container(
                                                child: Padding(
                                                  padding: EdgeInsets.all(5.0),
                                                  child: Text(
                                                    "Show Message",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    softWrap: true,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
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
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          child: Text("Back"),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                        )
                                                      ],
                                                    ));
                                              },
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.0),
                                              child: Row(
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () async {
                                                      showDialog(
                                                          context: context,
                                                          child: AlertDialog(
                                                              title: Text(
                                                                  "Adding User"),
                                                              content: Row(
                                                                children: <
                                                                    Widget>[
                                                                  CircularProgressIndicator(),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                        "Please wait"),
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
                                                                ['sender_id'],
                                                            'receiver': pending[
                                                                        i][
                                                                    'user_info']
                                                                ['receiver_id']
                                                          }),
                                                          headers: {
                                                            'Content-Type':
                                                                'application/json',
                                                            'Authorization':
                                                                'Bearer $token'
                                                          }).then((value) {
                                                        var resp = json
                                                            .decode(value.body);
                                                        if (resp['response'] ==
                                                            200) {
                                                          imageSaver(pending[i][
                                                                      'user_info']
                                                                  [
                                                                  'profile_pic'])
                                                              .then((value) {
                                                            var addNewUser = {
                                                              DataBaseHelper
                                                                  .friendId: pending[
                                                                          i][
                                                                      'user_info']
                                                                  ['sender_id'],
                                                              DataBaseHelper
                                                                  .friendName: pending[
                                                                          i][
                                                                      'user_info']
                                                                  ['fullName'],
                                                              DataBaseHelper
                                                                  .friendPic: pending[
                                                                          i][
                                                                      'user_info']
                                                                  [
                                                                  'profile_pic'],
                                                              DataBaseHelper
                                                                  .friendLastMessage: pending[
                                                                          i][
                                                                      'user_info']
                                                                  ['message'],
                                                              DataBaseHelper
                                                                      .friendLastMessageTime:
                                                                  '${DateTime.now()}'
                                                            };
                                                            var newMessage = {
                                                              DataBaseHelper
                                                                  .messageText: pending[
                                                                          i][
                                                                      'user_info']
                                                                  ['message'],
                                                              DataBaseHelper
                                                                  .messageOtherId: pending[
                                                                          i][
                                                                      'user_info']
                                                                  ['sender_id'],
                                                              DataBaseHelper
                                                                      .messageImage:
                                                                  "null",
                                                              DataBaseHelper
                                                                      .messageContainsImage:
                                                                  '0',
                                                              DataBaseHelper
                                                                  .messageSentBy: pending[
                                                                          i][
                                                                      'user_info']
                                                                  ['sender_id'],
                                                              DataBaseHelper
                                                                      .seenStatus:
                                                                  '0',
                                                              DataBaseHelper
                                                                      .messageTime:
                                                                  '${DateTime.now()}'
                                                            };
                                                            db.addUser(
                                                                addNewUser);
                                                            db.addMessage(
                                                                newMessage);
                                                          }).then((value) {
                                                            setState(() {
                                                              pending
                                                                  .removeAt(i);
                                                              chats = true;
                                                            });
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10,
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
                                                          context: context,
                                                          child: AlertDialog(
                                                              title: Text(
                                                                  "Rejecting Request"),
                                                              content: Row(
                                                                children: <
                                                                    Widget>[
                                                                  CircularProgressIndicator(),
                                                                  Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child: Text(
                                                                        "Please wait"),
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
                                                                ['sender_id'],
                                                            'receiver': pending[
                                                                        i][
                                                                    'user_info']
                                                                ['receiver_id']
                                                          }),
                                                          headers: {
                                                            'Content-Type':
                                                                'application/json',
                                                            'Authorization':
                                                                'Bearer $token'
                                                          }).then((value) {
                                                        var resp = json
                                                            .decode(value.body);
                                                        if (resp['response'] ==
                                                            200) {
                                                          setState(() {
                                                            pending.removeAt(i);
                                                          });
                                                        }
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                    child: Container(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 10,
                                                                  horizontal:
                                                                      15),
                                                          child: Text(
                                                            "Reject",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                            })),
          ),
        ],
      ),
    );
  }

  Widget recentChats(List usersList) {
    Map unSeenMessages = {};
    msgCount.forEach((element) {
      unSeenMessages['${element['otherId']}'] = element['msgCount'];
    });
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
          itemCount: lastMessages.length,
          itemBuilder: (BuildContext context, int index) {
            // List unSeenMessages;
            // db.getUnseenMessages(lastMessages[index]['user_id']).then((value) {
            //   // print("$value");
            //   // unSeenMessages = value;
            //   setState(() {
            //     unSeenMessages[lastMessages[index]['user_id']] =
            //         value[0]['newMessages'];
            //   });
            // });
            // print("$unSeenMessages");
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
                    showDialog(
                        context: context,
                        barrierDismissible: true,
                        child: new BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: AlertDialog(
                              title: Text("Are you sure?"),
                              content: Text(
                                  "By Clicking on yes you will clear all the messages with this ${lastMessages[index]['name']}."),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("yes"),
                                  onPressed: () {
                                    db
                                        .deletePersonMessages(
                                            lastMessages[index]['user_id'])
                                        .then((value) {
                                      db.updateLastMessage({
                                        'message': "  ",
                                        'messageTime': '${DateTime.now()}',
                                        'otherId': lastMessages[index]
                                            ['user_id']
                                      }).then((value) {
                                        Toast.show('cleared', context,
                                            duration: Toast.LENGTH_SHORT,
                                            gravity: Toast.BOTTOM);
                                      });
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                                FlatButton(
                                  child: Text("No"),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            )));
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
                    Navigator.push(context, _createRoute(lastMessages[index])),
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
                  child: Hero(
                    tag: "${lastMessages[index]['name']}",
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              child: Image.file(
                                  File.fromUri(Uri.file(lastMessages[index]
                                          ['small_pic'] ??
                                      lastMessages[index]['profile_pic'])),
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
                                  lastMessages[index]['name'],
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
                                    '${(lastMessages.isNotEmpty) ? lastMessages[index]['lastMessage'] : ''}',
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
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              // "${lastMessages[index]['LastMessageTime']}",
                              "${durationCalculator(lastMessages[index]['LastMessageTime'])}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            (unSeenMessages[
                                        '${lastMessages[index]['user_id']}'] !=
                                    null)
                                ? Bubble(
                                    child: Text(
                                        " ${(unSeenMessages.isNotEmpty) ? unSeenMessages[lastMessages[index]['user_id']] : "1"} ",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12)),
                                    radius: Radius.circular(50.0),
                                    color: Theme.of(context).primaryColor,
                                    elevation: 0,
                                  )
                                : Container()
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String durationCalculator(String pastDate) {
    DateTime newDate = DateTime.parse(pastDate);
    var diff = DateTime.now().difference(newDate);
    String output = "";
    if (diff.inDays > 0) {
      if (diff.inDays > 4) {
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
    } else {
      output = "${diff.inSeconds}";
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

    socketIO.sendMessage('update my status',
        json.encode({"uid": "$myId", "time": "${DateTime.now()}"}));
  }
}
