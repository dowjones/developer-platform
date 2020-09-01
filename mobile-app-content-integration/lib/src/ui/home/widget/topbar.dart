
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TopBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  TopBar({this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FB),
      ),
      padding: EdgeInsets.only(
        top: mediaQuery.padding.top + 32.0,
        bottom: mediaQuery.padding.bottom + 16.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          WidgetTitle(),
          Container(
            height: 23.0,
            width: 83.0,
            child: IconButton(
              icon: Icon(
                Icons.dehaze,
              ), 
              onPressed: () {
                scaffoldKey.currentState.openDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class WidgetTitle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 90, 0),
        child: Container(
          height: 10.0,
          width: 184,
          child: SvgPicture.asset(
            'assets/images/dev_platform_one_line_full_color.svg',
            semanticsLabel: 'Dev Portal Logo',
          ),
        ),
      ),
    );
  }
}
