import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  final VoidCallback logoutCallback;
  DrawerMenu({this.logoutCallback});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
    );

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Options',
              style: textStyle.copyWith(
                color: Colors.white,
              ),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF00A3D5),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.explore
            ),
            title: Text(
              'About',
              style: textStyle,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Log out',
              style: textStyle
            ),
            onTap: () {
              logoutCallback();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
