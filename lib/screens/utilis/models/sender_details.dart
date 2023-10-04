class SenderDetails {
  final String? name;
  final String? phoneNumber;

  SenderDetails({
    this.name,
    this.phoneNumber,
  });

  SenderDetails.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String?,
        phoneNumber = json['phone_number'] as String?;

  Map<String, dynamic> toJson() => {'name': name, 'phone_number': phoneNumber};
}
