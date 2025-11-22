import 'package:flutter/material.dart';
import 'package:shopping_app/pages/account_page.dart';
import 'package:shopping_app/pages/home_page.dart';
import 'package:shopping_app/providers/category_filter_notifier.dart';
import 'package:shopping_app/providers/search_query_notifier.dart';
import 'package:shopping_app/providers/selected_index_notifier.dart';
import '../pages/products_page.dart';
import '../pages/cart_page.dart';

// Pages for bottom navigation
final List<Widget> _pages = [
  HomePage(),
  ProductsPage(),
  CartPage(),
  AccountPage(),
];

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndexNotifier,
      builder: (context, selectedIndex, child) {
        return Scaffold(
          body: _pages[selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: selectedIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Theme.of(context).colorScheme.onSurface.withAlpha(153), // 0.6 * 255
            backgroundColor: Theme.of(context).colorScheme.surface,
            onTap: (index) {
              if (selectedIndexNotifier.value == 1 && index != 1) {
                searchQueryNotifier.value = "";
                categoryFilterNotifier.value = 'All';
              }
              selectedIndexNotifier.value = index;
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.shop), label: "Products"),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
            ],
          ),
        );
      },
    );
  }
}
