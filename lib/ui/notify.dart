import 'dart:convert';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:march/support/custom_week_day_labels_row.dart';
import 'package:march/support/day_tile_builder.dart';
import 'package:march/ui/remind.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:worm_indicator/shape.dart';
import 'package:worm_indicator/worm_indicator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'home.dart';


class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
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

class _NotifyState extends State<Notify> {

  List goals=["","",""];
  List time=["","",""];
  List target=["","",""];
  int g1,g2,g3;
  List<DateTime> date1=[];
  List<String> d1=[];
  List<DateTime> date2=[];
  List<String> d2=[];
  List<DateTime> date3=[];
  List<String> d3=[];
  String currentText = "";
  String selected_goal1="";
  String selected_goal2="";
  String selected_goal3="";
  bool _edit1=false;
  bool _edit2=false;
  bool _edit3=false;
  List months = ['January','February','March','April','May','June','July','August','September','October','November','December'];
  int len=1;
  GlobalKey<AutoCompleteTextFieldState<String>> key1 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key2 = new GlobalKey();
  GlobalKey<AutoCompleteTextFieldState<String>> key3 = new GlobalKey();
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
  Time _selectedTime1;
  String time1="1 Month";
  Time _selectedTime2;
  String time2="1 Month";
  Time _selectedTime3;
  String time3="1 Month";

  int _disable1=0;
  int _disable2=0;
  int _disable3=0;
  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;


  PageController _controller = PageController(
    initialPage: 0,
    viewportFraction: 1
  );

  String uid;
  @override
  void initState() {
     _load();
    _dropdownMenuItems =buildDropDownMenuItems(_time);
    _selectedTime1=_dropdownMenuItems[0].value;
    _selectedTime2=_dropdownMenuItems[0].value;
    _selectedTime3=_dropdownMenuItems[0].value;
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget slide1(){

    var now = new DateTime.now();
    int month=int.parse(now.month.toString());
    String currentMon = months[month-1];
    String year=now.year.toString();

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2.0), //Same as `blurRadius` i guess
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
               Row(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Center(child: Padding(
                          padding: const EdgeInsets.only(left:35.0),
                          child: Text(goals[0]!=""?goals[0]:"",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat',fontSize: 20),),
                        ))),
                    IconButton(icon: Icon(Icons.edit,size: 18,color: Color.fromRGBO(63, 92, 200, 1),),
                    onPressed: (){
                      setState(() {
                        _edit1=true;
                      });
                    },)
                  ],
                ),

