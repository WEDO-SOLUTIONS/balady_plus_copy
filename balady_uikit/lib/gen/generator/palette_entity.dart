class ColorValue {
  final String collection;
  final String name;

  ColorValue({required this.collection, required this.name});

  factory ColorValue.fromJson(Map<String, dynamic> json) => ColorValue(
        collection: json['collection'] as String,
        name: json['name'] as String,
      );
}

class ColorVariable {
  final String name;
  final String type;
  final bool isAlias;
  final dynamic value;

  ColorVariable({
    required this.name,
    required this.type,
    required this.isAlias,
    required this.value,
  });

  factory ColorVariable.fromJson(Map<String, dynamic> json) {
    return ColorVariable(
      name: json['name'] as String,
      type: json['type'] as String,
      isAlias: json['isAlias'] as bool,
      value: json['value'],
    );
  }
}

class ColorMode {
  final String name;
  final List<ColorVariable> variables;

  ColorMode({required this.name, required this.variables});

  factory ColorMode.fromJson(Map<String, dynamic> json) {
    final List<ColorVariable> variablesList = (json['variables'] as List)
        .map((variable) => ColorVariable.fromJson(variable as Map<String, dynamic>))
        .toList();

    return ColorMode(
      name: json['name'] as String,
      variables: variablesList,
    );
  }
}

class ColorCollection {
  final String name;
  final List<ColorMode> modes;

  ColorCollection({required this.name, required this.modes});

  factory ColorCollection.fromJson(Map<String, dynamic> json) {
    final List<ColorMode> modesList = (json['modes'] as List)
        .map((mode) => ColorMode.fromJson(mode as Map<String, dynamic>))
        .toList();

    return ColorCollection(
      name: json['name'] as String,
      modes: modesList,
    );
  }
}

class ColorPalette {
  final String version;
  final Map<String, dynamic> metadata;
  final List<ColorCollection> collections;

  ColorPalette({
    required this.version,
    required this.metadata,
    required this.collections,
  });

  factory ColorPalette.fromJson(Map<String, dynamic> json) {
    final List<ColorCollection> collectionsList = (json['collections'] as List)
        .map((collection) =>
            ColorCollection.fromJson(collection as Map<String, dynamic>))
        .toList();

    return ColorPalette(
      version: json['version'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      collections: collectionsList,
    );
  }
}
