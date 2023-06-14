class ServiceArgs {
  final String title;
  final Object image;
  final String description;
  final String? tag;
  final String route;

  ServiceArgs({
    required this.title,
    required this.image,
    required this.description,
    this.tag,
    required this.route,
  });

  ServiceArgs copyWith({
    String? title,
    Object? image,
    String? description,
    String? tag,
    String? route,
  }) {
    return ServiceArgs(
      title: title ?? this.title,
      image: image ?? this.image,
      description: description ?? this.description,
      tag: tag ?? this.tag,
      route: route ?? this.route,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'image': image,
      'description': description,
      'tag': tag,
      'route': route,
    };
  }

  factory ServiceArgs.fromMap(Map<String, dynamic> map) {
    return ServiceArgs(
      title: map['title'] as String,
      image: map['title'] as String,
      description: map['description'] as String,
      tag: map['tag'] as String?,
      route: map['route'] as String,
    );
  }

  @override
  String toString() {
    return 'ServiceArgs(title: $title, image: $image, description: $description, tag: $tag, route: $route)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceArgs &&
        other.title == title &&
        other.image == image &&
        other.description == description &&
        other.tag == tag &&
        other.route == route;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        image.hashCode ^
        description.hashCode ^
        tag.hashCode ^
        route.hashCode;
  }
}
