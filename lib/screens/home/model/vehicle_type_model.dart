class VehicleTypeModel extends DropdownBaseModel{
  String? name;
  String? modelNumber;

  VehicleTypeModel({this.name, this.modelNumber});

  VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    modelNumber = json['modelNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['modelNumber'] = modelNumber;
    return data;
  }

  @override
  // TODO: implement displayName
  String get displayName => name!;
}
abstract class DropdownBaseModel {
  String get displayName;
}