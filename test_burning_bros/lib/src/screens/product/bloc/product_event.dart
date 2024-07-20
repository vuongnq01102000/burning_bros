part of 'product_bloc.dart';

abstract class ProductEvent {}

class FetchProducts extends ProductEvent {
  // limit and skip are optional parameters
  final int limit;
  final int skip;
  FetchProducts({this.limit = 20, this.skip = 0});
}

class LoadMoreProducts extends ProductEvent {
  LoadMoreProducts();
}

class ToggleFavorite extends ProductEvent {
  final Product product;

  ToggleFavorite(this.product);
}

class FetchFavoriteProducts extends ProductEvent {
  FetchFavoriteProducts();
}

class SearchProducts extends ProductEvent {
  final String query;

  SearchProducts(this.query);
}
