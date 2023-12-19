import 'package:dgis_map/library.dart';
import 'package:mapness/entities/iwish/models/iwish_entity_variant.dart';

class IwishEntity {
  final String id;
  final String title;
  final String subtitle;
  final IwishMetadata metadata;

  final IwishCategory category;
  final IwishState state;

  final bool feedbackSent;
  final GeoPointMessage location;
  final int selectedVariantId;

  final List<String> photos;
  final List<IwishEntityVariant> variants;

  IwishEntity({
    required this.metadata,
    required this.variants,
    required this.photos,
    required this.category,
    required this.feedbackSent,
    required this.id,
    required this.location,
    required this.selectedVariantId,
    required this.state,
    required this.subtitle,
    required this.title,
  });
}

enum IwishState {
  unknown,
  planned,
  completed,
}

enum IwishCategory {
  unknown,
  joyParks,
}

class IwishMetadata {
  final String areaName;
  final String typeName;
  final int areaSize;
  final DateTime openingDate;

  const IwishMetadata({
    required this.areaName,
    required this.typeName,
    required this.areaSize,
    required this.openingDate,
  });
}

enum AreaSize {
  small,
  medium,
  large,
}
