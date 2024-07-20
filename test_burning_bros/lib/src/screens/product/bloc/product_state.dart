part of 'product_bloc.dart';

class ProductState extends Equatable {
  final List<Product> products;
  final ProductStatus status;
  final String errorMessage;
  final bool hasReachedMax;

  const ProductState({
    this.products = const [],
    this.status = ProductStatus.initial,
    this.errorMessage = '',
    this.hasReachedMax = false,
  });

  ProductState copyWith({
    List<Product>? products,
    List<Product>? favoriteProducts,
    ProductStatus? status,
    String? errorMessage,
    bool? hasReachedMax,
  }) {
    return ProductState(
      products: products ?? this.products,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        products,
        status,
        errorMessage,
        hasReachedMax,
      ];
}
