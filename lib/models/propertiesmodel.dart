class PropertyModel {
  final bool withError;
  final String shortMessage;
  final List<PropertyResult> result;

  PropertyModel({
    this.withError,
    this.result,
    this.shortMessage,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      // withError: json['error'],
      // shortMessage: json['message'],
      result: (json['properties'] as List)
          .map((e) => PropertyResult.fromJson(e))
          .toList(),
    );
  }
}

class PropertyResult {
  var id,
      name,
      date,
      title,
      titleAr,
      description,
      descriptionAr,
      propertyTypeId,
      listingId,
      price,
      beds,
      area,
      lng,
      lat,
      ownerId,
      baths,
      furnishTypeId,
      isFeatured,
      address,
      city,
      cityAr,
      buildingAge,
      frontArea,
      published,
      code,
      zoneId,
      zoneLocationId,
      archive,
      assignTo,
      video,
      phone,
      email,
      detail,
      viewCount,
      refNo,
      rentalPeriod,
      youtubeLink,
      threesixtyLink,
      requestTranslation,
      baseUrl,
      videoUrl,
      propertyTypeName,
      propertyTypeAr;
  List<ProductImages> productImages = List<ProductImages>();
  List<Ameneties> ameneties = List<Ameneties>();
  PropertyResult(
      {this.id,
      this.ameneties,
      this.baseUrl,
      this.address,
      this.archive,
      this.area,
      this.assignTo,
      this.productImages,
      this.date,
      this.baths,
      this.beds,
      this.buildingAge,
      this.city,
      this.cityAr,
      this.code,
      this.description,
      this.descriptionAr,
      this.detail,
      this.email,
      this.frontArea,
      this.furnishTypeId,
      this.isFeatured,
      this.lat,
      this.listingId,
      this.lng,
      this.name,
      this.ownerId,
      this.phone,
      this.zoneId,
      this.zoneLocationId,
      this.price,
      this.propertyTypeAr,
      this.propertyTypeId,
      this.propertyTypeName,
      this.published,
      this.refNo,
      this.rentalPeriod,
      this.requestTranslation,
      this.threesixtyLink,
      this.title,
      this.titleAr,
      this.video,
      this.videoUrl,
      this.viewCount,
      this.youtubeLink});
  factory PropertyResult.fromJson(Map<String, dynamic> json) {
    return PropertyResult(
      productImages: json['images'] == null ||
              json['images'].toString() == "[]" ||
              json['images'] == []
          ? null
          : (json['images'] as List)
              .map((e) => ProductImages.fromJson(e))
              .toList(),
      ameneties: json['amenities'] == null ||
              json['amenities'].toString() == "[]" ||
              json['amenities'] == []
          ? null
          : (json['amenities'] as List)
              .map((e) => Ameneties.fromJson(e))
              .toList(),
      id: json['id'] ?? "",
      furnishTypeId: json['furnish_type_id'] ?? null,
      title: json['title'] ?? "",
      titleAr: json['titlear'] ?? "",
      description: json['description'] ?? "",
      descriptionAr: json['descriptionar'] ?? "",
      propertyTypeId: json['property_type_id'] ?? "",
      date: json['created_at'] ?? "",
      listingId: json['listing_type_id'] ?? "",
      price: json['price'] ?? "",
      beds: json['beds'] ?? "",
      area: json['area'] ?? "",
      lng: json['lng'] ?? "",
      lat: json['lat'] ?? "",
      ownerId: json['owner_id'] ?? "",
      baths: json['baths'] ?? "",
      isFeatured: json['is_featured'] ?? "",
      address: json['address'] ?? "",
      city: json['city_name'] ?? "",
      cityAr: json['ar_city_name'] ?? "",
      published: json['published'] ?? "",
      code: json['code'] ?? "",
      archive: json['archived'] ?? "",
      assignTo: json['assigned_to'] ?? "",
      video: json['video'] ?? "",
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
      detail: json['details'] ?? "",
      viewCount: json['view_count'] ?? "",
      refNo: json['ref_no'] ?? "",
      rentalPeriod: json['rental_period'] ?? "",
      youtubeLink: json['youtube_link'] ?? "",
      threesixtyLink: json['three_sixty_link'] ?? "",
      requestTranslation: json['request_translation'] ?? "",
      baseUrl: json['base_url'] ?? "",
      videoUrl: json['video_url'] ?? "",
      propertyTypeName: json['property_type_name'] ?? "",
      propertyTypeAr: json['ar_property_type_name'] ?? "",
      zoneId: json['zone_id'] ?? "",
      zoneLocationId: json['zone_location_id'] ?? "",
    );
  }
}

class ProductImages {
  var id;
  var imagePath;
  ProductImages({
    this.id,
    this.imagePath,
  });
  factory ProductImages.fromJson(Map<String, dynamic> json) {
    return ProductImages(
      id: json['id'] ?? 0,
      imagePath: json['path'] ?? "",
    );
  }
}

class Ameneties {
  var id, name, arName;
  Ameneties({this.id, this.name, this.arName});
  factory Ameneties.fromJson(Map<String, dynamic> json) {
    return Ameneties(
      id: json['id'] ?? 0,
      arName: json['ar_name'] ?? "",
      name: json['name'] ?? "",
    );
  }
}
