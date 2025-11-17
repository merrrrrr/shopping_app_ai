class User {
	final String id;
	final String name;
	final String email;
	final String phoneNumber;
	final String photoUrl;
	final String address;
	final DateTime createdAt;

	User({
		required this.id,
		required this.name,
		required this.email,
		required this.phoneNumber,
		this.photoUrl = '',
		this.address = '',
		required this.createdAt,
	});

	Map<String, dynamic> toMap() {
		return {
			'id': id,
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
			id: map['id'],
			name: map['name'],
			email: map['email'],
			phoneNumber: map['phoneNumber'],
			photoUrl: map['photoUrl'] ?? '',
			address: map['address'] ?? '',
			createdAt: DateTime.parse(map['createdAt']),
		);
	}
}