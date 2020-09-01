import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/bloc/stocks/stocks_bloc.dart';
import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class StocksWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StockGraphContainer();
  }
}

class StockGraphContainer extends StatefulWidget {
  @override
  _StockGraphContainerState createState() => _StockGraphContainerState();
}

class _StockGraphContainerState extends State<StockGraphContainer> {
  List _selectedStockPoints = [];
  Map _companies = {};
  charts.TimeSeriesChart _chart;
  bool reloadChart = true;

  List<charts.Series<CompanyStockDataPoint, DateTime>> generateSeries(stockSeries) {
    final colors = colorGenerator().iterator;
    return List<charts.Series<CompanyStockDataPoint, DateTime>>.from(
        stockSeries.keys.map((stockSerie) {
          colors.moveNext();
          final color = getChartColor(colors.current);
          return charts.Series(
            id: stockSerie,
            data: stockSeries[stockSerie],
            seriesColor: color,
            domainFn: (CompanyStockDataPoint value, _) => value.date,
            measureFn: (CompanyStockDataPoint value, _) => value.close,
            measureLowerBoundFn: (CompanyStockDataPoint value, _) => value.low,
            measureUpperBoundFn: (CompanyStockDataPoint value, _) => value.high,
          );

        }).toList()
    );
  }

  Iterable<Color> colorGenerator() sync* {
    var startColor = 160.0;
    var endColor = 340;
    var colorIncrease = 0;

    while ( true ) {
      colorIncrease += 40;
      if ( (startColor + colorIncrease) > endColor ) {
        colorIncrease = 20;
      }
      yield HSLColor.fromAHSL(1.0, startColor + colorIncrease, 1.0, 0.5).toColor();
    }
  }

  charts.Color getChartColor(Color color) {
    return charts.Color(
        r: color.red,
        g: color.green,
        b: color.blue,
        a: color.alpha);
  }

  Widget _buildChartWidget(BuildContext context, StockState state) {
    if ( _chart == null || reloadChart ) {
      _companies = state.companiesData;
      _chart = charts.TimeSeriesChart(
        generateSeries(state.companiesStockData),
        animate: true,
        behaviors: [
          charts.SeriesLegend(
            horizontalFirst: false,
            desiredMaxRows: 2,
          ),
        ],
        selectionModels: [
          charts.SelectionModelConfig(changedListener: _onSelectionChange,)
        ],
      );
    }

   final mediaQuery = MediaQuery.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: mediaQuery.size.height * 0.35,
          child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: _chart
          ),
        ),
        SizedBox(height: 8.0,),
        Expanded(
          child: ListView.separated(
            itemCount: _selectedStockPoints.length,
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: _buildCardWidget,
          ),
        )
      ],
    );
  }

  Widget _buildCardWidget(context, index) {
    final _stockPoint = _selectedStockPoints[index];
    final stockLabelStyle = TextStyle(
      color: Color(0xFF39485A),
      fontFamily: 'Roboto-Medium',
      fontSize: 8,
    );
    final stockValueStyle = TextStyle(
      fontSize: 16,
      fontFamily: 'SimplonNorm-Medium',
      color: Color(0xFF00A3D5),
      fontWeight: FontWeight.normal,
    );
    final buttonStyle = TextStyle(
      fontFamily: 'Roboto-Medium',
      color: Color(0xFF00A3D5),
      fontSize: 14.0,
      letterSpacing: 0.5,
      fontWeight: FontWeight.w500,
    );

    return ClipRect(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _companies.containsKey(_stockPoint.series.id) ? 
                  Column(
                    children: [
                      Text(
                        _stockPoint.series.id,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF39485A),
                          fontFamily: 'SimplonNorm-Medium',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        _companies[_stockPoint.series.id].commonName,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF39485A),
                          fontFamily: 'SimplonNorm-Regular',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        width: 48.0,
                        height: 48.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(_companies[_stockPoint.series.id].image),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ) :
                  Text(
                      _stockPoint.series.id,
                      style: TextStyle(fontSize: 18, color: Color(0xFF325384), fontWeight: FontWeight.bold)
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Open: ', 
                            style: stockLabelStyle.copyWith(
                              color: Color(0xFF99A4B1),
                            ),
                          ),
                          Text(
                            '${_stockPoint.datum.open.toStringAsFixed(2)}',
                            style: stockValueStyle.copyWith(
                              color: Color(0xFF39485A),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Close: ', 
                            style: stockLabelStyle.copyWith(
                              color: Color(0xFF99A4B1),
                            ),
                          ),
                          Text(
                            '${_stockPoint.datum.close.toStringAsFixed(2)}',
                            style: stockValueStyle.copyWith(
                              color: Color(0xFF39485A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Low: ', 
                            style: stockLabelStyle.copyWith(
                              color: Color(0xFF99A4B1),
                            ),
                          ),
                          Text(
                            '${_stockPoint.datum.low.toStringAsFixed(2)}',
                            style: stockValueStyle.copyWith(
                              color: Color(0xFF39485A),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'High',
                            style: stockLabelStyle.copyWith(
                              color: Color(0xFF00A3D5),
                            ),
                          ),
                          Text(
                              '${_stockPoint.datum.high.toStringAsFixed(2)}',
                              style: stockValueStyle,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ButtonTheme(
                        minWidth: 30.0,
                        height: 30.0,
                        child: OutlineButton(
                          onPressed: () {},
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          child: Text(
                            'SELL',
                            style: buttonStyle,
                          ),
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: ButtonTheme(
                        minWidth: 30.0,
                        height: 30.0,
                        child: RaisedButton(
                          onPressed: () {},
                          child: Text(
                            'BUY',
                            style: buttonStyle.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          color: Color(0xFF00A3D5),
                        ),
                      ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }




  void _onSelectionChange(charts.SelectionModel model) {
    if (model.hasDatumSelection) {
      setState(() {
        _selectedStockPoints = model.selectedDatum;
        reloadChart = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocListener<StockBloc, StockState>(
        listener: (context, state) {
          if ( state.result == States.incomplete || state.result == States.failed ) {
            _chart = null;
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder(
          bloc: BlocProvider.of<StockBloc>(context),
          builder: (BuildContext context, StockState state) {
            switch (state.result) {
              case States.loading:
                reloadChart = true;
                _selectedStockPoints = [];
                return Center(child: Platform.isAndroid ? CircularProgressIndicator() : CupertinoActivityIndicator());
              case States.finished:
              case States.incomplete:
                return _buildChartWidget(context, state);
              default:
                return Center(child: Text('Data not available'));
            }
          },
        ),
      ),
    );
  }
}

