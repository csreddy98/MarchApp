import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show ImageFilter;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:intl/intl.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

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
  List<GlobalKey> _keys = [];
  final db = DataBaseHelper();
  WebSocketStatus socketStatus;
  int i = 0;
  @override
  void initState() {
    _load();
    super.initState();

    socketIO = SocketIOManager().createSocketIO(
        'https://glacial-waters-33471.herokuapp.com', '/',
        socketStatusCallback: _socketStatus);
    socketIO.init();
  }

  @override
  void dispose() {
    messageController.dispose();
    _scroller.dispose();
    // socketIO.unSubscribesAll();
    super.dispose();
  }

  _socketStatus(data) {
    print("SOCKET STATUS: $data");
  }

  void loadMessages() {
    db.getMessage(widget.user['user_id']).then((value) {
      for (var item in value) {
        _keys.add(GlobalKey());
      }
      setState(() {
        messages = value;
      });
      Timer(Duration(milliseconds: 500), () {
        if (i == 0) {
          _scroller.animateTo(_scroller.position.maxScrollExtent,
              duration: Duration(microseconds: 200), curve: Curves.bounceInOut);
          i++;
        }
      });
    });
    // if (i == 0) {
    // i++;
    // }
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
        title: Hero(
          tag: "${widget.user['name']}",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                child: Image.file(
                    File.fromUri(Uri.file(widget.user['profile_pic'])),
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10.0),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.user['name'],
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 20.0),
                        textAlign: TextAlign.start,
                      ),
                      // Text(
                      //   "${widget.user['profession']}",
                      //   style: TextStyle(color: Colors.grey, fontSize: 15.0),
                      //   textAlign: TextAlign.start,
                      // )
                    ]),
              )
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: (messages == null)
                  ? Center(child: Text("No Messages"))
                  : ListView.builder(
                      addRepaintBoundaries: false,
                      itemCount: messages.length,
                      controller: _scroller,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (BuildContext context, int index) {
                        return (messages[index]['sentBy'] != this.myId)
                            ? message('left', '${messages[index]['message']}',
                                messages[index]['time'], index)
                            : message('right', "${messages[index]['message']}",
                                messages[index]['time'], index);
                      }),
            ),
            Container(
              // margin: EdgeInsets.all(15.0),
              height: 61,
              // color: Colors.grey,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(35.0),
                  color: Colors.transparent),
              child: Row(
                children: [
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
                                Timer(Duration(milliseconds: 500), () {
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
                    padding: const EdgeInsets.all(12.0),
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
                        var msgCode = UniqueKey();
                        if (text != "") {
                          db.addMessage({
                            DataBaseHelper.messageCode: "$msgCode",
                            DataBaseHelper.messageSentBy: this.myId,
                            DataBaseHelper.messageOtherId:
                                widget.user['user_id'],
                            DataBaseHelper.messageText: text,
                            DataBaseHelper.messageContainsImage: '0',
                            DataBaseHelper.messageImage: "none",
                            DataBaseHelper.messageTransportStatus: "pending",
                            DataBaseHelper.messageTime: '${DateTime.now()}',
                          });
                          db.updateLastMessage({
                            'message': "you: $text",
                            'messageTime': "${DateTime.now()}",
                            'otherId': widget.user['user_id']
                          });
                          sendMessage({
                            'text': text,
                            'msgCode': msgCode,
                          }, context);
                          _scroller.animateTo(
                              _scroller.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.bounceInOut);
                        }
                      },
                      onDoubleTap: () async {
                        final text = messageController.text;
                        messageController.clear();
                        var msgCode = UniqueKey();
                        if (text != "") {
                          db.addMessage({
                            DataBaseHelper.messageCode: "$msgCode",
                            DataBaseHelper.messageSentBy: this.myId,
                            DataBaseHelper.messageOtherId:
                                widget.user['user_id'],
                            DataBaseHelper.messageText: text,
                            DataBaseHelper.messageContainsImage: '0',
                            DataBaseHelper.messageImage: "none",
                            DataBaseHelper.messageTransportStatus: "pending",
                            DataBaseHelper.messageTime: '${DateTime.now()}',
                          });
                          db.updateLastMessage({
                            'message': "you: $text",
                            'messageTime': "${DateTime.now()}",
                            'otherId': widget.user['user_id']
                          });
                          sendMessage({
                            'text': text,
                            'msgCode': msgCode,
                          }, context);
                          _scroller.animateTo(
                              _scroller.position.maxScrollExtent,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.bounceInOut);
                        }
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

  sendMessage(Map msgInfo, context) async {
    print("SENDING MESSAGE");
    http.post("https://march.lbits.co/api/worker.php",
        body: json.encode({
          'serviceName': 'generatetoken',
          'work': 'add message',
          'msgCode': '${msgInfo['msgCode']}',
          'receiver': widget.user['user_id'],
          'sender': this.myId,
          'message': msgInfo['text'],
          'containsImage': 'false',
          'imageUrl': 'none',
          'messageTime': '${DateTime.now()}'
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }).then((value) {
      var resp = json.decode(value.body);
      print("Response: $resp");
      if (resp['response'] == 200) {
        socketIO.sendMessage(
            'send message',
            json.encode({
              "msgCode": "${msgInfo['msgCode']}",
              "message": msgInfo['text'],
              "sender": this.myId,
              "receiver": widget.user['user_id'],
              "containsImage": "0",
              "imageUrl": "none",
              "time": '${DateTime.now()}',
            }));
        db.updateTransportStatus(
            {'msgCode': msgInfo['msgCode'], 'status': "success"});
      } else {
        db.updateTransportStatus(
            {'msgCode': msgInfo['msgCode'], 'status': "failed"});
        Toast.show('Network Error', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    }).catchError((e) {
      db.updateTransportStatus(
          {'msgCode': msgInfo['msgCode'], 'status': "failed"});
    });
  }

  Widget message(String direction, String message, String time, int index) {
    if (messages[index]['msgCode'] == null) {
      print("NULL $message");
    }
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: (direction == 'right')
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            GestureDetector(
              onDoubleTap: () {
                final RenderBox renderBox =
                    _keys[index].currentContext.findRenderObject();
                final boxSize = renderBox.localToGlobal(Offset.zero);
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    return Scaffold(
                        backgroundColor: Colors.transparent,
                        floatingActionButton: FloatingActionButton(
                          onPressed: () => Navigator.pop(context),
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.close),
                        ),
                        body: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                        top: ((MediaQuery.of(context)
                                                        .size
                                                        .height -
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        3.5)) >
                                                boxSize.dy)
                                            ? boxSize.dy
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height -
                                                (MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    2.3),
                                        left: (boxSize.dx < 20)
                                            ? boxSize.dx + 20
                                            : (boxSize.dx >
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width -
                                                        40)
                                                ? boxSize.dx - 40
                                                : boxSize.dx - 50,
                                        child: Hero(
                                          tag: '$index',
                                          child: Container(
                                              child: Column(
                                            children: <Widget>[
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height /
                                                            3,
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.75),
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                decoration: BoxDecoration(
                                                  color: direction == 'right'
                                                      ? Theme.of(context)
                                                          .primaryColor
                                                      : Color(0xFFeeeeee),
                                                  borderRadius: (direction ==
                                                          'right')
                                                      ? BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                        )
                                                      : BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10),
                                                        ),
                                                ),
                                                child: Text(
                                                  "${messages[index]['message']}",
                                                  style: TextStyle(
                                                      color:
                                                          direction == 'right'
                                                              ? Colors.white
                                                              : Colors.black),
                                                ),
                                              ),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8.0))),
                                                  child: Column(
                                                    children: <Widget>[
                                                      messages[index][
                                                                  'msgTransportStatus'] ==
                                                              "failed"
                                                          ? actionButtons(
                                                              'Retry', () {
                                                              print("Retrying");
                                                              sendMessage({
                                                                'msgCode':
                                                                    "${messages[index]['msgCode']}",
                                                                'text':
                                                                    "$message",
                                                              }, context);
                                                              Navigator.pop(
                                                                  context);
                                                              Toast.show(
                                                                  'Attempting to Send Again',
                                                                  context,
                                                                  duration: Toast
                                                                      .LENGTH_SHORT,
                                                                  gravity: Toast
                                                                      .BOTTOM);
                                                            })
                                                          : Container(),
                                                      actionButtons('Copy', () {
                                                        Clipboard.setData(
                                                            new ClipboardData(
                                                                text:
                                                                    '${messages[index]['message']}'));
                                                        Navigator.pop(context);
                                                        Toast.show(
                                                            'Coppied', context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      }),
                                                      actionButtons(
                                                          'Share', null),
                                                      actionButtons('Delete',
                                                          () {
                                                        if (messages.length -
                                                                1 ==
                                                            index) {
                                                          db.updateLastMessage({
                                                            'message':
                                                                "${messages[index - 1]['message']}",
                                                            'messageTime':
                                                                '${DateTime.now()}',
                                                            'otherId': widget
                                                                .user['user_id']
                                                          });
                                                          Toast.show('cleared',
                                                              context,
                                                              duration: Toast
                                                                  .LENGTH_SHORT,
                                                              gravity:
                                                                  Toast.BOTTOM);
                                                        }
                                                        db.deleteMessage(messages[
                                                                index][
                                                            '${db.messageId}']);
                                                        Navigator.pop(context);
                                                      })
                                                    ],
                                                  ))
                                            ],
                                          )),
                                        ))
                                  ],
                                ),
                              ),
                            )));
                  },
                );
              },
              child: Column(
                crossAxisAlignment: (direction == 'right')
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: '$index',
                    child: Container(
                      key: _keys[index],
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * .75),
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: direction == 'right'
                            ? (messages[index]['msgTransportStatus'] ==
                                    'failed')
                                ? Colors.red
                                : Theme.of(context).primaryColor
                            : Color(0x22161F3D),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        "$message",
                        style: TextStyle(
                            color: direction == 'right'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: (direction == 'right')
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "${DateFormat('kk:mm').format((DateTime.parse(time)))}",
                          style: TextStyle(color: Colors.grey)),
                      // SizedBox(width: 10.0),
                      // Icon(
                      //   Icons.done_all,
                      //   size: 20.0,
                      // ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
      ],
    );
  }

  Widget actionButtons(String name, Function onPress) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Text(
          name,
          style: TextStyle(color: Colors.white),
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
    socketIO.sendMessage('update my status',
        json.encode({"uid": "$myId", "time": "${DateTime.now()}"}));
  }
}
