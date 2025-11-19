import 'package:cloud_firestore/cloud_firestore.dart';

class User {
	final String name;
	final String email;
	final String phoneNumber;
	final String photoUrl;
	final String address;
	final DateTime createdAt;

	User({
		required this.name,
		required this.email,
		required this.phoneNumber,
		this.photoUrl = '',
		this.address = '',
		required this.createdAt,
	});

	Map<String, dynamic> toMap() {
		return {
			'name': name,
			'email': email,
			'phoneNumber': phoneNumber,
			'photoUrl': photoUrl,
			'address': address,
			'createdAt': createdAt.toIso8601String(),
		};
	}

	factory User.fromMap(Map<String, dynamic> map) {
		return User(
			name: map['name'],
			email: map['email'],
			phoneNumber: map['phoneNumber'],
			photoUrl: map['photoUrl'],
			address: map['address'],
			createdAt: (map['createdAt'] as Timestamp).toDate(),
		);
	}
}