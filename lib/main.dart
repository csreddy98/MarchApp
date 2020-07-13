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
        fontFamily: 'montserrat',
        scaffoldBackgroundColor: Colors.white,
        buttonColor: Color(0xffFFBF46),
        disabledColor: Color.fromRGBO(254, 209, 125, 0.5),
        primaryColor: Color(0xffFFBF46),
        textTheme: TextTheme(
            headline1: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            headline2: TextStyle(
              color: Color(0xFF3a7b8b),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            headline3: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            caption: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
            button: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w700, fontSize: 16),
            subtitle1: TextStyle(
                fontSize: 17,
                color: Color(0xffFED17D),
                fontWeight: FontWeight.w600),
            subtitle2: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
            bodyText1: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            bodyText2: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
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
        seconds: 4,
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
