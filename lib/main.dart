import 'package:flutter/material.dart';
import 'package:march/ui/home.dart';
import 'package:march/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'March',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xFF4267B2),
        fontFamily: 'montserrat',
      ),
      themeMode: ThemeMode.light,
      home: MyHomePage(title: 'March'),
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
    return Center(
      child: SplashScreen(
        seconds: 2,
        navigateAfterSeconds: n == 1 ? Home('') : Login(),
        image: new Image.asset("assets/images/logo1x.jpeg"),
        photoSize: 200,
        backgroundColor: Colors.white,
        loaderColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int intValue = prefs.getInt('log') ?? 0;
    if (intValue == 1) {
      setState(() {
        n = 1;
      });
    }
  }
}
