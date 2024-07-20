import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_burning_bros/src/screens/product/bloc/product_bloc.dart';

import 'package:test_burning_bros/src/utils/debouncer.dart';

class SearchProduct extends SearchDelegate {
  final Debouncer _debouncer =
      Debouncer(delay: const Duration(milliseconds: 500));
  @override
  List<Widget> buildActions(BuildContext context) {
    context.read<ProductBloc>().add(SearchProducts(query));
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, true);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.characters.length >= 3) {
      context.read<ProductBloc>().add(SearchProducts(query));
    }
    return BlocProvider.value(
      value: context.read<ProductBloc>(),
      child: BlocBuilder<ProductBloc, ProductState>(builder: (context, state) {
        if (state.products.isEmpty) {
          return const Center(
            child: Text('No products found'),
          );
        }
        return ListView.builder(
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return ListTile(
              title: Text(product.title ?? ""),
              leading: Image.network(
                product.thumbnail ?? "",
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
              trailing: IconButton(
                icon: Icon(
                  product.isFavorite ?? false
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: product.isFavorite ?? false ? Colors.red : null,
                ),
                onPressed: () {
                  context.read<ProductBloc>().add(ToggleFavorite(product));
                },
              ),
              subtitle: Text('\$${product.price?.toStringAsFixed(2) ?? "N/A"}'),
            );
          },
        );
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    _debouncer.run(() {
      if (query.isNotEmpty) {
        context.read<ProductBloc>().add(SearchProducts(query));
      }
    });

    return buildResults(context);
  }
}
