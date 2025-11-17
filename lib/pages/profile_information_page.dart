import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app_ai/services/user_service.dart';

class ProfileInformationPage extends StatefulWidget {
  const ProfileInformationPage({super.key});

  @override
  State<ProfileInformationPage> createState() => _ProfileInformationPageState();
}

class _ProfileInformationPageState extends State<ProfileInformationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
	final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
	final _defaultAvatar = 'assets/default_avatar.png';
  
  bool _isLoading = false;
  bool _isSaving = false;
	String _avatarUrl = '';

	Future<void> _loadUserData() async {
		setState(() {
			_isLoading = true;
		});
		try {
			final userData = await UserService().getUserData();
			if (userData != null) {
				_nameController.text = userData['name'] ?? '';
				_phoneController.text = userData['phoneNumber'] ?? '';
				_addressController.text = userData['address'] ?? '';
				_avatarUrl = userData['photoUrl'] == "" ? _defaultAvatar : userData['photoUrl'];
			}
		} catch (e) {
			debugPrint('Error loading user data: $e');
		} finally {
			setState(() {
				_isLoading = false;
			});
		}
	}

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
		_phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Information'),
        actions: [
          if (!_isLoading)
          TextButton(
            onPressed: _isSaving ? null : () async {
							_isSaving = true;
							UserService().updateUserData(
								_nameController.text.trim(),
								_phoneController.text.trim(),
								_avatarUrl,
								_addressController.text.trim(),
							);
							_isSaving = false;
							showDialog(
								context: context,
								builder: (context) => AlertDialog(
									title: const Text('Success'),
									content: const Text('Profile updated successfully.'),
									actions: [
										TextButton(
											onPressed: () {
												Navigator.of(context).pop();
												Navigator.of(context).pop();
											},
											child: const Text('OK'),
										),
									],
								)
							);
						},
            child: const Text('Save'),
          ),
        ],
      ),

      body: _isLoading || _isSaving
			? const Center(child: CircularProgressIndicator())
			: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(context),

              const SizedBox(height: 30),

              // Email (Read-only)
              _buildReadOnlyField(
                label: 'Email',
                value: user?.email ?? 'No email',
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 16),

              // Name Field
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

										
              const SizedBox(height: 16),

              // Phone Field
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value.trim())) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),
										
              // Address Field
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on_outlined,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

							OutlinedButton(
								onPressed: () {
								},
								style: OutlinedButton.styleFrom(
									side: BorderSide(color: colorScheme.primary),
									shape: RoundedRectangleBorder(
										borderRadius: BorderRadius.circular(12),
									),
									minimumSize: const Size(double.infinity, 48),
								),
								child: const Text('Reset Password')
							),

							const SizedBox(height: 20),

              // Delete Account Button
              OutlinedButton.icon(
                onPressed: () {
									showDialog(
										context: context,
										builder:(context) {
										  return AlertDialog(
												title: const Text('Confirm Account Deletion'),
												content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
												actions: [
													TextButton(
														onPressed: () {
															Navigator.of(context).pop();
														},
														child: const Text('Cancel'),
													),
													TextButton(
														onPressed: () {
															UserService().deleteUser();
															Navigator.of(context).pop();
														},
														child: const Text('Delete', style: TextStyle(color: Colors.red)),
													),
												],
											);
										},
									);
												
								},
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                label: const Text(
                  'Delete Account',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
		final isAssetImage = _avatarUrl.startsWith('assets/');
		
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: isAssetImage 
						? AssetImage(_avatarUrl) as ImageProvider
						: (_avatarUrl.isEmpty 
							? const AssetImage('assets/default_avatar.png')
							: FileImage(File(_avatarUrl))),
          backgroundColor: colorScheme.surface,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              onPressed: () {
              },
            ),
          ),
        ),
      ],
    );
	}

  // Read-only field widget
  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return TextFormField(
      initialValue: value,
      enabled: false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Editable text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}