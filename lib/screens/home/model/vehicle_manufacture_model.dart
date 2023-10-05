class VehicleManufacture {
  List<Models>? models;
  String? name;

  VehicleManufacture({this.models, this.name});

  VehicleManufacture.fromJson(Map<String, dynamic> json) {
    if (json['models'] != null) {
      models = <Models>[];
      json['models'].forEach((v) {
        models!.add(Models.fromJson(v));
      });
    }
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (models != null) {
      data['models'] = models!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    return data;
  }
}

class Models {
  String? modelNumber;
  String? name;

  Models({this.modelNumber, this.name});

  Models.fromJson(Map<String, dynamic> json) {
    modelNumber = json['modelNumber'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['modelNumber'] = modelNumber;
    data['name'] = name;
    return data;
  }
}
