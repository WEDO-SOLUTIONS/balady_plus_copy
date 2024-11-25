import '../../commercial_license_exports.dart' show CleanOptionResponse;

class CleanOptionResponseEntity{
  String? cleanOption;
  String? contractOption;
  CleanOptionResponseEntity({
    this.cleanOption,
    this.contractOption,
  });

  factory CleanOptionResponseEntity.fromMap(Map<String, dynamic> map) {
    return CleanOptionResponseEntity(
      cleanOption:
          map['cleanOption'] != null ? map['cleanOption'] as String : null,
      contractOption: map['contractOption'] != null
          ? map['contractOption'] as String
          : null,
    );
  }

  CleanOptionResponseEntity copyWith({
    String? cleanOption,
    String? contractOption,
  }) {
    return CleanOptionResponseEntity(
      cleanOption: cleanOption ?? this.cleanOption,
      contractOption: contractOption ?? this.contractOption,
    );
  }
}
