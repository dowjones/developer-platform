import 'package:flutter/material.dart';
import 'package:flutter_news_app/src/auth/firebaseauth.dart';
import 'package:flutter_news_app/src/ui/splash/splash_screen.dart';


class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = FireBaseAuth();
    return MaterialApp(
      home: SplashScreen(auth: auth),
    );
  }
}
