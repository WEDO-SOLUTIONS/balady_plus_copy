import 'package:balady_plus/app/features/athkar/domain/entities/athkar_entity.dart';

class AthkarEntityContentParams {
  final String title;
  final AthkarEntity athkarEntity;
  final int pageNumber;
  final List<AthkarEntity> athkarEntitiesList;

  AthkarEntityContentParams(
    this.title,
    this.athkarEntity,
    this.pageNumber,
    this.athkarEntitiesList,
  );
}
