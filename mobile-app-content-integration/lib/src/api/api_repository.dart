import 'dart:async';

import 'package:flutter_news_app/src/api/top_stories_api_provider.dart';
import 'package:flutter_news_app/src/api/company_api_provider.dart';
import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';
import 'package:flutter_news_app/src/api/stock_api_provider.dart';
import 'package:flutter_news_app/src/model/topstories/topstories.dart';

class ApiRepository {
  final _stockApiProvider = StockApiProvider();
  final _topStoriesApiProvider = TopStoriesApiProvider();
  final _companyApiProvider = CompanyApiProvider();

  Future<ResponseCompanyDataPoint> getCompanyStockInformation(company) =>
      _stockApiProvider.getCompanyStockInformation(company);

  Future<TopStories> fetchTopStories() =>
      _topStoriesApiProvider.getTopStories();

  Future<Company> fetchCompany(company) =>
      _companyApiProvider.getCompany(company);
  
  Future<List<Company>> fetchCompanies(userId) =>
      _companyApiProvider.getCompanies(userId);
  
  Future<int> storeCompany(userId, company) =>
      _companyApiProvider.postCompany(userId, company);
  
  Future<List<Company>> recommendCompany(domain) =>
      _companyApiProvider.recommendCompany(domain);
}
