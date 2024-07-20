import 'package:hive/hive.dart';

part 'favorite_product.g.dart';

@HiveType(typeId: 0)
class FavoriteProduct extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? thumbnail;

  @HiveField(3)
  final double price;

  FavoriteProduct({
    required this.id,
    required this.title,
    this.thumbnail,
    required this.price,
  });
}