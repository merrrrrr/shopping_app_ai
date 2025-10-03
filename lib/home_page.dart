import 'package:flutter/material.dart';
import 'dart:async';
import '../models/product.dart'; // Make sure to import your Product model
import '../data/products_data.dart'; // Import the products data

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Dummy data for the UI
  final List<String> _promoBanners = [
    'https://via.placeholder.com/600x200?text=Promo+Banner+1',
    'https://via.placeholder.com/600x200?text=Promo+Banner+2',
    'https://via.placeholder.com/600x200?text=Promo+Banner+3',
  ];

  final List<Product> _featuredProducts = products.where((p) => p.sales > 500).take(4).toList();
  final List<Product> _newArrivals = products.reversed.take(3).toList();

  late final PageController _pageController;
  late final Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _promoBanners.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 10),
              _buildPromoCarousel(),
              _buildQuickAccessButtons(),
              _buildSectionHeader(context, "Featured Products"),
              _buildFeaturedProductsGrid(),
              _buildAppHighlightBanner(),
              _buildSectionHeader(context, "New Arrivals"),
              _buildNewArrivalsList(),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }

  // WIDGET: Sliver App Bar
  SliverAppBar _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      backgroundColor: Colors.white,
      elevation: 2,
      shadowColor: Colors.black12,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hello, Taylor!",
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const Text(
            "What are you looking for?",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined, color: Colors.grey[800]),
          onPressed: () { /* Navigate to Cart */ },
        ),
        IconButton(
          icon: Icon(Icons.person_outline, color: Colors.grey[800]),
          onPressed: () { /* Navigate to Account */ },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for products...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // WIDGET: Promotional Carousel
  Widget _buildPromoCarousel() {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        controller: _pageController,
        itemCount: _promoBanners.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                _promoBanners[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
          );
        },
      ),
    );
  }

  // WIDGET: Quick Access Buttons
  Widget _buildQuickAccessButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildQuickAccessChip("Shop Now", Icons.storefront, Colors.blue),
          _buildQuickAccessChip("Deals", Icons.local_offer, Colors.orange),
          _buildQuickAccessChip("New", Icons.new_releases, Colors.green),
        ],
      ),
    );
  }

  Widget _buildQuickAccessChip(String label, IconData icon, Color color) {
    return ActionChip(
      label: Text(label),
      avatar: Icon(icon, color: color, size: 20),
      onPressed: () {},
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  // WIDGET: Section Header
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            "See All",
            style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  // WIDGET: Featured Products Grid
  Widget _buildFeaturedProductsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _featuredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(_featuredProducts[index]);
      },
    );
  }

  // WIDGET: New Arrivals Horizontal List
  Widget _buildNewArrivalsList() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _newArrivals.length,
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: Padding(
              padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 8.0,
                  right: index == _newArrivals.length - 1 ? 16.0 : 8.0),
              child: _buildProductCard(_newArrivals[index]),
            ),
          );
        },
      ),
    );
  }

  // WIDGET: Reusable Product Card
  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                product.images.first,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "RM ${product.price.toStringAsFixed(2)}",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
  
  // WIDGET: App Highlight Banner
  Widget _buildAppHighlightBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.local_shipping_outlined, color: Colors.teal[800], size: 30),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Free Shipping!",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text("On all orders over RM 100"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}