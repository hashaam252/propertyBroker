import 'package:property_broker/models/propertiesmodel.dart';

class SingleProductModel {
  final PropertyResult result;

  SingleProductModel({
    this.result,
  });

  factory SingleProductModel.fromJson(Map<String, dynamic> json) {
    return SingleProductModel(
      result: PropertyResult.fromJson(json),
    );
  }
}
