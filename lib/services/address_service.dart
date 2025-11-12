
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shopping_app_ai/models/address.dart';

class AddressService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get currentUserId {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('No authenticated user found.');
    }
    return user.uid;
  }

  CollectionReference get _addressesCollection {
    return _firestore.collection('users').doc(currentUserId).collection('addresses');
  }

  Future<void> addAddress(Address address) async {
    try {
      await _addressesCollection.add(address.toMap());
      debugPrint('Address added successfully.');
    } catch(e) {
      debugPrint('Error adding address: $e');
			throw Exception('Failed to add address');
    }
  }

  Future<List<Address>> getAllAddresses() async {
    try {
      QuerySnapshot snapshot = await _addressesCollection.get();
      List<Address> addresses = snapshot.docs.map((doc) {
        return Address.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      debugPrint('Retrieved ${addresses.length} addresses.');
      return addresses;
    } catch(e) {
      debugPrint('Error getting address: $e');
			throw Exception('Failed to get addresses');
    }
  }

  Future<Address?> getAddressById(String addressId) async {
		try {
			DocumentSnapshot doc = await _addressesCollection.doc(addressId).get();
			debugPrint('Retrieved address: ${doc.data()}');		
			return Address.fromMap(doc.data() as Map<String, dynamic>);
		} catch(e) {
			debugPrint('Error getting address: $e');
			throw Exception('Failed to get address');
		}
  }

  Future<void> updateAddress() async {
		
  } 

  Future<void> deleteAddress(String addressId) async {
    try {
      await _addressesCollection.doc(addressId).delete();
      debugPrint('Address deleted successfully.');
    } catch(e) {
      debugPrint('Error deleting address: $e');
			throw Exception('Failed to delete address');
    }
  }


}