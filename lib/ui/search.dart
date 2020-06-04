import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:march/models/people_model.dart';

class Search extends StatefulWidget {
  final String search;
  final List<Person> person;

  Search(this.search,this.person);
  @override
  _SearchState createState() => _SearchState(search,person);
}

class _SearchState extends State<Search> {
  String search;
  List<Person> person;
  _SearchState(this.search,this.person);
  List<Person> people=List();

  TextEditingController myController = TextEditingController();
  @override
  void initState() {
    people=person.where((u)=>(u.name.toLowerCase().contains(search.toLowerCase()))).toList();
    myController.text=search;
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Color(0xFFFFFFFF),
        title: TextField(
          controller: myController,
          style: TextStyle(fontSize: 16, color: Colors.black),
          decoration: InputDecoration(
            suffixIcon: GestureDetector(
                onTap: (){
                  FocusScope.of(context).requestFocus(new FocusNode()); //remove focus
                  WidgetsBinding.instance.addPostFrameCallback((_) => myController.clear());
                },
                child:Icon(Icons.clear)),
            contentPadding: const EdgeInsets.only(
              left: 16,
              right: 20,
              top: 14,
              bottom: 10,
            ),
          ),
         onChanged: (string){
            setState(() {
              people=person.where((u)=>(u.name.toLowerCase().contains(string.toLowerCase()))).toList();
            });
         },

        ),
      ),

      body: ListView.builder(
        itemCount: people.length,
        itemBuilder: (BuildContext context, int index) {
          Person person = people[index];
          return Stack(
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
                                    color: Colors.grey[400]
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
            );
        },
      ),
    );
  }

}
