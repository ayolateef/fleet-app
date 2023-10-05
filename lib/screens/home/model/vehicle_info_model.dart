class AddVehicleInfo {
  String? color;
  String? model;
  String? operation;
  bool? owner;
  String? plateNumber;
  bool? primaryVehicle;
  String? vehicleType;
  String? vin;
  String? year;
  String? manufacturer;

  AddVehicleInfo(
      {
        //this.accountUUID,
      this.color,
      this.model,
      this.operation,
      this.owner,
      this.plateNumber,
      this.primaryVehicle,
      this.vehicleType,
      this.vin,
      this.manufacturer,
      this.year});

  AddVehicleInfo.fromJson(Map<String, dynamic> json) {
   // accountUUID = json['accountUUID'];
    color = json['color'];
    model = json['model'];
    operation = json['operation'];
    owner = json['owner'];
    plateNumber = json['plateNumber'];
    primaryVehicle = json['primaryVehicle'];
    vehicleType = json['vehicleType'];
    vin = json['vin'];
    year = json['year'];
    manufacturer = json['manufacturer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
   // data['accountUUID'] = accountUUID;
    data['color'] = color;
    data['model'] = model;
    data['operation'] = operation;
    data['owner'] = owner;
    data['plateNumber'] = plateNumber;
    data['primaryVehicle'] = primaryVehicle;
    data['vehicleType'] = vehicleType;
    data['vin'] = vin;
    data['year'] = year;
    if(manufacturer!= null) data['manufacturer'] = manufacturer;
    return data;
  }
}
