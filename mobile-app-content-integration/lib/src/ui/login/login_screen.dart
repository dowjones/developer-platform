import 'package:flutter/material.dart';
import 'package:flutter_news_app/src/auth/baseauth.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreenWidget extends StatefulWidget {
  final String title;
  final BaseAuth auth;
  final VoidCallback loginCallback;

  LoginScreenWidget({Key key, this.title, this.auth, this.loginCallback}): super(key: key);

  @override
  _LoginScreenWidgetState createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  TextStyle textStyle = TextStyle(
    fontFamily: 'Roboto-Medium',
    fontSize: 14.0,
  );
  BorderSide borderStyle = BorderSide(
    width: 2.0,
    color: Color(0xFF00A3D5),
    style: BorderStyle.solid,
  );

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();

    final logo = SizedBox(
      height: 86.0,
      width: 208.0,
      child: SvgPicture.asset(
        'assets/images/developer_platform_2.svg',
        semanticsLabel: 'Dow Jones Logo'
      ),
    );

    final prototypeLabel = SizedBox(
      height: 23.0,
      width: 83.0,
      child: SvgPicture.asset(
        'assets/images/dj-prototypes-logo.svg',
        semanticsLabel: 'DJ Prototypes Label'
      ),
    );

    final emailField = TextField(
      controller: emailController,
      obscureText: false,
      style: textStyle,
      decoration: InputDecoration(
        fillColor: Color(0xFF00A3D5),
        prefixIcon: Icon(
          Icons.people,
          color: Color(0xFF00A3D5),
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintStyle: textStyle.copyWith(
          color: Color(0xFF000000).withOpacity(0.3),
          backgroundColor: Color(0xFFFAFAFA).withOpacity(0.1),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: borderStyle,
        ),
      ),
    );
    
    final passwordField = TextField(
      controller: passController,
      obscureText: true,
      style: textStyle,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Color(0xFF00A3D5),
        ),
        hintStyle: textStyle.copyWith(
          color: Color(0xFF000000).withOpacity(0.3),
          backgroundColor: Color(0xFFFAFAFA).withOpacity(0.1),
        ),
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: borderStyle,
        ),
      ),
    );

    final loginButton = Material(
      elevation: 5.0,
      color: Color(0xFF00A3D5),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width / 3.5,
        height: 36.0,
        onPressed: () async {
          var userId = await widget.auth.signIn(emailController.text, passController.text);
          if (userId.isNotEmpty && userId != null) {
            widget.loginCallback();
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Invalid Email/Password'),
            ));
          }
        },
        child: Text(
          'LOG IN',
          textAlign: TextAlign.center,
          style: textStyle.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );

    final rightsText = Container(
      child: Text(
        'Presenting a user experience that complements analyzing stock prices for buying/selling decisions by adding news and company recommendations, which can be leveraged to offer more engaging content besides traditional portfolio statistics',
        textAlign: TextAlign.center,
        style: textStyle.copyWith(
          color: Color(0xFF8090A2),
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 48.0),
                logo,
                SizedBox(height: 6.0),
                prototypeLabel,
                SizedBox(height: 58.0),
                Container(
                  child: emailField,
                  color: Color(0xFFFAFAFA),
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
                SizedBox(height: 20.0),
                Container(
                  child: passwordField,
                  color: Color(0xFFFAFAFA),
                  width: MediaQuery.of(context).size.width / 1.5,
                ),
                SizedBox(height: 20.0),
                loginButton,
                SizedBox(height: 120.0),
                rightsText,
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}
