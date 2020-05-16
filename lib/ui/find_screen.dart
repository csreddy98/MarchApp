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

class FindScreen extends StatefulWidget {
  @override
  _FindScreenState createState() => _FindScreenState();
}

class _FindScreenState extends State<FindScreen> {

  TextEditingController myController;
  List<Person> people=[];
  Location location = new Location();

  PermissionStatus _permissionGranted;
  LocationData _locationData;
//  bool _serviceEnabled;



  @override
  void initState() {
    myController= TextEditingController();
    _load();
    super.initState();
  }

  Future<List<Person>> _getPeople() async{

    var url = 'https://march.lbits.co/app/api/people-finder/people-finder.php?uid=27492837528&lat=17.4542774&lng=78.3753191&distance=3&minAge=20&maxAge=40&goals=hey';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      for(var i=0;i<jsonResponse.length;i++){
        people.add( Person(
          imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKPndf5Lp-mSpZ914kUQSDwr6tkf4N5Pj265PZyotfQmM6wNxNejlry9oSew&s",
          name: jsonResponse[i]['fullName'],
          age: jsonResponse[i]['age']+" Years Old",
          location: jsonResponse[i]['distance'].toString().substring(0,3)+" Km away",
          goals: 'Cricket, Travel, Fitness',
          id:jsonResponse[i]['uid'],
        ),);
      }

      return people;
    }
    else {
      print('Request failed with status: ${response.statusCode}.');
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

                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Slider_container()),
                    );

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
                        return Dismissible(
                          key: ObjectKey(people[index]),
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) => ViewProfile(person.id,person.imageUrl,person.name,person.age,person.goals)),
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
                                                icon: new Image.asset("assets/images/add-mentor-icon.png"),
                                                iconSize: 30,
                                                onPressed: (){
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                              BorderRadius.only(topRight: Radius.circular(75),
                                                                  bottomLeft: Radius.circular(75))), //this right here
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
                                                                      Container(width: MediaQuery.of(context).size.width/2.6,),
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
                                                                            color:Colors.deepPurple
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
                                              person.goals,
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
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        _locationData = await location.getLocation();
        print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
      }
    }
    else{
      _locationData = await location.getLocation();
      print("lat : "+_locationData.latitude.toString()+"long : "+_locationData.longitude.toString());
    }

  }

}


