class StaffModel {
  final bool withError;
  final String shortMessage;
  final List<StaffResult> result;

  StaffModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
      // withError: json['error'],
      // shortMessage: json['message'],
      result:
          (json['staff'] as List).map((e) => StaffResult.fromJson(e)).toList(),
    );
  }
}

class StaffResult {
  var id,
      name,
      email,
      phone,
      logo,
      brokerTypeId,
      propertiesAllowed,
      recurringDate,
      whatsApp,
      featured,
      description,
      descriptionAr,
      type,
      profileImage,
      zone,
      propertyId,
      detail,
      address,
      date,
      status,
      baseUrl;
  StaffResult(
      {this.id,
      this.date,
      this.status,
      this.baseUrl,
      this.brokerTypeId,
      this.email,
      this.address,
      this.featured,
      this.zone,
      this.logo,
      this.description,
      this.detail,
      this.propertyId,
      this.descriptionAr,
      this.name,
      this.phone,
      this.profileImage,
      this.propertiesAllowed,
      this.recurringDate,
      this.type,
      this.whatsApp});
  factory StaffResult.fromJson(Map<String, dynamic> json) {
    return StaffResult(
        id: json['id'] ?? "",
        date: json["created_at"] ?? "",
        propertyId: json['property_id'] ?? "",
        name: json['name'] ?? "",
        email: json['email'] ?? "",
        phone: json['phone'] ?? "",
        status: json['status'] ?? 1,
        logo: json['logo'] ?? "",
        propertiesAllowed: json['properties_allowed'] ?? "",
        recurringDate: json['recurring_date'] ?? "",
        whatsApp: json['whatsapp_no'] ?? "",
        featured: json['total_featured_allowed'] ?? "",
        type: json['type'] ?? "",
        brokerTypeId: json['broker_type_id'] ?? "",
        profileImage: json['profile_image'] ?? "",
        baseUrl: json['base_url'] ?? "",
        address: json['address'] ?? "",
        detail: json['details'] ?? "",
        zone: json['zone'] ?? "");
  }
}
