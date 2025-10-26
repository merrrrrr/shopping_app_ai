import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final String selectedCategory;
  final String selectedPriceRange;
  final String selectedBrand;
  final double selectedRating;
  final List<String> categories;
  final List<String> priceRanges;
  final List<String> brands;
  final List<String> ratings;
  final Function(String, String, String, double) onApplyFilters;
  final VoidCallback onResetFilters;

  const FilterButton({
    super.key,
    required this.selectedCategory,
    required this.selectedPriceRange,
    required this.selectedBrand,
    required this.selectedRating,
    required this.categories,
    required this.priceRanges,
    required this.brands,
    required this.ratings,
    required this.onApplyFilters,
    required this.onResetFilters,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextButton.icon(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          builder: (context) {
            // Temp variables declared once when modal opens
            String tempSelectedCategory = selectedCategory;
            String tempSelectedPriceRange = selectedPriceRange;
            String tempSelectedBrand = selectedBrand;
            double tempSelectedRating = selectedRating;

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Filter Products",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Category",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 8,
                            alignment: WrapAlignment.center,
                            children: categories.map((category) {
                              final isSelected =
                                  tempSelectedCategory == category;
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.surface.withAlpha(125),
                                  foregroundColor: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.secondary
                                            .withAlpha(125),
                                  ),
                                ),
                                onPressed: () {
                                  setModalState(
                                      () => tempSelectedCategory = category);
                                },
                                child: Text(category),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Price Range",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 8,
                            alignment: WrapAlignment.center,
                            children: priceRanges.map((range) {
                              final isSelected =
                                  tempSelectedPriceRange == range;
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.surface.withAlpha(125),
                                  foregroundColor: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.secondary
                                            .withAlpha(125),
                                  ),
                                ),
                                onPressed: () {
                                  setModalState(
                                      () => tempSelectedPriceRange = range);
                                },
                                child: Text(range),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Brand",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 8,
                            alignment: WrapAlignment.center,
                            children: brands.map((brand) {
                              final isSelected = tempSelectedBrand == brand;
                              return OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.surface.withAlpha(125),
                                  foregroundColor: isSelected
                                      ? colorScheme.onPrimary
                                      : colorScheme.onSurface,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.secondary
                                            .withAlpha(125),
                                  ),
                                ),
                                onPressed: () {
                                  setModalState(
                                      () => tempSelectedBrand = brand);
                                },
                                child: Text(brand),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Minimum Rating",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          child: Wrap(
                            spacing: 8,
                            alignment: WrapAlignment.center,
                            children: ratings.map((rating) {
                              if (rating == "Any") {
                                final isSelected = tempSelectedRating == 0;
                                return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.surface.withAlpha(125),
                                    foregroundColor: isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.secondary
                                              .withAlpha(125),
                                    ),
                                  ),
                                  onPressed: () {
                                    setModalState(
                                        () => tempSelectedRating = 0);
                                  },
                                  child: const Text("Any"),
                                );
                              } else {
                                final isSelected =
                                    tempSelectedRating == double.parse(rating);
                                return OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.surface.withAlpha(125),
                                    foregroundColor: isSelected
                                        ? colorScheme.onPrimary
                                        : colorScheme.onSurface,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.secondary
                                              .withAlpha(125),
                                    ),
                                  ),
                                  onPressed: () {
                                    setModalState(() => tempSelectedRating =
                                        double.parse(rating));
                                  },
                                  child: Text("$rating ★"),
                                );
                              }
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor:
                                      colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                ),
                                onPressed: () {
                                  onApplyFilters(
                                    tempSelectedCategory,
                                    tempSelectedPriceRange,
                                    tempSelectedBrand,
                                    tempSelectedRating,
                                  );
                                  Navigator.pop(context);
                                },
                                child: const Text("Apply Filters"),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  onResetFilters();
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.secondary,
                                  foregroundColor:
                                      colorScheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text("Reset Filters"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      style: TextButton.styleFrom(
        foregroundColor: Colors.grey[700],
        padding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      icon: const Icon(Icons.filter_alt),
      label: const Text("Filter"),
    );
  }
}