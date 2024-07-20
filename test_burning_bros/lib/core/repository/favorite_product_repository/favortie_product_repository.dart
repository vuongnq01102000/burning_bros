import 'package:hive/hive.dart';
import 'package:test_burning_bros/core/models/favorite_product.dart';
import 'package:test_burning_bros/core/models/product.dart';


class FavoriteRepository {
  final Box<FavoriteProduct> _favoritesBox = Hive.box<FavoriteProduct>('favorites');

  Future<void> toggleFavorite(Product product) async {
    final favoriteProduct = FavoriteProduct(
      id: product.id ?? 0,
      title: product.title ?? '',
      thumbnail: product.thumbnail,
      price: product.price ?? 0,
    );

    if (_favoritesBox.containsKey(product.id)) {
      await _favoritesBox.delete(product.id);
    } else {
      await _favoritesBox.put(product.id, favoriteProduct);
    }
  }

  bool isFavorite(int productId) {
    return _favoritesBox.containsKey(productId);
  }

  List<FavoriteProduct> getAllFavorites() {
    return _favoritesBox.values.toList();
  }
}