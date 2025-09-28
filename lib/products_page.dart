import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart'; // your hardcoded product list
import 'product_details_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  String searchQuery = "";
  String selectedCategory = "All";
  String selectedPriceRange = "All";
  String selectedBrand = "All";
  double selectedRating = 0;
  String selectedSort = "Default";

  // Example brands and sort options
  final List<String> brands = ["All", "Baseus", "Oppo", "Redmi", "Samsung", "Xiaomi"];
  final List<String> sortOptions = [
    "Default",
    "Price: Low to High",
    "Price: High to Low",
    "Best Selling",
    "Rating: High to Low"
  ];

  @override
  Widget build(BuildContext context) {
    // Filter products by search, category, price, brand, and rating
    List<Product> filteredProducts = products.where((p) {
      bool matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase());
      bool matchesCategory = selectedCategory == "All" || p.category == selectedCategory;
      bool matchesPrice = selectedPriceRange == "All" ||
        (selectedPriceRange == "Under RM50" && p.price < 50) ||
        (selectedPriceRange == "RM50-100" && p.price >= 50 && p.price <= 100) ||
        (selectedPriceRange == "RM100-RM200" && p.price >= 100 && p.price <= 200) ||
        (selectedPriceRange == "Over RM200" && p.price > 200);
      bool matchesBrand = selectedBrand == "All" || p.brand == selectedBrand;
      bool matchesRating = selectedRating == 0 || (p.rating != null && p.rating! >= selectedRating);
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
      // filteredProducts.sort((a, b) => (b.rating ?? 0).compareTo(a.rating ?? 0));
    }

    return Scaffold(
      body: SafeArea(
				child: Stack(
					children: [
						Padding(
							padding: const EdgeInsets.only(top: 82),
							child: GridView.builder(
								padding: const EdgeInsets.all(8),
								gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
									crossAxisCount: 2,
									crossAxisSpacing: 8,
									mainAxisSpacing: 8,
									childAspectRatio: 0.65,
								),
								itemCount: filteredProducts.length,
								itemBuilder: (context, index) {
									final product = filteredProducts[index];
									return GestureDetector(
										onTap: () {
											Navigator.push(
												context,
												MaterialPageRoute(
													builder: (context) => ProductDetailsPage(product: product),
												),
											);
										},
										child: Card(
											clipBehavior: Clip.hardEdge,
											shape: RoundedRectangleBorder(
												borderRadius: BorderRadius.circular(12),
											),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.start,
												children: [
													AspectRatio(
														aspectRatio: 1,
														child: Image.asset(
															product.images.first,
															fit: BoxFit.contain,
														),
													),
													Padding(
														padding: const EdgeInsets.all(8),
														child: Column(
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Text(
																	product.name,
																	maxLines: 2,
																	overflow: TextOverflow.ellipsis,
																	style: const TextStyle(fontWeight: FontWeight.bold),
																),
																const SizedBox(height: 2),
																Text(
																	"RM ${product.price.toStringAsFixed(2)}",
																	style: TextStyle(
																		fontSize: 16,
																		fontWeight: FontWeight.bold,
																		color: Colors.cyan[500],
																	),
																),
																const SizedBox(height: 2),
																Text(
																	"Sales: ${product.sales}",
																	style: const TextStyle(
																		fontSize: 12,
																		color: Colors.grey,
																	),
																),
															],
														),
													),
												],
											),
										),
									);
								},
							),
						),
						Positioned(
							top: 16,
							left: 16,
							right: 16,
							child: Container(
								decoration: BoxDecoration(
									color: Colors.white,
									borderRadius: BorderRadius.circular(25),
									boxShadow: [
										BoxShadow(
											color: Colors.black12,
											blurRadius: 8,
											offset: Offset(0, 2),
										),
									],
								),
								child: TextField(
									decoration: InputDecoration(
										hintText: "Search products...",
										prefixIcon: Icon(Icons.search, color: Colors.grey),
										suffixIcon: IconButton(
											onPressed: () {
												showModalBottomSheet(
													context: context,
													shape: const RoundedRectangleBorder(
      										  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      										),
													builder: (context) {
														return Padding(
															padding: const EdgeInsets.all(16),
															child: Column(
																mainAxisSize: MainAxisSize.min,
																children: [
																	Text(
																		"Filter Products",
																		style: TextStyle(
																			fontSize: 18,
																			fontWeight: FontWeight.bold
																		),
																	),

																	const SizedBox(height: 16),

																	Text(
																		"Category",
																		style: TextStyle(
																			fontSize: 16,
																			fontWeight: FontWeight.bold
																		),
																	),

																	SizedBox(height: 8),

																	SingleChildScrollView(
																		scrollDirection: Axis.horizontal,
																		child: Row(
																			children: [
																				FilterChip(
																					label: Text("All"),
																					selected: selectedCategory == "All",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedCategory = "All";
																						});
																					},
																				),
																				SizedBox(width: 8),
																				FilterChip(
																					label: Text("Audio"),
																					selected: selectedCategory == "Audio",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedCategory = selected ? "Audio" : "All";
																						});
																					},
																				),
																				SizedBox(width: 8),
																				FilterChip(
																					label: Text("Charging"),
																					selected: selectedCategory == "Charging",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedCategory = selected ? "Charging" : "All";
																						});
																					},
																				),
																				SizedBox(width: 8),
																				FilterChip(
																					label: Text("Car Accessories"),
																					selected: selectedCategory == "Car Accessories",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedCategory = selected ? "Car Accessories" : "All";
																						});
																					},
																				),
																				SizedBox(width: 8),
																				FilterChip(
																					label: Text("Others"),
																					selected: selectedCategory == "Others",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedCategory = selected ? "Others" : "All";
																						});
																					},
																				),
																			],
																		),
																	),

																	const SizedBox(height: 16),
																	
																	Text(
																		"Price Range",
																		style: TextStyle(
																			fontSize: 16,
																			fontWeight: FontWeight.bold
																		),
																	),

																	SizedBox(height: 8),

																	SingleChildScrollView(
																		scrollDirection: Axis.horizontal,
																		child: Row(
																			children: [
																				FilterChip(
																					label: Text("All"),
																					selected: selectedPriceRange == "All",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedPriceRange = "All";
																						});
																					},
																				),
																				SizedBox(width: 8),
																				FilterChip(
																					label: Text("Under RM50"),
																					selected: selectedPriceRange == "Under RM50",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedPriceRange = selected ? "Under RM50" : "All";
																						});
																					},
																				),
																				SizedBox(width: 8),
																				FilterChip(
																					label: Text("RM50-100"),
																					selected: selectedPriceRange == "RM50-100",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedPriceRange = selected ? "RM50-100" : "All";
																						});
																					},
																				),
																				SizedBox(width: 8),
																				FilterChip(
																					label: Text("RM100-RM200"),
																					selected: selectedPriceRange == "RM100-RM200",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedPriceRange = selected ? "RM100-RM200" : "All";
																						});
																					},
																				),
																		
																				FilterChip(
																					label: Text("Over RM200"),
																					selected: selectedPriceRange == "Over RM200",
																					onSelected: (bool selected) {
																						setState(() {
																							selectedPriceRange = selected ? "Over RM200" : "All";
																						});
																					},
																				),
																			],
																		),
																	),

																	SizedBox(height: 16),

																	Text("Brand", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                	SingleChildScrollView(
																		scrollDirection: Axis.horizontal,
																		child: Row(
																		spacing: 8,
																		children: brands.map((brand) {
																			return FilterChip(
																				label: Text(brand),
																				selected: selectedBrand == brand,
																				onSelected: (selected) {
																					setState(() => selectedBrand = brand);
																					Navigator.pop(context);
																				},
																			);
																		}).toList(),
																	),
																),

																	const SizedBox(height: 16),

																	Text("Minimum Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
																		const SizedBox(height: 8),
																		SingleChildScrollView(
																			scrollDirection: Axis.horizontal,
																																					child: Row(
																																						children: [
																																							FilterChip(
																																								label: Text("Any"),
																																								selected: selectedRating == 0,
																																								onSelected: (selected) {
																																									setState(() => selectedRating = 0);
																																								},
																																							),
																																							...List.generate(5, (i) {
																																								double ratingValue = (i + 1).toDouble();
																																								return FilterChip(
																																									label: Text("${ratingValue.toStringAsFixed(1)} ★"),
																																									selected: selectedRating == ratingValue,
																																									onSelected: (selected) {
																																										setState(() => selectedRating = ratingValue);
																																									},
																																								);
																																							}),
																																						],
																																					),
																																				),

																		const SizedBox(height: 16),

																		// Sort Options
                                    Text("Sort By", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    DropdownButton<String>(
                                      value: selectedSort,
                                      isExpanded: true,
                                      items: sortOptions.map((option) {
                                        return DropdownMenuItem(
                                          value: option,
                                          child: Text(option),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setState(() => selectedSort = value ?? "Default");
                                        Navigator.pop(context);
                                      },
                                    ),

                                    const SizedBox(height: 24),

																],
															),
														);
													}
												);
											},
											icon: Icon(Icons.filter_list, color: Colors.grey),
											),
										border: InputBorder.none,
										contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
									),
									onChanged: (value) {
										setState(() {
											searchQuery = value;
										});
									},
								),
							),
						),
						// Positioned(
						// 	top: 80,
						// 	left: 16,
						// 	right: 16,
						// 	child: Row(
						// 		children: [
						// 			Expanded(
						// 				child: Container(
						// 					padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
						// 					decoration: BoxDecoration(
						// 						borderRadius: BorderRadius.circular(8),
						// 						border: Border.all(color: Colors.grey.shade400),
						// 					),
						// 					child: DropdownButtonHideUnderline(
						// 						child: DropdownButton<String>(
						// 							value: selectedCategory == "All" ? null : selectedCategory,
						// 							isExpanded: true,
						// 							hint: Text("Category"),
						// 							items: ["Audio", "Charging", "Car Accessories", "Others"]
						// 									.map((String value) {
						// 								return DropdownMenuItem<String>(
						// 									value: value,
						// 									child: Text(value),
						// 								);
						// 							}).toList(),
						// 							onChanged: (String? newValue) {
						// 								setState(() {
						// 									selectedCategory = newValue ?? "All";
						// 								});
						// 							},
						// 						),
						// 					),
						// 				),
						// 			),
						// 			SizedBox(width: 16),
						// 			Expanded(
						// 				child: Container(
						// 					padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
						// 					decoration: BoxDecoration(
						// 						borderRadius: BorderRadius.circular(8),
						// 						border: Border.all(color: Colors.grey.shade400),
						// 					),
						// 					child: DropdownButtonHideUnderline(
						// 						child: DropdownButton<String>(
						// 							value: selectedPriceRange == "All" ? null : selectedPriceRange,
						// 							isExpanded: true,
						// 							hint: Text("Price Range"),
						// 							items: ["Under RM50", "RM50-100", "Over RM100"]
						// 									.map((String value) {
						// 								return DropdownMenuItem<String>(
						// 									value: value,
						// 									child: Text(value),
						// 								);
						// 							}).toList(),
						// 							onChanged: (String? newValue) {
						// 								setState(() {
						// 									selectedPriceRange = newValue ?? "All";
						// 								});
						// 							},
						// 						),
						// 					),
						// 				),
						// 			),
						// 		],
						// 	),
						// ),
					],
				),
			),
    );
  }
}
