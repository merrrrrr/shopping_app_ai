class Address {
  final String recipientName;
  final String phoneNumber;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String postcode;

  Address({
    required this.recipientName,
    required this.phoneNumber,
    required this.addressLine1,
    this.addressLine2 = '',
    required this.city,
    required this.state,
    required this.postcode,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postcode': postcode,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      recipientName: map['recipientName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      addressLine1: map['addressLine1'] ?? '',
      addressLine2: map['addressLine2'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      postcode: map['postcode'] ?? ''
    );
  }

  String get fullAddress {
    return '$addressLine1${addressLine2.isNotEmpty ? ', $addressLine2' : ''}, $postcode $city, $state';
  }
}