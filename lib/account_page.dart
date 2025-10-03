import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy user data
    const String userName = "Taylor Swift";
    const String userEmail = "taylor.swift@example.com";
    const String avatarUrl = "https://i.pravatar.cc/150?u=taylorswift";

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          // SECTION: Sliver App Bar with Profile Header
          SliverAppBar(
            expandedHeight: 220.0,
            pinned: true,
            backgroundColor: theme.primaryColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                userName,
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              titlePadding: const EdgeInsets.only(bottom: 16.0),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.primaryColor.withOpacity(0.8), theme.primaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 45,
                      backgroundImage: NetworkImage(avatarUrl),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      userEmail,
                      style: textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    ),
                    const SizedBox(height: 40), // Space for the title to settle
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => _showSnackBar(context, 'Edit Profile Tapped'),
                icon: const Icon(Icons.edit_outlined),
              ),
            ],
          ),

          // SECTION: Account Menu
          _buildSectionHeader("Account"),
          SliverToBoxAdapter(
            child: _buildMenuCard([
              _buildModernMenuListItem(
                context: context,
                icon: Icons.history_edu_rounded,
                title: 'Order History',
                onTap: () => _showSnackBar(context, 'Navigate to Order History'),
              ),
              _buildModernMenuListItem(
                context: context,
                icon: Icons.location_on_outlined,
                title: 'Address Management',
                onTap: () => _showSnackBar(context, 'Navigate to Address Management'),
              ),
              _buildModernMenuListItem(
                context: context,
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                onTap: () => _showSnackBar(context, 'Navigate to Payment Methods'),
              ),
              _buildModernMenuListItem(
                context: context,
                icon: Icons.favorite_border_rounded,
                title: 'Wishlist',
                onTap: () => _showSnackBar(context, 'Navigate to Wishlist'),
                showDivider: false,
              ),
            ]),
          ),

          // SECTION: Settings Menu
          _buildSectionHeader("Settings"),
          SliverToBoxAdapter(
            child: _buildMenuCard([
              _buildModernMenuListItem(
                context: context,
                icon: Icons.palette_outlined,
                title: 'Theme',
                onTap: () => _showSnackBar(context, 'Navigate to Theme Settings'),
              ),
              _buildModernMenuListItem(
                context: context,
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                onTap: () => _showSnackBar(context, 'Navigate to Notification Settings'),
              ),
              _buildModernMenuListItem(
                context: context,
                icon: Icons.privacy_tip_outlined,
                title: 'Privacy',
                onTap: () => _showSnackBar(context, 'Navigate to Privacy Settings'),
                showDivider: false,
              ),
            ]),
          ),
          
          // SECTION: Logout Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
                onPressed: () {
                  _showSnackBar(context, 'Logout Tapped');
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  )
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET: Section Header
  SliverToBoxAdapter _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }

  // WIDGET: Wrapper Card for Menu Items
  Widget _buildMenuCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: children,
          ),
        ),
      ),
    );
  }

  // WIDGET: Modern Menu List Item
  Widget _buildModernMenuListItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(icon, color: theme.primaryColor, size: 24),
                  const SizedBox(width: 16),
                  Text(title, style: const TextStyle(fontSize: 16)),
                  const Spacer(),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
                ],
              ),
            ),
            if (showDivider)
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[100],
                indent: 16,
                endIndent: 16,
              ),
          ],
        ),
      ),
    );
  }

  // HELPER: Show a SnackBar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}