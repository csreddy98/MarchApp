import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:march/models/user.dart';
import 'package:march/ui/edit_goals.dart';
import 'package:march/utils/database_helper.dart';

class ShowGoals extends StatefulWidget {
  @override
  _ShowGoalsState createState() => _ShowGoalsState();
}

class _ShowGoalsState extends State<ShowGoals> {

  var db = new DataBaseHelper();
  User user;

  List goals = [];
  List level=["Newbie","Skilled","Proficient","Experienced","Expert"];

  @override
  void initState() {
    _load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Your Goals",
          style: TextStyle(
              color: Colors.black,fontSize: 18,fontFamily: 'Nunito'
          ),),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:goals.length>0? ListView.builder
          (
          itemCount: goals.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                       Padding(
                         padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: <Widget>[
                             Expanded(
                                child: Wrap(
                                  children: <Widget>[
                                    Text("Goal Name :  ",style: TextStyle(fontWeight: FontWeight.w600),),
                                    AutoSizeText(goals[index]['goalName'])
                                  ],
                                )
                             ),
                             IconButton(
                                icon: Icon(Icons.edit,size: 18,),
                                onPressed: (){
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => EditGoal(goals[index]['goalNumber'],goals[index]['userId'],goals[index]['goalName'])));
                                },
                             )
                           ],
                         ),
                       ),

                       Padding(
                         padding: const EdgeInsets.fromLTRB(8,0,8,8),
                         child:
                         Row(
                           children: <Widget>[
                             Text("Goal Level :  ",style: TextStyle(fontWeight: FontWeight.w600),),
                             Text(
                                 level[int.parse(goals[index]['level'])]
                             ),
                           ],
                         )
                       ),

                        Padding(
                            padding: const EdgeInsets.fromLTRB(8,0,8,8),
                            child:
                            Row(
                              children: <Widget>[
                                Text("Remind Time :  ",style: TextStyle(fontWeight: FontWeight.w600),),
                                Text(
                                    goals[index]['remindTime']
                                ),
                              ],
                            )
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            );
          }
      ):Container(
        width: 0,
        height: 0,
      ),
        floatingActionButton: Visibility(
          maintainSize: false,
          maintainAnimation: true,
          maintainState: true,
          visible: goals.length<3?true:false,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EditGoal((goals.length+1).toString(),goals[0]['userId'],"")));
            },
            child: Icon(Icons.add),
          ),
        )
    );
  }

  void _load() async{
    user = await db.getUser(1);
    db.getGoal(1).then((value) {
      setState(() {
        goals.addAll(value);
      });
      print(goals);
    });
  }
}

