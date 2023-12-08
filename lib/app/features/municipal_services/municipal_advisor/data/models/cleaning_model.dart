import '../../municipal_advisor_exports.dart';

class CleaningModel extends CleaningEntity {
  const CleaningModel({
    required super.id,
    required super.name,
  });

  factory CleaningModel.fromMap(Map<String, dynamic> map) {
    return CleaningModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
