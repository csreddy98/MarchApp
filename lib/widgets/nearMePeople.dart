import 'package:flutter/material.dart';
import 'package:march/ui/profileScreen.dart';
import 'package:march/widgets/ProfileWidget.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:march/models/people_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui' show ImageFilter;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:march/support/functions.dart';
import 'dart:async';
import 'package:async/async.dart';

class NearMePeople extends StatefulWidget {
  final String peopleFinderType;
  NearMePeople({Key key, this.peopleFinderType}) : super(key: key);

  @override
  _NearMePeopleState createState() => _NearMePeopleState(this.peopleFinderType);
}

class _NearMePeopleState extends State<NearMePeople>
    with TickerProviderStateMixin {
  int check = 0;
  int clicked = 0;
  String id;
  List goalList = [];
  String lat;
  String lng;
  String goals = "";
  String uid;
  Location location = new Location();
  int maxAge = 100;
  int minAge = 18;
  TextEditingController myController;
  List<Person> people = [];
  int radius = 100;
  SocketIO socketIO;
  String token;
  String level = "none";
  DataBaseHelper db = DataBaseHelper();
  LocationData _locationData;
  PermissionStatus _permissionGranted;
  bool _serviceEnabled;
  TextEditingController messageController = new TextEditingController();
  List myUsers = [];
  bool loadPage = false;
  List<Widget> stackedCards = [];
  final String peopleFinderType;
  _NearMePeopleState(this.peopleFinderType);

  @override
  void initState() {
    _load();
    super.initState();
    // _getDataFromLocalDb();
    _getPeople();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget goalBox(goal) {
    List<Map> goalAssets = [
      {
        'name': 'Newbie',
        'image': 'assets/images/newbie.png',
        'bgColor': Color(0xFFCCEEED),
        'textColor': Color(0xFF00ACA3)
      },
      {
        'name': 'Skilled',
        'image': 'assets/images/skilled.png',
        'bgColor': Color(0xFFB1D1DF),
        'textColor': Color(0xFF4D6874)
      },
      {
        'name': 'Proficient',
        'image': 'assets/images/proficient.png',
        'bgColor': Color(0xFFE35E64),
        'textColor': Color(0xFF74272A)
      },
      {
        'name': 'Experienced',
        'image': 'assets/images/experienced.png',
        'bgColor': Color(0xFFF2C5D3),
        'textColor': Color(0xFF926D51)
      },
      {
        'name': 'Expert',
        'image': 'assets/images/expert.png',
        'bgColor': Color(0xFFF1D3B5),
        'textColor': Color(0xFF926D51)
      },
    ];
    return Container(
      decoration: BoxDecoration(
          color: goalAssets[int.parse(goal['level'])]['bgColor'],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Text(
          goal['goal'],
          style: TextStyle(
              color: goalAssets[int.parse(goal['level'])]['textColor'],
              fontSize: 14),
        ),
      ),
    );
  }

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  Widget cardGenerator(tag, id, name, pic, profession, location, description,
      List goals, int index) {
    return GestureDetector(
        onVerticalDragUpdate: (x) {
          if (x.delta.dy <= -6) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                          name: name,
                          profession: profession,
                          userId: id,
                          pic: pic,
                          location: location,
                          bio: description,
                        )));
          }
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    flightShuttleBuilder: _flightShuttleBuilder,
                    tag: "$tag",
                    child: ProfileTop(
                        name: "$name",
                        picUrl: "$pic",
                        profession: "$profession",
                        location: "$location"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 14.0),
                    child: Text(
                      "$description",
                      style: TextStyle(
                          fontFamily: 'montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w100),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "$name's Goals",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        children: List.generate(
                            goals.length, (index) => goalBox(goals[index])),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            deleteItem(index, id);
                          },
                          child: Container(
                            width: 130,
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color: Theme.of(context).primaryColor),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text(
                                "Skip",
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Container(
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
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<List<Widget>> _getPeople() async {
    if (token != null && id != null && check == 1) {
      var ur = 'https://march.lbits.co/api/worker.php';
      var resp = await http.post(
        ur,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode(<String, dynamic>{
          'serviceName': "",
          'work': "search with distance",
          'lat': lat,
          'lng': lng,
          'goals': goals,
          'radius': radius,
          'maxAge': maxAge,
          'minAge': minAge,
          'uid': id,
          'goalLevel': level,
          'listType': this.peopleFinderType
        }),
      );
      var result = json.decode(resp.body);
      stackedCards.clear();
      if (result['response'] == 200) {
        int l = result['result'].length;
        List requiredRes = result['result'].toList()..shuffle();
        print("Length: $l");
        print("This is the result: $requiredRes");
        for (var i = 0; i < l; i++) {
          print("Ittr: $i");
          // if (!myUsers.contains(result['result'][i]['user_info']['id'])) {}

          setState(() {
            stackedCards.add(cardGenerator(
                requiredRes[i]['user_info']['fullName'],
                requiredRes[i]['user_info']['id'],
                requiredRes[i]['user_info']['fullName'],
                requiredRes[i]['user_info']['profile_pic'],
                requiredRes[i]['user_info']['profession'],
                requiredRes[i]['user_info']['distance'] + " Km away",
                requiredRes[i]['user_info']['bio'],
                requiredRes[i]['goal_info'],
                i));
          });
          // db.getPersonWithId(requiredRes[i]['user_info']['id']).then((value) {
          //   if (value[0]['personCount'].toString() == '0') {
          //     db.insertPersonForPeopleFinder({
          //       DataBaseHelper.peopleFinderid: requiredRes[i]['user_info']
          //           ['id'],
          //       DataBaseHelper.peopleFinderName: requiredRes[i]['user_info']
          //           ['fullName'],
          //       DataBaseHelper.peopleFinderPic: requiredRes[i]['user_info']
          //           ['profile_pic'],
          //       DataBaseHelper.peopleFinderProfession: requiredRes[i]
          //           ['user_info']['profession'],
          //       DataBaseHelper.peopleFinderLocation:
          //           "${requiredRes[i]['user_info']['distance']} Km away",
          //       DataBaseHelper.peopleFinderBio: requiredRes[i]['user_info']
          //           ['bio'],
          //       DataBaseHelper.peopleFinderGender: requiredRes[i]['user_info']
          //           ['sex'],
          //       DataBaseHelper.peopleFinderAge: requiredRes[i]['user_info']
          //           ['age'],
          //     }).then((value) {
          //       requiredRes[i]['goal_info'].toList().forEach((element) {
          //         db.addPersonGoal({
          //           DataBaseHelper.peopleFinderPersonId: requiredRes[i]
          //               ['user_info']['id'],
          //           DataBaseHelper.peopleFinderGoalName: element['goal'],
          //           DataBaseHelper.peopleFinderGoalLevel: element['level']
          //         }).then((value) => print("ADDED"));
          //       });
          //     });
          // }
          // });
        }
      }
    }
    return stackedCards;
  }

  // Future<List<Widget>> _getDataFromLocalDb() async {
  //   _getPeople();
  //   int i = 0;
  //   stackedCards.clear();
  //   db.getPeopleFinderPeople().then((value) {
  //     print('This is from Local DB: $value Hello');
  //     value.forEach((element) {
  //       List goals = [];
  //       db.selectGoals("${element['personId']}").then((value2) {
  //         goals = value2;
  //       }).then((value) {
  //         stackedCards.add(cardGenerator(
  //             element['personName'],
  //             element['personId'],
  //             element['personName'],
  //             element['personPic'],
  //             element['personProfession'],
  //             element['personLocation'],
  //             element['personBio'],
  //             goals,
  //             i));
  //         setState(() {});
  //       });

  //       i = i + 1;
  //     });
  //   });

  //   return stackedCards;
  // }

  @override
  Widget build(BuildContext context) {
    // _getDataFromLocalDb();
    if (stackedCards.length != 0) {
      return Stack(children: stackedCards);
    } else {
      return FutureBuilder(
          future: _getPeople(),
          initialData: [],
          builder: (context, snapshot) {
            if (stackedCards.length == 0) {
              return Container(
                child: Center(
                  child: Image.asset(
                    "assets/images/animat-search-color.gif",
                    height: 125.0,
                    width: 125.0,
                  ),
                ),
              );
            } else {
              return Stack(children: stackedCards);
            }
          });
    }
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token') ?? "";
    // uid = prefs.getString('uid') ?? "";
    id = prefs.getString('id') ?? "";

    // SQLITE

    int n;
    db.getGoalCount().then((value) {
      setState(() {
        n = value;
      });
    });
    // var user = await db.getUser(1);
    db.getUser(1).then((value) {
      setState(() {
        uid = value.userId;
      });
    });

    db.getGoalsName().then((value) {
      setState(() {
        var m = value[0];
        goals = m["goalName"];
        goalList.add(m["goalName"]);
        for (var i = 1; i < n; i++) {
          var m = value[i];
          goals = goals + "," + m["goalName"];
          goalList.add(m["goalName"]);
        }
        print(goals);
      });
    });

    setState(() {
      token = userToken;
      //   uid = user.userId;
    });
    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.granted) {
      _serviceEnabled = await location.serviceEnabled();

      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          print("No Thanks");
          setState(() {
            lat = "17.4538444";
            lng = "78.416675";
            check = 1;
          });
          return;
        } else {
          print("Clicked Ok");
          _locationData = await location.getLocation();
          print("lat : " +
              _locationData.latitude.toString() +
              "long : " +
              _locationData.longitude.toString());
          setState(() {
            lat = _locationData.latitude.toString();
            lng = _locationData.longitude.toString();
            check = 1;
          });
        }
      } else {
        _locationData = await location.getLocation();
        print("lat : " +
            _locationData.latitude.toString() +
            "long : " +
            _locationData.longitude.toString());
        setState(() {
          lat = _locationData.latitude.toString();
          lng = _locationData.longitude.toString();
          check = 1;
        });
      }
    } else {
      //location permission in settings
      _permissionGranted = await location.requestPermission();

      if (_permissionGranted == PermissionStatus.granted) {
        //checking gps
        _serviceEnabled = await location.serviceEnabled();

        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            print("No Thanks");
            setState(() {
              lat = "17.4538444";
              lng = "78.416675";
              check = 1;
            });
            return;
          } else {
            print("Clicked Ok");
            _locationData = await location.getLocation();
            print("lat : " +
                _locationData.latitude.toString() +
                "long : " +
                _locationData.longitude.toString());
            setState(() {
              lat = _locationData.latitude.toString();
              lng = _locationData.longitude.toString();
              check = 1;
            });
          }
        } else {
          _locationData = await location.getLocation();
          print("lat : " +
              _locationData.latitude.toString() +
              "long : " +
              _locationData.longitude.toString());
          setState(() {
            lat = _locationData.latitude.toString();
            lng = _locationData.longitude.toString();
            check = 1;
          });
        }
      } else {
        //when location permission rejected
        setState(() {
          lat = "17.09";
          lng = "78.05";
          check = 1;
        });
      }
    }
  }

  void deleteItem(index, id) async {
    setState(() {
      print("DELETING $index, $id");
      stackedCards.removeAt(index);
      // db.peopleFinderRemovePerson(id);
      // db.removePersonGoals(id);
    });
  }

  void undoDeletion(index, item) {
    setState(() {
      people.insert(index, item);
    });
  }

  void add(person) {
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
                                        "receiver": "${person.id}",
                                        "message": "$msg",
                                        "requestStatus": "pending"
                                      }),
                                      headers: {
                                        'Authorization': 'Bearer $token',
                                        'Content-Type': 'application/json'
                                      }).then((value) {
                                    var resp = json.decode(value.body);
                                    if (resp['response'] == 200) {
                                      socketIO.sendMessage(
                                          "New user Request",
                                          json.encode({
                                            "sender": id,
                                            "receiver": person.id,
                                            "message": msg,
                                            "time": DateTime.now().toString(),
                                          }));
                                      Map<String, dynamic> messageMap = {
                                        DataBaseHelper.seenStatus: '0',
                                        DataBaseHelper.messageOtherId:
                                            person.id,
                                        DataBaseHelper.messageSentBy: id,
                                        DataBaseHelper.messageText: msg,
                                        DataBaseHelper.messageContainsImage:
                                            '0',
                                        DataBaseHelper.messageImage: 'null',
                                        DataBaseHelper.messageTime:
                                            "${DateTime.now()}"
                                      };

                                      imageSaver(person.imageUrl).then((value) {
                                        Map<String, dynamic> friendsMap = {
                                          DataBaseHelper.friendId: person.id,
                                          DataBaseHelper.friendName:
                                              person.name,
                                          DataBaseHelper.friendPic:
                                              value['image'],
                                          DataBaseHelper.friendSmallPic:
                                              value['small_image'],
                                          DataBaseHelper.friendLastMessage: msg,
                                          DataBaseHelper.friendLastMessageTime:
                                              "${DateTime.now()}"
                                        };
                                        db.addUser(friendsMap);
                                        db.addMessage(messageMap);
                                      });
                                    } else {
                                      print("$resp");
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Add",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Color.fromRGBO(63, 92, 200, 1),
                              ),
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
}
