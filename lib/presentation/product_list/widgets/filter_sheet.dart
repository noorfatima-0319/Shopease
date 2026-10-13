import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

// A plain bottom sheet with a price range slider and a minimum-rating
// selector. Values are only applied when the user taps Apply, so the
// list doesn't refilter on every pixel of slider movement.
class FilterSheetResult {
  final double minPrice;
  final double maxPrice;
  final double minRating;

  const FilterSheetResult({required this.minPrice, required this.maxPrice, required this.minRating});
}

Future<FilterSheetResult?> showFilterSheet(
  BuildContext context, {
  required double priceCeiling,
  required double initialMinPrice,
  required double initialMaxPrice,
  required double initialMinRating,
}) {
  return showModalBottomSheet<FilterSheetResult>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return _FilterSheetContent(
        priceCeiling: priceCeiling,
        initialMinPrice: initialMinPrice,
        initialMaxPrice: initialMaxPrice,
        initialMinRating: initialMinRating,
      );
    },
  );
}

class _FilterSheetContent extends StatefulWidget {
  final double priceCeiling;
  final double initialMinPrice;
  final double initialMaxPrice;
  final double initialMinRating;

  const _FilterSheetContent({
    required this.priceCeiling,
    required this.initialMinPrice,
    required this.initialMaxPrice,
    required this.initialMinRating,
  });

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  late RangeValues _priceRange;
  late double _minRating;

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(widget.initialMinPrice, widget.initialMaxPrice);
    _minRating = widget.initialMinRating;
  }

  @override
  Widget build(BuildContext context) {
    final ceiling = widget.priceCeiling <= 0 ? 1.0 : widget.priceCeiling;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filters', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () {
                  setState(() {
                    _priceRange = RangeValues(0, ceiling);
                    _minRating = 0;
                  });
                },
                child: const Text('Reset'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Price range', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          Text(
            '\$${_priceRange.start.toStringAsFixed(0)} - \$${_priceRange.end.toStringAsFixed(0)}',
            style: const TextStyle(color: AppColors.inkSoft, fontSize: 12),
          ),
          RangeSlider(
            min: 0,
            max: ceiling,
            values: _priceRange,
            divisions: ceiling >= 1 ? ceiling.round().clamp(1, 100) : 1,
            labels: RangeLabels(
              '\$${_priceRange.start.toStringAsFixed(0)}',
              '\$${_priceRange.end.toStringAsFixed(0)}',
            ),
            onChanged: (values) => setState(() => _priceRange = values),
          ),
          const SizedBox(height: 12),
          const Text('Minimum rating', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [0.0, 3.0, 3.5, 4.0, 4.5].map((value) {
              final label = value == 0 ? 'Any' : '${value.toStringAsFixed(1)}+';
              final selected = _minRating == value;
              return ChoiceChip(
                label: Text(label),
                selected: selected,
                onSelected: (_) => setState(() => _minRating = value),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  FilterSheetResult(
                    minPrice: _priceRange.start,
                    maxPrice: _priceRange.end,
                    minRating: _minRating,
                  ),
                );
              },
              child: const Text('Apply Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
