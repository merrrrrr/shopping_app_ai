import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shopping_app_ai/providers/category_filter_notifier.dart';
import 'package:shopping_app_ai/providers/search_query_notifier.dart';
import 'package:shopping_app_ai/providers/selected_index_notifier.dart';
import 'package:shopping_app_ai/widgets/product_card.dart';
import '../models/product.dart'; // Import your product model
import '../data/products_data.dart'; // Import your dummy product data

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Banner images from assets/banners/
  final List<String> _promoBanners = [
    'assets/banners/10_off_banner_1.png',
    'assets/banners/free_shipping_banner_1.png',
    'assets/banners/new_arrival_banner_1.png',
  ];

  final List<String> _categories = [
    'assets/categories/charging_category.png',
    'assets/categories/audio_category.png',
    'assets/categories/car_accessories_category.png',
    'assets/categories/other_category.png',
  ];

  final List<String> _categoryLabels = [
    'Charging',
    'Audio',
    'Car Acc.',
    'Others',
  ];

  bool _isLoading = false;

  Future<void> _refreshContent() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 700)); // simulate fetch
    setState(() => _isLoading = false);
  }

  List<Product> _randomRecommendation() {
    final List<Product> base = products.toList();
        base.shuffle();
    return base;
  }

  @override
  Widget build(BuildContext context) {
    final recommended = _randomRecommendation();
  final colorScheme = Theme.of(context).colorScheme;
  final shadowColor = Theme.of(context).shadowColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor.withAlpha(30),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                ),
                onSubmitted: (value) {
                  setState(() {
                    selectedIndexNotifier.value = 1;
                    searchQueryNotifier.value = value;
                  });
                },
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshContent,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Welcome Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                color: colorScheme.primary,
                child: const Text(
                  "Welcome to ShopEasy!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              // Promotional Banners Carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CarouselSlider.builder(
                  itemCount: _promoBanners.length,
                  itemBuilder: (context, index, realIndex) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        _promoBanners[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    viewportFraction: 0.95,
                    aspectRatio: 16 / 9,
                    enlargeCenterPage: true,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Category navigation
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  height: 128,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_categoryLabels.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndexNotifier.value = 1;
                            if (index == 2) {
                              categoryFilterNotifier.value = 'Car Accessories';
                            } else {
                              categoryFilterNotifier.value = _categoryLabels[index];
                            }
                          });
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 84,
                              height: 84,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Image.asset(
                                  _categories[index],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _categoryLabels[index],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommended for You",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    if (_isLoading) ...[
                      SizedBox(
                        height: 240,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.65,
                              ),
                          itemCount: 4,
                          itemBuilder: (_, _) => Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ] else if (recommended.isEmpty) ...[
                      // empty state
                      SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 48,
                                color: colorScheme.secondary,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'No products found',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 8,
                                childAspectRatio: 0.65,
                              ),
                          itemCount: 12,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) =>
                              ProductCard(product: recommended[index]),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}