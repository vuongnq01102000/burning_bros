import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:test_burning_bros/app_config.dart';
import 'package:test_burning_bros/core/models/favorite_product.dart';
import 'package:test_burning_bros/core/network_client/dio_client.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_burning_bros/core/repository/favorite_product_repository/favortie_product_repository.dart';
import 'package:test_burning_bros/core/repository/product_repository/product_repository.dart';
import 'package:test_burning_bros/core/services/connection/bloc/connectivity_cubit.dart';
import 'package:test_burning_bros/src/screens/product/bloc/product_bloc.dart';
import 'package:test_burning_bros/src/screens/product/list/product_list_view.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(FavoriteProductAdapter());
  await Hive.openBox<FavoriteProduct>('favorites');
  final appConfig = AppConfig(
    baseUrl: 'https://dummyjson.com',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dioClient = DioClient(appConfig);

  runApp(MyApp(
    dioClient: dioClient,
  ));
}

class MyApp extends StatelessWidget {
  final DioClient dioClient;
  const MyApp({required this.dioClient, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
            create: (context) => ProductRepositoryImpl(dioClient: dioClient)),
        RepositoryProvider(create: (context) => FavoriteRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ProductBloc(
                    productRepositoryImpl:
                        context.read<ProductRepositoryImpl>(),
                    favoriteRepository: context.read<FavoriteRepository>(),
                  )),
          BlocProvider(
            create: (context) => ConnectivityCubit()..checkConnectivity(),
          ),
        ],
        child: MaterialApp(
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          title: "Burning Bros",
          home: const ProductListView(),
        ),
      ),
    );
  }
}
