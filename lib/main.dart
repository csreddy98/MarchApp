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
          buttonColor: Color.fromRGBO(0, 172, 163, 1),
          disabledColor: Color.fromRGBO(0, 172, 163, 0.3),
          primaryColor: Color.fromRGBO(0, 172, 163, 1),
          textTheme: TextTheme(
            headline1:TextStyle(
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
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 12
            ),
            button: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14
            ),
            subtitle1: TextStyle(
              fontSize: 17,
              color: Color.fromRGBO(0, 172, 163, 1),
              fontWeight: FontWeight.w600
            ),
            subtitle2: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.black
            ),
            bodyText1: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600
            ),
            bodyText2: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500
            )
          ),

          fontFamily: 'montserrat'),

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
