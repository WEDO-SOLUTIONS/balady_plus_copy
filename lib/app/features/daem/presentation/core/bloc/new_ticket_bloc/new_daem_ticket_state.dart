part of 'new_daem_ticket_bloc.dart';

class NewDaemTicketState extends Equatable {
  BlocStatus status;
  DaemItem? category;
  DaemItem? subCategory;
  DaemItem? area;
  DaemItem? issueType;
  DaemItem? municipality;
  DaemItem? subMunicipality;
  String? description;
  List<AttachmentData> uploadedFiles = [];
  bool? isFormValid;
  String? daemId;
  bool? errorInUploading;
  String? error;
  final int currentPageValue;

  NewDaemTicketState({
    this.status = BlocStatus.initial,
    this.area,
    this.category,
    this.issueType,
    this.subCategory,
    this.municipality,
    this.subMunicipality,
    this.description,
    this.isFormValid,
    required this.uploadedFiles,
    this.daemId,
    this.errorInUploading,
    this.error,
    this.currentPageValue = 0,
  });

  bool isNextButtonEnabled() {
    return isFormValid ?? false;
  }

  NewDaemTicketState copyWith({
    BlocStatus? status,
    DaemItem? category,
    DaemItem? subCategory,
    DaemItem? area,
    DaemItem? issueType,
    DaemItem? municipality,
    DaemItem? subMunicipality,
    String? description,
    bool? isFormValid,
    List<AttachmentData>? uploadedFiles,
    bool? errorInUploading,
    String? daemId,
    String? error,
    bool clearSubCategory = false,
    bool clearArea = false,
    bool clearIssueType = false,
    bool clearSubMunicipality = false,
    int? currentPageValue,
  }) {
    return NewDaemTicketState(
      status: status ?? this.status,
      area: clearArea ? null : area ?? this.area,
      category: category ?? this.category,
      issueType: clearIssueType ? null : issueType ?? this.issueType,
      subCategory: clearSubCategory ? null : subCategory ?? this.subCategory,
      municipality: municipality ?? this.municipality,
      subMunicipality:
          clearSubMunicipality ? null : subMunicipality ?? this.subMunicipality,
      description: description ?? this.description,
      isFormValid: isFormValid ?? this.isFormValid,
      uploadedFiles: uploadedFiles ?? this.uploadedFiles,
      daemId: daemId ?? this.daemId,
      error: error ?? this.error,
      errorInUploading: errorInUploading ?? this.errorInUploading,
      currentPageValue: currentPageValue ?? this.currentPageValue,
    );
  }

  @override
  List<Object?> get props => [
        status,
        isFormValid,
        area,
        category,
        issueType,
        subCategory,
        municipality,
        subMunicipality,
        description,
        currentPageValue
      ];
}
