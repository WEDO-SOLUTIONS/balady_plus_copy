import '../../municipal_advisor_exports.dart' show BoardsParamsModel;

class BoardsParams extends BoardsParamsModel {
  const BoardsParams({
    required super.typeId,
    required super.area,
  });

  BoardsParams copyWith({
    int? typeId,
    num? area,
  }) {
    return BoardsParams(
      typeId: typeId ?? super.typeId,
      area: area ?? super.area,
    );
  }

}
