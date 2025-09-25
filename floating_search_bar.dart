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

//   @override
//   Widget build(BuildContext context) {
//     // Filter products by search
//     List<Product> filteredProducts = products.where((p) {
//       return p.name.toLowerCase().contains(searchQuery.toLowerCase());
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Products"),
//       ),
//       body: Stack(
//         children: [
//           Padding(
//             padding: const EdgeInsets.only(top: 80),
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
//         ],
//       ),
//     );
//   }
// }
