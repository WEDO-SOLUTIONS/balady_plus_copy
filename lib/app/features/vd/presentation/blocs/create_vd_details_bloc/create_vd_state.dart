part of 'create_vd_bloc.dart';

class CreateVDState extends Equatable {
  final BlocStatus status;
  final String? errorMessage;
  final int currentPageValue;
  final List<AttachmentItem> items;
  final CategoryItem? selectedCategory;
  final SplResponse? splResponse;
  final List<SplItem>? splItems;
  final GISResponse? gisResponse;
  final GISParams? location;
  final GISParams? currentUserlocation;
  final SPLDetailsResponse? splDetailsResponse;
  final OTPResponse? otpResponse;

  final String? issueDesc;
  final int? selectedSPLIndex;
  final String? firstName;
  final String? lastName;
  final String? mobileNumber;
  final bool? agreement;
  // final bool? isFromHome;
  final bool? isSearchShown;
  final bool? isCrValid;
  final String? crNumber;
  final bool qrCodeFlow;
  final PAGE_TYPE? pageType;
  //final String? splSearchedText;
  const CreateVDState({
    this.status = BlocStatus.initial,
    // this.isFromHome,
    this.errorMessage,
    this.currentPageValue = 0,
    required this.items,
    this.selectedCategory,
    this.splResponse,
    this.splItems,
    this.gisResponse,
    this.location,
    this.currentUserlocation,
    this.splDetailsResponse,
    this.otpResponse,
    this.issueDesc,
    this.selectedSPLIndex,
    this.firstName,
    this.lastName,
    this.mobileNumber,
    this.agreement,
    this.isSearchShown = false,
    this.isCrValid,
    this.crNumber,
    this.qrCodeFlow = false,
    this.pageType,

    //  this.splSearchedText
  });

  PhoneNumberValidation get phoneValidator => mobileNumber == null
      ? const PhoneNumberValidation.pure()
      : PhoneNumberValidation.dirty(value: mobileNumber);
  String? get phoneErrorText => phoneValidator.error?.message != null
      ? (phoneValidator.error?.message ?? "").tr()
      : null;

  NameValidation get firstNameValidator => firstName == null
      ? const NameValidation.pure()
      : NameValidation.dirty(value: firstName);
  String? get firstNameErrorText => firstNameValidator.error?.message != null
      ? (firstNameValidator.error?.message ?? "").tr()
      : null;

  NameValidation get lastNameValidator => lastName == null
      ? const NameValidation.pure()
      : NameValidation.dirty(value: lastName);
  String? get lastNameErrorText => lastNameValidator.error?.message != null
      ? (lastNameValidator.error?.message ?? "").tr()
      : null;

  IncidentDescValidation get incidentDescValidator => issueDesc == null
      ? const IncidentDescValidation.pure()
      : IncidentDescValidation.dirty(value: issueDesc);
  String? get incidentDescErrorText =>
      incidentDescValidator.error?.message != null
          ? (incidentDescValidator.error?.message ?? "").tr()
          : null;

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {
      if (selectedCategory?.categoryId == RemoteConfig.QaseemCategoryKey) {
        if (gisResponse?.adminMunicipalityId != '008') {
          CommonFunctions.showError('ErrOnlyQaseem'.tr());
          return false;
        } else {
          return true;
        }
      }
      return gisResponse != null && location != null;
    } else if (currentPageValue == 1)
      return splDetailsResponse != null;
    else if (((CommonProperties.isLoggedInMunicipality &&
                currentPageValue == 2) ||
            (!CommonProperties.isLoggedInMunicipality &&
                currentPageValue == 3)) &&
        validateAddetionalFields()) {
      bool status = Formz.validate([incidentDescValidator]);
      bool isRegaValid = isRegaClass() == true ? (isCrValid ?? false) : true;
      if (!incidentDescValidator.isPure && status && isRegaValid) return true;
    } else if ((!CommonProperties.isLoggedInMunicipality &&
        currentPageValue == 2)) {
      bool guestFormStatus = Formz.validate(
          [firstNameValidator, lastNameValidator, phoneValidator]);
      if (!firstNameValidator.isPure &&
          !lastNameValidator.isPure &&
          !phoneValidator.isPure &&
          guestFormStatus) return true;
    } else if (((CommonProperties.isLoggedInMunicipality &&
            currentPageValue == 3) ||
        (!CommonProperties.isLoggedInMunicipality && currentPageValue == 4))) {
      return agreement ?? false;
    }

