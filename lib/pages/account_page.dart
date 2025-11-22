import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app/pages/favourites_page.dart';
import 'package:shopping_app/pages/order_history_page.dart';
import 'package:shopping_app/pages/profile_information_page.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
          .collection("users")
          .doc(user?.uid)
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("User data not found"));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final userName = userData['name'] ?? 'User';
          final userEmail = userData['email'] ?? user?.email ?? '';
          final photoUrl = 'assets/default_avatar.png';

          return ListView(
            children: <Widget>[
              _buildProfileHeader(context, userName, userEmail, photoUrl),
          
              const SizedBox(height: 10),
          
              _buildMenuList(context),
          
              const SizedBox(height: 20),
          
              _buildLogoutButton(context),
            ],
          );
        }
      ),
    );
  }

  // WIDGET: Profile Header
	Widget _buildProfileHeader(BuildContext context, String userName, String userEmail, String photoUrl) {		
		return Container(
			padding: const EdgeInsets.all(20.0),
			child: Row(
				children: [
					CircleAvatar(
						radius: 40,
						backgroundImage: AssetImage(photoUrl),
						backgroundColor: Theme.of(context).colorScheme.surface,
					),
					const SizedBox(width: 20),
					Expanded(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text(
									userName,
									style: TextStyle(
										fontSize: 20,
										fontWeight: FontWeight.bold,
										color: Theme.of(context).colorScheme.onSurface,
									),
									overflow: TextOverflow.ellipsis,
								),
								const SizedBox(height: 4),
								Text(
									FirebaseAuth.instance.currentUser?.email ?? "",
									style: TextStyle(
										fontSize: 14,
										color: Theme.of(context).colorScheme.onSurface.withAlpha(153),
									),
									overflow: TextOverflow.ellipsis,
								),
							],
						),
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
					icon: Icons.person_outline,
					title: 'Profile Information',
					onTap: () => Navigator.push(context, MaterialPageRoute(
						builder: (context) => ProfileInformationPage()
					)),
				),
        _buildMenuListItem(
          context,
          icon: Icons.history,
          title: 'Order History',
          onTap: () => Navigator.push(context, MaterialPageRoute(
						builder: (context) => OrderHistoryPage()
					)),
        ),
        _buildMenuListItem(
          context,
          icon: Icons.payment,
          title: 'Payment Methods',
          onTap: () {},
        ),
        _buildMenuListItem(
          context,
          icon: Icons.favorite_border,
          title: 'Favourites',
          onTap: () => Navigator.push(context, MaterialPageRoute(
						builder: (context) => FavouritesPage()
					)),
        ),
        const Divider(),
        _buildMenuListItem(
          context,
          icon: Icons.settings_outlined,
          title: 'Settings',
          onTap: () {},
        ),
      ],
    );
  }

  // WIDGET: Individual Menu Item
  Widget _buildMenuListItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface.withAlpha(153)),
      onTap: onTap,
    );
  }

  // WIDGET: Logout Button
  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: OutlinedButton.icon(
        icon: Icon(Icons.logout, color: Colors.red),
        label: Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.red),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          FirebaseAuth.instance.signOut();
        },
      ),
    );
  }

}