import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserService {
	final _auth = FirebaseAuth.instance;
	final _firestore = FirebaseFirestore.instance;

	String get currentUserId {
		final user = _auth.currentUser;
		if (user == null) {
			throw Exception('No authenticated user found.');
		}
		return user.uid;
	}

	CollectionReference get _usersCollection {
		return _firestore.collection('users');
	}

	Future<void> createUser(String name, String email, String phoneNumber, String password) async {
		try {
			await _auth.createUserWithEmailAndPassword(email: email, password: password);
			await _usersCollection.add({
				'name': name,
				'email': email,
				'phoneNumber': phoneNumber,
				'photoUrl': '',
				'address': '',
				'createdAt': FieldValue.serverTimestamp(),
			});
		} catch(e) {
			debugPrint('Error creating new user: $e');
			throw Exception('Failed to create new user.');
		}
	}

	Future<Map<String, dynamic>?> getUserData() async {
		try {
			DocumentSnapshot doc = await _usersCollection.doc(currentUserId).get();
			if (!doc.exists) {
				throw Exception('User data not found.');
			}
			return doc.data() as Map<String, dynamic>?;
		} catch(e) {
			debugPrint('Error fetching user data: $e');
			throw Exception('Failed to fetch user data.');
		}
	}

	Future<void> updateUserData(String? name, String? phoneNumber, String photoUrl, String? address) async {
		try {
			DocumentSnapshot snapshot = await _usersCollection.doc(currentUserId).get();
			final data = snapshot.data() as Map<String, dynamic>?;
			final createdAt = data?['createdAt'] ?? FieldValue.serverTimestamp();
			await _usersCollection.doc(currentUserId).set({
				'email': _auth.currentUser?.email,
				'createdAt': createdAt,
				'name': name,
				'phoneNumber': phoneNumber,
				'photoUrl': photoUrl,
				'address': address,
			});
		} catch(e) {
			debugPrint('Error updating update user information: $e');
			throw Exception('Failed to update user information.');
		}
	}

	Future<void> deleteUser() async {
		try {
			await _usersCollection.doc(currentUserId).delete();
			await _auth.currentUser?.delete();
		} catch(e) {
			debugPrint('Error deleting user: $e');
			throw Exception('Failed to delete user.');
		}
	}

	Future<void> changePassword(String currentPassword, String newPassword) async {
		try {
			final user = _auth.currentUser;
			if (user == null || user.email == null) {
				throw Exception('No authenticated user found.');
			}

			// Re-authenticate user with current password
			final credential = EmailAuthProvider.credential(
				email: user.email!,
				password: currentPassword,
			);

			await user.reauthenticateWithCredential(credential);

			// Update to new password
			await user.updatePassword(newPassword);

			debugPrint('Password changed successfully');
		} on FirebaseAuthException catch (e) {
			debugPrint('Error changing password: ${e.code}');
			
			if (e.code == 'wrong-password') {
				throw Exception('Current password is incorrect.');
			} else if (e.code == 'weak-password') {
				throw Exception('New password is too weak.');
			} else {
				throw Exception('Failed to change password: ${e.message}');
			}
		} catch (e) {
			debugPrint('Error changing password: $e');
			throw Exception('Failed to change password.');
		}
	}

	Future<void> resetPassword(String email) async {
		try {
			await _auth.sendPasswordResetEmail(email: email);
		} catch(e) {
			throw Exception('Failed to reset password.');
		}
	}
}