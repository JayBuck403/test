import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/product.dart';
import '../services/api_service.dart';

part 'product_providers.g.dart';

enum SortType {
  none,
  priceAsc,
  priceDesc,
  byRating,
}

@riverpod
class ProductSort extends _$ProductSort {
  @override
  SortType build() => SortType.none;
  void setSort(SortType type) => state = type;
}

@riverpod
class SelectedCategory extends _$SelectedCategory {
  @override
  String build() => 'All';
  void setCategory(String category) => state = category;
}

@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return ref.watch(apiServiceProvider).fetchProducts();
  }
}


@riverpod
List<String> productCategories(Ref ref) {
  final products = ref.watch(productListProvider);

  return products.when(
    data: (list) {
      final categories = list.map((p) => p.category).toSet();
      return ['All', ...categories];
    },
    loading: () => ['All'],
    error: (_, __) => ['All'],
  );
}

@riverpod
List<Product> filteredProducts(Ref ref) {
  final asyncProducts = ref.watch(productListProvider);
  final sortType = ref.watch(productSortProvider);
  final selectedCategory = ref.watch(selectedCategoryProvider);

  if (asyncProducts.hasValue) {
    List<Product> products = asyncProducts.value!;

    List<Product> filtered = products;
    if (selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == selectedCategory).toList();
    }

    switch (sortType) {
      case SortType.priceAsc:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortType.priceDesc:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortType.byRating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortType.none:
        break;
    }
    return filtered;
  }

  return [];
}


@riverpod
class LikedProducts extends _$LikedProducts {
  @override
  Set<int> build() {
    return {};
  }

  void toggleLike(int productId) {
    state = Set.from(state); 

    if (state.contains(productId)) {
      state.remove(productId);
    } else {
      state.add(productId);
    }


  }
}