import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_ai/models/address.dart';
import 'package:shopping_app_ai/pages/address_form_page.dart';

class AddressManagementPage extends StatelessWidget {
  const AddressManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Address Management"),
      ),
      body: SafeArea(
				child: StreamBuilder<QuerySnapshot>(
					stream: FirebaseFirestore.instance
							.collection('users')
							.doc(user?.uid)
							.collection('addresses')
							.orderBy('isDefault', descending: true)
							.snapshots(),
					builder: (context, snapshot) {
						if (snapshot.connectionState == ConnectionState.waiting) {
							return const Center(child: CircularProgressIndicator());
						}
				
						if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
							return Center(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Icon(
											Icons.location_off,
											size: 64,
											color: Colors.grey,
										),
										const SizedBox(height: 16),
										Text(
											"No addresses found",
											style: TextStyle(
												fontSize: 18,
												color: Colors.grey,
											),
										),
										const SizedBox(height: 24),
										ElevatedButton.icon(
											onPressed: () {
												Navigator.push(
													context,
													MaterialPageRoute(
														builder: (context) => const AddressFormPage(),
													),
												);
											},
											icon: const Icon(Icons.add),
											label: const Text("Add Address"),
										),
									],
								),
							);
						}
				
						final addresses = snapshot.data!.docs
								.map((doc) => Address.fromMap(doc.data() as Map<String, dynamic>))
								.toList();
				
						return Column(
							children: [
								Expanded(
									child: ListView.builder(
										padding: const EdgeInsets.all(8),
										itemCount: addresses.length,
										itemBuilder: (context, index) {
											final address = addresses[index];
											return _buildAddressCard(context, address);
										},
									),
								),
								Padding(
									padding: const EdgeInsets.all(16),
									child: ElevatedButton.icon(
										onPressed: () {
											Navigator.push(
												context,
												MaterialPageRoute(
													builder: (context) => const AddressFormPage(),
												),
											);
										},
										icon: const Icon(Icons.add),
										label: const Text("Add New Address"),
										style: ElevatedButton.styleFrom(
											minimumSize: const Size(double.infinity, 48),
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12),
											),
										),
									),
								),
							],
						);
					},
				),
			),
    );
  }

  Widget _buildAddressCard(BuildContext context, Address address) {
    final user = FirebaseAuth.instance.currentUser;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    address.recipientName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Default",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address.phoneNumber,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              address.fullAddress,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!address.isDefault)
                  TextButton.icon(
                    onPressed: () => _setDefaultAddress(context, address, user!.uid),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text("Set as Default"),
                  ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddressFormPage(address: address),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text("Edit"),
                ),
                TextButton.icon(
                  onPressed: () => _deleteAddress(context, address, user!.uid),
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  label: const Text("Delete", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _setDefaultAddress(BuildContext context, Address address, String userId) async {
    try {
      final addressesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('addresses');

      // Remove default from all addresses
      final allAddresses = await addressesRef.get();
      for (var doc in allAddresses.docs) {
        await doc.reference.update({'isDefault': false});
      }

      // Set this address as default
      await addressesRef.doc(address.id).update({'isDefault': true});

      // Update user's defaultAddressID
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'defaultAddressID': address.id});

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Default address updated")),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> _deleteAddress(BuildContext context, Address address, String userId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Address"),
        content: const Text("Are you sure you want to delete this address?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('addresses')
          .doc(address.id)
          .delete();

      // If deleted address was default, clear defaultAddressID
      if (address.isDefault) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({'defaultAddressID': ''});
      }

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Address deleted")),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}