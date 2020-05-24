import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ViewProfile extends StatefulWidget {

  String imageUrl;
  String name;
  String age;
  List goals;
  String id;

  ViewProfile(this.id,this.imageUrl, this.name, this.age, this.goals);

  @override
  _ViewProfileState createState() => _ViewProfileState(id,imageUrl,name,age,goals);
}

class _ViewProfileState extends State<ViewProfile> {
  String imageUrl;
  String name;
  String age;
  List goals;
  String id;
  String bio;

  _ViewProfileState(this.id,this.imageUrl, this.name, this.age, this.goals);

  @override
  void initState() {
    // TODO: implement initState
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        elevation: 0,
        backgroundColor: Color(0xFFFFFFFF),
        title: Center(child: Text("User Profile",style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'montserrat'),)),
        actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.person_add),
                  iconSize: 30,
                  color: Color.fromRGBO(63, 92, 200, 0.4),
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

                  })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10,top: 15),
                  child:Container(
                    width: 80.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(imageUrl!=null?imageUrl:"https://thumbs.dreamstime.com/t/man-woman-silhouette-icons-pare-business-business-people-abstract-avatar-person-face-couple-58191914.jpg")
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      color: Colors.transparent,
                    ),
                  ),

                ),
              ),
              Center(child: Text(name!=null?name:"",style: TextStyle(fontSize: 18,),)),
              Center(child: Text(age!=null?age.toString():"",style: TextStyle(fontSize: 14,color: Colors.grey),)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,8,8),
                child: Row(
                  children: <Widget>[
                    Text("Goals :  ",style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(goals!=null?goals[0]+" , "+goals[1]+" , "+goals[2]:" ")
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,8,8),
                child: Row(
                  children: <Widget>[
                    Text("Bio :  ",style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,8,8),
                child: Row(
                  children: <Widget>[
                    Text(bio!=null?bio:""),
                  ],
                ),
              ),



            ],
          ),
        ),
      ),
    );
  }

  void _load() async{

    var url = 'https://march.lbits.co/app/api/index.php?uid=' + id;
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      setState(() {
        bio = jsonResponse["bio"];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
}
