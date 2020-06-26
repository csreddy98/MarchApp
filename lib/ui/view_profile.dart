import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:march/support/back_profile.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;

class ViewProfile extends StatefulWidget {

  final String imageUrl;
  final String name;
  final String age;
  final String goals;
  final String id;
  final String bio;
  final String profession;
  
  ViewProfile(this.id,this.imageUrl, this.name, this.age, this.goals,this.bio,this.profession);

  @override
  _ViewProfileState createState() => _ViewProfileState(id,imageUrl,name,age,goals,bio,profession);
}

class _ViewProfileState extends State<ViewProfile> {
  String imageUrl;
  String name;
  String age;
  String goals;
  String id;
  String bio;
  String profession;

  _ViewProfileState(this.id, this.imageUrl, this.name, this.age, this.goals,
      this.bio,this.profession);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20.0,color: Colors.white60,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Color.fromRGBO(63, 92, 200, 1),
        title: Center(child: Text("User Profile", style: TextStyle(
            color: Colors.white, fontSize: 18, fontFamily: 'montserrat'),)),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person_add),
              iconSize: 30,
              color: Colors.white60,
              onPressed: () {
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
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          width: MediaQuery
              .of(context)
              .size
              .width,
          child: Column(
            children: <Widget>[


              Stack(
                children: <Widget>[

                  Container(
                    height: MediaQuery.of(context).size.height*0.35,
                    width: MediaQuery.of(context).size.width,
                    child: CustomPaint(
                      painter: BackProfile(),
                    ),
                  ),

                  Container(
                    height: MediaQuery.of(context).size.height*0.28,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6,top: 6),
                            child:InkWell(
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>FullScreenImage(imageUrl))),
                              child: Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(imageUrl != null
                                          ? imageUrl
                                          : "https://thumbs.dreamstime.com/t/man-woman-silhouette-icons-pare-business-business-people-abstract-avatar-person-face-couple-58191914.jpg")
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                  color: Colors.transparent,
                                ),
                              ),
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: Center(
                              child: Text(name!=null?name[0].toUpperCase()+name.substring(1,):"",
                            style: TextStyle(
                                fontSize: 16,color: Colors.white,letterSpacing: 0.4
                              ),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: Center(
                              child: Text(profession!=null?profession[0].toUpperCase()+profession.substring(1,):"",
                                style: TextStyle(fontSize: 16,color: Colors.white,letterSpacing: 0.4),)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5,bottom:12.0),
                          child: Center(child: Text(age!=null?age.toString():"",
                            style: TextStyle(fontSize: 14,color: Colors.white,letterSpacing: 0.4),)),
                        ),

                      ],
                    ),
                  )

                ],
              ),



              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20, 8, 8),
                child: Row(
                  children: <Widget>[
                    Text("Goals :  ",
                      style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 0.4,fontSize: 16),),
                    Text(goals,style: TextStyle(letterSpacing: 0.3,fontSize: 16),)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20, 8, 8),
                child: Row(
                  children: <Widget>[
                    Text("Bio :  ",
                      style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 0.4,fontSize: 16),),
                    AutoSizeText(bio != null ? bio : "", maxLines: 12,style: TextStyle(letterSpacing: 0.4,fontSize: 16),),
                  ],
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget{
  final imageURL;
  FullScreenImage(this.imageURL);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  child: Icon(Icons.close),
                  onTap: ()=> Navigator.pop(context),
                ),
              )
            ],
          ),
          Image.network(imageURL)
        ],
      ),
    );
  }

}