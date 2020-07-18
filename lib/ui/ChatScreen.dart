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
import 'package:march/support/Api/api.dart';
import 'package:march/ui/profileScreen.dart';
import 'package:march/utils/database_helper.dart';
import 'package:march/widgets/MessageWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

import 'home.dart';

class TextingScreen extends StatefulWidget {
  final Map user;
  TextingScreen({this.user});

  @override
  _TextingScreenState createState() => _TextingScreenState();
}
enum Choose{
  block
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
  int msgCount = 0;
  String remoteStatus = "done";
  bool checkStatus = true;
  Api api = Api();
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
          _scroller.jumpTo(_scroller.position.maxScrollExtent);
          i++;
        }
      });
    }).then((value) {
      db.markAsSeen(widget.user['user_id']);
    });
    if (messages.length > 10 && checkStatus) {
      http.post("https://march.lbits.co/api/worker.php",
          body: json.encode({
            'serviceName': '',
            'work': 'check testimonial status',
            'writtenBy': '$myId',
            'writtenTo': '${widget.user['user_id']}'
          }),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          }).then((value) {
        var jsonResp = json.decode(value.body);
        print(jsonResp);
        if (jsonResp['result'] == 'pending') {
          setState(() {
            remoteStatus = 'pending';
            checkStatus = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadMessages();

    Choose _selection;

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
          Theme(
            data:ThemeData(primaryColor: Colors.black),
            child: PopupMenuButton<Choose>(
              onSelected: (Choose choose) async {
                if(choose.index==0){

                  print(myId);
                  print(widget.user['user_id']);
                  var url =
                      'https://march.lbits.co/api/worker.php';
                  var resp = await http.post(
                    url,
                    headers: {
                      'Content-Type': 'application/json',
                      'Authorization': 'Bearer $token'
                    },
                    body: json.encode(<String, dynamic>{
                      'serviceName': "",
                      'work': "block user",
                      'myId': myId,
                      'otherId': widget.user['user_id'],
                    }),
                  );

                  print("res " + resp.body.toString());

                  var result = json.decode(resp.body);
                  if (result['response'] == 200) {

                    await db.deleteSingleUser(widget.user['user_id']);

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home('block user')),
                            (Route<dynamic> route) => false);

                  }

                  }
                setState(() {
                 _selection=choose;
               });
              },
              itemBuilder: (BuildContext context)=><PopupMenuEntry<Choose>>[
                const PopupMenuItem<Choose>(
                    value: Choose.block,
                    child: Text('Block User'))
              ],
            ),
          )
        ],
        title: Row(
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
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ProfileScreen(
                                fromNetwork: true,
                                userId: widget.user['user_id'],
                              )));
                },
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
              ),
            )
          ],
        ),
      ),
      floatingActionButton: (remoteStatus == 'done')
          ? null
          : FloatingActionButton(
              child: Icon(Icons.edit),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                var contentController = TextEditingController();
                showDialog(
                    barrierDismissible: true,
                    context: context,
                    child: AlertDialog(
                      title: Text(
                          "Write few words about ${widget.user['name'].toString().split(" ")[0]}"),
                      content: TextField(
                        minLines: 4,
                        maxLines: 20,
                        controller: contentController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)))),
                      ),
                      actions: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            String content = contentController.text;
                            contentController.clear();
                            http.post("https://march.lbits.co/api/worker.php",
                                body: json.encode({
                                  'serviceName': '',
                                  'work': 'add testimonial',
                                  'writtenBy': '$myId',
                                  'writtenTo': '${widget.user['user_id']}',
                                  'content': '$content'
                                }),
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization': 'Bearer $token'
                                }).then((value) {
                              print(value.body);
                              setState(() {
                                remoteStatus = 'done';
                              });
                            }).catchError((err) => print("ERRRO"));
                            Navigator.pop(context);
                          },
                          child: Text("Add"),
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ));
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: GestureDetector(
        onHorizontalDragStart: (details) {
          print("${details.localPosition.direction}");
          if (details.localPosition.direction > 1.4) {
            Navigator.pop(context);
          }
        },
        child: Padding(
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
                              // ? message('left', '${messages[index]['message']}',
                              //     messages[index]['time'], index)
                              ? MessageBubble(
                                  mainContext: context,
                                  direction: 'left',
                                  message: '${messages[index]['message']}',
                                  messages: messages,
                                  messageKeys: _keys,
                                  myId: this.myId,
                                  userId: widget.user['user_id'],
                                  time: '${messages[index]['time']}',
                                  index: index,
                                )
                              : MessageBubble(
                                  mainContext: context,
                                  direction: 'right',
                                  message: '${messages[index]['message']}',
                                  messages: messages,
                                  messageKeys: _keys,
                                  myId: this.myId,
                                  userId: widget.user['user_id'],
                                  time: '${messages[index]['time']}',
                                  index: index,
                                );
                        }),
              ),
              Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.grey[200]),
                child: Row(
                  children: [
                    SizedBox(width: 10.0),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Row(
                          children: [
                            Flexible(
                              child: new ConstrainedBox(
                                constraints: new BoxConstraints(
                                  minHeight: 25.0,
                                  maxHeight: 135.0,
                                ),
                                child: new Scrollbar(
                                  child: new TextField(
                                    onTap: () {
                                      Timer(Duration(milliseconds: 100), () {
                                        _scroller.jumpTo(
                                            _scroller.position.maxScrollExtent);
                                      });
                                    },
                                    cursorColor: Colors.red,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
                                    controller: messageController,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          top: 2.0,
                                          left: 13.0,
                                          right: 13.0,
                                          bottom: 2.0),
                                      hintText: "Type your message",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
                      fillColor: Theme.of(context).primaryColor,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () async {
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
                          _scroller.jumpTo(
                            _scroller.position.maxScrollExtent,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendMessage(Map msgInfo, context) async {
    print("SENDING MESSAGE");
    api.sendMessage({
      'serviceName': 'generatetoken',
      'work': 'add message',
      'msgCode': '${msgInfo['msgCode']}',
      'receiver': widget.user['user_id'],
      'sender': this.myId,
      'message': msgInfo['text'],
      'containsImage': 'false',
      'imageUrl': 'none',
      'messageTime': '${DateTime.now()}'
    }).then((value) {
      Map resp = value;
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
