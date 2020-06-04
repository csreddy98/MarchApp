import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:march/widgets/recent_chats.dart';
// import 'package:march/widgets/category_selector.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  int selectedIndex;
  List<String> categories = ['Chats', 'Requests'];
  bool chats;

  List newReqs = [
    {
      "Image": "https://images.pexels.com/photos/1468379/pexels-photo-1468379.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      "Name": "Stacy",
      "Age": "21",
      "Goals": "Scientist, Physicist, Botanist"
    },{
      "Image": "https://images.pexels.com/photos/1520760/pexels-photo-1520760.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      "Name": "Nancy",
      "Age": "19",
      "Goals": "Scientist, Physicist, Botanist"
    },{
      "Image": "https://images.pexels.com/photos/2613260/pexels-photo-2613260.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      "Name": "Angie",
      "Age": "20",
      "Goals": "Scientist, Physicist, Botanist"
    },
  ];
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    chats = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    setState(() {
                      chats = true;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Center(child: Text("Chats")),
                    width: 120.0,
                  ),
                  color:
                      (chats == true) ? Color(0xFFFCFCFC) : Color(0xFFE2E3ED),
                  // shape: RoundedRectangleBorder(side: BorderSide(width: 1.0)),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      chats = false;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    child: Center(child: Text("Requests")),
                    width: 120.0,
                  ),
                  color:
                      (chats == false) ? Color(0xFFFCFCFC) : Color(0xFFE2E3ED),
                  // shape: RoundedRectangleBorder(side: BorderSide(width: 1.0)),
                )
              ],
            ),
          ),
          chats == true ? RecentChats() : ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: newReqs.length,
              itemBuilder: (_, i){
                return requests(newReqs[i]['Image'], newReqs[i]['Name'], newReqs[i]['Age'], newReqs[i]['Goals'], "");
            }),
        ],
      ),
    );
  }

  Widget requests(url, name, age, goals, uid) {
    return Card(
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 130,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Image.network(
                url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: "Name: ",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18
                  ),
                  children: [
                    TextSpan(
                      text: "$name",
                      style: TextStyle(
                        color: Colors.black,
                      )
                    )
                  ]
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "Age: ",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 18
                  ),
                  children: [
                    TextSpan(
                      text: "$age",
                      style: TextStyle(
                        color: Colors.black
                      )
                    )
                  ]
                ),
              ),
              RichText(
                text: TextSpan(
                  text: "Goals: ",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 16
                  ),
                  children: [
                    TextSpan(
                      text: "$goals",
                      style: TextStyle(
                        color: Colors.black
                      )
                    ),
                  ]
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: null,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      )
                    ),
                    // color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 40),
                  InkWell(
                    onTap: null,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        child: Text(
                          "Reject",
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      )
                    ),
                    // color: Theme.of(context).primaryColor,
                  )
                ],
              ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
