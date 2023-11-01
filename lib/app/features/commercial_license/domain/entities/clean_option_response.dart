class CleanOptionResponse {
  String? cleanOption;
  String? contractOption;
  CleanOptionResponse({
    this.cleanOption,
    this.contractOption,
  });

  CleanOptionResponse copyWith({
    String? cleanOption,
    String? contractOption,
  }) {
    return CleanOptionResponse(
      cleanOption: cleanOption ?? this.cleanOption,
      contractOption: contractOption ?? this.contractOption,
    );
  }
}
