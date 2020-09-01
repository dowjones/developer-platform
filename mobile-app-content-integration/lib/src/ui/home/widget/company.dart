import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/bloc/company/company_bloc.dart';
import 'package:flutter_news_app/src/bloc/home/home_bloc.dart';
import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';
import 'package:flutter_news_app/src/bloc/stocks/stocks_bloc.dart';
import 'package:flutter_news_app/src/ui/home/widget/register_company.dart';

class WidgetCompany extends StatefulWidget {
  final String userId;
  WidgetCompany({this.userId});

  @override
  _WidgetCompanyState createState() => _WidgetCompanyState();
}

class _WidgetCompanyState extends State<WidgetCompany> {
  final List<Company> _allCompanyButton = [
    Company(
      commonName: 'All',
    ),
  ];
  final List<Company> _addCompanyButton = [
    Company(
      commonName: 'Add',
      image: 'https://content.fortune.com/wp-content/uploads/2019/04/brb05.19.plus_.jpg',
    ),
  ];
  List<Company> _listCompanies = [];

  int indexSelectedCompany = 0;
  HomeBloc _homeBloc;
  StockBloc _stocksBloc;
  CompanyBloc _companyBloc;

  @override
  void initState() {
    var _listCompanies = _allCompanyButton + _addCompanyButton;
    _homeBloc = BlocProvider.of<HomeBloc>(context);
    _stocksBloc = BlocProvider.of<StockBloc>(context);
    _companyBloc = BlocProvider.of<CompanyBloc>(context);
    _companyBloc.add(CompanyEventList(widget.userId));
    _homeBloc.add(DataEvent(category: _listCompanies[indexSelectedCompany].commonName));
    super.initState();
  }

  Widget _buildCompanyWidget(BuildContext context) {
    return Container(
      height: 74,
      child: ListView.builder(
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var itemCompany = _listCompanies[index];
          return Padding(
            padding: EdgeInsets.only(
              left: 16.0,
              right: index == _listCompanies.length - 1 ? 16.0 : 0.0,
            ),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      indexSelectedCompany = index;
                    });
                    if (_listCompanies[indexSelectedCompany].commonName == 'Add') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BlocProvider<CompanyBloc>.value(
                            value: _companyBloc,
                            child:  RegisterCompanyWidget(userId: widget.userId),
                          );
                        });
                    } else if (_listCompanies[indexSelectedCompany].commonName == 'All') {
                      _homeBloc.add(DataEvent(
                          category: _listCompanies[indexSelectedCompany].commonName));
                      _stocksBloc.add(StockEvent(
                          action: StockEventType.loadAllCompanies,
                          companies: _listCompanies
                      ));
                    } else {
                      _homeBloc.add(DataEvent(
                          category: _listCompanies[indexSelectedCompany].commonName));
                      _stocksBloc.add(StockEvent(
                          action: StockEventType.loadCompany,
                          company: _listCompanies[indexSelectedCompany].ticker,
                          companies: _listCompanies
                      ));

                    }
                  },
                  child: index == 0
                      ? Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF00A3D5),
                      border: indexSelectedCompany == index
                          ? Border.all(
                        color: Color(0xFF00A3D5),
                        width: 5.0,
                      )
                          : null,
                    ),
                    child: Icon(
                      Icons.apps,
                      color: Colors.white,
                    ),
                  )
                      : itemCompany.commonName == 'Add' ?
                       Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: indexSelectedCompany == index
                          ? Border.all(
                        color: Colors.white,
                        width: 5.0,
                      )
                          : null,
                    ),
                    child: Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF8090A2),
                      size: 40.0,
                    ),
                  )
                      : Container(
                    width: 48.0,
                    height: 48.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(itemCompany.image),
                        fit: BoxFit.cover,
                      ),
                      border: indexSelectedCompany == index
                          ? Border.all(
                        color: Color(0xFF8090A2),
                        width: 10.0,
                      )
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  itemCompany.commonName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Roboto-Regular',
                    fontSize: 12,
                    color: Color(0xFF8090A2),
                    fontWeight: indexSelectedCompany == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: _listCompanies.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyBloc, CompanyState>(
      listener: (context, state) {
        if (state is CompanySuccess) {
          _listCompanies = _allCompanyButton + _addCompanyButton + state.data;
          _stocksBloc.add(StockEvent(action: StockEventType.loadAllCompanies, companies: _listCompanies));
        }
      },
      child: BlocBuilder<CompanyBloc, CompanyState>(
          bloc: _companyBloc,
          builder: (BuildContext context, CompanyState state) {
            if (state is CompanySuccess) {
              return _buildCompanyWidget(context);
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
