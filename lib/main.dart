import 'package:flutter/material.dart';
import 'package:march/ui/home.dart';
import 'package:march/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget  {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF4267B2),
        fontFamily: 'montserrat'
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int n;

  @override
  void initState() {
    _load();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds:n==1?Home():Login(),
      image: new Image.network('https://cdn.pixabay.com/photo/2017/03/19/20/19/ball-2157465__340.png'),
      photoSize: 200,
      backgroundColor: Colors.black,
      loaderColor: Colors.red,
    );
  }

  void _load() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int intValue = prefs.getInt('log')??0;
    if(intValue==1){
      setState(() {
        n=1;
      });
    }

  }
}
