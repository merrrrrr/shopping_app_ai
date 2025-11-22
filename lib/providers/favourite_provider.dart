import 'package:flutter/material.dart';
import 'package:shopping_app/services/user_service.dart';

class FavouriteProvider with ChangeNotifier {
  final UserService _userService = UserService();
  Set<String> _favouriteProductIds = {};

  Set<String> get favouriteProductIds => Set.unmodifiable(_favouriteProductIds);

  bool isFavourite(String productId) => _favouriteProductIds.contains(productId);

	Future<void> loadFavourites() async {
    try {
      final favouritesList = await _userService.getUserFavourites(); 
      _favouriteProductIds = Set<String>.from(favouritesList);
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading favourites: $e");
    }
  }

  Future<void> toggleFavourite(String productId) async {
    final bool isCurrentlyFavourite = isFavourite(productId);

    if (isCurrentlyFavourite) {
      _favouriteProductIds.remove(productId);
    } else {
      _favouriteProductIds.add(productId);
    }
    notifyListeners();

    try {
      await _userService.updateUserFavourites(_favouriteProductIds.toList());
    } catch (e) {
      debugPrint("Error saving favourite: $e");
      if (isCurrentlyFavourite) {
        _favouriteProductIds.add(productId);
      } else {
        _favouriteProductIds.remove(productId);
      }
      notifyListeners();
    }
  }
}