              Text("Did you work on your goal today?"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async{
                  if(d1.length>0){
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    if(d1[d1.length-1].substring(0,10)!=now.toString().substring(0,10)){
                      setState(() {
                        g1=g1+1;
                       int n=g1+1;
                        date1.add(DateTime.now());
                        d1.add(DateTime.now().toString());
                        prefs.setInt('g1', n);
                        prefs.setStringList('date1', d1);
                      });
                    }

                  }
                  else{

                    setState(() {
                      g1=g1+1;
                      date1.add(DateTime.now());
                      d1.add(DateTime.now().toString());
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('g1', g1);
                    prefs.setStringList('date1', d1);

                  }


                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.042,
                  width: MediaQuery.of(context).size.width*0.45,
                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Yes")),
                  ),

                ),
              ),
              GestureDetector(
                onTap: (){

                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.042,
                  width: MediaQuery.of(context).size.width*0.45,
                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text("No")),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(15,8,0,0),
                child: Row(
                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Image.asset("assets/images/streak.png"),
                            ),
                            Text(g1!=null?g1.toString():"0",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ),),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,15,8),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6.0),
                        ),
                        color: Color.fromRGBO(63, 92, 200, 1) ,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Remind()),
                          );
                        },
                        child: const Text(
                            'Remind me',
                            style: TextStyle(fontSize: 12,color: Colors.white)

                        ),
                      ),
                    ),


                  ],
                ),
              ),


              Container(
                height: MediaQuery.of(context).size.height*0.415,
                width: MediaQuery.of(context).size.width*0.85,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currentMon+" "+year),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Calendarro(
                            startDate: DateUtils.getFirstDayOfCurrentMonth(),
                            endDate: DateUtils.getLastDayOfCurrentMonth(),
                            displayMode: DisplayMode.MONTHS,
                            selectionMode: SelectionMode.MULTI,
                            selectedDates: date1!=null?date1:[],
                            weekdayLabelsRow: CustomWeekdayLabelsRow(),
                            dayTileBuilder: CustomDayTileBuilder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }




  Widget slide2(){

    var now = new DateTime.now();
    int month=int.parse(now.month.toString());
    String currentMon = months[month-1];
    String year=now.year.toString();

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2.0), //Same as `blurRadius` i guess
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Center(child: Padding(
                        padding: const EdgeInsets.only(left:35.0),
                        child: Text(goals[1]!=""?goals[1]:"",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat',fontSize: 20),),
                      ))),
                  IconButton(icon: Icon(Icons.edit,size: 18,color: Color.fromRGBO(63, 92, 200, 1),),onPressed: (){
                    setState(() {
                      _edit2=true;
                    });
                  },)
                ],
              ),
              Text("Did you work on your goal today?"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async{
                  if(d2.length>0){
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    if(d2[d2.length-1].substring(0,10)!=now.toString().substring(0,10)){
                      setState(() {
                        g2=g2+1;
                        int n=g2+1;
                        date2.add(DateTime.now());
                        d2.add(DateTime.now().toString());
                        prefs.setInt('g2', n);
                        prefs.setStringList('date2', d2);
                      });
                    }

                  }
                  else{

                    setState(() {
                      g2=g2+1;
                      date2.add(DateTime.now());
                      d2.add(DateTime.now().toString());
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('g2', g2);
                    prefs.setStringList('date2', d2);

                  }


                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.042,
                  width: MediaQuery.of(context).size.width*0.45,
                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Yes")),
                  ),

                ),
              ),
              GestureDetector(
                onTap: (){

                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.042,
                  width: MediaQuery.of(context).size.width*0.45,
                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text("No")),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(15,8,0,0),
                child: Row(
                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Image.asset("assets/images/streak.png"),
                            ),
                            Text(g2!=null?g2.toString():"0",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ),),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,15,8),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6.0),
                        ),
                        color: Color.fromRGBO(63, 92, 200, 1) ,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Remind()),
                          );
                        },
                        child: const Text(
                            'Remind me',
                            style: TextStyle(fontSize: 12,color: Colors.white)

                        ),
                      ),
                    ),


                  ],
                ),
              ),


              Container(
                height: MediaQuery.of(context).size.height*0.415,
                width: MediaQuery.of(context).size.width*0.85,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currentMon+" "+year),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Calendarro(
                            startDate: DateUtils.getFirstDayOfCurrentMonth(),
                            endDate: DateUtils.getLastDayOfCurrentMonth(),
                            displayMode: DisplayMode.MONTHS,
                            selectionMode: SelectionMode.MULTI,
                            selectedDates: date2!=null?date2:[],
                            weekdayLabelsRow: CustomWeekdayLabelsRow(),
                            dayTileBuilder: CustomDayTileBuilder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget slide3(){

    var now = new DateTime.now();
    int month=int.parse(now.month.toString());
    String currentMon = months[month-1];
    String year=now.year.toString();

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2.0), //Same as `blurRadius` i guess
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
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Center(child: Padding(
                        padding: const EdgeInsets.only(left:35.0),
                        child: Text(goals[2]!=""?goals[2]:"",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat',fontSize: 20),),
                      ))),
                  IconButton(icon: Icon(Icons.edit,size: 18,color: Color.fromRGBO(63, 92, 200, 1),),
                  onPressed:(){
                    setState(() {
                      _edit3=true;
                    });
                  }),
                ],
              ),
              Text("Did you work on your goal today?"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async{
                  if(d3.length>0){
                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    if(d3[d3.length-1].substring(0,10)!=now.toString().substring(0,10)){
                      setState(() {
                        g3=g3+1;
                        int n=g3+1;
                        date3.add(DateTime.now());
                        d3.add(DateTime.now().toString());
                        prefs.setInt('g3', n);
                        prefs.setStringList('date3', d3);
                      });
                    }

                  }
                  else{

                    setState(() {
                      g3=g3+1;
                      date3.add(DateTime.now());
                      d3.add(DateTime.now().toString());
                    });
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('g3', g3);
                    prefs.setStringList('date3', d3);

                  }


                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.042,
                  width: MediaQuery.of(context).size.width*0.45,
                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text("Yes")),
                  ),

                ),
              ),
              GestureDetector(
                onTap: (){

                },
                child: Container(
                  height: MediaQuery.of(context).size.height*0.042,
                  width: MediaQuery.of(context).size.width*0.45,
                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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
                    padding: const EdgeInsets.all(8),
                    child: Center(child: Text("No")),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(15,8,0,0),
                child: Row(
                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Image.asset("assets/images/streak.png"),
                            ),
                            Text(g3!=null?g3.toString():"0",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ),),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,15,8),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6.0),
                        ),
                        color: Color.fromRGBO(63, 92, 200, 1) ,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Remind()),
                          );
                        },
                        child: const Text(
                            'Remind me',
                            style: TextStyle(fontSize: 12,color: Colors.white)

                        ),
                      ),
                    ),


                  ],
                ),
              ),


              Container(
                height: MediaQuery.of(context).size.height*0.415,
                width: MediaQuery.of(context).size.width*0.85,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(currentMon+" "+year),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0),
                          child: Calendarro(
                            startDate: DateUtils.getFirstDayOfCurrentMonth(),
                            endDate: DateUtils.getLastDayOfCurrentMonth(),
                            displayMode: DisplayMode.MONTHS,
                            selectionMode: SelectionMode.MULTI,
                            selectedDates: date3!=null?date3:[],
                            weekdayLabelsRow: CustomWeekdayLabelsRow(),
                            dayTileBuilder: CustomDayTileBuilder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget goals1(){

    final myController = TextEditingController();
    String target1="";
    onChangeDropDownItem(Time selectedTime){
      setState(() {
        _selectedTime1=selectedTime;
        time1=selectedTime.time;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*0.74,
          width: MediaQuery.of(context).size.width*0.9,
          margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SimpleAutoCompleteTextField(
                    key: key1,
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
                      if (text != "" && _disable1==0) {
                        print(text);
                        setState(() {
                          _disable1=1;
                          selected_goal1=text;
                        });
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

                _disable1==1?Padding(
                  padding: const EdgeInsets.fromLTRB(18.0,8,8,8),
                  child: Row(
                    children: <Widget>[
                      Text("Selected Goal:  ",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1)),),
                      Text(selected_goal1)
                    ],
                  ),
                ):Container(),


                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0,60,20.0,0),
                  child: Row(
                    children: <Widget>[
                      Text('Time Frame : '),
                      SizedBox(width: 20,),
                      DropdownButton(
                        value: _selectedTime1,
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
                          target1 = value;
                        } catch (exception) {
                          target1 ="";
                        }
                      },
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top:15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.15,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(6.0),
                              ),
                              color: Color.fromRGBO(63, 92, 200, 1) ,
                              onPressed: () {
                                setState(() {
                                  target1="";
                                  time1="1 Month";
                                  selected_goal1="";
                                  _disable1=0;
                                  myController.clear();
                                  _selectedTime1=_dropdownMenuItems[0].value;
                                });

                              },
                              child: const Text(
                                  'Clear',
                                  style: TextStyle(fontSize: 12,color: Colors.white)

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
                            width: MediaQuery.of(context).size.width*0.15,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(6.0),
                              ),
                              color: Color.fromRGBO(63, 92, 200, 1) ,
                              onPressed: () async{

                                print(time1+target1+selected_goal1);
/*
                                if(selected_goal1!=""&&myController.text!=""){

                                  _onLoading();
                                  print('time : '+time1+' target :'+target1);

                                  var url= 'https://march.lbits.co/app/api/goals.php';
                                  var resp=await http.post(url,body: jsonEncode(<String, dynamic>{
                                    'uid':uid,
                                    'goal':selected_goal1,
                                    'goal_number':1,
                                    'time_frame':time1,
                                    'target':target1
                                  }));

                                  print(resp.body.toString());
                                  if(resp.body.toString()==' success'){
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) => Home('')),
                                            (Route<dynamic> route) => false);

                                  }
                                  else{
                                    Navigator.pop(context);
                                    setState(() {
                                      _disable1=0;
                                      target1="";
                                      myController.clear();
                                      time1="1 Month";
                                      _selectedTime1=_dropdownMenuItems[0].value;
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
                                    content: Text("Enter all Details",
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
*/

                              },
                              child: const Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 12,color: Colors.white)

                              ),
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
    );
  }

  Widget goals2(){

    final myController = TextEditingController();
    String target2="";
    onChangeDropDownItem(Time selectedTime){
      setState(() {
        _selectedTime2=selectedTime;
        time2=selectedTime.time;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*0.74,
          width: MediaQuery.of(context).size.width*0.9,
          margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SimpleAutoCompleteTextField(
                    key: key2,
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
                      if (text != "" && _disable2==0) {
                        print(text);
                        setState(() {
                          _disable2=1;
                          selected_goal2=text;
                        });
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

                _disable2==1?Padding(
                  padding: const EdgeInsets.fromLTRB(18.0,8,8,8),
                  child: Row(
                    children: <Widget>[
                      Text("Selected Goal:  ",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1)),),
                      Text(selected_goal2)
                    ],
                  ),
                ):Container(),


                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0,60,20.0,0),
                  child: Row(
                    children: <Widget>[
                      Text('Time Frame : '),
                      SizedBox(width: 20,),
                      DropdownButton(
                        value: _selectedTime2,
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
                          target2 = value;
                        } catch (exception) {
                          target2 ="";
                        }
                      },
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.only(top:15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width*0.15,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(6.0),
                              ),
                              color: Color.fromRGBO(63, 92, 200, 1) ,
                              onPressed: () {
                                setState(() {
                                  target2="";
                                  time2="1 Month";
                                  selected_goal2="";
                                  _disable2=0;
                                  myController.clear();
                                  _selectedTime2=_dropdownMenuItems[0].value;
                                });

                              },
                              child: const Text(
                                  'Clear',
                                  style: TextStyle(fontSize: 12,color: Colors.white)

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
                            width: MediaQuery.of(context).size.width*0.15,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(6.0),
                              ),
                              color: Color.fromRGBO(63, 92, 200, 1) ,
                              onPressed: () async{

                                if(selected_goal2!=""&&myController.text!=""){

                                  _onLoading();
                                  print('time : '+time2+' target :'+target2);

                                  var url= 'https://march.lbits.co/app/api/goals.php';
                                  var resp=await http.post(url,body: jsonEncode(<String, dynamic>{
                                    'uid':uid,
                                    'goal':selected_goal2,
                                    'goal_number':2,
                                    'time_frame':time2,
                                    'target':target2
                                  }));

                                  print(resp.body.toString());
                                  if(resp.body.toString()==' success'){
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) => Home('')),
                                            (Route<dynamic> route) => false);

                                  }
                                  else{
                                    Navigator.pop(context);
                                    setState(() {
                                      _disable2=0;
                                      target2="";
                                      myController.clear();
                                      time2="1 Month";
                                      _selectedTime2=_dropdownMenuItems[0].value;
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
                                    content: Text("Enter all Details",
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
                              child: const Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 12,color: Colors.white)

                              ),
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
    );
  }


  Widget goals3(){

    final myController = TextEditingController();
    String target3="";
    onChangeDropDownItem(Time selectedTime){
      setState(() {
        _selectedTime3=selectedTime;
        time3=selectedTime.time;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height*0.74,
          width: MediaQuery.of(context).size.width*0.9,
          margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
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

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SimpleAutoCompleteTextField(
                    key: key3,
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
                      if (text != "" && _disable3==0) {
                        print(text);
                        setState(() {
                          _disable3=1;
                          selected_goal3=text;
                        });
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

                _disable3==1?Padding(
                  padding: const EdgeInsets.fromLTRB(18.0,8,8,8),
                  child: Row(
                    children: <Widget>[
                      Text("Selected Goal: ",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1)),),
                      Text(selected_goal3)
                    ],
                  ),
                ):Container(),


                Padding(
                  padding: const EdgeInsets.fromLTRB(25.0,60,20.0,0),
                  child: Row(
                    children: <Widget>[
                      Text('Time Frame : '),
                      SizedBox(width: 20,),
                      DropdownButton(
                        value: _selectedTime3,
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
                          target3 = value;
                        } catch (exception) {
                          target3 ="";
                        }
                      },
                    ),
                  ),
                ),


               Padding(
                 padding: const EdgeInsets.only(top:15.0),
                 child: Row(
                   children: <Widget>[
                     Expanded(
                       flex: 1,
                       child: Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: SizedBox(
                           width: MediaQuery.of(context).size.width*0.15,
                           child: RaisedButton(
                             shape: RoundedRectangleBorder(
                               borderRadius: new BorderRadius.circular(6.0),
                             ),
                             color: Color.fromRGBO(63, 92, 200, 1) ,
                             onPressed: () {
                               setState(() {
                                 target3="";
                                 time3="1 Month";
                                 selected_goal3="";
                                 _disable3=0;
                                 myController.clear();
                                 _selectedTime3=_dropdownMenuItems[0].value;
                               });

                             },
                             child: const Text(
                                 'Clear',
                                 style: TextStyle(fontSize: 12,color: Colors.white)

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
                           width: MediaQuery.of(context).size.width*0.15,
                           child: RaisedButton(
                             shape: RoundedRectangleBorder(
                               borderRadius: new BorderRadius.circular(6.0),
                             ),
                             color: Color.fromRGBO(63, 92, 200, 1) ,
                             onPressed: () async{

                               if(selected_goal3!=""&&myController.text!=""){

                                 _onLoading();
                                 print('time : '+time3+' target :'+target3);

                                 var url= 'https://march.lbits.co/app/api/goals.php';
                                 var resp=await http.post(url,body: jsonEncode(<String, dynamic>{
                                   'uid':uid,
                                   'goal':selected_goal3,
                                   'goal_number':3,
                                   'time_frame':time3,
                                   'target':target3
                                 }));

                                 print(resp.body.toString());
                                 if(resp.body.toString()==' success'){
                                   Navigator.pushAndRemoveUntil(context,
                                       MaterialPageRoute(builder: (context) => Home('')),
                                           (Route<dynamic> route) => false);

                                 }
                                 else{
                                   Navigator.pop(context);
                                   setState(() {
                                     _disable3=0;
                                     target3="";
                                     myController.clear();
                                     time3="1 Month";
                                     _selectedTime3=_dropdownMenuItems[0].value;
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
                                   content: Text("Enter all Details",
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
                             child: const Text(
                                 'Submit',
                                 style: TextStyle(fontSize: 12,color: Colors.white)

                             ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sk,
     resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                child: _edit1?goals1():slide1(),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                child:_edit2?goals2():len>1 ?slide2():goals2(),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                child:_edit3?goals3():len>2 ?slide3():goals3(),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: Align(
                alignment:Alignment.bottomCenter,
                child: WormIndicator(
                  indicatorColor: Color.fromRGBO(63, 92, 200, 1),
                  color: Color.fromRGBO(63, 92, 200, 0.4),
                  length: 3,
                  controller: _controller,
                  shape: Shape(
                      size: 6,
                      spacing: 3,
                      shape: DotShape.Circle // Similar for Square
                  ),
                ),
            ),
          ),

        ],
      )
    );
  }
  void _load() async{

    var now = new DateTime.now();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('uid')??"";
    setState(() {
      uid=id;
    });

    var url = 'https://march.lbits.co/app/api/goals.php?uid='+id;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      for(var i=0;i<jsonResponse.length;i++){
        setState(() {
          goals[i]=jsonResponse[i]['goal'];
   //       time[i]=jsonResponse[i]['time_frame'];
   //       target[i]=jsonResponse[i]['target'];
        });
      }
      setState(() {
        len=jsonResponse.length;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }

    int goal1 = prefs.getInt('g1')??0;
    int goal2 = prefs.getInt('g2')??0;
    int goal3 = prefs.getInt('g3')??0;


    setState(() {
      d1=prefs.getStringList("date1")??[];
      for(var i=0;i<d1.length;i++){
        date1.add(DateTime.parse(d1[i]));
      }
      if(d1.length>0){
        if(d1[d1.length-1].substring(0,10)==DateTime(now.year,now.month,now.day-1).toString().substring(0,10)){
          g1=goal1;
        }
        else if(d1.length==1){
          g1=1;
        }
        else{
          g1=0;
        }
      }
      else{
        g1=0;
      }
// check this
      if(now.day==1){
        prefs.setStringList("date1",[]);
      }

      if(len>1){

        d2=prefs.getStringList("date2")??[];
        for(var i=0;i<d2.length;i++){
          date2.add(DateTime.parse(d2[i]));
        }
        if(d2.length>0){
          if(d2[d2.length-1].substring(0,10)==DateTime(now.year,now.month,now.day-1).toString().substring(0,10)){
            g2=goal2;
          }
          else if(d1.length==1){
            g2=1;
          }
          else{
            g2=0;
          }
        }
        else{
          g2=0;
        }
// check this
        if(now.day==1){
          prefs.setStringList("date2",[]);
        }
      }

      if(len>2){

        d3=prefs.getStringList("date3")??[];
        for(var i=0;i<d3.length;i++){
          date3.add(DateTime.parse(d3[i]));
        }
        if(d3.length>0){
          if(d3[d3.length-1].substring(0,10)==DateTime(now.year,now.month,now.day-1).toString().substring(0,10)){
            g3=goal3;
          }
          else if(d1.length==1){
            g3=1;
          }
          else{
            g3=0;
          }
        }
        else{
          g3=0;
        }
// check this
        if(now.day==1){
          prefs.setStringList("date3",[]);
        }
      }


    });


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