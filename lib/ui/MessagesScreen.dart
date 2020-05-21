import 'package:flutter/material.dart';
import 'package:march/widgets/recent_chats.dart';
import 'package:march/widgets/category_selector.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          CategorySelector(),
          RecentChats(),
        ],
      ),
    );
  }
}
