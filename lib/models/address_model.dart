class AddressModel {
  final String street;
  final String city;
  final String phone;

  AddressModel({
    required this.street,
    required this.city,
    required this.phone,
});

  factory AddressModel.fromMap(Map<String, dynamic>map) {
    return AddressModel(
        street: map['street'] ?? '',
        city: map['city'] ?? '',
        phone: map['phone'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'street' : street,
      'city' : city,
      'phone' : phone,
    };
  }

  AddressModel copyWith({
    String? street,
    String? city,
    String? phone,
}) {
    return AddressModel(
      street: street ?? this.street,
        city: city ?? this.city,
        phone: phone ?? this.phone,
    );
  }

  bool get isComplete =>
      street.trim().isNotEmpty &&
  city.trim().isNotEmpty &&
  phone.trim().isNotEmpty;
}