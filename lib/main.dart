import 'dart:async';
import 'package:Products/clients/client_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Products/screens/wrapper.dart';
import 'package:Products/services/auth.dart';
import 'models/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => new Wrapper(),
          '/client_grid': (BuildContext context) => new ClientGrid(quotation: false,),
        },
      ),
    );
  }
}

//opening screen for the app
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 5),
      () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
          ModalRoute.withName('/home')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.orange[100],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: Image.asset(
                          'assets/images/splash_screen/Logo_uni.png',
                          height: 100.0,
                          width: 100.0,
                        ),
                      ),
                      Container(
                        child: Image.asset(
                          'assets/images/splash_screen/name_uni.png',
                          height: 50.0,
                          width: 150.0,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
