import '../../municipal_advisor_exports.dart';

class AttachmentModel extends AttachmentEntity {
  const AttachmentModel({
    required super.id,
    required super.name,
    required super.mandatory,
  });

  factory AttachmentModel.fromMap(Map<String, dynamic> map) {
    return AttachmentModel(
      id: map['id'] as int,
      name: map['name'] as String,
      mandatory: map['mandatory'] as bool,
    );
  }
}
