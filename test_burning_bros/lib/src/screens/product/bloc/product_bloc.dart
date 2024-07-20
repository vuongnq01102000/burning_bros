import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_burning_bros/core/models/product.dart';
import 'package:test_burning_bros/core/repository/favorite_product_repository/favortie_product_repository.dart';
import 'package:test_burning_bros/core/repository/product_repository/product_repository.dart';
import 'package:test_burning_bros/src/screens/product/bloc/product_status.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepositoryImpl productRepositoryImpl;
  final FavoriteRepository favoriteRepository;
  int currentSkip = 0;
  static const int itemsPerPage = 20;

  ProductBloc(
      {required this.productRepositoryImpl, required this.favoriteRepository})
      : super(
          const ProductState(
            status: ProductStatus.initial,
          ),
        ) {
    on<FetchProducts>(_onFetchProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SearchProducts>(_onSearchProducts);
  }

  Future<void> _onFetchProducts(
      FetchProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      // get products from the repository

      final products = await productRepositoryImpl.getProducts(
          limit: event.limit, skip: event.skip);

      // get favorite products from the repository
      final favoriteProducts = favoriteRepository.getAllFavorites();

      // update the products with the favorite status
      final updatedProducts = products.map((product) {
        return product.copyWith(
            isFavorite: favoriteProducts
                .any((favoriteProduct) => favoriteProduct.id == product.id));
      }).toList();

      // return to  updated products
      emit(
        state.copyWith(
          products: updatedProducts,
          status: ProductStatus.loaded,
          hasReachedMax: products.length < itemsPerPage,
        ),
      );
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event, Emitter<ProductState> emit) async {
    if (state.hasReachedMax) return;

    emit(state.copyWith(status: ProductStatus.loadingMore));
    try {
      final moreProducts = await productRepositoryImpl.getProducts(
          limit: itemsPerPage, skip: currentSkip);

      final favoriteProducts = favoriteRepository.getAllFavorites();
      final favoriteProductIds = favoriteProducts.map((p) => p.id).toSet();

      final newProducts = moreProducts.map((product) {
        return product.copyWith(
          isFavorite: favoriteProductIds.contains(product.id),
        );
      }).where((newProduct) {
        return !state.products
            .any((existingProduct) => existingProduct.id == newProduct.id);
      }).toList();

      if (moreProducts.isEmpty) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
          products: List.of(state.products)..addAll(newProducts),
          status: ProductStatus.loaded,
          hasReachedMax: moreProducts.length < itemsPerPage,
        ));
        currentSkip += moreProducts.length;
      }
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onToggleFavorite(
      ToggleFavorite event, Emitter<ProductState> emit) async {
    // toggle the favorite status of the product
    await favoriteRepository.toggleFavorite(event.product);

    // update the product with the new favorite status
    final updatedProducts = state.products.map((product) {
      if (product.id == event.product.id) {
        return product.copyWith(
            isFavorite: favoriteRepository.isFavorite(product.id ?? 0));
      }
      return product;
    }).toList();

    emit(state.copyWith(products: updatedProducts));
  }

  Future<void> _onSearchProducts(
      SearchProducts event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading));
    try {
      final products = await productRepositoryImpl.searchProducts(event.query);
      final favoriteProducts = favoriteRepository.getAllFavorites();
      final updateList = <Product>[];

      for (var product in products) {
        final isFavorite = favoriteProducts
            .any((favoriteProduct) => favoriteProduct.id == product.id);
        updateList.add(product.copyWith(isFavorite: isFavorite));
      }

      emit(state.copyWith(
        products: updateList,
        status: ProductStatus.loaded,
        hasReachedMax: true,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }
}
