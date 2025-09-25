// import 'package:flutter/material.dart';
// import '../models/product.dart';
// import '../data/products_data.dart'; // your hardcoded product list
// import 'product_details_page.dart';

// class ProductsPage extends StatefulWidget {
//   const ProductsPage({Key? key}) : super(key: key);

//   @override
//   State<ProductsPage> createState() => _ProductsPageState();
// }

// class _ProductsPageState extends State<ProductsPage> {
//   String searchQuery = "";
//   String selectedCategory = "All";
//   String selectedPriceRange = "All";

//   @override
//   Widget build(BuildContext context) {
//     // Filter products by search, category, and price
//     List<Product> filteredProducts = products.where((p) {
//       bool matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase());
//       bool matchesCategory = selectedCategory == "All" || p.category == selectedCategory;
//       bool matchesPrice = selectedPriceRange == "All" || 
//         (selectedPriceRange == "Under RM50" && p.price < 50) ||
//         (selectedPriceRange == "RM50-100" && p.price >= 50 && p.price <= 100) ||
//         (selectedPriceRange == "Over RM100" && p.price > 100);
//       return matchesSearch && matchesCategory && matchesPrice;
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Products"),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 140),
//             child: GridView.builder(
//               padding: const EdgeInsets.all(8),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//                 childAspectRatio: 0.65,
//               ),
//               itemCount: filteredProducts.length,
//               itemBuilder: (context, index) {
//                 final product = filteredProducts[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ProductDetailsPage(product: product),
//                       ),
//                     );
//                   },
//                   child: Card(
//                     elevation: 3,
//                     clipBehavior: Clip.hardEdge,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         AspectRatio(
//                           aspectRatio: 1,
//                           child: Image.asset(
//                             product.images.first,
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 product.name,
//                                 maxLines: 2,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: const TextStyle(fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 "RM ${product.price.toStringAsFixed(2)}",
//                                 style: const TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Text(
//                                 "Sales: ${product.sales}",
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           Positioned(
//             top: 16,
//             left: 16,
//             right: 16,
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(25),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black12,
//                     blurRadius: 8,
//                     offset: Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: TextField(
//                 decoration: InputDecoration(
//                   hintText: "Search products...",
//                   prefixIcon: Icon(Icons.search, color: Colors.grey),
//                   suffixIcon: Icon(Icons.mic, color: Colors.grey),
//                   border: InputBorder.none,
//                   contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                 ),
//                 onChanged: (value) {
//                   setState(() {
//                     searchQuery = value;
//                   });
//                 },
//               ),
//             ),
//           ),
//           Positioned(
//             top: 80,
//             left: 16,
//             right: 16,
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   FilterChip(
//                     label: Text("All"),
//                     selected: selectedCategory == "All",
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedCategory = "All";
//                       });
//                     },
//                   ),
//                   SizedBox(width: 8),
//                   FilterChip(
//                     label: Text("Audio"),
//                     selected: selectedCategory == "Audio",
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedCategory = selected ? "Audio" : "All";
//                       });
//                     },
//                   ),
//                   SizedBox(width: 8),
//                   FilterChip(
//                     label: Text("Charging"),
//                     selected: selectedCategory == "Charging",
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedCategory = selected ? "Charging" : "All";
//                       });
//                     },
//                   ),
//                   SizedBox(width: 8),
//                   FilterChip(
//                     label: Text("Car Accessories"),
//                     selected: selectedCategory == "Car Accessories",
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedCategory = selected ? "Car Accessories" : "All";
//                       });
//                     },
//                   ),
//                   SizedBox(width: 8),
//                   FilterChip(
//                     label: Text("Others"),
//                     selected: selectedCategory == "Others",
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedCategory = selected ? "Others" : "All";
//                       });
//                     },
//                   ),
//                   SizedBox(width: 8),
//                   FilterChip(
//                     label: Text("Under RM50"),
//                     selected: selectedPriceRange == "Under RM50",
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedPriceRange = selected ? "Under RM50" : "All";
//                       });
//                     },
//                   ),
//                   SizedBox(width: 8),
//                   FilterChip(
//                     label: Text("RM50-100"),
//                     selected: selectedPriceRange == "RM50-100",
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedPriceRange = selected ? "RM50-100" : "All";
//                       });
//                     },
//                   ),
//                   SizedBox(width: 8),
//                   FilterChip(
//                     label: Text("Over RM100"),
//                     selected: selectedPriceRange == "Over RM100",
//                     onSelected: (bool selected) {
//                       setState(() {
//                         selectedPriceRange = selected ? "Over RM100" : "All";
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
