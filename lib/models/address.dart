class Address {
  final String id;
  final String recipientName;
  final String phoneNumber;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postcode;
  final bool isDefault;

  Address({
    required this.id,
    required this.recipientName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.postcode,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postcode': postcode,
      'isDefault': isDefault,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] ?? '',
      recipientName: map['recipientName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postcode: map['postcode'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }

  String get fullAddress {
    return '$addressLine1${addressLine2.isNotEmpty ? ', $addressLine2' : ''}, $postcode $city, $state';
  }
}