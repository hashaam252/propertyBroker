class SupportModel {
  final SupportModelResult result;

  SupportModel({
    this.result,
  });

  factory SupportModel.fromJson(Map<String, dynamic> json) {
    return SupportModel(
      result: SupportModelResult.fromJson(json),
    );
  }
}

class SupportModelResult {
  int id;

  var name, email, isSuper, phone, active, whatsApp;
  SupportModelResult(
      {this.active,
      this.email,
      this.id,
      this.isSuper,
      this.name,
      this.phone,
      this.whatsApp});

  factory SupportModelResult.fromJson(Map<String, dynamic> json) {
    return SupportModelResult(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      isSuper: json['is_super'] ?? "",
      phone: json['phone'] ?? "",
      active: json['active'] ?? "",
      email: json['email'] ?? "",
      whatsApp: json['whatsapp_no'] ?? "",
    );
  }
}
