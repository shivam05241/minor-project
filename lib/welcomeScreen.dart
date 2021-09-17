import 'dart:async';
import 'package:flutter/material.dart';
import 'Home screen.dart';
import 'constants.dart';

class welcome extends StatelessWidget {
  const welcome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 3),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen())));

    return Scaffold(
      backgroundColor: Color(0xff191A2D),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/appLogo.png'),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Welcome to music app",
                style: TextStyle(
                    foreground: Paint()..shader = klinearGradient,
                    fontSize: 25),
              ),
            ),
            SizedBox(
              height: 60,
            ),
          ],
        ),
      ),
    );
  }
}