    return false;
  }

  /// To Validate Addetional Fields
  bool validateAddetionalFields() {
    bool isValid = true;
    if (splDetailsResponse?.questionList != null &&
        splDetailsResponse!.questionList!.isNotEmpty) {
      List<bool> questionsValidations =
          splDetailsResponse!.questionList!.map<bool>((element) {
        switch (element.fieldType) {
          case GeneralKey.Textbox:
          case GeneralKey.TextArea:
          case GeneralKey.Numbersfield:
          case GeneralKey.HijriCalendar:
          case GeneralKey.GregorianCalendar:
            isValid = (element.isMandatory() &&
                    element.selectedTextValue != null &&
                    element.selectedTextValue!.isNotEmpty) ||
                !element.isMandatory();
            break;
          case GeneralKey.DropdownList:
          case GeneralKey.Radiobutton:
            isValid = (element.isMandatory() &&
                    element.selectedDropDownValue?.addlFeildValue != null &&
                    element
                        .selectedDropDownValue!.addlFeildValue!.isNotEmpty) ||
                !element.isMandatory();
            break;

          case GeneralKey.MultiSelectDropdown:
            isValid = (element.isMandatory() &&
                    element.selectedMultiSelectValue != null &&
                    element.selectedMultiSelectValue!.isNotEmpty) ||
                !element.isMandatory();
            break;
        }
        return isValid;
      }).toList();

      isValid = !(questionsValidations.contains(false));
    }

    return isValid;
  }

  CreateVDState copyWith(
      {final BlocStatus? status,
      final String? errorMessage,
      int? currentPageValue,
      List<AttachmentItem>? items,
      CategoryItem? selectedCategory,
      SplResponse? splResponse,
      List<SplItem>? splItems,
      GISResponse? gisResponse,
      GISParams? location,
      GISParams? currentUserlocation,
      SPLDetailsResponse? splDetailsResponse,
      OTPResponse? otpResponse,
      int? selectedSPLIndex,
      String? issueDesc,
      bool? clearSPLDetailsResponse,
      bool? clearSPLResponse,
      String? firstName,
      String? lastName,
      String? mobileNumber,
      bool? agreement,
      // bool? isFromHome,
      bool? isSearchShown,
      String? splSearchedText,
      bool? isCrValid,
      String? crNumber,
      bool? qrCodeFlow,
      PAGE_TYPE? pageType}) {
    return CreateVDState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        items: items ?? this.items,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        splResponse:
            clearSPLResponse == true ? null : splResponse ?? this.splResponse,
        gisResponse: gisResponse ?? this.gisResponse,
        location: location ?? this.location,
        currentUserlocation: currentUserlocation ?? this.currentUserlocation,
        splDetailsResponse:
            (clearSPLDetailsResponse == true || clearSPLResponse == true)
                ? null
                : splDetailsResponse ?? this.splDetailsResponse,
        otpResponse: otpResponse ?? this.otpResponse,
        issueDesc: issueDesc ?? this.issueDesc,
        selectedSPLIndex: selectedSPLIndex ?? this.selectedSPLIndex,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        agreement: agreement ?? this.agreement,
        // isFromHome: isFromHome ?? this.isFromHome,
        isSearchShown: isSearchShown ?? this.isSearchShown,
        splItems: clearSPLResponse == true ? null : splItems ?? this.splItems,
        isCrValid: isCrValid ?? this.isCrValid,
        crNumber: crNumber ?? this.crNumber,
        qrCodeFlow: qrCodeFlow ?? this.qrCodeFlow,
        pageType: pageType ?? this.pageType);
  }

  String? getImagePath() {
    return items.firstOrNull?.filePath;
  }

  String? getImagebase64() {
    return items.firstOrNull?.base64;
  }

  bool isRegaClass() {
    return selectedCategory?.categoryId == RemoteConfig.regaClass
        ? true
        : false;
  }

  @override
  List<Object?> get props => [
        status,
        currentPageValue,
        items,
        location,
        selectedSPLIndex,
        issueDesc,
        firstName,
        lastName,
        mobileNumber,
        agreement,
        splDetailsResponse,
        isSearchShown,
        splItems,
        splResponse,
        crNumber,
        isCrValid,
        otpResponse,
        qrCodeFlow,
        pageType
      ];
}
