import 'package:json_annotation/json_annotation.dart';
part 'company_stock_data.g.dart';

@JsonSerializable()
class ResponseCompanyDataPoint {
  List<CompanyStockDataPoint> stockDataPoints;
  String error;

  ResponseCompanyDataPoint(this.stockDataPoints);

  factory ResponseCompanyDataPoint.fromJson(List<dynamic> json) {
    var datums = <CompanyStockDataPoint>[];
    datums = json.map( ( e ) => _$CompanyStockDataPointFromJson(e) ).toList();
    return ResponseCompanyDataPoint(datums);
  }

  ResponseCompanyDataPoint.withError(this.error);

  @override
  String toString() {
    return 'Total count: ${stockDataPoints.length}';
  }
}

@JsonSerializable()
class CompanyStockDataPoint {
  DateTime date;
  double close;
  double open;
  double high;
  double low;

  factory CompanyStockDataPoint.fromJson(Map<String, dynamic> json) => _$CompanyStockDataPointFromJson(json);

  CompanyStockDataPoint(this.date, this.close, this.open, this.high, this.low);

  @override
  String toString() {
    return '$date: $close, $open';
  }
}

class Company {
  String commonName;
  String ticker;
  String image;
  String domain;
  List<CompanyStockDataPoint> stockDataPoints;

  Company({this.commonName, this.ticker, this.image, this.domain});

  @override
  String toString() {
    return commonName;
  }
}
