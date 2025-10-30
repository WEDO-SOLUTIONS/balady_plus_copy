import 'package:balady_plus/app/features/athkar/data/models/athkar_entites_params.dart';
import 'package:balady_plus/app/features/athkar/data/models/athkar_entity_content_params.dart';
import 'package:balady_plus/app/features/athkar/domain/entities/athkar_entity.dart';

class AthkarContentAndEntitiesParams {
  final AthkarEntityContentParams athkarContentParams;
  final AthkarEntitiesParams athkarEntitiesParams;

  AthkarContentAndEntitiesParams(
    String name,
    AthkarEntity athkarEntity,
    int currentPage, {
    required this.athkarContentParams,
    required this.athkarEntitiesParams,
  });
}
