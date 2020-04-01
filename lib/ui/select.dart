import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:march/ui/home.dart';

class Select extends StatefulWidget {
  @override
  _SelectState createState() => _SelectState();
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
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:50.0,bottom: 10.0),
                child: Center(child: Text("Select Your Goals",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)),
              ),

               Text("Goal "+count.toString()+" of 3"),

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
                  if (text != "") {

                    if(count<3){

                      added[count]=text;
                      count=count+1;
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


              count>0?Padding(
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
                        onTap: () {

                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(builder: (context) => Home()),
                                  (Route<dynamic> route) => false);


                        },
                        child: Center(
                          child: Text(count==3?"NEXT":"SKIP",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  letterSpacing: 1.0)),
                        ),
                      ),
                    ),
                  ),
                ),
              ):Container(),
            ],
          ),
        ),
      ),
    );
  }
}
