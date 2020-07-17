import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:intl/intl.dart';
import 'package:march/support/Api/api.dart';
import 'package:march/utils/database_helper.dart';
import 'dart:ui' show ImageFilter;

import 'package:toast/toast.dart';

// ignore: must_be_immutable
class MessageBubble extends StatelessWidget {
  final String direction, message, time, userId, myId;
  final int index;
  final List messages, messageKeys;
  final BuildContext mainContext;
  MessageBubble(
      {Key key,
      @required this.direction,
      @required this.message,
      @required this.time,
      @required this.index,
      @required this.messages,
      @required this.messageKeys,
      @required this.mainContext,
      @required this.userId,
      @required this.myId})
      : super(key: key) {
    socketIO = SocketIOManager()
        .createSocketIO('https://glacial-waters-33471.herokuapp.com', '/');
    socketIO.init();
  }

  DataBaseHelper db = DataBaseHelper();
  SocketIO socketIO;
  Api api = Api();
  @override
  Widget build(BuildContext context) {
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
                    messageKeys[this.index].currentContext.findRenderObject();
                final boxSize = renderBox.localToGlobal(Offset.zero);
                showDialog(
                  barrierDismissible: true,
                  context: mainContext,
                  builder: (mainContext) {
                    return Scaffold(
                        backgroundColor: Colors.transparent,
                        floatingActionButton: FloatingActionButton(
                          onPressed: () => Navigator.pop(mainContext),
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(Icons.close),
                        ),
                        body: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Container(
                                width: MediaQuery.of(mainContext).size.width,
                                height: MediaQuery.of(mainContext).size.height,
                                child: Stack(
                                  children: <Widget>[
                                    Positioned(
                                        top: ((MediaQuery.of(mainContext)
                                                        .size
                                                        .height -
                                                    (MediaQuery.of(mainContext)
                                                            .size
                                                            .height /
                                                        3.5)) >
                                                boxSize.dy)
                                            ? boxSize.dy
                                            : MediaQuery.of(mainContext)
                                                    .size
                                                    .height -
                                                (MediaQuery.of(mainContext)
                                                        .size
                                                        .height /
                                                    2.3),
                                        left: (boxSize.dx < 20)
                                            ? boxSize.dx + 20
                                            : (boxSize.dx >
                                                    MediaQuery.of(mainContext)
                                                            .size
                                                            .width -
                                                        40)
                                                ? boxSize.dx - 40
                                                : boxSize.dx - 50,
                                        child: Container(
                                            child: Column(
                                          children: <Widget>[
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(mainContext)
                                                              .size
                                                              .height /
                                                          3,
                                                  maxWidth:
                                                      MediaQuery.of(mainContext)
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
                                                            Radius.circular(10),
                                                        topLeft:
                                                            Radius.circular(10),
                                                        topRight:
                                                            Radius.circular(10),
                                                      )
                                                    : BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(10),
                                                        bottomLeft:
                                                            Radius.circular(10),
                                                        bottomRight:
                                                            Radius.circular(10),
                                                      ),
                                              ),
                                              child: Text(
                                                "${messages[this.index]['message']}",
                                                style: TextStyle(
                                                    color: direction == 'right'
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
                                                    messages[this.index][
                                                                'msgTransportStatus'] ==
                                                            "failed"
                                                        ? actionButtons('Retry',
                                                            () {
                                                            print("Retrying");
                                                            sendMessage({
                                                              'msgCode':
                                                                  "${messages[this.index]['msgCode']}",
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
                                                                  '${messages[this.index]['message']}'));
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
                                                    actionButtons('Delete', () {
                                                      if (messages.length - 1 ==
                                                          this.index) {
                                                        db.updateLastMessage({
                                                          'message':
                                                              "${messages[this.index - 1]['message']}",
                                                          'messageTime':
                                                              '${DateTime.now()}',
                                                          'otherId': this.userId
                                                        });
                                                        Toast.show(
                                                            'cleared', context,
                                                            duration: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                Toast.BOTTOM);
                                                      }
                                                      db.deleteMessage(messages[
                                                              this.index]
                                                          ['${db.messageId}']);
                                                      Navigator.pop(context);
                                                    })
                                                  ],
                                                ))
                                          ],
                                        )))
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
                  CustomCard(
                    message: message,
                    time: this.time,
                    messages: this.messages,
                    messageKeys: this.messageKeys,
                    index: this.index,
                    direction: this.direction,
                  )
                  // Row(
                  //   mainAxisAlignment: (direction == 'right')
                  //       ? MainAxisAlignment.end
                  //       : MainAxisAlignment.start,
                  //   children: <Widget>[
                  //     // SizedBox(width: 10.0),
                  //     // Icon(
                  //     //   Icons.done_all,
                  //     //   size: 20.0,
                  //     // ),
                  //   ],
                  // )
                ],
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
      ],
    );
  }

  sendMessage(Map msgInfo, context) async {
    print("SENDING MESSAGE");
    api.sendMessage({
      'serviceName': 'generatetoken',
      'work': 'add message',
      'msgCode': '${msgInfo['msgCode']}',
      'receiver': '$userId',
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
              "receiver": '$userId',
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
}

class CustomCard extends StatelessWidget {
  final String message, direction, time;
  final List messageKeys, messages;
  final int index;

  CustomCard(
      {@required this.message,
      this.direction,
      this.time,
      this.messageKeys,
      this.messages,
      this.index});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: '${this.index}',
      child: Container(
        key: messageKeys[this.index],
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: direction == 'right'
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  )
                : BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
          ),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * .75),
            padding: const EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: direction == 'right'
                  ? (messages[this.index]['msgTransportStatus'] == 'failed')
                      ? Colors.red
                      : Color(0xffFFBF46)
                  : Color(0x22161F3D),
              borderRadius: direction == 'right'
                  ? BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    )
                  : BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
            ),
            child: Wrap(
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: <Widget>[
                Text(
                  "$message",
                  style: TextStyle(
                      color:
                          direction == 'right' ? Colors.black : Colors.black),
                ),
                SizedBox(
                  width: 40,
                ),
                Text("${DateFormat('kk:mm').format((DateTime.parse(time)))}",
                    style: TextStyle(
                        color:
                            direction == 'right' ? Colors.black : Colors.black,
                        fontSize: 12))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
