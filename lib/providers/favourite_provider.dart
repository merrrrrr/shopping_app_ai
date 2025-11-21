import 'package:flutter/material.dart';

class FavouriteProvider with ChangeNotifier {
  final Set<String> _favouriteIds = {};

  Set<String> get favouriteIds => Set.unmodifiable(_favouriteIds);

  bool isFavourite(String productId) => _favouriteIds.contains(productId);

  void toggleFavourite(String productId) {
    if (_favouriteIds.contains(productId)) {
      _favouriteIds.remove(productId);
    } else {
      _favouriteIds.add(productId);
    }
    notifyListeners();
  }
}