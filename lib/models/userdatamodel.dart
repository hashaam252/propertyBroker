class UserDataModel {
  final UserResult result;
  var activeProperties, featuredProperties, subscriptionStatus;

  UserDataModel(
      {this.result,
      this.activeProperties,
      this.featuredProperties,
      this.subscriptionStatus});

  factory UserDataModel.fromJson(Map<String, dynamic> json) {
    return UserDataModel(
      subscriptionStatus: json['active_properties'] ?? "",
      featuredProperties: json['feature_properties'] ?? "",
      activeProperties: json['subscription_status'] ?? "",
      result: UserResult.fromJson(json),
    );
  }
}

class UserResult {
  int id;

  var name,
      email,
      company,
      address,
      phone,
      active,
      logo,
      description,
      arName,
      brokerTypeId,
      lat,
      long,
      zoneLocation,
      descriptionAr,
      propertiesAllowed,
      recurringDate,
      whatsApp,
      baseUrl,
      zone;
  var status;
  int emailVerified;
  UserResult(
      {this.status,
      this.emailVerified,
      this.id,
      this.email,
      this.active,
      this.address,
      this.arName,
      this.baseUrl,
      this.brokerTypeId,
      this.company,
      this.description,
      this.descriptionAr,
      this.lat,
      this.logo,
      this.long,
      this.name,
      this.phone,
      this.propertiesAllowed,
      this.recurringDate,
      this.whatsApp,
      this.zone,
      this.zoneLocation});

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      id: json['id'],
      name: json['name'],
      emailVerified: json['EmailVerifiedAt'],
      company: json['company'] ?? "",
      address: json['address'] ?? "",
      email: json['email'] ?? "",
      phone: json['phone'] ?? "",
      status: json['Status'],
      active: json['active'],
      logo: json['logo'],
      description: json['description'],
      arName: json['ar_company'] ?? "",
      long: json['lng'] ?? "",
      lat: json['lat'] ?? "",
      descriptionAr: json['description_ar'] ?? "",
      recurringDate: json['recurring_date'],
      whatsApp: json['whatsapp_no'],
      baseUrl: json['base_url'] ?? "",
      zone: json['zone'] ?? "",
      zoneLocation: json['zone_location'] ?? "",
      brokerTypeId: json['broker_type_id'] ?? "",
    );
  }
}
