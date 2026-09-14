import 'product.dart';

class Category {
  final String? id;
  final String? name;
  final List<Product>? products;

  const Category({this.id, this.name, this.products});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json['id'] as String?,
    name: json['name'] as String?,
    products: (json['products'] as List<dynamic>?)?.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList(),
  );

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'products': products?.map((e) => e.toJson()).toList()};

  List<Object?> get props => [id, name, products];
}
