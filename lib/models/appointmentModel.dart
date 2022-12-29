import 'package:property_broker/models/staffmodel.dart';

class AppointmentModel {
  final bool withError;
  final String shortMessage;
  final List<StaffResult> result;

  AppointmentModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      // withError: json['error'],
      // shortMessage: json['message'],
      result: (json['data']['appointment_request'] as List)
          .map((e) => StaffResult.fromJson(e))
          .toList(),
    );
  }
}
