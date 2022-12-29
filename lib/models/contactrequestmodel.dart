import 'package:property_broker/models/staffmodel.dart';

class ContactRequestModel {
  final bool withError;
  final String shortMessage;
  final List<StaffResult> result;

  ContactRequestModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory ContactRequestModel.fromJson(Map<String, dynamic> json) {
    return ContactRequestModel(
      // withError: json['error'],
      // shortMessage: json['message'],
      result: (json['data']['contact_request'] as List)
          .map((e) => StaffResult.fromJson(e))
          .toList(),
    );
  }
}
