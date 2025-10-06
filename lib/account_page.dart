import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data
    const String userName = "Taylor Swift";
    const String userEmail = "taylor.swift@example.com";
    const String avatarUrl = "https://i.pravatar.cc/150?u=taylorswift"; // Placeholder avatar

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: ListView(
        children: <Widget>[
          // SECTION: USER PROFILE INFO
          _buildProfileHeader(context, userName, userEmail, avatarUrl),

          const SizedBox(height: 10),

          // SECTION: MAIN MENU
          _buildMenuList(context),

          const SizedBox(height: 20),

          // SECTION: LOGOUT BUTTON
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  // WIDGET: Profile Header
  Widget _buildProfileHeader(BuildContext context, String name, String email, String avatarUrl) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(avatarUrl),
            backgroundColor: Colors.grey,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.grey),
            onPressed: () {
              _showSnackBar(context, 'Edit Profile Tapped');
            },
          ),
        ],
      ),
    );
  }

  // WIDGET: Menu List
  Widget _buildMenuList(BuildContext context) {
    return Column(
      children: [
        _buildMenuListItem(
          context,
          icon: Icons.history,
          title: 'Order History',
          onTap: () => _showSnackBar(context, 'Navigate to Order History'),
        ),
        _buildMenuListItem(
          context,
          icon: Icons.location_on_outlined,
          title: 'Address Management',
          onTap: () => _showSnackBar(context, 'Navigate to Address Management'),
        ),
        _buildMenuListItem(
          context,
          icon: Icons.payment,
          title: 'Payment Methods',
          onTap: () => _showSnackBar(context, 'Navigate to Payment Methods'),
        ),
        _buildMenuListItem(
          context,
          icon: Icons.favorite_border,
          title: 'Wishlist',
          onTap: () => _showSnackBar(context, 'Navigate to Wishlist'),
        ),
        const Divider(),
        _buildMenuListItem(
          context,
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () => _showSnackBar(context, 'Navigate to Settings'),
        ),
      ],
    );
  }

  // WIDGET: Individual Menu Item
  Widget _buildMenuListItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  // WIDGET: Logout Button
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          // Add your logout logic here
          _showSnackBar(context, 'Logout Tapped');
        },
      ),
    );
  }

  // HELPER: Show a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}