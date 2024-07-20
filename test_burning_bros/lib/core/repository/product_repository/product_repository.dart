import 'package:test_burning_bros/core/models/product.dart';
import 'package:test_burning_bros/core/network_client/dio_client.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int? limit, int? skip});
  Future<List<Product>> searchProducts(String query);
}

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({required this.dioClient});

  final DioClient dioClient;
  @override
  Future<List<Product>> getProducts({int? limit, int? skip}) async {
    final res = await dioClient
        .get('/products', queryParameters: {'limit': limit, 'skip': skip});
    return res.data["products"]
        .map<Product>((e) => Product.fromJson(e))
        .toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final res =
        await dioClient.get('/products/search', queryParameters: {'q': query});
    return res.data["products"]
        .map<Product>((e) => Product.fromJson(e))
        .toList();
  }
}
