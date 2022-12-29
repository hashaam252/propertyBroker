import 'package:property_broker/models/staffmodel.dart';

class DashboardModel {
  final bool withError;
  final String shortMessage;
  BarchartModel barchartModel;
  List<SaleResult> saleResult;
  List<RentResult> rentResult;

  DashboardModel({
    this.withError,
    this.barchartModel,
    this.rentResult,
    this.saleResult,
    this.shortMessage,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      // withError: json['error'],
      // shortMessage: json['message'],
      barchartModel: BarchartModel.fromJson(json['barChartData']),
      rentResult: (json['graphDataYearlyStatsRent'] as List)
          .map((e) => RentResult.fromJson(e))
          .toList(),
      saleResult: (json['graphDataYearlyStatsSale'] as List)
          .map((e) => SaleResult.fromJson(e))
          .toList(),
    );
  }
}

class SaleResult {
  var date;
  var value;
  SaleResult({
    this.date,
    this.value,
  });
  factory SaleResult.fromJson(Map<String, dynamic> json) {
    return SaleResult(
      date: json['date'] ?? "",
      value: json['value'] ?? 0,
    );
  }
}

class RentResult {
  var date;
  var value;
  RentResult({
    this.date,
    this.value,
  });
  factory RentResult.fromJson(Map<String, dynamic> json) {
    return RentResult(
      date: json['date'] ?? "",
      value: json['value'] ?? 0,
    );
  }
}

class BarchartModel {
  List name = List();
  List saleCount = List();
  List rentCount = List();
  List commercialsaleCount = List();
  List commercialrentCount = List();

  BarchartModel(
      {this.name,
      this.commercialrentCount,
      this.commercialsaleCount,
      this.rentCount,
      this.saleCount});

  factory BarchartModel.fromJson(Map<String, dynamic> json) {
    return BarchartModel(
      name: json['names'] ?? [],
      saleCount: json['saleCounts'] ?? [],
      rentCount: json['rentCounts'] ?? [],
      commercialrentCount: json['commercialRentCounts'] ?? [],
      commercialsaleCount: json['commercialSaleCounts'] ?? [],
    );
  }
}
