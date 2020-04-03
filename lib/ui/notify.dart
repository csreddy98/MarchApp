import 'package:flutter/material.dart';
import 'package:worm_indicator/shape.dart';
import 'package:worm_indicator/worm_indicator.dart';

class Notify extends StatefulWidget {
  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {

  PageController _controller = PageController(
    initialPage: 0,
    viewportFraction: 0.9
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }




  Widget slide1(){
    return Container(
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Cricket",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat',fontSize: 20),),
          ),
          Text("Did you work on your goal today?"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: (){

            },
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

              child: Padding(
                padding: const EdgeInsets.only(left:50,right: 50,top:12,bottom: 12),
                child: Text("Yes"),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){

            },
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

              child: Padding(
                padding: const EdgeInsets.only(left:50,right: 50,top:12,bottom: 12),
                child: Text("No"),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0,8,0,0),
            child: Row(
              children: <Widget>[

                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:35.0),
                          child: Text("0",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ),),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(6.0),
                      ),
                      color: Color.fromRGBO(63, 92, 200, 1),
                      onPressed: () {},
                      child: const Text(
                          'Remind me',
                          style: TextStyle(fontSize: 12,color: Colors.white)
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )


        ],
      ),
    );
  }




  Widget slide2(){
    return Container(
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Cricket",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat',fontSize: 20),),
          ),
          Text("Did you work on your goal today?"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: (){

            },
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

              child: Padding(
                padding: const EdgeInsets.only(left:50,right: 50,top:12,bottom: 12),
                child: Text("Yes"),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){

            },
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

              child: Padding(
                padding: const EdgeInsets.only(left:50,right: 50,top:12,bottom: 12),
                child: Text("No"),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0,8,0,0),
            child: Row(
              children: <Widget>[

                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:35.0),
                          child: Text("0",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ),),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                      ),
                      color: Color.fromRGBO(63, 92, 200, 1) ,
                      onPressed: () {},
                      child: const Text(
                          'Remind me',
                          style: TextStyle(fontSize: 12,color: Colors.white)

                      ),
                    ),
                  ),
                ),

              ],
            ),
          )

        ],
      ),
    );
  }

  Widget slide3(){
    return Container(
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Cricket",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ,fontWeight: FontWeight.bold,fontFamily: 'montserrat',fontSize: 20),),
          ),
          Text("Did you work on your goal today?"),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: (){

            },
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

              child: Padding(
                padding: const EdgeInsets.only(left:50,right: 50,top:12,bottom: 12),
                child: Text("Yes"),
              ),
            ),
          ),
          GestureDetector(
            onTap: (){

            },
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

              child: Padding(
                padding: const EdgeInsets.only(left:50,right: 50,top:12,bottom: 12),
                child: Text("No"),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(0,8,0,0),
            child: Row(
              children: <Widget>[

                Expanded(
                  flex: 1,
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left:35.0),
                          child: Text("0",style: TextStyle(color: Color.fromRGBO(63, 92, 200, 1) ),),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(6.0),
                      ),
                      color: Color.fromRGBO(63, 92, 200, 1) ,
                      onPressed: () {},
                      child: const Text(
                          'Remind me',
                          style: TextStyle(fontSize: 12,color: Colors.white)
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )

        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _controller,
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                child: slide1(),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                child: slide2(),
              ),
              Padding(
                padding: const EdgeInsets.only(left:8.0,top: 8.0,bottom: 15.0),
                child: slide3(),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(bottom:8.0),
            child: Align(
                alignment:Alignment.bottomCenter,
                child: WormIndicator(
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
}