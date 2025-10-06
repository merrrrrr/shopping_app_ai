import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/products_data.dart';
import 'widgets/product_card.dart';

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
	final List<String> categories = ["All", "Audio", "Charging", "Car Accessories", "Others"];
  final List<String> brands = ["All", "Baseus", "Oppo", "Redmi", "Samsung", "Xiaomi"];
	final List<String> priceRanges = [
		"All",
		"Under RM50",
		"RM50-100",
		"RM100-RM200",
		"Over RM200"
	];
	final List<String> ratings = ["Any", "1.0", "2.0", "3.0", "4.0", "5.0"];
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
							padding: const EdgeInsets.only(top: 116),
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
									return ProductCard(product: product);
								},
							),
						),
						Positioned(
							top: 16,
							left: 16,
							right: 16,
							child: Column(
							  children: [
							    Container(
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
							    	child: Column(
							    	  children: [
							    	    TextField(
							    	    	decoration: InputDecoration(
							    	    		hintText: "Search products...",
							    	    		prefixIcon: Icon(Icons.search, color: Colors.grey),
							    	    		suffixIcon: IconButton(
							    	    			onPressed: () {
							    	    				
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
							    	  ],
							    	),
							    ),

									const SizedBox(height: 4),

							    Row(
										mainAxisAlignment: MainAxisAlignment.spaceBetween,
							      children: [
											Text("${filteredProducts.length} Products Found", style: TextStyle(fontWeight: FontWeight.bold)),
							        Row(
							        	mainAxisAlignment: MainAxisAlignment.end,
							        	children: [
							        		TextButton.icon(
							        			onPressed: () {
															showModalBottomSheet(
							    	    					context: context,
							    	    					isScrollControlled: true,
							    	    					shape: const RoundedRectangleBorder(
							    	          			  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
							    	          		),
							    	    					builder: (context) {
							    	    						return SafeArea(
							    	    							child: Padding(
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
							    	    
							    	    									Row(
							    	    									  children: [
							    	    									    Expanded(
							    	    									      child: ElevatedButton(
							    	    									        onPressed: () {
							    	    									          Navigator.pop(context);
							    	    									        },
							    	    									        child: Text("Apply Filters"),
							    	    									      ),
							    	    									    ),
							    	  
							    	    									    const SizedBox(width: 8),
							    	  
							    	    											Expanded(
							    	    												child: ElevatedButton(
							    	    													onPressed: () {
							    	    														Navigator.pop(context);
							    	    													},
							    	    													style: ElevatedButton.styleFrom(
							    	    														backgroundColor: Colors.grey[500],
							    	    														foregroundColor: Colors.white,
							    	    													),
							    	    													child: Text("Reset Filters"),
							    	    												),
							    	    											)
							    	    										],
							    	    									),
							    	    								],
							    	    							),
							    	    						),
							    	    					);
							    	    				}
							    	    			);
														},
							        			style: TextButton.styleFrom(
							        				foregroundColor: Colors.grey[700],
															padding: EdgeInsets.symmetric(horizontal: 8),
															shape: RoundedRectangleBorder(
																borderRadius: BorderRadius.circular(8),
															),
							        			),
							        			icon: Icon(Icons.sort),
							        			label: Text("Sort")
							        		),

													const SizedBox(width: 8),
		
							        		TextButton.icon(
							        			onPressed: () {
															showModalBottomSheet(
							    	    					context: context,
							    	    					isScrollControlled: true,
							    	    					shape: const RoundedRectangleBorder(
							    	          			borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
							    	          		),
							    	    					builder: (context) {
							    	    						return SafeArea(
							    	    							child: Padding(
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
							    	    
							    	    										Wrap(
							    	    										spacing: 8,
							    	    										children: categories.map((category) {
							    	    											return FilterChip(
							    	    												label: Text(category),
							    	    												selected: selectedCategory == category,
							    	    												onSelected: (selected) {
							    	    													setState(() => selectedCategory = category);
							    	    													Navigator.pop(context);
							    	    												},
							    	    											);
							    	    										}).toList(),
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
							    	    
							    	    										Wrap(
							    	    										spacing: 8,
							    	    										children: priceRanges.map((range) {
							    	    											return FilterChip(
							    	    												label: Text(range),
							    	    												selected: selectedPriceRange == range,
							    	    												onSelected: (selected) {
							    	    													setState(() => selectedPriceRange = selected ? range : "All");
							    	    													Navigator.pop(context);
							    	    												},
							    	    											);
							    	    										}).toList(),
							    	    									),
							    	    
							    	    										SizedBox(height: 16),
							    	    
							    	    										Text("Brand", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
							    	    
							    	    										const SizedBox(height: 8),
							    	    
							    	    										Wrap(
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
							    	    
							    	    										const SizedBox(height: 16),
							    	    
							    	    										Text("Minimum Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
							    	    
							    	    										const SizedBox(height: 8),
							    	    
							    	    										Wrap(
							    	    										spacing: 8,
							    	    										children: ratings.map((rating) {
							    	    											if (rating == "Any") {
							    	    												return FilterChip(
							    	    													label: Text("Any"),
							    	    													selected: selectedRating == 0,
							    	    													onSelected: (selected) {
							    	    														setState(() => selectedRating = 0);
							    	    														Navigator.pop(context);
							    	    													},
							    	    												);
							    	    											} else {
							    	    												return FilterChip(
							    	    													label: Text("$rating ★"),
							    	    													selected: selectedRating == double.parse(rating),
							    	    													onSelected: (selected) {
							    	    														setState(() => selectedRating = double.parse(rating));
							    	    														Navigator.pop(context);
							    	    													},
							    	    												);
							    	    											}
							    	    										}).toList(),
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
							    	    
							    	    										Row(
							    	    										  children: [
							    	    										    Expanded(
							    	    										      child: ElevatedButton(
							    	    										        onPressed: () {
							    	    										          Navigator.pop(context);
							    	    										        },
							    	    										        child: Text("Apply Filters"),
							    	    										      ),
							    	    										    ),
							    	    
							    	    										    const SizedBox(width: 8),
							    	    
							    	    												Expanded(
							    	    													child: ElevatedButton(
							    	    														onPressed: () {
							    	    															Navigator.pop(context);
							    	    														},
							    	    														style: ElevatedButton.styleFrom(
							    	    															backgroundColor: Colors.grey[500],
							    	    															foregroundColor: Colors.white,
							    	    														),
							    	    														child: Text("Reset Filters"),
							    	    													),
							    	    												)
							    	    											],
							    	    										),
							    	    
							    	    										
							    	    									],
							    	    								),
							    	    							),
							    	    						);
							    	    					}
							    	    				);
														},
							        			style: TextButton.styleFrom(
							        				foregroundColor: Colors.grey[700],
							        				padding: EdgeInsets.symmetric(horizontal: 8),
															shape: RoundedRectangleBorder(
																borderRadius: BorderRadius.circular(8),
															),
							        			),
							        			icon: Icon(Icons.filter_alt),
							        			label: Text("Filter"),
							        		),
		
							        		
							        	],
							        ),
							      ],
							    )
							  ],
							),
						),
					],
				),
			),
    );
  }
}