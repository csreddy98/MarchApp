import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:march/ui/home.dart';
import 'package:http/http.dart' as http;

class Select extends StatefulWidget {
  @override
  _SelectState createState() => _SelectState();
}

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


class _SelectState extends State<Select> {

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

  List<Time> _time=Time.getTime();
  List<DropdownMenuItem<Time>> _dropdownMenuItems;
  Time _selectedTime;
  String time="1 Month";
  String target="";
  int cnt=1;
  String uid;

  @override
  void initState() {
    // TODO: implement initState

    FirebaseAuth.instance.currentUser().then((val){
      setState(() {
        uid=val.uid;
      });
    });

    _dropdownMenuItems =buildDropDownMenuItems(_time);
    _selectedTime=_dropdownMenuItems[0].value;
    super.initState();
  }

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

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }


  int _disable=0;
  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
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

               Center(child: Text("Goal "+cnt.toString()+" of 3")),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SimpleAutoCompleteTextField(
                key: key,
                decoration: new InputDecoration(
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
                  if (text != "" && _disable==0) {

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

               Row(
              children: <Widget>[
               added[0]!=""? Padding(
                 padding: const EdgeInsets.fromLTRB(25.0,0,8.0,8.0),
                 child: Container(
                   margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20.0),
                     color: Colors.white,
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey,
                         offset: Offset(0.0, 1.0), //(x,y)
                         blurRadius: 6.0,
                       ),
                     ],
                   ),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right:3.0),
                            child: Text(added[0],style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(added[1]==""&&added[2]==""){
                                    added[0]="";
                                    count=count-1;
                                  }

    //                              added.removeAt(0);
                                });
                              },
                              child: Icon(Icons.clear,size: 18,))
                        ],
                      ),
                   ),
                  ),
               ):Container(),
                added[1]!=""? Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,0,8.0,8.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right:3.0),
                            child: Text(added[1],style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(added[2]==""){
                                    added[1]="";
                                    count=count-1;
                                  }

  //                                added.removeAt(1);
                                });
                              },
                              child: Icon(Icons.clear,size: 18,))
                        ],
                      ),
                    ),
                  ),
                ):Container(),
                added[2]!=""? Padding(
                  padding: const EdgeInsets.fromLTRB(8.0,0,8.0,8.0),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right:3.0),
                            child: Text(added[2],style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          GestureDetector(
                              onTap: (){
                                setState(() {
                                    added[2]="";
                                    count=count-1;
//                                  added.removeAt(2);
                                });
                              },
                              child: Icon(Icons.clear,size: 18,))
                        ],
                      ),
                    ),
                  ),
                ):Container(),
              ],
            ),

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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,50,0,0),
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 5, left: 10,right: 15),
                          width: MediaQuery.of(context).size.width*0.3,
                          height: ScreenUtil().setHeight(80),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.red, Colors.deepPurple]),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(.3),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Container(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.grey,
                              onTap: () {

                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) => Home()),
                                        (Route<dynamic> route) => false);


                              },
                              child: Center(
                                child: Text("SKIP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0,50,0,0),
                      child: InkWell(
                        child: Container(
                          margin: EdgeInsets.only(top: 5, left: 10,right: 15),
                          width: MediaQuery.of(context).size.width*0.3,
                          height: ScreenUtil().setHeight(80),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.red, Colors.deepPurple]),
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xFF6078ea).withOpacity(.3),
                                    offset: Offset(0.0, 8.0),
                                    blurRadius: 8.0)
                              ]),
                          child: Container(
                            color: Colors.transparent,
                            child: InkWell(
                              splashColor: Colors.grey,
                              onTap: () async {

                                if(target!="" && added[count-1]!=""){

                                   _onLoading();
                                  print('cnt :'+cnt.toString()+'time : '+time+' target :'+target);

                                  var url= 'https://march.lbits.co/app/api/goals.php';
                                  var resp=await http.post(url,body: jsonEncode(<String, dynamic>{
                                    'uid':uid,
                                    'goal':added[count-1],
                                    'goal_number':count,
                                    'time_frame':time,
                                    'target':target
                                  }));

                                  print(resp.body.toString());

                                  if(count==3 && resp.body.toString()==' success'){

                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) => Home()),
                                            (Route<dynamic> route) => false);

                                  }
                                  else if(resp.body.toString()==' success'){
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
                              child: Center(
                                child: Text("NEXT",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: 1.0)),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ):Padding(
                padding: const EdgeInsets.fromLTRB(0,50,0,0),
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 10,right: 15),
                    width: MediaQuery.of(context).size.width*0.8,
                    height: ScreenUtil().setHeight(80),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.red, Colors.deepPurple]),
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFF6078ea).withOpacity(.3),
                              offset: Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Container(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: Colors.grey,
                        onTap: () async {
                          if(target!="" && added[0]!=""){
                            _onLoading();
                            print('cnt :'+cnt.toString()+'time : '+time+' target :'+target);

                            var url= 'https://march.lbits.co/app/api/goals.php';
                            var resp=await http.post(url,body: jsonEncode(<String, dynamic>{
                              'uid':uid,
                              'goal':added[count-1],
                              'goal_number':count,
                              'time_frame':time,
                              'target':target
                            }));

                            print(resp.body.toString());
                            if(resp.body.toString()==' success'){
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
                        child: Center(
                          child: Text("NEXT",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1.0)),
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
    );
  }

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
}
