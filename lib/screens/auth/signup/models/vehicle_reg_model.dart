class VehicleReg {
  String? accountUUID;
  String? color;
  String? model;
  String? operation;
  bool? owner;
  String? plateNumber;
  bool? primaryVehicle;
  String? vin;
  String? year;

  VehicleReg(
      {this.accountUUID,
        this.color,
        this.model,
        this.operation,
        this.owner,
        this.plateNumber,
        this.primaryVehicle,
        this.vin,
        this.year});

  VehicleReg.fromJson(Map<String, dynamic> json) {
    accountUUID = json['accountUUID'];
    color = json['color'];
    model = json['model'];
    operation = json['operation'];
    owner = json['owner'];
    plateNumber = json['plateNumber'];
    primaryVehicle = json['primaryVehicle'];
    vin = json['vin'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountUUID'] = accountUUID;
    data['color'] = color;
    data['model'] = model;
    data['operation'] = operation;
    data['owner'] = owner;
    data['plateNumber'] = plateNumber;
    data['primaryVehicle'] = primaryVehicle;
    data['vin'] = vin;
    data['year'] = year;
    return data;
  }
}
