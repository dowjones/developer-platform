import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/auth/baseauth.dart';
import 'package:flutter_news_app/src/bloc/company/company_bloc.dart';
import 'package:flutter_news_app/src/bloc/home/home_bloc.dart';
import 'package:flutter_news_app/src/ui/home/widget/company.dart';
import 'package:flutter_news_app/src/ui/home/widget/drawer_menu.dart';
import 'package:flutter_news_app/src/ui/home/screen/recommendation_screen.dart';
import 'package:flutter_news_app/src/ui/home/screen/stocks_screen.dart';
import 'package:flutter_news_app/src/ui/home/widget/topbar.dart';
import 'package:flutter_news_app/src/bloc/stocks/stocks_bloc.dart';
import 'package:flutter_news_app/src/ui/home/widget/topstories.dart';

final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
class HomeScreen extends StatefulWidget {
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  HomeScreen({this.userId, this.auth, this.logoutCallback});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _indexBottomElement = 0;
  var _companyBloc;

  @override
  Widget build(BuildContext context) {
    _companyBloc = CompanyBloc(); // Check if there is a better way to catch the close/open bloc

    final homeBlocProvider = MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc(),
        ),
        BlocProvider<StockBloc>(
          create: (context) => StockBloc(),
        ),
        BlocProvider<CompanyBloc>(
          create: (context) => _companyBloc,
        ),
      ],
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  TopBar(scaffoldKey: scaffoldState),
                  SizedBox(height: 12.0),
                  WidgetCompany(userId: widget.userId),
                  TabBar(
                    tabs: <Widget>[
                      Tab(
                        icon: Icon(
                          Icons.assignment,
                          // color: Color(0xFF99A4B1),
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.show_chart,
                          // color: Color(0xFF99A4B1),
                        ),
                      ),
                    ],
                    labelColor: Color(0xFF00A3D5),
                    unselectedLabelColor: Color(0xFF99A4B1),
                  )
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: WidgetLatestNews(),
                        )
                      ]
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildWidgetTitleLable(context, 'Latest Trends'),
                      SizedBox(height: 8.0),
                      Expanded(
                          child: StocksWidget()
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );

    final recommendingBlocProvider = BlocProvider<CompanyBloc>(
      create: (context) => _companyBloc,
      child: RecommendationScreen(scaffoldKey: scaffoldState, userId: widget.userId),
    );
    
    final homeWidgets = [
      homeBlocProvider,
      recommendingBlocProvider,
    ];
    
    final bottomTextStyle = TextStyle(
      fontFamily: 'Roboto-Regular',
      fontSize: 8.0,
    );

    final bottomNavigationBar = BottomNavigationBar(
      onTap: (int index) {
        setState(() {
          _indexBottomElement = index;
        });
      },
      currentIndex: _indexBottomElement,
      selectedItemColor: Color(0xFF00A3D5),
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          title: Text(
            'HOME',
            style: bottomTextStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.equalizer,
          ),
          title: Text(
            'RECOMMEND',
            style: bottomTextStyle,
          ),
        ),
      ],
      backgroundColor: Color(0xFFF8F9FB),
    );

    return Scaffold(
      key: scaffoldState,
      body: homeWidgets[_indexBottomElement],
      bottomNavigationBar: bottomNavigationBar,
      drawer: DrawerMenu(logoutCallback: widget.logoutCallback),
    );
  }

  Widget _buildWidgetTitleLable(BuildContext context, title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle2.merge(
          TextStyle(
            fontFamily: 'Roboto-Regular',
            fontSize: 8.0,
            color: Color(0xFF39485A),
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class WidgetLatestNews extends StatefulWidget {
  WidgetLatestNews();

  @override
  _WidgetLatestNewsState createState() => _WidgetLatestNewsState();
}

class _WidgetLatestNewsState extends State<WidgetLatestNews> {
  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    return Padding(
      padding: EdgeInsets.only(
        bottom: mediaQuery.padding.bottom + 16.0,
      ),
      child: BlocListener<HomeBloc, DataState>(
        listener: (context, state) {
          if (state is DataFailed) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
        },
        child: BlocBuilder(
          bloc: homeBloc,
          builder: (BuildContext context, DataState state) {
            return _buildWidgetContentLatestNews(state, mediaQuery);
          },
        ),
      ),
    );
  }

  Widget _buildWidgetContentLatestNews(
      DataState state, MediaQueryData mediaQuery) {
    if (state is DataLoading) {
      return Center(
        child: Platform.isAndroid
            ? CircularProgressIndicator()
            : CupertinoActivityIndicator(),
      );
    } else if (state is DataSucessTopStories) {
      return TopStoriesWidget(data: state.data, name: state.name);
    } else {
      return Container();
    }
  }
}
