import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/text_format.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/error_view.dart';
import '../../core/widgets/product_card.dart';
import '../../core/widgets/shimmer_placeholder.dart';
import '../../domain/repositories/product_repository.dart';
import '../../injection/injection_container.dart';
import '../../routes/app_router.dart';
import 'cubit/product_list_cubit.dart';
import 'cubit/product_list_state.dart';
import 'widgets/filter_sheet.dart';

class ProductListScreen extends StatelessWidget {
  final String? initialCategory;
  final String? initialQuery;

  const ProductListScreen({super.key, this.initialCategory, this.initialQuery});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductListCubit(sl<ProductRepository>())
        ..loadProducts(initialCategory: initialCategory),
      child: _ProductListView(initialQuery: initialQuery),
    );
  }
}

class _ProductListView extends StatefulWidget {
  final String? initialQuery;
  const _ProductListView({this.initialQuery});

  @override
  State<_ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<_ProductListView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery ?? '');
    if (widget.initialQuery != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ProductListCubit>().setSearchQuery(widget.initialQuery!);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _sortLabel(SortOption option) {
    switch (option) {
      case SortOption.none: return 'Default';
      case SortOption.priceLowHigh: return 'Price: Low to High';
      case SortOption.priceHighLow: return 'Price: High to Low';
      case SortOption.ratingHighLow: return 'Rating: High to Low';
    }
  }

  Future<void> _openFilters(ProductListState state) async {
    final cubit = context.read<ProductListCubit>();
    final result = await showFilterSheet(
      context,
      priceCeiling: state.priceCeiling,
      initialMinPrice: state.minPrice,
      initialMaxPrice: state.maxPrice,
      initialMinRating: state.minRating,
    );
    if (result != null) {
      cubit.applyPriceAndRatingFilter(
        minPrice: result.minPrice,
        maxPrice: result.maxPrice,
        minRating: result.minRating,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: BlocBuilder<ProductListCubit, ProductListState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  controller: _controller,
                  onChanged: (value) => context.read<ProductListCubit>().setSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _controller.clear();
                              context.read<ProductListCubit>().setSearchQuery('');
                            },
                          ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (state.categoryFilter != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InputChip(
                          label: Text(formatCategoryLabel(state.categoryFilter!)),
                          onDeleted: () => context.read<ProductListCubit>().setCategoryFilter(null),
                        ),
                      ),
                    InkWell(
                      onTap: state.status == ProductListStatus.loaded ? () => _openFilters(state) : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Chip(
                        label: const Text('Filters'),
                        avatar: Icon(
                          Icons.tune,
                          size: 16,
                          color: state.hasActiveFilters ? AppColors.primary : null,
                        ),
                        backgroundColor: state.hasActiveFilters
                            ? AppColors.primary.withValues(alpha: 0.1)
                            : null,
                      ),
                    ),
                    const Spacer(),
                    PopupMenuButton<SortOption>(
                      initialValue: state.sortOption,
                      onSelected: (option) => context.read<ProductListCubit>().setSortOption(option),
                      itemBuilder: (context) => SortOption.values
                          .map((option) => PopupMenuItem(value: option, child: Text(_sortLabel(option))))
                          .toList(),
                      child: Chip(
                        label: Text(_sortLabel(state.sortOption)),
                        avatar: const Icon(Icons.sort, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductListState state) {
    if (state.status == ProductListStatus.error) {
      return ErrorView(
        message: state.errorMessage ?? 'Unable to load products',
        onRetry: () => context.read<ProductListCubit>().loadProducts(),
      );
    }

    if (state.status != ProductListStatus.loaded) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.62,
        ),
        itemBuilder: (context, index) => const ProductCardShimmer(),
      );
    }

    if (state.visibleProducts.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: 'No products found',
        subtitle: 'Try a different search term, category or filter.',
        action: state.hasActiveFilters
            ? OutlinedButton(
                onPressed: () => context.read<ProductListCubit>().resetFilters(),
                child: const Text('Clear filters'),
              )
            : null,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      itemCount: state.visibleProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.62,
      ),
      itemBuilder: (context, index) {
        final product = state.visibleProducts[index];
        return ProductCard(
          product: product,
          width: double.infinity,
          onTap: () => context.push('${AppRoutes.productDetail}/${product.id}'),
        );
      },
    );
  }
}
