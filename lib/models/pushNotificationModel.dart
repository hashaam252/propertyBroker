class NotificationModel {
  final bool withError;
  final String shortMessage;
  final List<NotificationResult> result;

  NotificationModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      // withError: json['error'],
      // shortMessage: json['message'],
      result: (json['list'] as List)
          .map((e) => NotificationResult.fromJson(e))
          .toList(),
    );
  }
}

class NotificationResult {
  var id, time, name, email, phone, isRead, type, propertId;
  NotificationResult(
      {this.email,
      this.id,
      this.time,
      this.phone,
      this.type,
      this.propertId,
      this.isRead,
      this.name});

  factory NotificationResult.fromJson(Map<String, dynamic> json) {
    return NotificationResult(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      type: json['type'] ?? "",
      phone: json['phone'] ?? "",
      isRead: json['unread'] ?? 0,
      propertId: json['property_id'] ?? "",
      time: json['preferred_time'],
    );
  }
}
