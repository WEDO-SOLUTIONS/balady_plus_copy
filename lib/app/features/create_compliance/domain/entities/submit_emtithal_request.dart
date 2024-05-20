class SubmitEmtithalRequest {
  final String? notes;
  final String? visitDate;
  final String? visitTimeFrom;
  final String? visitTimeTo;
  SubmitEmtithalRequest({
    this.notes,
    this.visitDate,
    this.visitTimeFrom,
    this.visitTimeTo,
  });

  SubmitEmtithalRequest copyWith({
    String? notes,
    String? visitDate,
    String? visitTimeFrom,
    String? visitTimeTo,
  }) {
    return SubmitEmtithalRequest(
      notes: notes ?? this.notes,
      visitDate: visitDate ?? this.visitDate,
      visitTimeFrom: visitTimeFrom ?? this.visitTimeFrom,
      visitTimeTo: visitTimeTo ?? this.visitTimeTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'notes': notes,
      if (visitDate!=null)
      'visitDate': visitDate,
         if (visitTimeFrom!=null)
      'visitTimeFrom': visitTimeFrom,
      if (visitTimeTo!=null)
      'visitTimeTo': visitTimeTo,
    };
  }
}
