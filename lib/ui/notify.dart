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
      color: Colors.black12,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Cricket",style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 20,fontWeight: FontWeight.bold),),
          ),
          Text("Did you work on your goal today?"),
          const SizedBox(height: 10),
          RaisedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.only(left:35.0,right: 35.0),
              child: const Text(
                  'Yes',
                  style: TextStyle(fontSize: 16)
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.only(left:35.0,right: 35.0),
              child: const Text(
                  'No',
                  style: TextStyle(fontSize: 16)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget slide2(){
    return Container(
      color: Colors.black12,
    );
  }

  Widget slide3(){
    return Container(
      color: Colors.black12,
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

          Align(
              alignment:Alignment.bottomCenter,
              child: WormIndicator(
                length: 3,
                controller: _controller,
                shape: Shape(
                    size: 6,
                    spacing: 3,
                    shape: DotShape.Circle  // Similar for Square
                ),
              ),
          ),
        ],
      )
    );
  }
}
