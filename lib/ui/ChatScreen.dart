import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:march/models/user_model.dart';

Random random = new Random();

class TextingScreen extends StatefulWidget {
  final User user;
  TextingScreen({this.user});
  
  @override
  _TextingScreenState createState() => _TextingScreenState();
}

class _TextingScreenState extends State<TextingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      leading: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        color: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(40.0)),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRRect(
            child: Image.network(
                "https://firebasestorage.googleapis.com/v0/b/march-5a1f0.appspot.com/o/profile%2Fskphotuhhdhd_1.jpeg%7D?alt=media&token=7855da63-6a04-43d4-bb41-cfb830925bbe",
                height: 40,
                width: 40,
                fit: BoxFit.contain),
            borderRadius: BorderRadius.circular(10.0),
          ),
          Column(
            children: <Widget>[
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    child: new Text(
                      widget.user.name,
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Container(
                  child: new Text(
                    "online",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ]),
            ],
          ),
        ],
      ),
    ),
    body: ChatScreen()
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

// Add the ChatScreenState class definition in main.dart.
class ChatMessage extends StatelessWidget {
  ChatMessage({
    this.text,
    this.animationController,
    this.sent,
  });
  final String text;
  final AnimationController animationController;
  final sent;
  //double width = MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*new Container(
              margin: const EdgeInsets.only(right:10.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),*/
            ConditionalBuilder(
              condition: sent == 0,
              builder: (context) {
                return new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      //new Text(_name, style: Theme.of(context).textTheme.subhead),
                      new Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Card(
                              color: Colors.grey[200],
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      padding:
                                          new EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: new Text(
                                        text,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ]))),
                    ],
                  ),
                );
              },
            ),
            ConditionalBuilder(
              condition: sent == 1,
              builder: (context) {
                return new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //new Text(_name, style: Theme.of(context).textTheme.subhead),
                      new Container(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: Card(
                              color: Colors.grey[200],
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Container(
                                      margin:
                                          const EdgeInsets.only(bottom: 10.0),
                                      padding:
                                          new EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: new Text(
                                        text,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ]))),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

/*class ChatMessage1 extends StatelessWidget {
  ChatMessage1({this.text1, this.animationController1});         
  final String text1;
  final AnimationController animationController1;
  //double width = MediaQuery.of(context).size.width;                  
  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
    sizeFactor: new CurvedAnimation(
        parent: animationController1, curve: Curves.easeOut),
    axisAlignment: 0.0, 
    child: new Container(      
      margin: const EdgeInsets.symmetric(vertical: .0),
      child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*new Container(
              margin: const EdgeInsets.only(right:10.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),*/
            new Expanded(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //new Text(_name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  child: Card(
                  color: Colors.grey[200],
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                  new Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  padding: new EdgeInsets.fromLTRB(5, 5, 5, 5),
                  child: new Text(text1, textAlign: TextAlign.left,),
                  ),
                  ]))
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}*/
class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  //final List<ChatMessage1> _messages1 = <ChatMessage1>[];
  final TextEditingController _textController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //appBar: new AppBar(title: new Text("Friendlychat")),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return new Container(
      color: Colors.grey[200],
      //margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 2.0),
            child: new IconButton(
                icon: new Icon(
                  Icons.add,
                  color: Colors.grey[600],
                ), //new
                onPressed: () => _handleSubmitted(_textController.text)),
          ),
          new Flexible(
            child: new TextField(
              scrollPadding: EdgeInsets.fromLTRB(0, 2, 0, 2),
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                hintText: "Send a message",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(23.9)),
                  borderSide:
                      const BorderSide(color: Colors.white, width: 10.0),
                ),
              ),
            ),
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(
                  Icons.send,
                  color: Colors.lightBlue[600],
                ), //new
                onPressed: () => _handleSubmitted(_textController.text)),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    int randomNumber;
    randomNumber = random.nextInt(2);
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
      sent: randomNumber,
    );
    /*ChatMessage1 message1 = new ChatMessage1(
    text1: text,
    animationController1: new AnimationController(
      duration: new Duration(milliseconds: 700), 
      vsync: this,                               
    ),
  );*/
    setState(() {
      _messages.insert(0, message);
      //_messages1.insert(1, message1);
    });
    message.animationController.forward();
    //message1.animationController1.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    /*for (ChatMessage1 message in _messages1)
    message.animationController1.dispose();*/
    super.dispose();
  }
}
