import 'package:flutter/material.dart';

class Find extends StatefulWidget {
  @override
  _FindState createState() => _FindState();
}

class _FindState extends State<Find> {

  String bio=" Prabhas, is an Indian actor who works in Telugu, Hindi and Tamil films. Prabhas made his screen debut with the 2002 Telugu action drama film Eeswar. He has garnered the state Nandi Award for Best Actor, for his role in Mirchi.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:20.0,left: 18,right: 18),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.favorite_border,size: 30,)),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text("Health".toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.grey),),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(

                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.deepPurple,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.directions_bike,size: 30,color: Colors.deepPurple,)),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text("sport".toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.deepPurple),),
                              ),
                            ],
                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child:  Container(

                          ),
                        ),

                        Expanded(
                          flex: 1,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.audiotrack,size: 30,)),
                              Padding(
                                padding: const EdgeInsets.only(top:8.0),
                                child: Text("Music".toUpperCase(),style: TextStyle(fontSize: 14,color: Colors.grey),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

              Padding(
                padding: const EdgeInsets.only(left:20.0,right: 18.0,top: 18),
                child: Container(
                  color: Colors.black12,
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                ),
              ),

              Row(
                children: <Widget>[

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,10.0,8.0,4.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.deepPurple, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                               Text("Cricket",style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,10.0,8.0,4.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.deepPurple,
                          border: Border.all(
                            color: Colors.deepPurple, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right:3.0),
                                child: Text("ball",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,10.0,8.0,4.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.deepPurple, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right:3.0),
                                child: Text("Rugby",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,10.0,8.0,4.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.deepPurple, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right:3.0),
                                child: Text("Golf",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),


              Row(
                children: <Widget>[

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0,8.0,8.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.deepPurple,
                          border: Border.all(
                            color: Colors.deepPurple, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text("Squash",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0,8.0,8.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.deepPurple,
                          border: Border.all(
                            color: Colors.deepPurple, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right:3.0),
                                child: Text("ball",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0,8.0,8.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.deepPurple, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right:3.0),
                                child: Text("Soccer",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0,0,8.0,8.0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.deepPurple, //                   <--- border color
                            width: 2.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right:3.0),
                                child: Text("Hockey",style: TextStyle(fontWeight: FontWeight.bold),),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
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

                      Padding(
                        padding: const EdgeInsets.only(top:15.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 32.0,
                            backgroundImage:
                            NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Prabhas_at_MAMI_18th_Mumbai_film_festival.jpg/240px-Prabhas_at_MAMI_18th_Mumbai_film_festival.jpg"),
                            backgroundColor: Colors.transparent,
                          ),
                          title: Text('  Prabhas',style: TextStyle(fontSize: 18,color: Colors.deepPurple),),
                          subtitle: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top:3.0,bottom: 5.0),
                                  child: Text('  28 Years Old',style: TextStyle(fontSize: 14),),
                                ),
                                Row(
                                  children: <Widget>[
                                    Icon(Icons.location_on),
                                    Text(" 4 Km away"),
                                  ],
                                )
                              ],
                            ),
                          ),

                        ),
                      ),

                     Padding(
                       padding: const EdgeInsets.fromLTRB(18.0,8.0,8.0,8.0),
                       child: Row(
                         children: <Widget>[
                           Text("Goals : ",style: TextStyle(fontSize: 16,color: Colors.deepPurple,fontWeight: FontWeight.bold),),
                           Text("Cricket, Travel, Fitness",style: TextStyle(fontSize: 16,color: Colors.deepPurple),)
                         ],
                       ),
                     ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18.0,0,8.0,8.0),
                        child:  Text("Bio : ",style: TextStyle(fontSize: 16,color: Colors.deepPurple,fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15.0,8.0,8.0,8.0),
                        child: Text(bio,style: TextStyle(fontSize: 14,color: Colors.deepPurple),)
                      ),


                      Padding(
                        padding: const EdgeInsets.only(bottom:8.0),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 50,
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top:15.0),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.clear,size: 25,),
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(top:15.0),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.green,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0.0, 1.0), //(x,y)
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                  ),
                                  child: Icon(Icons.check,size: 25,),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: 50,
                            ),

                          ],
                        ),
                      ),


                    ],
                  ),

                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
