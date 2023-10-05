class VehicleModel {
  VehicleModel({
    required this.plateNumber,
    required this.color,
    required this.model,
    required this.vin,
    required this.year,
    required this.owner,
    required this.approved,
    required this.primaryVehicle,
    required this.accountUUID,
    required this.createdAt,
    required this.lastUpdated,
    required this.registrationDate,
    required this.documents,
    required this.id,
    required this.hasAirCondition,
    required this.suv,
  });
  late final String plateNumber;
  late final String color;
  late final String model;
  late final String vin;
  late final String year;
  late final bool owner;
  late final bool approved;
  late final bool primaryVehicle;
  late final String accountUUID;
  late final String createdAt;
  late final String lastUpdated;
  late final String registrationDate;
  late final List<Documents> documents;
  late final String id;
  late final bool hasAirCondition;
  late final bool suv;

  VehicleModel.fromJson(Map<String, dynamic> json){
    plateNumber = json['plateNumber'];
    color = json['color'];
    model = json['model'];
    vin = json['vin'];
    year = json['year'];
    owner = json['owner'];
    approved = json['approved'];
    primaryVehicle = json['primaryVehicle'];
    accountUUID = json['accountUUID'];
    createdAt = json['createdAt'];
    lastUpdated = json['lastUpdated'];
    registrationDate = json['registrationDate'];
    documents = List.from(json['documents']).map((e)=>Documents.fromJson(e)).toList();
    id = json['id'];
    hasAirCondition = json['hasAirCondition'];
    suv = json['suv'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['plateNumber'] = plateNumber;
    _data['color'] = color;
    _data['model'] = model;
    _data['vin'] = vin;
    _data['year'] = year;
    _data['owner'] = owner;
    _data['approved'] = approved;
    _data['primaryVehicle'] = primaryVehicle;
    _data['accountUUID'] = accountUUID;
    _data['createdAt'] = createdAt;
    _data['lastUpdated'] = lastUpdated;
    _data['registrationDate'] = registrationDate;
    _data['documents'] = documents.map((e)=>e.toJson()).toList();
    _data['id'] = id;
    _data['hasAirCondition'] = hasAirCondition;
    _data['suv'] = suv;
    return _data;
  }
}

class Documents {
  Documents({
    required this.id,
    required this.ownerId,
    required this.documentType,
    required this.documentOwnerType,
    required this.document,
    required this.documentNumber,
    this.expiryDate,
    required this.dateCreated,
  });
  late final String? id;
  late final String? ownerId;
  late final String? documentType;
  late final String? documentOwnerType;
  late final String? document;
  late final String? documentNumber;
  late final String? expiryDate;
  late final String? dateCreated;

  Documents.fromJson(Map<String, dynamic> json){
    id = json['id'];
    ownerId = json['ownerId'];
    documentType = json['documentType'];
    documentOwnerType = json['documentOwnerType'];
    document = json['document'];
    documentNumber = json['documentNumber'];
    expiryDate = null;
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['ownerId'] = ownerId;
    _data['documentType'] = documentType;
    _data['documentOwnerType'] = documentOwnerType;
    _data['document'] = document;
    _data['documentNumber'] = documentNumber;
    _data['expiryDate'] = expiryDate;
    _data['dateCreated'] = dateCreated;
    return _data;
  }
}