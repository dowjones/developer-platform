import 'package:dio/dio.dart';
import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';


class StockApiProvider {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://us-central1-dj-finance-recommendation.cloudfunctions.net/retrieveTicker';

  Future<ResponseCompanyDataPoint> getCompanyStockInformation(company) async {
    try {
      final response = await _dio.get('$_baseUrl?ticker=$company');
      return ResponseCompanyDataPoint.fromJson(response.data);
    } catch (error, stacktrace) {
      print('Exception occured: $error with stacktrace: $stacktrace');
      return ResponseCompanyDataPoint.withError(error.toString());
    }
  }

}
