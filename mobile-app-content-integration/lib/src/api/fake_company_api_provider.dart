import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';

class FakeCompanyApiProvider {

  Future<Company> getCompany(name) async {
    print('Fake getCompany');
    return Company(
      commonName: 'Amazon',
      ticker: 'AMZN',
      image: 'https://p7.hiclipart.com/preview/832/502/474/text-brand-clip-art-amazon.jpg',
      domain: 'www.amazon.com',
    );
  }

  Future<List<Company>> getCompanies(String userId) async {
    print('Fake getCompanies');
    return [
      Company(
        commonName: 'Amazon',
        ticker: 'AMZN',
        image: 'https://p7.hiclipart.com/preview/832/502/474/text-brand-clip-art-amazon.jpg',
        domain: 'www.amazon.com',
      ),
      Company(
        commonName: 'Disney',
        ticker: 'DIS',
        image: 'https://i.pinimg.com/originals/dc/5f/ee/dc5fee0189b193c8ebf8e19076ad56f0.png',
        domain: 'www.disney.com'
      )
    ];
  }

  Future<int> postCompany(String userId, Company company) async {
    print('Fake postCompany');
    return 200;
  }

  Future<List<Company>> recommendCompany(String domain) async {
    print('Fake recommendCompany');
    
    return [
      Company(
        commonName: 'Apple',
        ticker: 'AAPL',
        image: 'https://cdn3.iconfinder.com/data/icons/picons-social/57/56-apple-512.png',
        domain: 'www.apple.com',
      ),
      Company(
        commonName: 'Nike',
        ticker: 'NKE',
        image: 'https://www.marketingdirecto.com/wp-content/uploads/2014/01/nike-logo.jpg',
        domain: 'www.nike.com'
      )
    ];
  }
}
