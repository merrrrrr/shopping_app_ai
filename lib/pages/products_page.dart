import 'package:flutter/material.dart';
import 'package:shopping_app_ai/providers/category_filter_notifier.dart';
import 'package:shopping_app_ai/providers/search_query_notifier.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../models/product.dart';
import '../../data/products_data.dart';
import '../widgets/filter_button.dart';
import '../widgets/product_card.dart';
import '../widgets/sort_button.dart';

class ProductsPage extends StatefulWidget {
  final String? initialSearchQuery;

  const ProductsPage({super.key, this.initialSearchQuery});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String selectedCategory = categoryFilterNotifier.value;
  String selectedPriceRange = "All";
  String selectedBrand = "All";
  double selectedRating = 0;
  String selectedSort = "Default";

  final List<String> categories = [
    "All",
    "Car Accessories",
    "Audio",
    "Charging",
    "Others",
  ];

  final List<String> brands = [
    "All",
    "Baseus",
    "Oppo",
    "Redmi",
    "Samsung",
    "Xiaomi",
  ];

  final List<String> priceRanges = [
    "All",
    "Under RM50",
    "RM50-100",
    "RM100-RM200",
    "Over RM200",
  ];

  final List<String> ratings = ["Any", "1.0", "2.0", "3.0", "4.0", "5.0"];

  final List<String> sortOptions = [
    "Default",
    "Price: Low to High",
    "Price: High to Low",
    "Best Selling",
    "Rating: High to Low",
  ];

  bool _isLoading = false;

  Future<void> _refreshContent() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
    selectedCategory = "All";
		selectedPriceRange = "All";
		selectedBrand = "All";
		selectedRating = 0;
		selectedSort = "Default";
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Filter products by search, category, price, brand, and rating
    List<Product> filteredProducts = products.where((p) {
      bool matchesSearch = p.name.toLowerCase().contains(
        searchQueryNotifier.value.toLowerCase(),
      );

      bool matchesCategory = selectedCategory == "All" || p.category == selectedCategory;

      bool matchesPrice = selectedPriceRange == "All" ||
			(selectedPriceRange == "Under RM50" && p.price < 50) ||
			(selectedPriceRange == "RM50-100" && p.price >= 50 && p.price <= 100) ||
			(selectedPriceRange == "RM100-RM200" && p.price >= 100 && p.price <= 200) ||
			(selectedPriceRange == "Over RM200" && p.price > 200);

      bool matchesBrand = selectedBrand == "All" || p.brand == selectedBrand;

      bool matchesRating = selectedRating == 0 || (p.rating >= selectedRating);
      return matchesSearch && matchesCategory && matchesPrice && matchesBrand && matchesRating;
    }).toList();

    // Sort products
    if (selectedSort == "Price: Low to High") {
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort == "Price: High to Low") {
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    } else if (selectedSort == "Best Selling") {
      filteredProducts.sort((a, b) => b.sales.compareTo(a.sales));
    } else if (selectedSort == "Rating: High to Low") {
      filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            if (filteredProducts.isEmpty) ...[
              const Center(
                child: Text("No products found"),
              )
            ] else ...[
                									
              // ========== PRODUCTS GRID BUILDER ==========
              Skeletonizer(
								enabled: _isLoading,
								child: RefreshIndicator(
									onRefresh: _refreshContent,
									child: Padding(
										padding: const EdgeInsets.only(top: 116),
										child: GridView.builder(
											padding: const EdgeInsets.all(8),
											gridDelegate:
												const SliverGridDelegateWithFixedCrossAxisCount(
												crossAxisCount: 2,
												crossAxisSpacing: 8,
												mainAxisSpacing: 8,
												childAspectRatio: 0.65,
											),
											itemCount: filteredProducts.length,
											itemBuilder: (context, index) {
												final product = filteredProducts[index];
												return ProductCard(product: product);
											},
										),
									),
								),
							),
                								],
                
            // ========== SEARCH & FILTER BAR ==========
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withAlpha(20),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                
                				// ========== SEARCH BAR ==========
                        TextField(
                          controller: TextEditingController(
                            text: searchQueryNotifier.value
                					),
                          decoration: InputDecoration(
                            hintText: "Search products...",
                            prefixIcon: Icon(
                							Icons.search,
                              color: colorScheme.secondary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 15,
                            ),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              searchQueryNotifier.value = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                
                  const SizedBox(height: 4),
                
                	// ========= FILTER & SORT ROW ==========
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${filteredProducts.length} Products Found",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
												),
                      ),
                
                      // ========== FILTER & SORT BUTTON ==========
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                
                					// ========== SORT BUTTON ==========
                          SortButton(
                            selectedSort: selectedSort,
                            sortOptions: sortOptions,
                            onApplySorting: (newSort) {
                              setState(() {
                                selectedSort = newSort;
                              });
                            },
                            onResetSorting: () {
                              setState(() {
                                selectedSort = "Default";
                              });
                            },
                          ),
                
                          const SizedBox(width: 8),
                															
                					// ========== FILTER BUTTON ==========
                          FilterButton(
                            selectedCategory: selectedCategory,
                            selectedPriceRange: selectedPriceRange,
                            selectedBrand: selectedBrand,
                            selectedRating: selectedRating,
                            categories: categories,
                            priceRanges: priceRanges,
                            brands: brands,
                            ratings: ratings,
                            onApplyFilters: (
                              newCategory,
                              newPriceRange,
                              newBrand,
                              newRating,
                            ) {
                              setState(() {
                                selectedCategory = newCategory;
                                selectedPriceRange = newPriceRange;
                                selectedBrand = newBrand;
                                selectedRating = newRating;
                              });
                            },
                            onResetFilters: () {
                              setState(() {
                                selectedCategory = "All";
                                selectedPriceRange = "All";
                                selectedBrand = "All";
                                selectedRating = 0;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
