import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_ai/models/address.dart';
import 'package:shopping_app_ai/services/address_service.dart';

class AddressFormPage extends StatefulWidget {
  final Address? address;

  const AddressFormPage({super.key, this.address});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
	AddressService addressService = AddressService();
	DocumentReference docRef = FirebaseFirestore.instance.collection('addresses').doc();

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _recipientNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _postcodeController;

  String _selectedState = 'Selangor';
  bool _isDefault = false;

  final List<String> _malaysianStates = [
    'Johor',
    'Kedah',
    'Kelantan',
    'Melaka',
    'Negeri Sembilan',
    'Pahang',
    'Penang',
    'Perak',
    'Perlis',
    'Sabah',
    'Sarawak',
    'Selangor',
    'Terengganu',
    'Kuala Lumpur',
    'Labuan',
    'Putrajaya',
  ];

  @override
  void initState() {
    super.initState();
    _recipientNameController = TextEditingController(text: widget.address?.recipientName ?? '');
    _phoneNumberController = TextEditingController(text: widget.address?.phoneNumber ?? '');
    _addressLine1Controller = TextEditingController(text: widget.address?.addressLine1 ?? '');
    _addressLine2Controller = TextEditingController(text: widget.address?.addressLine2 ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _postcodeController = TextEditingController(text: widget.address?.postcode ?? '');
    _selectedState = widget.address?.state ?? 'Selangor';
    _isDefault = widget.address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _phoneNumberController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address == null ? "Add Address" : "Edit Address"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _recipientNameController,
              decoration: InputDecoration(
                labelText: "Recipient Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter recipient name";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter phone number";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressLine1Controller,
              decoration: InputDecoration(
                labelText: "Address Line 1",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter address";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressLine2Controller,
              decoration: InputDecoration(
                labelText: "Address Line 2 (Optional)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "City",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter city";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedState,
              decoration: InputDecoration(
                labelText: "State",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: _malaysianStates.map((state) {
                return DropdownMenuItem(
                  value: state,
                  child: Text(
										state,
										style: const TextStyle(
											fontWeight: FontWeight.w500
										)
									),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _postcodeController,
              decoration: InputDecoration(
                labelText: "Postcode",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter postcode";
                }
                if (value.length != 5) {
                  return "Postcode must be 5 digits";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text("Set as default address"),
              value: _isDefault,
              onChanged: (value) {
                setState(() {
                  _isDefault = value ?? false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                addressService.addAddress(
                  Address(
										id: docRef.id,
                    recipientName: _recipientNameController.text,
                    phoneNumber: _phoneNumberController.text,
                    addressLine1: _addressLine1Controller.text,
                    addressLine2: _addressLine2Controller.text,
                    city: _cityController.text,
                    state: _selectedState,
                    postcode: _postcodeController.text,
                    isDefault: _isDefault,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(widget.address == null ? "Add Address" : "Update Address"),
            ),
          ],
        ),
      ),
    );
  }

}