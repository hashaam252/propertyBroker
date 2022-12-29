class TypesModel {
  final List<ListinTypes> listingType;
  final List<PropertyTypes> propertyType;
  final List<AmenetiesTypes> amenityType;
  final List<FurnishTypes> furnishType;
  final List<ZoneResult> zone;
  final List<ZoneLocationResult> zoneLocation;

  TypesModel(
      {this.amenityType,
      this.furnishType,
      this.zone,
      this.zoneLocation,
      this.listingType,
      this.propertyType});

  factory TypesModel.fromJson(Map<String, dynamic> json) {
    return TypesModel(
      // withError: json['error'],
      // shortMessage: json['message'],
      listingType: (json['listingTypes'] as List)
          .map((e) => ListinTypes.fromJson(e))
          .toList(),
      propertyType: (json['propertyTypes'] as List)
          .map((e) => PropertyTypes.fromJson(e))
          .toList(),
      amenityType: (json['amenities'] as List)
          .map((e) => AmenetiesTypes.fromJson(e))
          .toList(),
      furnishType: (json['furnishTypes'] as List)
          .map((e) => FurnishTypes.fromJson(e))
          .toList(),
      zone: (json['zones'] as List).map((e) => ZoneResult.fromJson(e)).toList(),
      zoneLocation: (json['zone_locations'] as List)
          .map((e) => ZoneLocationResult.fromJson(e))
          .toList(),
    );
  }
}

class ListinTypes {
  var id;
  var name, arName;
  ListinTypes({this.id, this.name, this.arName});
  factory ListinTypes.fromJson(Map<String, dynamic> json) {
    return ListinTypes(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      arName: json['ar_name'] ?? "",
    );
  }
}

class PropertyTypes {
  var id;
  var name, arName;
  PropertyTypes({this.id, this.name, this.arName});
  factory PropertyTypes.fromJson(Map<String, dynamic> json) {
    return PropertyTypes(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      arName: json['ar_name'] ?? "",
    );
  }
}

class AmenetiesTypes {
  var id;
  var name, arName;
  AmenetiesTypes({this.id, this.name, this.arName});
  factory AmenetiesTypes.fromJson(Map<String, dynamic> json) {
    return AmenetiesTypes(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      arName: json['ar_name'] ?? "",
    );
  }
}

class FurnishTypes {
  var id;
  var name, arName;
  FurnishTypes({this.id, this.name, this.arName});
  factory FurnishTypes.fromJson(Map<String, dynamic> json) {
    return FurnishTypes(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      arName: json['ar_name'] ?? "",
    );
  }
}

class ZoneResult {
  var id;
  var name, arName;
  ZoneResult({this.id, this.name, this.arName});
  factory ZoneResult.fromJson(Map<String, dynamic> json) {
    return ZoneResult(
      id: json['id'] ?? 0,
      name: json['name'] ?? "",
      arName: json['ar_name'] ?? "",
    );
  }
}

class ZoneLocationResult {
  var id, zoneId;
  var name, arName;
  ZoneLocationResult({this.id, this.zoneId, this.name, this.arName});
  factory ZoneLocationResult.fromJson(Map<String, dynamic> json) {
    return ZoneLocationResult(
      id: json['id'] ?? 0,
      zoneId: json['zone_id'] ?? 0,
      name: json['name'] ?? "",
      arName: json['ar_name'] ?? "",
    );
  }
}
