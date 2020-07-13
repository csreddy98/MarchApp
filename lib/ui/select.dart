import 'dart:convert';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:march/models/goal.dart';
import 'package:march/ui/home.dart';
import 'package:http/http.dart' as http;
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Select extends StatefulWidget {
  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> with SingleTickerProviderStateMixin {
  List<String> added = ["", "", ""];
  String currentText = "";
  String currentText1 = "";
  int click = 0;
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  int count = 0;
  String remind = "0";
  Color c = Colors.grey[100];
  final GlobalKey<ScaffoldState> _sk = GlobalKey<ScaffoldState>();
  List<String> suggestions = [];
  List<String> suggestions1 = [
    "Newbie",
    "Skilled",
    "Proficient",
    "Experienced",
    "Expert"
  ];
// drop down
  var db = new DataBaseHelper();
  String note = "";
  String goalsLevel = "";
// till here
  String sendTime = "none";
  int cnt = 1;
  String uid;
  String token;
  bool checkedValue = false;
  bool timeView = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Color activeColor = Color(0xffFFBF46);
  AnimationController animationController;
  Animation d1, p1, d2, p2, d3, p3, d4, p4, d5;
  TextEditingController nameController;
  TextEditingController numberController;
  TextEditingController dateController;
  TextEditingController cvvController;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        uid = val.uid;
      });
    });
    _load();
    super.initState();
    nameController = TextEditingController();
    numberController = TextEditingController();
    dateController = TextEditingController();
    cvvController = TextEditingController();

    animationController = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    d1 = ColorTween(begin: Colors.white, end: activeColor).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.3, 0.5, curve: Curves.linear)));
    p1 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController, curve: Interval(0.5, 0.6)));
    d2 = ColorTween(begin: Colors.white, end: activeColor).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.6, 0.8, curve: Curves.linear)));
    p2 = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Interval(0.8, 1)));
    d3 = ColorTween(begin: Colors.white, end: activeColor).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0.8, 1, curve: Curves.linear)));
    animationController.forward();

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

  final myController = TextEditingController();
  String expertise = "";

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  int _disable = 0, _disable1 = 0;

  int selectedHour = 0;
  int selectedMin = 0;
  String ampm = "AM";

  @override
  Widget build(BuildContext context) {
    final dotSize = 20.0;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _sk,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Select Your Goals', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                  child: Text(
                "Goal " + cnt.toString() + " of 3",
                style: Theme.of(context).textTheme.headline2,
              )),
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget child) => Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.all(12),
                          width: MediaQuery.of(context).size.width,
                          child: Row(children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5, color: activeColor)),
                              width: dotSize + 15,
                              height: dotSize + 15,
                              child: Center(
                                child: Container(
                                    width: dotSize,
                                    height: dotSize,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(dotSize / 2),
                                        color: activeColor)),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Container(
                                  height: 3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: LinearProgressIndicator(
                                    backgroundColor: cnt >= 2
                                        ? activeColor
                                        : Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        cnt >= 2
                                            ? activeColor
                                            : Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 0.5,
                                      color: cnt >= 2
                                          ? activeColor
                                          : Colors.grey)),
                              width: dotSize + 15,
                              height: dotSize + 15,
                              child: Center(
                                child: Container(
                                  width: dotSize,
                                  height: dotSize,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(dotSize / 2),
                                      color: cnt >= 2
                                          ? activeColor
                                          : Colors.grey[200]),
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Container(
                                  height: 3,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: LinearProgressIndicator(
                                    backgroundColor: cnt >= 3
                                        ? activeColor
                                        : Colors.grey[200],
                                    //  value: p1.value,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        cnt >= 3
                                            ? activeColor
                                            : Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 0.5,
                                    color: cnt >= 3 ? activeColor : Colors.grey,
                                    // color: activeColor
                                  )),
                              width: dotSize + 15,
                              height: dotSize + 15,
                              child: Center(
                                child: Container(
                                  width: dotSize,
                                  height: dotSize,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(dotSize / 2),
                                      //    color: d3.value
                                      color: cnt >= 3
                                          ? activeColor
                                          : Colors.grey[300]),
                                ),
                              ),
                            ),
                          ])),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.only(left: 14, right: 20),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(count > 0 ? added[0] : "Goal 1",
                        style: Theme.of(context).textTheme.caption),
                    Text(count > 1 ? added[1] : "Goal 2",
                        style: Theme.of(context).textTheme.caption),
                    // SizedBox(width: MediaQuery.of(context).size.width * 0.25,),
                    Text(count > 2 ? added[2] : "Goal 3",
                        style: Theme.of(context).textTheme.caption),
                  ],
                ),
              ),
              _disable == 1
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SimpleAutoCompleteTextField(
                        key: key,
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
                            hintText: "Enter Your Goals",
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
                            if (count < 3) {
                              added[count] = text;
                              count = count + 1;
                              _disable = 1;
                            } else {
                              _sk.currentState.showSnackBar(SnackBar(
                                content: Text(
                                  "You can Select only 3",
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
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(child: Text(added[count - 1])),
                                IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _disable = 0;
                                        added[count - 1] = "";
                                        count = count - 1;
                                      });
                                    }),
                              ],
                            ),
                          )),
                    )
                  : Container(),
              _disable1 == 1
                  ? Container()
                  : Padding(
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
                    ),
              _disable1 == 1
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Expanded(child: Text(expertise)),
                                IconButton(
                                    icon: Icon(
                                      Icons.clear,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _disable1 = 0;
                                        expertise = "";
                                      });
                                    }),
                              ],
                            ),
                          )),
                    )
                  : Container(),
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
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 5, right: 20),
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
                                    padding: const EdgeInsets.only(left: 30),
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
                                            backgroundColor: Colors.transparent,
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
                                            onSelectedItemChanged: (int index) {
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
              cnt > 1
                  ? Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                                child: FlatButton(
                                    child: Text(
                                      'SKIP',
                                      style: Theme.of(context).textTheme.button,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.all(15),
                                    color: Theme.of(context).primaryColor,
                                    textColor: Colors.white,
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setInt('log', 1);

                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Home('')),
                                          (Route<dynamic> route) => false);
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                                child: FlatButton(
                                  child: Text(
                                    'NEXT',
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if ((checkedValue == true && click == 1) ||
                                        checkedValue == false) {
                                      if (expertise != "" &&
                                          added[count - 1] != "") {
                                        if (sendTime != "none") {
                                          setState(() {
                                            remind = "1";
                                          });
                                        }
                                        _onLoading();
                                        print('cnt :' +
                                            cnt.toString() +
                                            ' expertise :' +
                                            expertise);

                                        print(remind + " " + sendTime);

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
                                            'uid': uid,
                                            'goalName': added[count - 1],
                                            'goalNumber': count.toString(),
                                            'goalLevel': int.parse(goalsLevel),
                                            'remindEveryday': int.parse(remind),
                                            'remindTime': sendTime,
                                          }),
                                        );

                                        print(resp.body.toString());
                                        var result = json.decode(resp.body);
                                        if (count == 3 &&
                                            result['response'] == 200) {

                                          if(remind=="1"){
                                            _showNotification(count,added[count-1], "It's time to work on your goal",
                                                Time(int.parse(sendTime.substring(0,2)),selectedMin));
                                          }

                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Home('')),
                                              (Route<dynamic> route) => false);

                                          int savedGoal = await db.saveGoal(
                                              new Goal(
                                                  uid,
                                                  added[count - 1],
                                                  goalsLevel,
                                                  remind,
                                                  sendTime,
                                                  count.toString()));

                                          print("goal saved :$savedGoal");

                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          prefs.setInt('log', 1);
                                        } else if (result['response'] == 200) {
                                          // check what to save
                                          if(remind=="1"){
                                            _showNotification(count,added[count-1], "It's time to work on your goal",
                                                Time(int.parse(sendTime.substring(0,2)),selectedMin));
                                          }

                                          int savedGoal = await db.saveGoal(
                                              new Goal(
                                                  uid,
                                                  added[count - 1],
                                                  goalsLevel,
                                                  remind,
                                                  sendTime,
                                                  count.toString()));

                                          print("goal saved :$savedGoal");

                                          Navigator.pop(context);
                                          setState(() {
                                            _disable = 0;
                                            _disable1 = 0;
                                            selectedHour = 0;
                                            selectedMin = 0;
                                            sendTime = "none";
                                            remind = "0";
                                            ampm = 'AM';
                                            note = "";
                                            timeView = false;
                                            checkedValue = false;
                                            click = 0;
                                            expertise = "";
                                            goalsLevel = "";
                                            cnt = cnt + 1;
                                          });
                                        } else {
                                          Navigator.pop(context);
                                          setState(() {
                                            selectedHour = 0;
                                            selectedMin = 0;
                                            checkedValue = false;
                                            ampm = 'AM';
                                            timeView = false;
                                            expertise = "";
                                            sendTime = "none";
                                            remind = "0";
                                            note = "";
                                            click = 0;
                                            goalsLevel = "";
                                            _disable = 0;
                                            _disable1 = 0;
                                            added[count - 1] = "";
                                            count = count - 1;
                                          });

                                          _sk.currentState
                                              .showSnackBar(SnackBar(
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
                                            "Enter all details and Submit next",
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
                                          "click done",
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
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 0),
                          child: FlatButton(
                            child: Text(
                              'NEXT',
                              style: Theme.of(context).textTheme.button,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.all(15),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            onPressed: () async {
                              if ((checkedValue == true && click == 1) ||
                                  checkedValue == false) {
                                if (expertise != "" && added[0] != "") {
                                  if (sendTime != "none") {
                                    setState(() {
                                      remind = "1";
                                    });
                                  }
                                  _onLoading();
                                  print('cnt :' +
                                      cnt.toString() +
                                      ' expertise :' +
                                      expertise);

                                  print(remind + " " + sendTime);

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
                                      'uid': uid,
                                      'goalName': added[count - 1],
                                      'goalNumber': count.toString(),
                                      'goalLevel': int.parse(goalsLevel),
                                      'remindEveryday': int.parse(remind),
                                      'remindTime': sendTime,
                                      //                                'note':"",
                                    }),
                                  );

                                  print(resp.body.toString());
                                  var result = json.decode(resp.body);
                                  if (result['response'] == 200) {
                                    if(remind=="1"){
                                      _showNotification(count,added[count-1], "It's time to work on your goal",
                                          Time(int.parse(sendTime.substring(0,2)),selectedMin));
                                    }

                                    int savedGoal = await db.saveGoal(new Goal(
                                        uid,
                                        added[count - 1],
                                        goalsLevel,
                                        remind,
                                        sendTime,
                                        count.toString()));

                                    print("goal saved :$savedGoal");

                                    Navigator.pop(context);
                                    setState(() {
                                      _disable = 0;
                                      _disable1 = 0;
                                      selectedHour = 0;
                                      selectedMin = 0;
                                      ampm = 'AM';
                                      note = "";
                                      click = 0;
                                      timeView = false;
                                      checkedValue = false;
                                      sendTime = "none";
                                      remind = "0";
                                      expertise = "";
                                      goalsLevel = "";
                                      cnt = cnt + 1;
                                    });
                                  } else {
                                    Navigator.pop(context);
                                    setState(() {
                                      selectedHour = 0;
                                      selectedMin = 0;
                                      ampm = 'AM';
                                      expertise = "";
                                      goalsLevel = "";
                                      note = "";
                                      click = 0;
                                      timeView = false;
                                      checkedValue = false;
                                      sendTime = "none";
                                      remind = "0";
                                      _disable = 0;
                                      _disable1 = 0;
                                      added[count - 1] = "";
                                      count = count - 1;
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
                                              topLeft: Radius.circular(12.0),
                                              topRight: Radius.circular(12.0))),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.lightBlueAccent,
                                    ));
                                  }
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
                              } else {
                                _sk.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                    "Click Done",
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
                          ),
                        ),
                      ],
                    ),
            ],
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

  void _load() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
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
}
