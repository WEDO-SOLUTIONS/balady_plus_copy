class Product {
  final String? id;
  final String? name;
  final bool? enabled;

  const Product({this.id, this.name, this.enabled});

  factory Product.fromJson(Map<String, dynamic> json) =>
      Product(id: json['id'] as String?, name: json['name'] as String?, enabled: json['enabled'] as bool?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'enabled': enabled};

  List<Object?> get props => [id, name, enabled];
}
