part of 'create_dc_bloc.dart';

class CreateDCState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<AttachmentItem> items;
  final CategoryItem? selectedCategory;
  final GISResponse? gisResponse;
  final GISParams? location;
  final GISParams? currentUserlocation;
  final String? issueDesc;

  final bool? agreement;
  final bool? isFromHome;
  final List<CarModel>? carModels;
  final List<CarType>? carTypes;
  final CarModel? selectedCarModel;
  final CarType? selectedCarType;
  final String? chassisNumber;
  final String? plateDigit;
  final String? leftLetter;
  final String? middleLetter;
  final String? rightLetter;
  final DropDownItem? reportType;
  final DropDownItem? registerType;
  //final String? splSearchedText;
  CreateDCState(
      {this.status = BlocStatus.initial,
      this.carModels,
      this.carTypes,
      this.isFromHome,
      this.errorMessage,
      this.currentPageValue = 0,
      required this.items,
      this.selectedCategory,
      this.gisResponse,
      this.location,
      this.currentUserlocation,
      this.issueDesc,
      this.agreement,
      this.selectedCarModel,
      this.selectedCarType,
      this.chassisNumber,
      this.plateDigit,
      this.leftLetter,
      this.middleLetter,
      this.rightLetter,
      this.reportType,
      this.registerType
      //  this.splSearchedText
      });

  IncidentDescValidation get incidentDescValidator => issueDesc == null
      ? IncidentDescValidation.pure()
      : IncidentDescValidation.dirty(value: issueDesc);
  String? get incidentDescErrorText =>
      incidentDescValidator.error?.message != null
          ? (incidentDescValidator.error?.message ?? "").tr()
          : null;

  RequiredFieldValidation get chassisNumberValidator => chassisNumber == null
      ? const RequiredFieldValidation.pure()
      : RequiredFieldValidation.dirty(value: chassisNumber);
  String? get chassisNumberErrorText =>
      chassisNumberValidator.error?.message != null
          ? (chassisNumberValidator.error?.message ?? "").tr()
          : null;

  RequiredFieldValidation get plateDigitValidator => plateDigit == null
      ? const RequiredFieldValidation.pure()
      : RequiredFieldValidation.dirty(value: plateDigit);
  String? get plateDigitErrorText => plateDigitValidator.error?.message != null
      ? (plateDigitValidator.error?.message ?? "").tr()
      : null;

  RequiredFieldValidation get leftLetterValidator => leftLetter == null
      ? const RequiredFieldValidation.pure()
      : RequiredFieldValidation.dirty(value: leftLetter);
  String? get leftLetterErrorText => leftLetterValidator.error?.message != null
      ? (leftLetterValidator.error?.message ?? "").tr()
      : null;

  RequiredFieldValidation get middleLetterValidator => middleLetter == null
      ? const RequiredFieldValidation.pure()
      : RequiredFieldValidation.dirty(value: leftLetter);
  String? get middleLetterErrorText =>
      middleLetterValidator.error?.message != null
          ? (middleLetterValidator.error?.message ?? "").tr()
          : null;

  RequiredFieldValidation get rightLetterValidator => rightLetter == null
      ? const RequiredFieldValidation.pure()
      : RequiredFieldValidation.dirty(value: rightLetter);
  String? get rightLetterErrorText =>
      rightLetterValidator.error?.message != null
          ? (rightLetterValidator.error?.message ?? "").tr()
          : null;

  bool isNextButtonEnabled() {
    if (currentPageValue == 0)
      return gisResponse != null && location != null;
    else if ((currentPageValue == 1)) {
      return //selectedCarModel != null &&
          //  selectedCarType != null &&
          reportType != null;
    } else if ((currentPageValue == 2)) {
      //return true;
      /*return Formz.validate([
        chassisNumberValidator,
        plateDigitValidator,
        leftLetterValidator,
        rightLetterValidator,
        middleLetterValidator
      ]).isValid;*/

      if ((plateDigit ?? "").isNotEmpty ||
          (leftLetter ?? "").isNotEmpty ||
          (middleLetter ?? "").isNotEmpty ||
          (rightLetter ?? "").isNotEmpty) {
        return Formz.validate([
          plateDigitValidator,
          leftLetterValidator,
          rightLetterValidator,
          middleLetterValidator
        ]);
      } else
        return true;
    } else if ((currentPageValue == 3)) {
      bool descFormStatus = Formz.validate([incidentDescValidator]);
      if (!incidentDescValidator.isPure && descFormStatus) return true;
    } else if ((currentPageValue == 4)) {
      return agreement ?? false;
    }

    return false;
  }

  CreateDCState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      int? currentPageValue,
      List<AttachmentItem>? items,
      CategoryItem? selectedCategory,
      GISResponse? gisResponse,
      GISParams? location,
      GISParams? currentUserlocation,
      String? issueDesc,
      bool? agreement,
      bool? isFromHome,
      bool? clearCarModel,
      List<CarModel>? carModels,
      List<CarType>? carTypes,
      CarModel? selectedCarModel,
      CarType? selectedCarType,
      String? chassisNumber,
      String? plateDigit,
      String? leftLetter,
      String? middleLetter,
      String? rightLetter,
      DropDownItem? reportType,
      DropDownItem? registerType}) {
    return CreateDCState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        items: items ?? this.items,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        gisResponse: gisResponse ?? this.gisResponse,
        location: location ?? this.location,
        currentUserlocation: currentUserlocation ?? this.currentUserlocation,
        issueDesc: issueDesc ?? this.issueDesc,
        agreement: agreement ?? this.agreement,
        isFromHome: isFromHome ?? this.isFromHome,
        carModels: carModels ?? this.carModels,
        carTypes: carTypes ?? this.carTypes,
        selectedCarModel: clearCarModel == true
            ? null
            : selectedCarModel ?? this.selectedCarModel,
        selectedCarType: selectedCarType ?? this.selectedCarType,
        chassisNumber: chassisNumber ?? this.chassisNumber,
        plateDigit: plateDigit ?? this.plateDigit,
        leftLetter: leftLetter ?? this.leftLetter,
        middleLetter: middleLetter ?? this.middleLetter,
        rightLetter: rightLetter ?? this.rightLetter,
        reportType: reportType ?? this.reportType,
        registerType: registerType ?? this.registerType);
  }

  String? getImagePath() {
    return items.firstOrNull?.filePath;
  }

  String? getImagebase64() {
    return items.firstOrNull?.base64;
  }

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        items,
        location,
        issueDesc,
        agreement,
        selectedCarModel,
        selectedCarType,
        chassisNumber,
        plateDigit,
        leftLetter,
        middleLetter,
        rightLetter,
        reportType,
        registerType
      ];

  List<DropDownItem> getCarModelsItems() {
    return (carModels ?? [])
        .mapIndexed(
            (index, e) => e.getDropDownItem() ?? DropDownItem(name: "", id: ""))
        .toList();
  }

  List<DropDownItem> getCarTypesItems() {
    return (carTypes ?? [])
        .mapIndexed(
            (index, e) => e.getDropDownItem() ?? DropDownItem(name: "", id: ""))
        .toList();
  }

  List<DropDownItem> getReprtTypes() {
    return [
      DropDownItem(
        id: "Damaged",
        name: "Damaged".tr(),
      ),
      DropDownItem(id: "BRoken", name: "BRoken".tr()),
      DropDownItem(id: "Abandoned", name: "Abandoned".tr()),
    ];
  }

  List<DropDownItem> getRegstrationTypes() {
    return [
      DropDownItem(
        id: "1",
        name: "خاص",
      ),
      DropDownItem(
        id: "10",
        name: "دراجة آلية",
      ),
      DropDownItem(
        id: "11",
        name: "مؤقت",
      ),
      DropDownItem(
        id: "2",
        name: "نقل عام",
      ),
      DropDownItem(
        id: "3",
        name: "نقل خاص",
      ),
      DropDownItem(
        id: "4",
        name: "حافلة صغيرة عامة",
      ),
      DropDownItem(
        id: "5",
        name: "حافلة صغيرة خاصة",
      ),
      DropDownItem(
        id: "6",
        name: "أجرة",
      ),
      DropDownItem(
        id: "7",
        name: "أشغال عامة",
      ),
      DropDownItem(
        id: "8",
        name: "تصدير",
      ),
      DropDownItem(
        id: "9",
        name: "دبلوماسي",
      ),
    ];
  }

  String get arLetters => CommonFunctions.getCarPlateArabicLetters(
      "${rightLetter ?? ""} ${middleLetter ?? ""} ${leftLetter ?? ""}");
  String get arNumbers =>
      CommonFunctions.replaceEnglishNumberWithArabic(plateDigit ?? "");
  String get enNumbers => plateDigit ?? "";
  String get enLetters => CommonFunctions.getCarPlateEnlgishLetters(arLetters);
}
