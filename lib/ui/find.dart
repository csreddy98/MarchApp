import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Find extends StatefulWidget {
  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {

  String goal1="BasketBall";
  String goal2="FootBall";
  String goal3="Dance";

  List names=["Rajamouli","Samantha Akinneni"];
  List profile=["https://upload.wikimedia.org/wikipedia/commons/thumb/7/7f/S._S._Rajamouli_at_the_trailer_launch_of_Baahubali.jpg/220px-S._S._Rajamouli_at_the_trailer_launch_of_Baahubali.jpg","https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/Samantha_At_The_Irumbu_Thirai_Trailer_Launch.jpg/220px-Samantha_At_The_Irumbu_Thirai_Trailer_Launch.jpg"];
  List goals=["Cricket , Travel","Cricket , Travel"];
  List age=["20 Years old","25 Years old"];
  List distance =["4 Km away","4 Km away"];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(left:15.0,right: 15.0),
                child: TextField(
/*
                  controller: controller,
                  focusNode: focusNode,
*/
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  decoration: InputDecoration(
                   /* focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor),
                    ),*/
                    suffixIcon: Icon(Icons.search),
                    hintText: "Search People...",
                    contentPadding: const EdgeInsets.only(
                      left: 16,
                      right: 20,
                      top: 14,
                      bottom: 14,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left:15.0,top:5,bottom:5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex:1,
                        child: Text("Featured",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color.fromRGBO(63, 92, 200, 1)),)),
                    Padding(
                      padding: const EdgeInsets.only(right:15.0),
                      child: Icon(Icons.list),
                    )
                  ],
                ),
              ),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height*0.75,
                child: ListView.builder(
                  itemCount: 2,
                  itemBuilder: (context, i) {
                    return  Padding(
                      padding: const EdgeInsets.fromLTRB(15,5,15,5),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(25.0,8,8,8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15.0),
                                      child: Image.network(
                                        profile[i],
                                        height: 110.0,
                                        width: 65.0,
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(8,15,0,0),
                                  child: Container(
                                    height: 110.0,
                                    width: MediaQuery.of(context).size.width*0.5,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(top:8.0,bottom: 3),
                                            child: Text(names[i],style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat'),),
                                          ),
                                          Text(age[i],style: TextStyle(color: Colors.grey),),
                                          Padding(
                                            padding: const EdgeInsets.only(top:3.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(Icons.location_on,size: 16,),
                                                Text(distance[i],style: TextStyle(fontSize: 12),),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(bottom:70.0),
                                  child:Stack(
                                    children: <Widget>[
                                      Image.asset("assets/images/add.png",height: 15,width: 15,),
                                      Padding(
                                        padding: const EdgeInsets.only(top:10.0,left: 9.0),
                                        child: Icon(Icons.add_circle_outline,size: 10,),
                                      )
                                    ],
                                  )
                                )

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:25.0,bottom: 15),
                              child: Row(
                                children: <Widget>[
                                  Text("Goals:  ",style: TextStyle(fontWeight: FontWeight.bold),),
                                  Text(goals[i])
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
