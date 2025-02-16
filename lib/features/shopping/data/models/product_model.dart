import 'package:freshket_app/features/shopping/domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
    );
  }

  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: name,
      price: price,
    );
  }
}
