import 'package:flutter/material.dart';
import 'package:flutter_news_app/src/auth/baseauth.dart';
import 'dart:async';

import 'package:flutter_news_app/src/ui/root/root_screen.dart';
import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  final BaseAuth auth;
  
  SplashScreen({this.auth});

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  SplashScreenState();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RootScreen(auth: widget.auth),
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final peopleImg = SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        'assets/images/dj_people.png',
      ),
    );
    final prototypeLabel = SizedBox(
      height: 23.0,
      width: 83.0,
      child: DecoratedBox(
        child: Text(
          ' /prototypes ',
          style: TextStyle(
            color: Color(0xFF39485A),
            fontSize: 12.0,
            fontFamily: 'Consolas',
          ),
          textAlign: TextAlign.center,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            style: BorderStyle.solid,
            color: Color(0xFFE9E9E9),
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
      ),
    );
    final logo = SizedBox(
      height: 86.0,
      width: 208.0,
      child: SvgPicture.asset(
        'assets/images/developer_platform_2.svg',
        semanticsLabel: 'Dow Jones Logo'
      ),
    );
    final rightsText = Container(
      child: Text('Presenting a user experience that complements analyzing stock prices for buying/selling decisions by adding news and company recommendations, which can be leveraged to offer more engaging content besides traditional portfolio statistics',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF8090A2),
          fontFamily: 'Roboto-Regular',
          fontSize: 10.0,
          backgroundColor: Colors.white,
        ),
      ),
    );
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(22.0),
            child: Column(
              children: [
                peopleImg,
                logo,
                SizedBox(height: 20.0),
                prototypeLabel,
                SizedBox(height: 90.0),
                rightsText,
              ],
            ),
          ),
        ),
      )
    );
  }
}
