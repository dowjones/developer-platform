import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/bloc/company/company_bloc.dart';
import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';
import 'package:flutter_news_app/src/ui/home/widget/topbar.dart';

class RecommendationScreen extends StatefulWidget {
  final String userId;
  final GlobalKey<ScaffoldState> scaffoldKey;
  RecommendationScreen({this.scaffoldKey, this.userId});

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  CompanyBloc _companyBloc;
  List<Company> _suggestedCompanies = [];

  @override
  void initState() {
    _companyBloc = BlocProvider.of<CompanyBloc>(context);
    _companyBloc.add(CompanyEventRecommend(widget.userId));
    super.initState();
  }

  Widget _buildRecommendationWidget(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TopBar(scaffoldKey: widget.scaffoldKey),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 6.0),
                          child: Row(
                            children: [
                              _suggestedCompanies[position].image != null ?
                              Container(
                                width: 48.0,
                                height: 48.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(_suggestedCompanies[position].image),
                                    onError: (exception, stackTrace) => NetworkImage('https://flutter.io/images/catalog-widget-placeholder.png'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ) : Container(),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  _suggestedCompanies[position].commonName,
                                  style: TextStyle(
                                      fontFamily: 'Roboto-Regular',
                                      fontSize: 10.0,
                                      color: Color(0xFF8090A2),
                                      fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: FlatButton(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text(
                                      'FOLLOW',
                                      style: TextStyle(
                                        fontFamily: 'Roboto-Regular',
                                        fontSize: 14.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                _companyBloc.add(
                                  CompanyEventStore(
                                    data: _suggestedCompanies[position].commonName,
                                    userId: widget.userId
                                  )
                                );
                                _companyBloc.add(
                                  CompanySingleEventRecommend(
                                    _suggestedCompanies[position],
                                  ),
                                );
                              },
                              color: Color(0xFF00A3D5),
                            ),
                            height: 36,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 1.0,
                      thickness: 2.0,
                      color: Color(0xFFF8F8F8),
                    ),
                  ],
                );
              },
              itemCount: _suggestedCompanies.length,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xFFFFFFFF),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyBloc, CompanyState>(
      listener: (context, state) {
        if (state is CompanySuggestionSuccess) {
          _suggestedCompanies = state.data;
        }
      },
      child: BlocBuilder<CompanyBloc, CompanyState>(
          bloc: _companyBloc,
          builder: (BuildContext context, CompanyState state) {
            if (state is CompanySuggestionSuccess) {
              return _buildRecommendationWidget(context);
            }
            return Center(
              child: Platform.isAndroid
                ? CircularProgressIndicator()
                : CupertinoActivityIndicator(),
            );
          },
        ),
    );
  }
}
