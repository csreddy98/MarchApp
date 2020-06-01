import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Remind extends StatefulWidget {
  @override
  RemindState createState() => RemindState();
}

class RemindState extends State {

  bool viewVisible = false ;

  final GlobalKey<ScaffoldState> _sk=GlobalKey<ScaffoldState>();

  int selectedHour=0;
  int selectedMin=0;
  int meridian;
  String ampm="AM";

  TextEditingController myController = TextEditingController();

  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _sk,
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment:  CrossAxisAlignment.start ,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                       flex:1,
                      child: Container(),
                     ),
                    IconButton(
                      onPressed: (){
                        Navigator.of(context).pop(null);
                      },
                      icon: Icon(Icons.clear,
                        color: Colors.black,
                      ),
                      iconSize: 35,
                      color: Colors.black,
                    )
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:20.0),
                child: Text("Write a Note",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10,right: 20),
                child: TextField(
                  controller: myController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      hintText: "It's Time to Work on your goal"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left:20.0,top: 5,right: 20),
                child: Text("This will be the text on the remainder notification",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10,right: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Remind me",
                      style: TextStyle(
                          fontSize: 20
                      ),),
                    SizedBox(width: size.width/2.29),
                    myController.text!=""?Switch(
                      activeColor: Colors.white,
                      inactiveThumbColor: Colors.white,
                      activeTrackColor: Colors.green,
                      inactiveTrackColor: Colors.red,
                      value: viewVisible,
                      onChanged: (newval){
                        if(newval){
                          setState(() {
                            viewVisible = true ;
                          });
                        }
                        else{
                          setState(() {
                            viewVisible = false ;
                          });
                        }
                      },
                    ):GestureDetector(
                      onTap: (){
                        _sk.currentState.showSnackBar(SnackBar(
                          content: Text("Note Should not be Empty",
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

                      },
                      child: Switch(
                        activeColor: Colors.white,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.red,
                        value: false,
                        onChanged: null,
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 5,right: 20),
                child: Divider(thickness: 1,),
              ),

              Center(
                child: Visibility(
                    maintainSize: true,
                    maintainAnimation: true,
                    maintainState: true,
                    visible: viewVisible,
                    child: Container(
                        height: size.height/2.9,
                        width: size.width/1.14,
                        margin: EdgeInsets.only(top: 5, bottom: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Text('Remind me Everyday at $selectedHour:$selectedMin $ampm',
                                style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1),
                                    fontSize: 18)),
                            Padding(
                              padding: const EdgeInsets.only(top:8.0),
                              child: Divider(thickness: 1,),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(left:30),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      width: size.width/4.5,
                                      height: size.height/4,
                                      child: CupertinoPicker(
                                        backgroundColor: Colors.transparent,
                                        itemExtent: 50,
                                        onSelectedItemChanged: (int index){
                                          setState(() {
                                            selectedHour = index+1;
                                          });
                                          print("$selectedHour");
                                        },
                                        children: <Widget>[
                                          Text("01"), Text("02"),
                                          Text("03"), Text("04"),
                                          Text("05"), Text("06"),
                                          Text("07"),Text("08"),
                                          Text("09"),Text("10"),
                                          Text("11"),Text("12"),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: size.width/50,),
                                  Container(
                                    width: 75,
                                    height: 100,
                                    child: CupertinoPicker(
                                      backgroundColor: Colors.transparent,
                                      itemExtent: 50,
                                      children: <Widget>[
                                        Text("01"), Text("02"),
                                        Text("03"), Text("04"),
                                        Text("05"), Text("06"),
                                        Text("07"),Text("08"),
                                        Text("09"),Text("10"),
                                        Text("11"),Text("12"),
                                        Text("13"), Text("14"),
                                        Text("15"), Text("16"),
                                        Text("17"), Text("18"),
                                        Text("19"),Text("20"),
                                        Text("21"),Text("22"),
                                        Text("23"),Text("24"),
                                        Text("25"), Text("26"),
                                        Text("27"), Text("28"),
                                        Text("29"), Text("30"),
                                        Text("31"),Text("32"),
                                        Text("33"),Text("34"),
                                        Text("35"),Text("36"),
                                        Text("37"), Text("38"),
                                        Text("39"), Text("40"),
                                        Text("41"), Text("42"),
                                        Text("43"),Text("44"),
                                        Text("45"),Text("46"),
                                        Text("47"),Text("48"),
                                        Text("49"), Text("50"),
                                        Text("51"), Text("52"),
                                        Text("53"), Text("54"),
                                        Text("55"),Text("56"),
                                        Text("57"),Text("58"),
                                        Text("59"),
                                      ],
                                      onSelectedItemChanged: (int index){
                                        setState(() {
                                          selectedMin = index+1;
                                        });
                                        print("$selectedMin");
                                      },
                                    ),
                                  ),
                                  SizedBox(width: size.width/50,),
                                  Center(
                                    child: Container(
                                      width: 75,
                                      height: 115,
                                      child: CupertinoPicker(
                                        backgroundColor: Colors.transparent,
                                        itemExtent: 50,
                                        onSelectedItemChanged: (int index){
                                          if(index==0) {
                                            setState(() {
                                              ampm = "AM";
                                            });
                                          }
                                          else{
                                            setState(() {
                                              ampm = "PM";
                                            });
                                          }
                                        },
                                        children: <Widget>[
                                          Text("AM"), Text("PM"),
                                        ],
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                            ),

                          ],
                        )
                    )
                ),
              ),
            ]
        ),
      ),
    );
  }
}