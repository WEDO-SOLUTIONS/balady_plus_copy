import '../../commercial_license_exports.dart' show CleanOptionResponse;

class CleanOptionResponseModel extends CleanOptionResponse {
  CleanOptionResponseModel({
    super.cleanOption,
    super.contractOption,
  });

  factory CleanOptionResponseModel.fromMap(Map<String, dynamic> map) {
    return CleanOptionResponseModel(
      cleanOption:
          map['cleanOption'] != null ? map['cleanOption'] as String : null,
      contractOption: map['contractOption'] != null
          ? map['contractOption'] as String
          : null,
    );
  }
}
