import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:march/models/people_model.dart';
import 'package:march/ui/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:march/ui/slider_container.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:march/ui/view_profile.dart';
import 'package:location/location.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {

  TextEditingController myController;
  List<Person> people=[];
  Location location = new Location();

  PermissionStatus _permissionGranted;
  bool _serviceEnabled;
  LocationData _locationData;
//  bool _serviceEnabled;
  int clicked=0;
  String lat;
  String token;
  String id;
  String lng;
  int minAge=18;
  int maxAge=100;
  int radius=100;
  int check=0;

  @override
  void initState() {
    myController= TextEditingController();
    _load();
    super.initState();
  }

  Future<List<Person>> _getPeople() async{

    if(token!=null && id!=null && check==1){
      /*if(lat==null){
        setState(() {
          lat="17.453844";
          lng="78.4166759";
        });
      }*/
      var ur= 'https://march.lbits.co/api/worker.php';
      var resp=await http.post(ur,
        headers: {
          'Content-Type':
          'application/json',
          'Authorization':
          'Bearer $token'
        },
        body: json.encode(<String, dynamic>
        {
          'serviceName': "",
          'work': "search with distance",
          'lat':lat,
          'lng':lng,
          'goals':'Cricket',
          'radius':radius,
          'maxAge':maxAge,
          'minAge':minAge,
          'uid':id,
        }),
      );

      print(resp.body.toString());
      var result = json.decode(resp.body);
      if (result['response'] == 200) {
        var now = new DateTime.now();
        int l=result['result'].length;
        if(l>10){
          l=10;
        }

        if(clicked==0){

          for(var i=0;i<l;i++){

            int age=int.parse(now.toString().substring(0, 4)) - int.parse(result['result'][0]['DOB'].toString().substring(0,4));
            people.add( Person(
              //result['result'][i]['profile_pic']
              imageUrl: "https:\/\/loremflickr.com\/cache\/resized\/65535_49338807117_be0482d150_320_240_nofilter.jpg",
              name: result['result'][i]['fullName'],
              age: age.toString() +" Years Old",
              location: result['result'][i]['distance'].toString().substring(0,3)+" Km away",
              goals: convert.jsonEncode(['Cricket', 'Travel', 'Dance']),
              id:result['result'][i]['uid'],
              bio: result['result'][i]['bio']
            ),);
          }

          setState(() {
            clicked=1;
          });
        }
        return people;
      }
      //else print error
    }


  }
  final GlobalKey<ScaffoldState> _sk=GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _sk,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left:15.0,right: 15.0),
            child: Container(
              color: Colors.white,
              child: TextField(
                controller: myController,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search,
                      color: Colors.blueGrey,
                    ),
                    iconSize: 25,
                    onPressed: (){
                      String name=myController.text;

                      if(people.length!=0){

                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Search(name,people)),
                        );
                        FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
                        WidgetsBinding.instance.addPostFrameCallback((_) => myController.clear());

                      }
                      else{

                        _sk.currentState.showSnackBar(SnackBar(
                          content: Text("Wait....",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 15,
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0))),
                          duration: Duration(seconds: 1),
                          backgroundColor: Colors.lightBlueAccent,
                        ));


                      }


                      FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
                      WidgetsBinding.instance.addPostFrameCallback((_) => myController.clear()); //

                    },
                  ),
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
          ),
          Container(
            height: 60,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Featured',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontSize: 20.0,
                      letterSpacing: 0.4,
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.tune,color: Colors.grey,), iconSize: 26.0, onPressed: (){

                    if(people.length>0){
                      _navigateAndDisplaySelection(context);
                    }

                  }),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              child: FutureBuilder(
                future: _getPeople(),
                builder: (BuildContext context,AsyncSnapshot snapshot){
                  if(snapshot.data ==null){
                    return Container(
                      child: Center(
                        child: Text("Loading..."),
                      ),
                    );
                  }
                  else{
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        Person person = people[index];
                        List<dynamic> list=convert.jsonDecode(person.goals);
                        return Dismissible(
                          key: ObjectKey(people[index]),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) => ViewProfile(person.id,person.imageUrl,person.name,person.age,list,person.bio)),
                                      (Route<dynamic> route) => true);
                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(17, 5, 20, 5),
                                  height: 170,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 6,
                                          offset: Offset(1, 1)),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(115, 0, 20, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            SizedBox(
                                              width:  MediaQuery.of(context).size.width*0.4,
                                              child: AutoSizeText(
                                                person.name,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue[900],
                                                ),
                                                maxLines:1,
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.person_add),
                                                iconSize: 28,
                                                color: Color.fromRGBO(63, 92, 200, 0.4),
                                                onPressed: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.all(Radius.circular(15.0))), //this right here
                                                          child: Container(
                                                            height: 250,
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(20.0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text("Send A Message",
                                                                    style: TextStyle(
                                                                        fontSize: 20,
                                                                        color: Colors.black,
                                                                        fontWeight: FontWeight.w600
                                                                    ),),

                                                                  Container(height:15,),
                                                                  TextField(
                                                                    keyboardType: TextInputType.multiline,
                                                                    maxLines: 3,
                                                                    decoration: InputDecoration(
                                                                        enabledBorder: OutlineInputBorder(
                                                                          borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                                        ),
                                                                        hintText: 'Enter a Message'),
                                                                  ),
                                                                  Container(height:15,),
                                                                  Row(
                                                                    children: <Widget>[
                                                                      Container(width: MediaQuery.of(context).size.width/2.2,),
                                                                      SizedBox(
                                                                        width: 100,
                                                                        child: RaisedButton(
                                                                            shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(35)
                                                                            ),
                                                                            onPressed: () {},
                                                                            child: Text(
                                                                              "Add",
                                                                              style: TextStyle(color: Colors.white),
                                                                            ),
                                                                          color: Color.fromRGBO(63, 92, 200, 1),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),

                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });

                                                }),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(115, 0, 20, 0),
                                        child: Text(
                                          person.age,
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(95, 0, 20, 0),
                                        child: Row(
                                          children: <Widget>[
                                            IconButton(
                                                icon: Icon(
                                                  Icons.location_on,
                                                  color: Colors.grey[400],
                                                ),
                                                onPressed: null),
                                            Text(
                                              person.location,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Goals:  ',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.8),
                                            ),
                                            Text(
                                              list[0]+" , ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black87,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            Text(
                                              list[1]+" , ",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black87,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            Text(
                                              list[2],
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black87,
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  left: 30,
                                  top: 15,
                                  bottom: 70,
                                  child: Container(
                                    width: 90.0,
                                    height: 90.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(person.imageUrl),
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                      color: Colors.transparent,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          onDismissed: (direction){
                            Person item = people[index];

                            deleteItem(index);

                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text("Profile deleted"),
                                action: SnackBarAction(
                                    label: "UNDO",
                                    onPressed: () {
                                      undoDeletion(index, item);
                                    })));
                          },

                        );
                      },
                    );
                  }



                },
              )
            ),
          ),
        ],
      ),
    );
  }

  void deleteItem(index){
    setState((){
      people.removeAt(index);
    });
  }

  void undoDeletion(index, item){
    setState((){
      people.insert(index, item);
    });
  }

  void _load() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token')??"";
    String uid = prefs.getString('uid')??"";

    setState(() {
      token=userToken;
      id=uid;
    });

    _permissionGranted = await location.hasPermission();

    if(_permissionGranted==PermissionStatus.granted){

      _serviceEnabled = await location.serviceEnabled();

      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          print("No Thanks");
          setState(() {
            lat="17.4538444";
            lng="78.416675";
            check=1;
          });
          return;
        }
        else{
          print("Clicked Ok");
          _locationData = await location.getLocation();
          print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
          setState(() {
            lat=_locationData.latitude.toString();
            lng=_locationData.longitude.toString();
            check=1;
          });

        }
      }
      else{
        _locationData = await location.getLocation();
        print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
        setState(() {
          lat=_locationData.latitude.toString();
          lng=_locationData.longitude.toString();
          check=1;
        });
      }

    }
    else{
      //location permission in settings
      _permissionGranted = await location.requestPermission();

      if(_permissionGranted==PermissionStatus.granted){
      //checking gps
        _serviceEnabled = await location.serviceEnabled();

        if (!_serviceEnabled) {
          _serviceEnabled = await location.requestService();
          if (!_serviceEnabled) {
            print("No Thanks");
            setState(() {
              lat="17.4538444";
              lng="78.416675";
              check=1;
            });
            return;
          }
          else{
            print("Clicked Ok");
            _locationData = await location.getLocation();
            print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
            setState(() {
              lat=_locationData.latitude.toString();
              lng=_locationData.longitude.toString();
              check=1;
            });

          }
        }
        else{
          _locationData = await location.getLocation();
          print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
          setState(() {
            lat=_locationData.latitude.toString();
            lng=_locationData.longitude.toString();
            check=1;
          });
        }

      }
      else{
        //when location permission rejected
        setState(() {
          lat="17.09";
          lng="78.05";
          check=1;
        });
      }
    }

   /* if (_permissionGranted == PermissionStatus.denied) {

      *//*_permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        print("yes");
        _locationData = await location.getLocation();
        print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
        setState(() {
          lat=_locationData.latitude.toString();
          lng=_locationData.longitude.toString();
        });
      }
      else{
        print("permission not granted");
      }
      setState(() {
        check=1;
      });*//*
    }
    else{
      *//*_locationData = await location.getLocation();
      print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
      setState(() {
        lat=_locationData.latitude.toString();
        lng=_locationData.longitude.toString();
        check=1;
        print("location on");
      });*//*
    }*/

  }

  _navigateAndDisplaySelection(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Slider_container("Cricket","Dance","Hockey")),
    );
    if(result!=null){
      print(result);
      int minAge=result[0];
      int maxAge=result[1];
      int distance=result[2];
      List<dynamic> record=result[3];

      for(var i=people.length-1;i>=0;i--) {

        List<dynamic> l=convert.jsonDecode(people[i].goals);

        if(int.parse(people[i].age.substring(0,2))<minAge){
          setState(() {
            people.removeAt(i);
          });
        }
        else if(int.parse(people[i].age.substring(0,2))>maxAge){
          setState(() {
            people.removeAt(i);
          });

        }
        else if(double.parse(people[i].location.substring(0,3))>double.parse(distance.toString())){
          setState(() {
            people.removeAt(i);
          });
        }
        else if(record.length>2){
          if(!l.contains(record[0]) || !l.contains(record[1]) || !l.contains(record[2])){
            setState(() {
              people.removeAt(i);
            });
          }
        }
        else if(record.length>1){
          if(!l.contains(record[0]) || !l.contains(record[1])){
            setState(() {
              people.removeAt(i);
            });
          }
        }
        else if(record.length>0){
          if(!l.contains(record[0])){
            setState(() {
              people.removeAt(i);
            });
          }
        }

      }

    }
  }

}


