import 'package:bloc/bloc.dart';
import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';
import 'package:flutter_news_app/src/api/api_repository.dart';

enum StockEventType { loadAllCompanies, loadCompany, lockGraph }

class StockEvent {
  StockEventType action;
  String company;
  List<Company> companies;

  StockEvent({ this.action, this.company, this.companies});
}

enum States { loading, finished, failed, incomplete, displaySelected }

class StockState {
  Map companiesData;
  Map companiesStockData;
  States result;
  String message;


  StockState(this.result);

  StockState.withData(this.companiesData, this.companiesStockData) : result = States.finished;

  StockState.withError(this.message) : result = States.failed;

  StockState.incomplete(this.message, this.companiesData, this.companiesStockData) : result = States.incomplete;

  @override
  String toString() {
    return '$result';
  }
}


class StockBloc extends Bloc<StockEvent, StockState>{

  ApiRepository _apiRepository;


  @override
  StockState get initialState => StockState(States.loading);

  @override
  Stream<StockState> mapEventToState(StockEvent event) async* {
    yield StockState(States.loading);
    _apiRepository = ApiRepository();
    final companiesDict = Map.fromIterable(event.companies,
      key: (company) => company.ticker,
      value: (company) => company
    );
    switch(event.action) {
      case StockEventType.loadAllCompanies:
        final tickers = event.companies
            .map((company) => company.ticker)
            .where((company) => company != null)
            .toList();
        final stockData = await getAllCompaniesData(tickers);
        final completeData = stockData.entries.where((e) => e != null).toList();
        if ( completeData.length == ( event.companies.length - 2 ) ) {
          yield StockState.withData(companiesDict, stockData);
        } else if ( completeData.isNotEmpty ) {
          yield StockState.incomplete('Data might be incomplete', companiesDict, stockData);
        } else {
          yield StockState.withError('Failed to fetch data');
        }
        break;
      case StockEventType.loadCompany:
        if ( event.company == null ) {
          yield StockState.withError('Failed to fetch data');
          break;
        }

        final data = await _apiRepository.getCompanyStockInformation(event.company);
        yield ( data.error == null ) ? StockState.withData(companiesDict, { event.company : data.stockDataPoints }) : StockState.withError('Failed to fetch data');
        break;
      case StockEventType.lockGraph:
        yield StockState(States.displaySelected);
        break;
    }
  }

  Future<Map> getAllCompaniesData(companiesTicker) async {
    var _companiesStockPoints = {};

    await Future.forEach(companiesTicker, (company) async{
      _companiesStockPoints[company] = await getOneCompanyData(company);
    });

    return _companiesStockPoints;
  }

  Future<List<CompanyStockDataPoint>> getOneCompanyData(company) async {
      final data = await _apiRepository.getCompanyStockInformation(company);
      return data.stockDataPoints;
  }
}
