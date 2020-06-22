import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:march/ui/home.dart';
import 'package:http/http.dart' as http;
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:march/models/goal.dart';


class Select extends StatefulWidget {
  @override
  _SelectState createState() => _SelectState();
}
// this is for drop down
class Time{
  int id;
  String time;

  Time(this.id,this.time);

  static List<Time> getTime(){
    return <Time> [
      Time(1,'1 Month'),
      Time(2,'3 Month'),
      Time(3,'6 Month'),
      Time(4,'1 Year'),
      Time(5,'>1 Year'),
    ];
  }
}


class _SelectState extends State<Select> with SingleTickerProviderStateMixin {

  List<String> added = ["","",""];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  int count=0;
  final GlobalKey<ScaffoldState> _sk=GlobalKey<ScaffoldState>();
  List<String> suggestions = [
    "Sports",
    "Exam",
    "Health",
    "Music",
    "Dance",
    "Treking",
    "KickBoxing",
  ];
// drop down
  List<Time> _time=Time.getTime();
  var db = new DataBaseHelper();
  List<DropdownMenuItem<Time>> _dropdownMenuItems;
  Time _selectedTime;
  String time="1 Month";
// till here

  String target="";
  int cnt=1;
  String uid;
  String token;

  Color activeColor= Color(0xFF4267B2);
  AnimationController animationController;
  Animation d1, p1, d2, p2, d3, p3, d4, p4, d5;
  TextEditingController nameController;
  TextEditingController numberController;
  TextEditingController dateController;
  TextEditingController cvvController;


  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((val){
      setState(() {
        uid=val.uid;
      });
    });
//drop down
    _dropdownMenuItems =buildDropDownMenuItems(_time);
    _selectedTime=_dropdownMenuItems[0].value;
  //
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
  }


  //drop down

  List<DropdownMenuItem<Time>> buildDropDownMenuItems(List tim){
    List<DropdownMenuItem<Time>> items=List();
    for(Time time in tim){
      items.add(DropdownMenuItem(
        value:time,
        child: Text(time.time),
      )
      );
    }
    return items;
  }

  onChangeDropDownItem(Time selectedTime){
    setState(() {
      _selectedTime=selectedTime;
      time=selectedTime.time;
    });
  }

  //till here


  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    animationController.dispose();
    super.dispose();
  }


  int _disable=0;
  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    final dotSize = 20.0;

    return Scaffold(
      key: _sk,
      body: SingleChildScrollView(
        child: Container(
           height: MediaQuery.of(context).size.height,
           width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:50.0,bottom: 10.0),
                child: Center(child: Text("Select Your Goals",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
              ),


              AnimatedBuilder(
                animation: animationController,
                builder:(BuildContext context,Widget child)=>Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(top: 30),
                          padding: EdgeInsets.all(12),
                          width: MediaQuery.of(context).size.width,
                          child: Row(children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 0.5, color: activeColor)),
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
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  child: LinearProgressIndicator(
                                    backgroundColor: cnt>=2?activeColor:Colors.grey,
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(cnt>=2?activeColor:Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 0.5, color: cnt>=2?activeColor:Colors.grey)),
                              width: dotSize + 15,
                              height: dotSize + 15,
                              child: Center(
                                child: Container(
                                  width: dotSize,
                                  height: dotSize,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(dotSize / 2),
                                      color: cnt>=2?activeColor:Colors.grey),
                                ),
                              ),
                            ),
                            Container(
                              child: Center(
                                child: Container(
                                  height: 3,
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: LinearProgressIndicator(
                                    backgroundColor: cnt>=3?activeColor:Colors.grey,
                                    //  value: p1.value,
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(cnt>=3?activeColor:Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(width: 0.5,
                                    color: cnt>=3?activeColor:Colors.grey,
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
                                      color: cnt>=3?activeColor:Colors.grey
                                  ),
                                ),
                              ),
                            ),
                          ])),
                    ],
                  ),
                ) ,
              ),


         //      Center(child: Text("Goal "+cnt.toString()+" of 3")),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SimpleAutoCompleteTextField(
                key: key,
                decoration: new InputDecoration(
                  contentPadding:  const EdgeInsets.fromLTRB(15,15,15,5),
                  hintText: "Enter Your Goals",
                  border: new OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  )
                ),
                controller: TextEditingController(),
                suggestions: suggestions,
                textChanged: (text) => currentText = text,
                clearOnSubmit: true,
                textSubmitted: (text) => setState(() {
                  if (text != "" &&_disable==0) {

                    if(count<3){

                      added[count]=text;
                      count=count+1;
                      _disable=1;

                    }
                    else{
                      _sk.currentState.showSnackBar(SnackBar(
                        content: Text("You can Select only 3",
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
                  }
                  else{
                    _sk.currentState.showSnackBar(SnackBar(
                      content: Text("Enter all details and Submit next",
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

              _disable==1?Padding(
                padding: const EdgeInsets.fromLTRB(18.0,8,8,8),
                child: Row(
                  children: <Widget>[
                    Text("Selected Goal: ",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1)),),
                    Text(added[count-1])
                  ],
                ),
              ):Container(),


              //drop down
              Padding(
                padding: const EdgeInsets.fromLTRB(25.0,60,20.0,0),
                child: Row(
                  children: <Widget>[
                    Text('Time Frame : '),
                    SizedBox(width: 20,),
                    DropdownButton(
                      value: _selectedTime,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropDownItem,
                    ),
                  ],
                ),
              ),
              //
              Padding(
                padding: const EdgeInsets.only(top:25.0,left: 15),
                child: Text("Mention the target for your goal"),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(15.0,8,15,0),
                child: Container(
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Workout for an hour a day",
                      border: OutlineInputBorder(),
                    ),
                    controller: myController,
                    onChanged: (String value) {
                      try {
                        target = value;
                      } catch (exception) {
                        target ="";
                      }
                    },
                  ),
                ),
              ),


              cnt>1?Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                          child: FlatButton(
                            child: Text(
                              'SKIP',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'montserrat'
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.all(15),
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                              onPressed: () async {

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('log', 1);

                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) => Home('')),
                                        (Route<dynamic> route) => false);


                              }
                          ),
                        ),
                      ],
                    ),
                  ),

                  /*



                  */

                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                          child: FlatButton(
                              child: Text(
                                'NEXT',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'montserrat'
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.all(15),
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                            onPressed: () async {

                              if(target!="" && added[count-1]!=""){

                                _onLoading();
                                print('cnt :'+cnt.toString()+'time : '+time+' target :'+target);

/*
                                  var url= 'https://march.lbits.co/app/api/goals.php';
                                  var resp=await http.post(url,body: jsonEncode(<String, dynamic>{
                                    'uid':uid,
                                    'goal':added[count-1],
                                    'goal_number':count,
                                    'time_frame':time,
                                    'target':target
                                  }));
*/

                                var url= 'https://march.lbits.co/api/worker.php';
                                var resp=await http.post(url,
                                  headers: {
                                    'Content-Type':
                                    'application/json',
                                    'Authorization':
                                    'Bearer $token'
                                  },
                                  body: json.encode(<String, dynamic>
                                  {
                                    'serviceName': "",
                                    'work': "add goal",
                                    'uid':uid,
                                    'goalName':added[count-1],
                                    'target':target,
                                    'timeFrame':time,
                                    'goalNumber':count.toString(),
                                  }),
                                );


                                print(resp.body.toString());
                                var result = json.decode(resp.body);
                                if(count==3 && result['response'] == 200){

                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(builder: (context) => Home('')),
                                          (Route<dynamic> route) => false);

                                  int savedGoal =
                                  await db.saveGoal(new Goal(uid,added[count-1],target,time,count.toString()));

                                  print("goal saved :$savedGoal");

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setInt('log', 1);

                                }
                                else if(result['response'] == 200){

                                  int savedGoal =
                                  await db.saveGoal(new Goal(uid,added[count-1],target,time,count.toString()));

                                  print("goal saved :$savedGoal");


                                  Navigator.pop(context);
                                  setState(() {
                                    _disable=0;
                                    target="";
                                    myController.clear();
                                    time="1 Month";
                                    _selectedTime=_dropdownMenuItems[0].value;
                                    cnt=cnt+1;
                                  });
                                }
                                else{
                                  Navigator.pop(context);
                                  setState(() {
                                    _disable=0;
                                    target="";
                                    myController.clear();
                                    time="1 Month";
                                    _selectedTime=_dropdownMenuItems[0].value;
                                    cnt=cnt-1;
                                    added[count-1]="";
                                    count=count-1;
                                  });

                                  _sk.currentState.showSnackBar(SnackBar(
                                    content: Text("There is Some Technical Problem Submit again",
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
                              }
                              else{
                                _sk.currentState.showSnackBar(SnackBar(
                                  content: Text("Enter all details and Submit next",
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
                  ),
                ],
              ):Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                    child: FlatButton(
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'montserrat'
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(15),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {
                        if(target!="" && added[0]!=""){
                          _onLoading();
                          print('cnt :'+cnt.toString()+'time : '+time+' target :'+target);

/*
                            var url= 'https://march.lbits.co/app/api/goals.php';
                            var resp=await http.post(url,body: jsonEncode(<String, dynamic>{
                              'uid':uid,
                              'goal':added[count-1],
                              'goal_number':count,
                              'time_frame':time,
                              'target':target
                            }));
*/


                          var url= 'https://march.lbits.co/api/worker.php';
                          var resp=await http.post(url,
                            headers: {
                              'Content-Type':
                              'application/json',
                              'Authorization':
                              'Bearer $token'
                            },
                            body: json.encode(<String, dynamic>
                            {
                              'serviceName': "",
                              'work': "add goal",
                              'uid':uid,
                              'goalName':added[count-1],
                              'target':target,
                              'timeFrame':time,
                              'goalNumber':count.toString(),
                            }),
                          );

                          print(resp.body.toString());
                          var result = json.decode(resp.body);
                          if(result['response'] == 200){

                            int savedGoal =
                            await db.saveGoal(new Goal(uid,added[count-1],target,time,count.toString()));

                            print("goal saved :$savedGoal");

                            Navigator.pop(context);
                            setState(() {
                              _disable=0;
                              target="";
                              myController.clear();
                              time="1 Month";
                              _selectedTime=_dropdownMenuItems[0].value;
                              cnt=cnt+1;
                            });

                          }
                          else{
                            Navigator.pop(context);
                            setState(() {
                              _disable=0;
                              target="";
                              myController.clear();
                              time="1 Month";
                              _selectedTime=_dropdownMenuItems[0].value;
                              cnt=cnt+1;
                              added[count-1]="";
                              count=count-1;
                            });

                            _sk.currentState.showSnackBar(SnackBar(
                              content: Text("There is Some Technical Problem Submit again",
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
                        }
                        else{
                          _sk.currentState.showSnackBar(SnackBar(
                            content: Text("Enter all details and Submit next",
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


  /*


   */
  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Loading"),
              ],
            ),
          ),
        );
      },
    );
  }
  void _load() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('token');
    });
  }
}
