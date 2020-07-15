import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final Map user;
  ChatScreen({Key key, this.user}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState(user: this.user);
}

class _ChatScreenState extends State<ChatScreen> {
  final Map user;
  List<DropdownMenuItem> chatDropDown = [
    DropdownMenuItem(child: Text("Block")),
    DropdownMenuItem(child: Text("Report & Block")),
  ];
  TextEditingController msgController = TextEditingController();
  _ChatScreenState({this.user});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context)),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  imageUrl:
                      "https://images.pexels.com/photos/2853198/pexels-photo-2853198.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500"),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text("Emma"),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.more_vert), onPressed: () => print('Hello'))
        ],
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
                width: size.width,
                height: 0.08 * size.height,
                color: Theme.of(context).primaryColor,
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.add_circle,
                          size: 35.0,
                        ),
                        onPressed: () => print("Add Image")),
                    TextField(
                      controller: msgController,
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
