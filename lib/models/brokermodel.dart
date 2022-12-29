class BrokerModel {
  final List<BrokerResult> result;

  BrokerModel({
    this.result,
  });

  factory BrokerModel.fromJson(Map<String, dynamic> json) {
    return BrokerModel(
      result: (json['brokers'] as List)
          .map((e) => BrokerResult.fromJson(e))
          .toList(),
    );
  }
}

class BrokerResult {
  int id;

  var name, company, address, email, phone;
  BrokerResult(
      {this.address, this.company, this.email, this.id, this.name, this.phone});

  factory BrokerResult.fromJson(Map<String, dynamic> json) {
    return BrokerResult(
      id: json['id'] ?? "",
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
      email: json['email'] ?? "",
    );
  }
}
