// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_stock_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseCompanyDataPoint _$ResponseCompanyDataPointFromJson(
    Map<String, dynamic> json) {
  return ResponseCompanyDataPoint(
    (json['stockDataPoints'] as List)
        ?.map((e) => e == null
            ? null
            : CompanyStockDataPoint.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )..error = json['error'] as String;
}

Map<String, dynamic> _$ResponseCompanyDataPointToJson(
        ResponseCompanyDataPoint instance) =>
    <String, dynamic>{
      'stockDataPoints': instance.stockDataPoints,
      'error': instance.error,
    };

CompanyStockDataPoint _$CompanyStockDataPointFromJson(
    Map<String, dynamic> json) {
  return CompanyStockDataPoint(
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    (json['close'] as num)?.toDouble(),
    (json['open'] as num)?.toDouble(),
    (json['high'] as num)?.toDouble(),
    (json['low'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$CompanyStockDataPointToJson(
        CompanyStockDataPoint instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'close': instance.close,
      'open': instance.open,
      'high': instance.high,
      'low': instance.low,
    };
