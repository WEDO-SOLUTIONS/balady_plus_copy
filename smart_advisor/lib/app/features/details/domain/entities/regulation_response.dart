class RegulationResponse {
  List<String> generalRules;
  List<String> specialRules;
  List<String> locationRules;

  RegulationResponse({
    required this.generalRules,
    required this.specialRules,
    required this.locationRules,
  });

  RegulationResponse copyWith({
    List<String>? generalRules,
    List<String>? specialRules,
    List<String>? locationRules,
  }) =>
      RegulationResponse(
        generalRules: generalRules ?? this.generalRules,
        specialRules: specialRules ?? this.specialRules,
        locationRules: locationRules ?? this.locationRules,
      );
}
