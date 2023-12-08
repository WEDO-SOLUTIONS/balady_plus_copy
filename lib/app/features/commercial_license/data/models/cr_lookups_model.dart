import '../../commercial_license_exports.dart';

class CrLookupsModel extends CrLookupsEntity {
  const CrLookupsModel({
    int? id,
    String? name,
  }) : super(
          lookupId: id ?? 0,
          lookupMame: name ?? '',
        );

  factory CrLookupsModel.fromJson(Map<String, dynamic> json) => CrLookupsModel(
        id: json["id"],
        name: json["name"],
      );
}
