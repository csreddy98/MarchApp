import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:march/models/goal.dart';
import 'package:march/ui/show_goals.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

class EditGoal extends StatefulWidget {
  final String gno;
  final String uid;
  EditGoal(this.gno, this.uid);
  @override
  _EditGoalState createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  String token;
  String selectedGoal = "";
  final GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  String remind = "0";
  Color c = Colors.grey[100];
  int _disable = 0;
  String currentText = "";
  String currentText1 = "";
  int click = 0;
  List<String> suggestions = [];
  String note = "";
  String goalsLevel = "";
// till here
  String sendTime = "none";
  bool checkedValue = false;
  bool timeView = false;
  bool showWhichErrorText = false;

  int selectedHour = 0;
  int selectedMin = 0;
  String ampm = "AM";
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    _load();
    super.initState();

    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    print("Tapped on Notification");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Center(
            child: Text(
          "Update Goal",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'montserrat'),
        )),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(
                bottom: 6.0), //Same as `blurRadius` i guess
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 2.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  _disable == 1
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SimpleAutoCompleteTextField(
                            key: key,
                            decoration: new InputDecoration(
                                filled: true,
                                fillColor: c,
                                hintText: "Enter Your Goals",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: c, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                )),
                            controller: TextEditingController(),
                            suggestions: suggestions,
                            textChanged: (text) => currentText = text,
                            clearOnSubmit: true,
                            textSubmitted: (text) => setState(() {
                              if (text != "" && _disable == 0) {
                                print(text);
                                setState(() {
                                  _disable = 1;
                                  selectedGoal = text;
                                });
                              } else {
                                _sk.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    "Enter all details and Submit next",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          topRight: Radius.circular(12.0))),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.lightBlueAccent,
                                ));
                              }
                            }),
                          ),
                        ),
                  _disable == 1
                      ? Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(child: Text(selectedGoal)),
                                    IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          size: 16,
                                          color: Color.fromRGBO(63, 92, 200, 1),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _disable = 0;
                                            selectedGoal = "";
                                          });
                                        }),
                                  ],
                                ),
                              )),
                        )
                      : Container(),
                   /*Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                          child: SimpleAutoCompleteTextField(
                            key: key1,
                            decoration: new InputDecoration(
                                filled: true,
                                fillColor: c,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: c, width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(15, 15, 15, 5),
                                hintText: "Choose Expertise",
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                )),
                            controller: TextEditingController(),
                            suggestions: suggestions1,
                            textChanged: (text) => currentText1 = text,
                            clearOnSubmit: true,
                            textSubmitted: (text) => setState(() {
                              if (text != "" && _disable1 == 0) {
                                setState(() {
                                  expertise = text;
                                  _disable1 = 1;
                                  if (expertise == 'Newbie') {
                                    goalsLevel = "0";
                                  } else if (expertise == 'Skilled') {
                                    goalsLevel = "1";
                                  } else if (expertise == 'Proficient') {
                                    goalsLevel = "2";
                                  } else if (expertise == 'Experienced') {
                                    goalsLevel = "3";
                                  } else if (expertise == 'Expert') {
                                    goalsLevel = "4";
                                  }
                                });
                              } else {
                                _sk.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    "Enter all details and Submit next",
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(12.0),
                                          topRight: Radius.circular(12.0))),
                                  duration: Duration(seconds: 3),
                                  backgroundColor: Colors.lightBlueAccent,
                                ));
                              }
                            }),
                          ),
                        ),*/
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18.0,8,18,8),
                    child: Theme(
                      data: ThemeData(primaryColor: Colors.black),
                      child: Container(
                        color: Colors.grey[100],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.grey[100]))),
                            items: [
                              DropdownMenuItem<String>(
                                value: "0",
                                child: Text(
                                  "Newbie",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "1",
                                child: Text(
                                  "Skilled",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "2",
                                child: Text(
                                  "Proficient",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "3",
                                child: Text(
                                  "Experienced",
                                ),
                              ),
                              DropdownMenuItem<String>(
                                value: "4",
                                child: Text(
                                  "Expert",
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                goalsLevel=value;
                              });
                            },
                            isExpanded: true,
                            hint: Text(
                              "Choose Your Expertise ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                                fontFamily: 'montserrat',
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  CheckboxListTile(
                    title: Text(
                      "Remind me every day",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400),
                    ),
                    value: checkedValue,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (newValue) {
                      setState(() {
                        checkedValue = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, top: 5, right: 20),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Center(
                    child: Visibility(
                        maintainSize: false,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: checkedValue,
                        child: Container(
                            height: size.height / 2.9,
                            width: size.width / 1.14,
                            margin: EdgeInsets.only(top: 5, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    'Remind me Everyday at $selectedHour:$selectedMin $ampm',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                                Visibility(
                                  maintainSize: false,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  visible: timeView == false ? true : false,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: () {
                                          if (ampm == 'PM') {
                                            int hour = selectedHour + 12;
                                            String min = selectedMin.toString();
                                            if (selectedMin < 10) {
                                              min = "0$selectedMin";
                                            }
                                            setState(() {
                                              click = 1;
                                              sendTime = "$hour:$min:00";
                                              print(sendTime);
                                            });
                                          } else {
                                            String hr = selectedHour.toString();
                                            String min = selectedMin.toString();
                                            if (selectedHour < 10) {
                                              min = "0$selectedMin";
                                            }
                                            if (selectedMin < 10) {
                                              hr = "0$selectedHour";
                                            }
                                            setState(() {
                                              click = 1;
                                              sendTime = "$hr:$min:00";
                                              print(sendTime);
                                            });
                                          }
                                          setState(() {
                                            timeView = true;
                                          });
                                        },
                                        child: Text(
                                          'Done',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                timeView == false
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Center(
                                              child: Container(
                                                width: size.width / 4.5,
                                                height: size.height / 4,
                                                child: CupertinoPicker(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  itemExtent: 50,
                                                  onSelectedItemChanged:
                                                      (int index) {
                                                    setState(() {
                                                      selectedHour = index + 1;
                                                    });
                                                    //   print("$selectedHour");
                                                  },
                                                  children: <Widget>[
                                                    Text("01"),
                                                    Text("02"),
                                                    Text("03"),
                                                    Text("04"),
                                                    Text("05"),
                                                    Text("06"),
                                                    Text("07"),
                                                    Text("08"),
                                                    Text("09"),
                                                    Text("10"),
                                                    Text("11"),
                                                    Text("12"),
                                                  ],
                                                ),
                                              ),
                                            ),

//                                  SizedBox(width: size.width/50,),
                                            Container(
                                              width: 75,
                                              height: 100,
                                              child: CupertinoPicker(
                                                backgroundColor:
                                                    Colors.transparent,
                                                itemExtent: 50,
                                                children: <Widget>[
                                                  Text("01"),
                                                  Text("02"),
                                                  Text("03"),
                                                  Text("04"),
                                                  Text("05"),
                                                  Text("06"),
                                                  Text("07"),
                                                  Text("08"),
                                                  Text("09"),
                                                  Text("10"),
                                                  Text("11"),
                                                  Text("12"),
                                                  Text("13"),
                                                  Text("14"),
                                                  Text("15"),
                                                  Text("16"),
                                                  Text("17"),
                                                  Text("18"),
                                                  Text("19"),
                                                  Text("20"),
                                                  Text("21"),
                                                  Text("22"),
                                                  Text("23"),
                                                  Text("24"),
                                                  Text("25"),
                                                  Text("26"),
                                                  Text("27"),
                                                  Text("28"),
                                                  Text("29"),
                                                  Text("30"),
                                                  Text("31"),
                                                  Text("32"),
                                                  Text("33"),
                                                  Text("34"),
                                                  Text("35"),
                                                  Text("36"),
                                                  Text("37"),
                                                  Text("38"),
                                                  Text("39"),
                                                  Text("40"),
                                                  Text("41"),
                                                  Text("42"),
                                                  Text("43"),
                                                  Text("44"),
                                                  Text("45"),
                                                  Text("46"),
                                                  Text("47"),
                                                  Text("48"),
                                                  Text("49"),
                                                  Text("50"),
                                                  Text("51"),
                                                  Text("52"),
                                                  Text("53"),
                                                  Text("54"),
                                                  Text("55"),
                                                  Text("56"),
                                                  Text("57"),
                                                  Text("58"),
                                                  Text("59"),
                                                ],
                                                onSelectedItemChanged:
                                                    (int index) {
                                                  setState(() {
                                                    selectedMin = index + 1;
                                                  });
                                                  //   print("$selectedMin");
                                                },
                                              ),
                                            ),
                                            //                                SizedBox(width: size.width/50,),
                                            Center(
                                              child: Container(
                                                width: 75,
                                                height: 115,
                                                child: CupertinoPicker(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  itemExtent: 50,
                                                  onSelectedItemChanged:
                                                      (int index) {
                                                    if (index == 0) {
                                                      setState(() {
                                                        ampm = "AM";
                                                      });
                                                    } else {
                                                      setState(() {
                                                        ampm = "PM";
                                                      });
                                                    }
                                                  },
                                                  children: <Widget>[
                                                    Text("AM"),
                                                    Text("PM"),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        height: 0,
                                        width: 0,
                                      ),
                                /*Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top:12.0),
                                  child: Text("Write a Note (Optional)",style: Theme.of(context).textTheme.subtitle2,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0,10.0,0.0,10),
                                  child: TextField(
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black
                                    ),
                                    decoration: InputDecoration(
                                        hintText: "its time to work on your goal",
                                        border: OutlineInputBorder(),
                                        hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                                    onChanged: (String value) {
                                      try {
                                        note = value;
                                      } catch (exception) {
                                        note ="";
                                      }
                                    },
                                  ),
                                ),
                                Text("these will be text on your notification",style: Theme.of(context).textTheme.headline3,),
                              ],
                            ),
*/
                              ],
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0),
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    selectedGoal = "";
                                    _disable = 0;
                                    selectedHour = 0;
                                    selectedMin = 0;
                                    checkedValue = false;
                                    ampm = 'AM';
                                    timeView = false;
                                    sendTime = "none";
                                    remind = "0";
                                    note = "";
                                    click = 0;
                                    goalsLevel = "";
                                    _disable = 0;
                                  });
                                },
                                child: Text(
                                  'Clear',
                                  style: Theme.of(context).textTheme.button,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.15,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(6.0),
                                ),
                                color: Theme.of(context).primaryColor,
                                textColor: Colors.white,
                                onPressed: () async {
                                  if ((checkedValue == true && click == 1) ||
                                      checkedValue == false) {
                                    if (selectedGoal != "" && goalsLevel != "") {
                                      if (sendTime != "none") {
                                        setState(() {
                                          remind = "1";
                                        });
                                      }
                                      print(widget.gno +
                                          " goalno " +
                                          sendTime +
                                          "  " +
                                          remind +
                                          " " +
                                          goalsLevel);
                                      _onLoading();

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
                                          'work': "add goal",
                                          'uid': widget.uid,
                                          'goalName': selectedGoal,
                                          'goalNumber': widget.gno,
                                          'goalLevel':int.parse(goalsLevel),
                                          'remindEveryday': int.parse(remind),
                                          'remindTime': sendTime,
                                        }),
                                      );

                                      print("res " + resp.body.toString());

                                      var result = json.decode(resp.body);
                                      if (result['response'] == 200) {
                                        var db = new DataBaseHelper();
                                        int cnt = await db.getGoalCount();

                                        print(cnt);
                                        if (cnt >= int.parse(widget.gno)) {
                                          //  print(widget.gno+" "+selectedGoal);
                                          if(remind=="1"){
                                            _showNotification(int.parse(widget.gno),selectedGoal, "It's time to work on your goal",
                                                Time(int.parse(sendTime.substring(0,2)),selectedMin));
                                          }

                                          await db.updateGoal(Goal(
                                              widget.uid,
                                              selectedGoal,
                                              goalsLevel,
                                              remind,
                                              sendTime,
                                              widget.gno));

                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Home('edit')),
                                                  (Route<dynamic> route) => false);
                                        } else {
                                          if(remind=="1"){
                                            _showNotification(int.parse(widget.gno),selectedGoal, "It's time to work on your goal",
                                                Time(int.parse(sendTime.substring(0,2)),selectedMin));
                                          }

                                          int savedGoal = await db.saveGoal(
                                              new Goal(
                                                  widget.uid,
                                                  selectedGoal,
                                                  goalsLevel,
                                                  remind,
                                                  sendTime,
                                                  widget.gno));

                                          print("goal saved :$savedGoal");

                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Home('edit')),
                                                  (Route<dynamic> route) => false);
                                        }
                                      } else {
                                        Navigator.pop(context);
                                        setState(() {
                                          selectedGoal = "";
                                          _disable = 0;
                                          selectedHour = 0;
                                          selectedMin = 0;
                                          checkedValue = false;
                                          ampm = 'AM';
                                          timeView = false;
                                          sendTime = "none";
                                          remind = "0";
                                          note = "";
                                          click = 0;
                                          goalsLevel = "";
                                          _disable = 0;
                                        });

                                        _sk.currentState.showSnackBar(SnackBar(
                                          content: Text(
                                            "There is Some Technical Problem Submit again",
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontSize: 15,
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(12.0),
                                                  topRight:
                                                      Radius.circular(12.0))),
                                          duration: Duration(seconds: 3),
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                        ));
                                      }
                                    } else {
                                      _sk.currentState.showSnackBar(SnackBar(
                                        content: Text(
                                          "Enter all Details",
                                          style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 15,
                                          ),
                                        ),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12.0),
                                                topRight:
                                                    Radius.circular(12.0))),
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Colors.lightBlueAccent,
                                      ));
                                    }
                                  } else {
                                    _sk.currentState.showSnackBar(SnackBar(
                                      content: Text(
                                        "click done",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: 15,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12.0),
                                              topRight: Radius.circular(12.0))),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.lightBlueAccent,
                                    ));
                                  }
                                },
                                child: Text('Submit',
                                    style: Theme.of(context).textTheme.button),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _showNotification(int goalNumber, String title, String content,
      Time notificationTime) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails('100',
        'Goal Reminder', 'This channel is reserved for the goal Reminders',
        playSound: false, importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
      goalNumber,
      '$title',
      '$content',
      notificationTime,
      platformChannelSpecifics,
    );
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token') ?? "";
    setState(() {
      token = userToken;
    });
    var url = 'https://march.lbits.co/api/worker.php';
    var resp = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: json.encode(<String, dynamic>{
        'serviceName': "",
        'work': "get goals list",
      }),
    );

    print(resp.body.toString());
    var res = json.decode(resp.body);
    if (res['response'] == 200) {
      List n = res['result'];
      setState(() {
        for (var i = 0; i < n.length; i++) {
          suggestions.add(res['result'][i].toString());
        }
      });
    }
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Center(
            child: Image.asset(
              "assets/images/animat-rocket-color.gif",
              height: 125.0,
              width: 125.0,
            ),
          ),
        );
      },
    );
  }
}
