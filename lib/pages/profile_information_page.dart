import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopping_app_ai/services/user_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

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

Future<void> _updateAvatar() async {
  final ImagePicker picker = ImagePicker();
  
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Change Profile Picture',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    maxWidth: 512,
                    maxHeight: 512,
                    imageQuality: 85,
                  );
                  if (image != null && mounted) {
                    final String? savedPath = await _saveImageLocally(image);
                    if (savedPath != null) {
                      setState(() {
                        _avatarUrl = savedPath;
                      });
                    }
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    maxWidth: 512,
                    maxHeight: 512,
                    imageQuality: 85,
                  );
                  if (image != null && mounted) {
                    // Save to local storage
                    final String? savedPath = await _saveImageLocally(image);
                    if (savedPath != null) {
                      setState(() {
                        _avatarUrl = savedPath;
                      });
                    }
                  }
                },
              ),
              if (_avatarUrl != _defaultAvatar)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _deleteLocalImage(_avatarUrl);
                    setState(() {
                      _avatarUrl = _defaultAvatar;
                    });
                  },
                ),
            ],
          ),
        ),
      );
    },
  );
}

Future<String?> _saveImageLocally(XFile image) async {
  try {
    // Get the app's document directory
    final Directory appDir = await getApplicationDocumentsDirectory();
    
    // Create a subfolder for profile images
    final Directory profileDir = Directory('${appDir.path}/profile_images');
    if (!await profileDir.exists()) {
      await profileDir.create(recursive: true);
    }

    // Delete old image if it exists and is not the default
    if (_avatarUrl != _defaultAvatar && _avatarUrl.isNotEmpty && !_avatarUrl.startsWith('assets/')) {
      await _deleteLocalImage(_avatarUrl);
    }
    
    // Generate a unique filename using timestamp and user ID
    final String fileName = 'profile_${FirebaseAuth.instance.currentUser?.uid}_${DateTime.now().millisecondsSinceEpoch}${path.extension(image.path)}';
    final String filePath = '${profileDir.path}/$fileName';
    
    // Copy the file to the new location
    final File sourceFile = File(image.path);
    await sourceFile.copy(filePath);
    
    debugPrint('Image saved locally: $filePath');
    
    // ← ADD: Save to Firestore immediately after saving locally
    await UserService().updateUserData(
      _nameController.text.trim(),
      _phoneController.text.trim(),
      filePath, // Save the local file path
      _addressController.text.trim(),
    );
    
    debugPrint('Image path saved to Firestore: $filePath');
    
    return filePath;
  } catch (e) {
    debugPrint('Error saving image locally: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save image')),
      );
    }
    return null;
  }
}

Future<void> _deleteLocalImage(String imagePath) async {
  try {
    if (imagePath.isEmpty || imagePath.startsWith('assets/')) {
      return; // Don't delete asset images
    }
    
    final File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      await imageFile.delete();
      debugPrint('Deleted local image: $imagePath');
      
      // ← ADD: Update Firestore to reset to default avatar
      await UserService().updateUserData(
        _nameController.text.trim(),
        _phoneController.text.trim(),
        _defaultAvatar,
        _addressController.text.trim(),
      );
    }
  } catch (e) {
    debugPrint('Error deleting local image: $e');
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
								_updateAvatar();
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