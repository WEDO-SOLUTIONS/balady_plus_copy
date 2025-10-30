part of 'create_retrive_bloc.dart';

class CreateRetriveCarState extends Equatable {
  final BlocStatus status;
  final VehicleItem? vehicleItem;
  final String? errorMessage;
  final int currentPageValue;
  final List<AttachmentItem> items;
  final String? issueDesc;
  final bool? agreement;
  final String? date;
  final FileDataItem? file;
  final String? type;

  //final String? splSearchedText;
  CreateRetriveCarState(
      {this.status = BlocStatus.initial,
      this.errorMessage,
      this.vehicleItem,
      this.currentPageValue = 0,
      required this.items,
      this.issueDesc,
      this.agreement,
      this.date,
      this.file,
      this.type

      //  this.splSearchedText
      });

  DescValidation get incidentDescValidator => issueDesc == null
      ? DescValidation.pure()
      : DescValidation.dirty(value: issueDesc);
  String? get incidentDescErrorText =>
      incidentDescValidator.error?.message != null
          ? (incidentDescValidator.error?.message ?? "").tr()
          : null;

  /*RequiredFieldValidation get rightLetterValidator => rightLetter == null
      ? RequiredFieldValidation.pure()
      : RequiredFieldValidation.dirty(value: rightLetter);
  String? get rightLetterErrorText =>
      rightLetterValidator.error?.message != null
          ? trans(rightLetterValidator.error?.message ?? "")
          : null;*/

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {
      return true;
    }

    if (currentPageValue == 1) {
      bool isValid = Formz.validate([incidentDescValidator]);

      if (type == "OnBehalfOfDeadPerson" && file == null) return false;

      if (agreement == true &&
          !incidentDescValidator.isPure &&
          isValid &&
          date != null) return true;
    }
    // return true;
    /* if (currentPageValue == 0)
      return gisResponse != null && location != null;
    else if ((currentPageValue == 1)) {
      return selectedCarModel != null && selectedCarType != null;
    } else if ((currentPageValue == 2)) {
      return Formz.validate([
        chassisNumberValidator,
        plateDigitValidator,
        leftLetterValidator,
        rightLetterValidator,
        middleLetterValidator
      ]).isValid;
    } else if ((currentPageValue == 3)) {
      FormzStatus descFormStatus = Formz.validate([incidentDescValidator]);
      if (agreement == true &&
          !incidentDescValidator.pure &&
          descFormStatus.isValid) return true;
    }*/

    return false;
  }

  CreateRetriveCarState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      int? currentPageValue,
      List<AttachmentItem>? items,
      String? issueDesc,
      bool? agreement,
      bool? clearFile,
      final String? date,
      final FileDataItem? file}) {
    return CreateRetriveCarState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        items: items ?? this.items,
        issueDesc: issueDesc ?? this.issueDesc,
        agreement: agreement ?? this.agreement,
        vehicleItem: this.vehicleItem,
        date: date ?? this.date,
        file: clearFile == true ? null : file ?? this.file,
        type: type);
  }

  String? getImagePath() {
    return items.firstOrNull?.filePath;
  }

  String? getImagebase64() {
    return items.firstOrNull?.base64;
  }

  @override
  List<Object?> get props =>
      [status, currentPageValue, items, issueDesc, agreement, date, file, type];
}
