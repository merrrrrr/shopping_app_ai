class User {
	final String id;
	final String name;
	final String email;
	final String phoneNumber;
	final String photoUrl;
	final String defaultAddressID;
	final DateTime createdAt;

	User({
		required this.id,
		required this.name,
		required this.email,
		required this.phoneNumber,
		this.photoUrl = '',
		this.defaultAddressID = '',
		required this.createdAt,
	});
}