class AddressModel {
  final String fullName;
  final String phone;
  final String addressLine;
  final String city;

  const AddressModel({
    required this.fullName,
    required this.phone,
    required this.addressLine,
    required this.city,
  });

  Map<String, dynamic> toMap() => {
        'fullName': fullName,
        'phone': phone,
        'addressLine': addressLine,
        'city': city,
      };

  factory AddressModel.fromMap(Map<dynamic, dynamic> map) => AddressModel(
        fullName: map['fullName'] as String,
        phone: map['phone'] as String,
        addressLine: map['addressLine'] as String,
        city: map['city'] as String,
      );
}
