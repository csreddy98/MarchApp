import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TextingScreen extends StatefulWidget {
  final Map user;
  TextingScreen({this.user});

  @override
  _TextingScreenState createState() => _TextingScreenState();
}

class _TextingScreenState extends State<TextingScreen> {
  ScrollController _scroller = ScrollController();
  TextEditingController messageController = new TextEditingController();
  SocketIO socketIO;
  List messages = [];
  String myId, token, uid;
  final db = DataBaseHelper();

  @override
  void initState() {
    _load();
    socketIO = SocketIOManager().createSocketIO(
      'https://glacial-waters-33471.herokuapp.com',
      '/',
    );
    socketIO.init();
    socketIO.subscribe('new message', (jsonData) {
      var data = json.decode(jsonData);
      if (data['sender'].toString() == myId ||
          data['receiver'].toString() == myId) {
        // loadMessages();
        print('$data');
        Map newMessage = <String, String>{
          DataBaseHelper.messageOtherId: data['sender'] != myId ? data['sender'] : data['receiver'],
          DataBaseHelper.messageSentBy: data['sender'],
          DataBaseHelper.messageText: data['message'],
          DataBaseHelper.messageContainsImage: '0',
          DataBaseHelper.messageImage: "null",
          DataBaseHelper.messageTime: data['time']
        };
        db.addMessage(newMessage);
        // setState(() {
        //   messages.add(data);
        // });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    _scroller.dispose();
    super.dispose();
  }

  void loadMessages() {
    db.getMessage(widget.user['id']).then((value) {
      messages.clear();
      setState(() {
        messages.addAll(value);
      });
      print("Messages: $messages");
      // _scroller.animateTo(_scroller.position.maxScrollExtent,
      // duration: Duration(microseconds: 500), curve: Curves.easeOut);
      _scroller.jumpTo(_scroller.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    loadMessages();
    return Scaffold(
      backgroundColor: Color(0xFFFBFCFE),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: FlatButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).primaryColor,
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              child: Image.network("${widget.user['profile_pic']}",
                  height: 50, width: 50, fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10.0),
            ),
            SizedBox(width: 10),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.user['fullName'],
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 20.0),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    "online",
                    style: TextStyle(color: Colors.grey, fontSize: 15.0),
                    textAlign: TextAlign.start,
                  )
                ])
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: (messages == null)
                  ? Center(child: Text(""))
                  : ListView.builder(
                      addRepaintBoundaries: false,
                      itemCount: messages.length,
                      controller: _scroller,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return (messages[index]['otherId'] == this.myId)
                            ? Column(
                                children: <Widget>[
                                  Row(
                                    children: [
                                      SizedBox(width: 5.0),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .6),
                                            padding: const EdgeInsets.all(15.0),
                                            decoration: BoxDecoration(
                                              color: Color(0x22161F3D),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              "${messages[index]['message']}",
                                              style: TextStyle(
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              SizedBox(width: 10.0),
                                              Text("9:45",
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 15),
                                    ],
                                  ),
                                  SizedBox(height: 15.0)
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .6),
                                            padding: const EdgeInsets.all(15.0),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                            ),
                                            child: Text(
                                              "${messages[index]['message']}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Text("9:45",
                                                  style: TextStyle(
                                                      color: Colors.grey)),
                                              SizedBox(width: 10.0),
                                              Icon(
                                                Icons.done_all,
                                                size: 20.0,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(width: 5),
                                    ],
                                  ),
                                ],
                              );
                      }),
            ),
            Container(
              // margin: EdgeInsets.all(15.0),
              height: 61,
              // color: Colors.grey,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(35.0),
                  color: Color(0xFFCFCFCF)),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(11.0),
                    decoration: BoxDecoration(
                        color: Colors.transparent, shape: BoxShape.circle),
                    child: InkWell(
                      child: Icon(
                        Icons.add,
                        size: 35.0,
                        color: Colors.white,
                      ),
                      onTap: () {},
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35.0),
                        boxShadow: [
                          BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 5,
                              color: Colors.grey)
                        ],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20.0,
                          ),
                          Expanded(
                            child: TextField(
                              onTap: () {
                                Timer(Duration(milliseconds: 300), () {
                                  _scroller.jumpTo(
                                      _scroller.position.maxScrollExtent);
                                });
                              },
                              controller: messageController,
                              decoration: InputDecoration(
                                  hintText: "Type Something...",
                                  border: InputBorder.none),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                        color: Color(0xFF3F5CC8), shape: BoxShape.circle),
                    child: InkWell(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onTap: () async {
                        final text = messageController.text;
                        messageController.clear();
                        // socketIO.sendMessage(
                        //     "chat message",
                        //     json.encode(<String, dynamic>{
                        //       "message": text,
                        //       "sender": this.myId,
                        //       "receiver": widget.user['id'],
                        //       "time": '${DateTime.now()}'
                        //     }));
                        socketIO.sendMessage(
                            'chat message',
                            json.encode({
                              "message": text,
                              "sender": this.myId,
                              "receiver": widget.user['id'],
                              "time": '${DateTime.now()}'
                            }));

                        // int sentId = await rootBundle
                        //     .load("assets/audios/open-up.mp3")
                        //     .then((ByteData soundData) {
                        //   return pool.load(soundData);
                        // });
                        // int streamSentId = await pool.play(sentId);

                        // print("$streamSentId");
                      },
                      onDoubleTap: () async {
                        final text = messageController.text;
                        messageController.clear();
                        socketIO.sendMessage(
                            "chat message",
                            jsonEncode(<String, dynamic>{
                              "message": text,
                              "myId": this.myId,
                              "otherId": widget.user['id'],
                              "sentBy": this.myId
                            }));

                        // int sentId = await rootBundle
                        //     .load("assets/audios/open-up.mp3")
                        //     .then((ByteData soundData) {
                        //   return pool.load(soundData);
                        // });
                        // int streamSentId = await pool.play(sentId);

                        // print("$streamSentId");
                      },
                    ),
                  ),
                  SizedBox(width: 10.0)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    myId = prefs.getString('id');
    uid = prefs.getString('uid');
    prefs.setInt('log', 1);
    if (uid == null) {
      FirebaseAuth.instance.currentUser().then((val) async {
        String uid = val.uid;
        prefs.setString('uid', uid);
      });
    }
  }
}
