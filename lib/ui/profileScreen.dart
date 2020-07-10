import 'package:flutter/material.dart';
import 'package:march/widgets/ProfileWidget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:status_alert/status_alert.dart';
import 'dart:ui' show ImageFilter;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:march/utils/database_helper.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:march/support/functions.dart';
import 'package:march/widgets/functions.dart';

class ProfileScreen extends StatefulWidget {
  final String name;
  final String pic;
  final String bio;
  final String location;
  final String userId;
  final String profession;
  final List goals;
  final List testimonials;

  ProfileScreen(
      {Key key,
      this.name,
      this.pic,
      this.bio,
      this.location,
      this.userId,
      this.profession,
      this.goals,
      this.testimonials})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(
      this.name,
      this.pic,
      this.bio,
      this.location,
      this.userId,
      this.profession,
      this.goals,
      this.testimonials);
}

class _ProfileScreenState extends State<ProfileScreen> {
  final String name;
  final String pic;
  final String bio;
  final String location;
  final String userId;
  final String profession;
  final List goals;
  final List testimonials;
  TextEditingController messageController = TextEditingController();
  SocketIO socketIO;
  String token, id, uid;
  bool showButton = true;
  DataBaseHelper db = DataBaseHelper();

  _ProfileScreenState(this.name, this.pic, this.bio, this.location, this.userId,
      this.profession, this.goals, this.testimonials);

  @override
  void initState() {
    _load();
    socketIO = SocketIOManager().createSocketIO(
      'https://glacial-waters-33471.herokuapp.com',
      '/',
    );
    socketIO.init();
    socketIO.connect();
    db.getSingleUser(this.userId).then((value) {
      setState(() {
        if (value[0]['user_count'].toString() != '0') {
          showButton = false;
        } else {
          showButton = true;
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFFBFCFE),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text("${this.name}"),
          centerTitle: true,
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            child: FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.close),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.delta.dy >= 6) {
                      Navigator.pop(context);
                      // Navigator.canPop(context);
                    }
                  },
                  child: Hero(
                    tag: "$userId",
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      child: ProfileTop(
                          name: "$name",
                          picUrl: "$pic",
                          profession: "$profession",
                          location: "$location"),
                    ),
                  ),
                ),
                (showButton)
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            add(this.userId, this.name, this.pic);
                          },
                          child: Container(
                            width: 130,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "Connect",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 130,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(
                                  width: 1,
                                  color: Theme.of(context).primaryColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Text(
                              "Connected",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 13.0),
                  child: Text(
                    "$bio",
                    maxLines: 4,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontFamily: 'montserrat',
                      fontSize: 14,
                      height: 1.2,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "$name's Goals",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        this.goals.length,
                        (index) => Expanded(
                            child: goalCardGenerator(
                                context,
                                "${this.goals[index]['personGoalName']}",
                                int.parse(
                                    this.goals[index]['personGoalLevel'])))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    "Here’s what others are saying about Mason",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
                Container(
                    // padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    testimonial(
                        context,
                        "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                        "Emily",
                        "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car"),
                    testimonial(
                        context,
                        "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                        "Emily",
                        "By the same illusion which lifts the horizon of the sea to the level of the spectator on a hillside, the sable cloud beneath was dished out, and the car")
                  ],
                )),
              ],
            ),
          ),
        ));
  }

  void add(userId, userName, userImage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(15.0))), //this right here
              child: Container(
                height: 250,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Send A Message",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        height: 15,
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        controller: messageController,
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1.0),
                            ),
                            hintText: 'Enter a Message'),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 100,
                              child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35)),
                                  onPressed: () async {
                                    var msg = messageController.text;
                                    var db = DataBaseHelper();
                                    messageController.clear();
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    String id = prefs.getString('id') ?? "";
                                    print("UID IS EMPTY? $uid");
                                    await http.post(
                                        'https://march.lbits.co/api/worker.php',
                                        body: json.encode(<String, dynamic>{
                                          "serviveName": "",
                                          "work": "add new request",
                                          "uid": "$uid",
                                          "sender": "$id",
                                          "receiver": "$id",
                                          "message": "$msg",
                                          "requestStatus": "pending"
                                        }),
                                        headers: {
                                          'Authorization': 'Bearer $token',
                                          'Content-Type': 'application/json'
                                        }).then((value) {
                                      var resp = json.decode(value.body);
                                      if (resp['response'] == 200) {
                                        var key = UniqueKey();
                                        socketIO.sendMessage(
                                            "New user Request",
                                            json.encode({
                                              "msgCode": "$key",
                                              "message": "$msg",
                                              "sender": id,
                                              "receiver": userId,
                                              "containsImage": "0",
                                              "imageUrl": "none",
                                              "time": '${DateTime.now()}',
                                            }));
                                        Map<String, dynamic> messageMap = {
                                          DataBaseHelper.seenStatus: '0',
                                          DataBaseHelper.messageCode:
                                              UniqueKey(),
                                          DataBaseHelper.messageOtherId: userId,
                                          DataBaseHelper.messageSentBy: id,
                                          DataBaseHelper.messageText: msg,
                                          DataBaseHelper.messageContainsImage:
                                              '0',
                                          DataBaseHelper.messageImage: 'null',
                                          DataBaseHelper.messageTime:
                                              "${DateTime.now()}"
                                        };

                                        imageSaver(userImage).then((value) {
                                          Map<String, dynamic> friendsMap = {
                                            DataBaseHelper.friendId: userId,
                                            DataBaseHelper.friendName: userName,
                                            DataBaseHelper.friendPic:
                                                value['image'],
                                            DataBaseHelper.friendSmallPic:
                                                value['small_image'],
                                            DataBaseHelper.friendLastMessage:
                                                msg,
                                            DataBaseHelper
                                                    .friendLastMessageTime:
                                                "${DateTime.now()}"
                                          };
                                          db.addUser(friendsMap);
                                          db.addMessage(messageMap);
                                          setState(() async {
                                            await db.peopleFinderRemovePerson(
                                                userId);
                                            await db.removePersonGoals(userId);
                                          });
                                        });
                                      } else {
                                        print("$resp");
                                      }
                                    });
                                    StatusAlert.show(context,
                                        duration: Duration(seconds: 2),
                                        title: "Added",
                                        configuration: IconConfiguration(
                                            icon: Icons.done));
                                  },
                                  child: Text(
                                    "Add",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    id = prefs.getString('id');
    uid = prefs.getString('uid');
    prefs.setInt('log', 1);
    if (uid == null) {
      FirebaseAuth.instance.currentUser().then((val) async {
        String uid = val.uid;
        prefs.setString('uid', uid);
      });
    }

    socketIO.sendMessage('update my status',
        json.encode({"uid": "$id", "time": "${DateTime.now()}"}));
  }
}
