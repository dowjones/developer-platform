import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';

class CompanyApiProvider {
  final Dio _dio = Dio();
  final String _firebaseUrl = 'https://us-central1-dj-finance-recommendation.cloudfunctions.net';

  Future<Company> getCompany(name) async {
    try {
      final companyResponse = await _dio.get('$_firebaseUrl/getCompany?name=$name');
      final companyData = companyResponse.data;

      final company = Company(
        commonName: companyData['name'],
        ticker: companyData['ticker'],
        image: companyData['logo'],
        domain: companyData['domain']
      );
      
      return company;
    } catch (error, stacktrace) {
      print('Exception occured in getCompany: $error with stacktrace: ${stacktrace}:${name}');
      return null;
    }
  }

  // Working
  Future<List<Company>> getCompanies(String userId) async {
    try {
      final response = await _dio.get('$_firebaseUrl/userProfile?userId=$userId');
      final data = response.data['companies'];
      final companies = data
        .map<Company>((company) => 
          Company(
            commonName: company['name'],
            image: company['logo'],
            ticker: company['ticker'],
            domain: company['domain'])
          ).toList();
          
      return companies.where((company) => company.commonName != 'Add')
        .where((company) => company.commonName != 'All')
        .where((company) => company.image != null)
        .toList();
    } catch (error, stacktrace) {
      print('Exception occured in getCompanies: $error with stacktrace: ${stacktrace}');
      return [];
    }
  }

  Future<int> postCompany(String userId, Company company) async {
    try {
      final payload = {
        'user': {
          'username': userId,
        },
        'company': {
          'name': company.commonName,
          'logo': company.image,
          'ticker': company.ticker,
          'domain': company.domain
        }
      };
      final payloadEncoded = jsonEncode(payload);
      final response = await _dio.post('$_firebaseUrl/userProfile', data: payloadEncoded);

      return response.statusCode;
    } catch (error, stacktrace) {
      print('Exception occured in postCompany: $error with stacktrace: ${stacktrace}');
      return 500;
    }
  }

  Future<List<Company>> recommendCompany(String domain) async {
    try {
      final response = await _dio.get('$_firebaseUrl/recommendCompany?domain=$domain');
      final companiesData = response.data['results'];
      var companies = companiesData.map<Company>((company) {
        if (company['name'] != null) {
          return Company(
            commonName: company['name'],
            ticker: company['ticker'],
            image: company['logo'],
            domain: company['domain']
          );
        }
        return null;
      });

      return companies
        .where((company) => company != null)
        .toList();
    } catch(error, stacktrace) {
      print('Exception occured in recommendCompany: $error with stacktrace: ${stacktrace}:${domain}');
      return null;
    }
  }
}
