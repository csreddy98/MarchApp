import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:march/models/people_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:march/ui/slider_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:march/ui/view_profile.dart';
import 'package:location/location.dart';
import 'package:march/utils/database_helper.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {
  int check = 0;
  int clicked = 0;
  String id;
  String lat;
  String lng;
  String uid;
  Location location = new Location();
  final int maxAge = 100;
  final int minAge = 18;
  TextEditingController myController;
  List<Person> people = [];
  List<Map> peoples = [];
  int radius = 100;
  SocketIO socketIO;
  String token;
  DataBaseHelper db = DataBaseHelper();
  LocationData _locationData;
  PermissionStatus _permissionGranted;
  bool _serviceEnabled;
  TextEditingController messageController = new TextEditingController();
  List myUsers = [];
  bool loadPage = false;
  @override
  void initState() {
    _load();
    socketIO = SocketIOManager().createSocketIO(
      'https://glacial-waters-33471.herokuapp.com',
      '/',
    );
    socketIO.init();
    socketIO.connect();
    // socketIO.subscribe('new message', (data) {
    //   print("MESSAGE: $data");
    // });
    super.initState();
  }

  Future<List<Person>> _getPeople() async {
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
          'goals': 'Cricket',
          'radius': radius,
          'maxAge': maxAge,
          'minAge': minAge,
          'uid': id,
        }),
      );
      var result = json.decode(resp.body);
      print("This is the result: $result");
      if (result['response'] == 200) {
        int l = result['result'].length;
        if (l > 10) {
          l = 10;
        }

        if (clicked == 0) {
          for (var i = 0; i < l; i++) {
            if (!myUsers.contains(result['result'][i]['user_info']['id'])) {}
            people.add(
              Person(
                  imageUrl: result['result'][i]['user_info']['profile_pic'],
                  name: result['result'][i]['user_info']['fullName'],
                  gender: result['result'][i]['user_info']['sex'],
                  age: "${result['result'][i]['user_info']['age']} Years Old",
                  location:
                      result['result'][i]['user_info']['distance'] + " Km away",
                  goals: result['result'][i]['goal_info'],
                  id: result['result'][i]['user_info']['id'],
                  bio: result['result'][i]['user_info']['bio'],
                  profession: result['result'][i]['user_info']['profession']),
            );
            peoples.add({
                  'imageUrl': result['result'][i]['user_info']['profile_pic'],
                  'name': result['result'][i]['user_info']['fullName'],
                  'gender': result['result'][i]['user_info']['sex'],
                  'age': "${result['result'][i]['user_info']['age']} Years Old",
                  'location':
                      result['result'][i]['user_info']['distance'] + " Km away",
                  'goals': result['result'][i]['goal_info'],
                  'id': result['result'][i]['user_info']['id'],
                  'bio': result['result'][i]['user_info']['bio'],
                  'profession': result['result'][i]['user_info']['profession']
            });
          }

          setState(() {
            clicked = 1;
          });
        }
      }
    }
    print(people);
    return people;
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sk,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 25.0, left: 25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Text(
                      'Featured',
                      style: TextStyle(fontSize: 20),
                    )),
                IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: Colors.grey,
                    ),
                    iconSize: 26.0,
                    onPressed: () {
                      if (people.length > 0) {
                        _navigateAndDisplaySelection(context);
                      }
                    }),
              ],
            ),
          ),
          Expanded(
            child: Container(
                color: Colors.white,
                child: FutureBuilder(
                  future: _getPeople(),
                  initialData: [],
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    print("SNAPSHOT: ${snapshot.data}");
                    if (snapshot.data.length == 0) {
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
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext context, int index) {
                          Person person = people[index];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Dismissible(
                              key: ObjectKey(people[index]),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewProfile(
                                              person.id,
                                              person.imageUrl,
                                              person.name,
                                              person.age,
                                              person.goals,
                                              person.bio)),
                                      (Route<dynamic> route) => true);
                                },
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.fromLTRB(17, 5, 20, 5),
                                      height: 170,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              blurRadius: 2,
                                              offset: Offset(1, 1)),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                115, 0, 20, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.4,
                                                  child: AutoSizeText(
                                                    person.name[0]
                                                            .toUpperCase() +
                                                        person.name
                                                            .substring(1),
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                      letterSpacing: 0.4,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blue[900],
                                                    ),
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                IconButton(
                                                    icon:
                                                        Icon(Icons.person_add),
                                                    iconSize: 28,
                                                    color: Color.fromRGBO(
                                                        63, 92, 200, 0.4),
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return Dialog(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15.0))), //this right here
                                                              child: Container(
                                                                height: 250,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          20.0),
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        "Send A Message",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w600),
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            15,
                                                                      ),
                                                                      TextField(
                                                                        keyboardType:
                                                                            TextInputType.multiline,
                                                                        maxLines:
                                                                            3,
                                                                        controller:
                                                                            messageController,
                                                                        decoration: InputDecoration(
                                                                            enabledBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                                            ),
                                                                            hintText: 'Enter a Message'),
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            width:
                                                                                MediaQuery.of(context).size.width / 2.2,
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                SizedBox(
                                                                              width: 100,
                                                                              child: RaisedButton(
                                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                                                                onPressed: () async {
                                                                                  var msg = messageController.text;
                                                                                  var db = DataBaseHelper();
                                                                                  messageController.clear();
                                                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                  String id = prefs.getString('id') ?? "";
                                                                                  print("UID IS EMPTY? $uid");
                                                                                  await http.post('https://march.lbits.co/api/worker.php',
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
                                                                                        DataBaseHelper.messageOtherId: person.id,
                                                                                        DataBaseHelper.messageSentBy: id,
                                                                                        DataBaseHelper.messageText: msg,
                                                                                        DataBaseHelper.messageContainsImage: '0',
                                                                                        DataBaseHelper.messageImage: 'null',
                                                                                        DataBaseHelper.messageTime: "${DateTime.now()}"
                                                                                      };
                                                                                      Map<String, dynamic> friendsMap = {
                                                                                        DataBaseHelper.friendId: person.id,
                                                                                        DataBaseHelper.friendName: person.name,
                                                                                        DataBaseHelper.friendPic: person.imageUrl,
                                                                                        DataBaseHelper.friendLastMessage: msg,
                                                                                        DataBaseHelper.friendLastMessageTime: "${DateTime.now()}"
                                                                                      };
                                                                                      db.addUser(friendsMap);
                                                                                      db.addMessage(messageMap);
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
                                                            );
                                                          });
                                                    }),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                115, 0, 20, 0),
                                            child: Text(
                                              person.profession,
                                              style: TextStyle(
                                                letterSpacing: 0.4,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                95, 0, 20, 0),
                                            child: Row(
                                              children: <Widget>[
                                                IconButton(
                                                    icon: Icon(
                                                      Icons.location_on,
                                                      color: Colors.grey[400],
                                                    ),
                                                    onPressed: null),
                                                Text(
                                                  person.location,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    letterSpacing: 0.4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 5, 20, 0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  'Goals:  ',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.6),
                                                ),
                                                Text(
                                                  person.goals,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black87,
                                                    letterSpacing: 0.6,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: 30,
                                      top: 15,
                                      bottom: 70,
                                      child: Container(
                                        width: 90.0,
                                        height: 90.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image:
                                                NetworkImage(person.imageUrl),
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onDismissed: (direction) {
                                Person item = people[index];

                                deleteItem(index);

                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text("Profile deleted"),
                                    action: SnackBarAction(
                                        label: "UNDO",
                                        onPressed: () {
                                          undoDeletion(index, item);
                                        })));
                              },
                            ),
                          );
                        },
                      );
                    }
                  },
                )),
          ),
        ],
      ),
    );
  }

  void deleteItem(index) {
    setState(() {
      people.removeAt(index);
    });
  }

  void undoDeletion(index, item) {
    setState(() {
      people.insert(index, item);
    });
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token') ?? "";
    // uid = prefs.getString('uid') ?? "";
    id = prefs.getString('id') ?? "";

    // SQLITE

    // var user = await db.getUser(1);
    db.getUser(1).then((value) {
      setState(() {
        uid = value.userId;
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

    /* if (_permissionGranted == PermissionStatus.denied) {
      */ /*_permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("yes");
        _locationData = await location.getLocation();
        print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
        setState(() {
          lat=_locationData.latitude.toString();
          lng=_locationData.longitude.toString();
        });
      }
      else{
        print("permission not granted");
      }
      setState(() {
        check=1;
      });*/ /*
    }
    else{
      */ /*_locationData = await location.getLocation();
      print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
      setState(() {
        lat=_locationData.latitude.toString();
        lng=_locationData.longitude.toString();
        check=1;
        print("location on");
      });*/ /*
    }*/
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Slider_container("Cricket", "Dance", "Hockey")),
    );
    if (result != null) {
      print(result);
      int minAge = result[0];
      int maxAge = result[1];
      int distance = result[2];
      List<dynamic> record = result[3];

      for (var i = people.length - 1; i >= 0; i--) {
        List<dynamic> l = convert.jsonDecode(people[i].goals);

        if (int.parse(people[i].age.substring(0, 2)) < minAge) {
          setState(() {
            people.removeAt(i);
          });
        } else if (int.parse(people[i].age.substring(0, 2)) > maxAge) {
          setState(() {
            people.removeAt(i);
          });
        } else if (double.parse(people[i].location.substring(0, 3)) >
            double.parse(distance.toString())) {
          setState(() {
            people.removeAt(i);
          });
        } else if (record.length > 2) {
          if (!l.contains(record[0]) ||
              !l.contains(record[1]) ||
              !l.contains(record[2])) {
            setState(() {
              people.removeAt(i);
            });
          }
        } else if (record.length > 1) {
          if (!l.contains(record[0]) || !l.contains(record[1])) {
            setState(() {
              people.removeAt(i);
            });
          }
        } else if (record.length > 0) {
          if (!l.contains(record[0])) {
            setState(() {
              people.removeAt(i);
            });
          }
        }
      }
    }
  }
}
