import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:test_burning_bros/core/services/connection/bloc/connectivity_cubit.dart';
import 'package:test_burning_bros/src/screens/product/bloc/product_bloc.dart';
import 'package:test_burning_bros/src/screens/product/bloc/product_status.dart';
import 'package:test_burning_bros/src/screens/product/list/search_product/search_product.dart';
import 'package:test_burning_bros/src/utils/widgets/w_connect_retry.dart';
import 'package:test_burning_bros/src/utils/widgets/w_footer_custom.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final RefreshController _refreshController = RefreshController();
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectivityCubit, ConnectivityStatus>(
      bloc: context.read<ConnectivityCubit>(),
      listener: (context, state) {
        if (state == ConnectivityStatus.offline) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Mất kết nối internet')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã kết nối internet')),
          );
          context.read<ProductBloc>().add(FetchProducts());
        }
      },
      builder: (context, state) {
        if (state == ConnectivityStatus.offline) {
          return NoInternetWidget(
            onRetry: () =>
                context.read<ConnectivityCubit>().checkConnectivity(),
          );
        }
        return BlocProvider.value(
          value: context.read<ProductBloc>()
            ..add(
              FetchProducts(),
            ),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Product List'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () async {
                    await showSearch(
                            context: context, delegate: SearchProduct())
                        .then(
                      (value) {
                        if (value != null && value == true) {
                          context.read<ProductBloc>().add(
                                FetchProducts(),
                              );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                context.read<ProductBloc>().add(FetchProducts());
              },
              child: const Icon(Icons.refresh),
            ),
            body: BlocConsumer<ProductBloc, ProductState>(
              listener: (context, state) {
                if (state.status == ProductStatus.loaded) {
                  _refreshController.refreshCompleted();
                  _refreshController.loadComplete();
                } else if (state.status == ProductStatus.error) {
                  _refreshController.refreshFailed();
                  _refreshController.loadFailed();
                }
              },
              builder: (context, state) {
                if (state.status == ProductStatus.loading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state.status == ProductStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error loading products: ${state.errorMessage}'),
                        ElevatedButton(
                          onPressed: () {
                            context.read<ProductBloc>().add(FetchProducts());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: !state.hasReachedMax,
                    onRefresh: () {
                      context.read<ProductBloc>().add(FetchProducts());
                    },
                    onLoading: () {
                      context.read<ProductBloc>().add(LoadMoreProducts());
                    },
                    footer: const WidgetFooterCustom(),
                    child: state.products.isEmpty
                        ? const Center(
                            child: Text('No products found'),
                          )
                        : ListView.builder(
                            itemCount: state.products.length +
                                (state.status == ProductStatus.loadingMore
                                    ? 1
                                    : 0),
                            itemBuilder: (context, index) {
                              if (index >= state.products.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                );
                              }
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
                                    color: product.isFavorite ?? false
                                        ? Colors.red
                                        : null,
                                  ),
                                  onPressed: () {
                                    context
                                        .read<ProductBloc>()
                                        .add(ToggleFavorite(product));
                                  },
                                ),
                                subtitle: Text(
                                    '\$${product.price?.toStringAsFixed(2) ?? "N/A"}'),
                              );
                            },
                          ),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
