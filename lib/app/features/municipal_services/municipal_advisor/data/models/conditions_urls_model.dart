import '../../municipal_advisor_exports.dart';

class ConditionsUrlsModel extends ConditionsUrlsEntity {
  const ConditionsUrlsModel({
    required super.boardsUrl,
    required super.baladyConditionsUrl,
  });

  factory ConditionsUrlsModel.fromMap(Map<String, dynamic> map) {
    return ConditionsUrlsModel(
      boardsUrl: map['boardsUrl'] as String,
      baladyConditionsUrl: map['baladyConditionsUrl'] as String,
    );
  }
}
