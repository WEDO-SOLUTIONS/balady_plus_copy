part of 'ekram_request_transportation_bloc.dart';

class EkramRequestTransportationState extends Equatable {
  final String? errorMsg;
  final bool? isVerified;
  final bool? isSpecialTransferNeeded;
  final bool? isBurialInsideDeathCity;
  final List<LookUpItem>? nationalIdTypes;
  final bool isdeceasedInfoReadOnly;
  final bool isBurialDatesDisabled;
  final bool isDeathDatesDisabled;
  final String? deceassedDOBHijri;
  final String? burialDateHijri;
  final LookUpItem? selectedNationalIdType;
  final LookUpItem? selectedCemetryType;
  final LookUpItem? selectedlaundry;
  final LookUpItem? selectedMosque;
  final List<LookUpItem>? countries;
  final List<LookUpItem>? cemetries;
  final List<LookUpItem>? prayers;
  final List<LookUpItem>? specialTransportReasons;
  final BlocStatus status;
  final String? errorMessage;
  final bool? valid;
  final int currentPageValue;
  final double? lat;
  final double? long;
  final List<LookUpItem>? deathCities;
  final List<LookUpItem>? burialCities;
  final List<LookUpItem>? bodyArrivalCities;
  final List<LookUpItem>? hospitals;
  final List<LookUpItem>? nationalities;
  final List<LookUpItem>? cemetryTypeItems;
  final List<LookUpItem>? laundries;
  final List<LookUpItem>? mosques;
  final List<LookUpItem>? transportations;
  final bool? agreementChecked;
  final String? fullName;
  final String? mobileNumber;
  final String? requestType;
  final String? relation;
  final String? deathLocation;
  final LookUpItem? selectedDeathCity;
  final LookUpItem? selectedtransportation;
  final LookUpItem? selectedCemetry;
  final LookUpItem? selectedPrayer;
  final LookUpItem? selectedSpecialTransportReason;
  final LookUpItem? selectedBurialCity;
  final LookUpItem? selectedBodyArrivalCity;
  final LookUpItem? selectedDeathCountry;
  final LookUpItem? selectedHospital;
  final String? otherHospitalName;
  final LookUpItem? selectedNationality;
  // final List<DeceasedInfoDto>? deceasedInfoDto;
  final FileDataItem? letter;
  final String? deceassedDOBGorgian;
  final String? burialDateGregorian;
  final String? madinahEmirateApprovalStatus;
  final String? madinahEmirateApprovalDate;
  final String? deathDateGregorian;
  final String? deathDateHijri;
  final int? requestId;
  final String? deceasedId;
  final RequestDetailsResponseModel? requestDetailsModel;
  final bool? editInfoSection;
  final bool? isDeceasedBtnEnabled;
  final bool? isDraft;
  final bool? maghsalaExist;
  final String? cemeteryReservationMsg;

  const EkramRequestTransportationState(
      {this.deceassedDOBGorgian,
      this.burialDateGregorian,
      this.madinahEmirateApprovalStatus,
      this.madinahEmirateApprovalDate,
      this.deathDateGregorian,
      this.deathDateHijri,
      this.isVerified,
      this.isSpecialTransferNeeded,
      this.isBurialInsideDeathCity,
      this.requestId,
      this.deceasedId,
      this.deceassedDOBHijri,
      this.burialDateHijri,
      this.isdeceasedInfoReadOnly = false,
      this.isBurialDatesDisabled = false,
      this.isDeathDatesDisabled = false,
      this.isDraft = false,
      this.errorMsg,
      this.nationalIdTypes,
      this.selectedNationalIdType,
      this.selectedCemetryType,
      this.selectedlaundry,
      this.selectedMosque,
      this.status = BlocStatus.initial,
      this.errorMessage,
      this.valid,
      this.currentPageValue = 0,
      this.lat,
      this.long,
      this.deathCities,
      this.burialCities,
      this.bodyArrivalCities,
      this.hospitals,
      this.countries,
      this.cemetries,
      this.prayers,
      this.specialTransportReasons,
      this.nationalities,
      this.cemetryTypeItems,
      this.laundries,
      this.mosques,
      this.transportations,
      this.agreementChecked,
      this.fullName,
      this.mobileNumber,
      this.requestType,
      this.relation,
      this.deathLocation,
      this.selectedDeathCity,
      this.selectedtransportation,
      this.selectedCemetry,
      this.selectedPrayer,
      this.selectedSpecialTransportReason,
      this.selectedBurialCity,
      this.selectedBodyArrivalCity,
      this.selectedDeathCountry,
      this.selectedHospital,
      this.otherHospitalName,
      this.selectedNationality,
      this.requestDetailsModel,
      this.letter,
      this.editInfoSection,
      this.isDeceasedBtnEnabled,
      this.maghsalaExist,
      this.cemeteryReservationMsg});

  EkramRequestTransportationState copyWith(
      {final Nullable<String?>? deceassedDOBHijri,
      final Nullable<String?>? burialDateHijri,
      final bool? isdeceasedInfoReadOnly,
      final bool? isBurialDatesDisabled,
      final bool? isDeathDatesDisabled,
      final bool? isVerified,
      final bool? isDraft,
      final double? lat,
      final double? long,
      final bool? isSpecialTransferNeeded,
      final bool? isBurialInsideDeathCity,
      final BlocStatus? status,
      final String? errorMsg,
      final LookUpItem? selectedNationalIdType,
      final LookUpItem? selectedCemetryType,
      final LookUpItem? selectedlaundry,
      final LookUpItem? selectedMosque,
      final List<LookUpItem>? nationalIdTypes,
      final String? errorMessage,
      final bool? valid,
      final int? currentPageValue,
      final bool? agreementChecked,
      final String? relation,
      final String? deathLocation,
      final List<LookUpItem>? deathCities,
      final List<LookUpItem>? burialCities,
      final List<LookUpItem>? bodyArrivalCities,
      final List<LookUpItem>? hospitals,
      final List<LookUpItem>? countries,
      final List<LookUpItem>? cemetries,
      final List<LookUpItem>? prayers,
      final List<LookUpItem>? specialTransportReasons,
      final List<LookUpItem>? nationalities,
      final List<LookUpItem>? cemetryTypeItems,
      final List<LookUpItem>? laundries,
      final List<LookUpItem>? mosques,
      final List<LookUpItem>? transportations,
      final LookUpItem? selectedDeathCity,
      final LookUpItem? selectedtransportation,
      final LookUpItem? selectedCemetry,
      final LookUpItem? selectedPrayer,
      final LookUpItem? selectedSpecialTransportReason,
      final LookUpItem? selectedBurialCity,
      final LookUpItem? selectedBodyArrivalCity,
      final LookUpItem? selectedDeathCountry,
      final LookUpItem? selectedHospital,
      final String? otherHospitalName,
      final LookUpItem? selectedNationality,
      // final List<DeceasedInfoDto>? deceasedInfoDto,
      final bool? clearHospital,
      final FileDataItem? letter,
      final Nullable<String?>? deceassedDOBGorgian,
      final Nullable<String?>? burialDateGregorian,
      final String? madinahEmirateApprovalStatus,
      final String? madinahEmirateApprovalDate,
      final Nullable<String?>? deathDateGregorian,
      final Nullable<String?>? deathDateHijri,
      final int? requestId,
      final String? deceasedId,
      final RequestDetailsResponseModel? requestDetailsModel,
      final bool? editInfoSection,
      final bool? isDeceasedBtnEnabled,
      final bool? maghsalaExist,
      final String? cemeteryReservationMsg}) {
    return EkramRequestTransportationState(
        isdeceasedInfoReadOnly:
            isdeceasedInfoReadOnly ?? this.isdeceasedInfoReadOnly,
        isBurialDatesDisabled:
            isBurialDatesDisabled ?? this.isBurialDatesDisabled,
        isDeathDatesDisabled: isDeathDatesDisabled ?? this.isDeathDatesDisabled,
        isVerified: isVerified ?? this.isVerified,
        isSpecialTransferNeeded:
            isSpecialTransferNeeded ?? this.isSpecialTransferNeeded,
        isBurialInsideDeathCity:
            isBurialInsideDeathCity ?? this.isBurialInsideDeathCity,
        errorMsg: errorMsg ?? this.errorMsg,
        selectedNationalIdType:
            selectedNationalIdType ?? this.selectedNationalIdType,
        selectedCemetryType: selectedCemetryType ?? this.selectedCemetryType,
        selectedlaundry: selectedlaundry ?? this.selectedlaundry,
        selectedMosque: selectedMosque ?? this.selectedMosque,
        nationalIdTypes: nationalIdTypes ?? this.nationalIdTypes,
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        valid: valid ?? this.valid,
        currentPageValue: currentPageValue ?? this.currentPageValue,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        agreementChecked: agreementChecked ?? this.agreementChecked,
        relation: relation ?? this.relation,
        deathLocation: deathLocation ?? this.deathLocation,
        deathCities: deathCities ?? this.deathCities,
        burialCities: burialCities ?? this.burialCities,
        bodyArrivalCities: bodyArrivalCities ?? this.bodyArrivalCities,
        hospitals: hospitals ?? this.hospitals,
        countries: countries ?? this.countries,
        cemetries: cemetries ?? this.cemetries,
        prayers: prayers ?? this.prayers,
        specialTransportReasons:
            specialTransportReasons ?? this.specialTransportReasons,
        nationalities: nationalities ?? this.nationalities,
        cemetryTypeItems: cemetryTypeItems ?? this.cemetryTypeItems,
        laundries: laundries ?? this.laundries,
        mosques: mosques ?? this.mosques,
        transportations: transportations ?? this.transportations,
        selectedDeathCity: selectedDeathCity ?? this.selectedDeathCity,
        selectedtransportation:
            selectedtransportation ?? this.selectedtransportation,
        selectedCemetry: selectedCemetry ?? this.selectedCemetry,
        selectedPrayer: selectedPrayer ?? this.selectedPrayer,
        selectedSpecialTransportReason: selectedSpecialTransportReason ??
            this.selectedSpecialTransportReason,
        selectedBurialCity: selectedBurialCity ?? this.selectedBurialCity,
        selectedBodyArrivalCity:
            selectedBodyArrivalCity ?? this.selectedBodyArrivalCity,
        selectedDeathCountry: selectedDeathCountry ?? this.selectedDeathCountry,
        selectedHospital: clearHospital == true
            ? null
            : selectedHospital ?? this.selectedHospital,
        selectedNationality: selectedNationality ?? this.selectedNationality,
        // deceasedInfoDto: deceasedInfoDto ?? this.deceasedInfoDto,
        letter: letter ?? this.letter,
        otherHospitalName: otherHospitalName ?? this.otherHospitalName,
        fullName: fullName ?? fullName,
        mobileNumber: mobileNumber ?? mobileNumber,
        requestType: requestType,
        requestId: requestId ?? this.requestId,
        deceasedId: deceasedId ?? this.deceasedId,
        deceassedDOBGorgian: deceassedDOBGorgian == null
            ? this.deceassedDOBGorgian
            : deceassedDOBGorgian.value,
        burialDateGregorian: burialDateGregorian == null
            ? this.burialDateGregorian
            : burialDateGregorian.value,
        madinahEmirateApprovalStatus:
            madinahEmirateApprovalStatus ?? this.madinahEmirateApprovalStatus,
        madinahEmirateApprovalDate:
            madinahEmirateApprovalDate ?? this.madinahEmirateApprovalDate,
        deathDateGregorian: deathDateGregorian == null
            ? this.deathDateGregorian
            : deathDateGregorian.value,
        deathDateHijri:
            deathDateHijri == null ? this.deathDateHijri : deathDateHijri.value,
        deceassedDOBHijri: deceassedDOBHijri == null
            ? this.deceassedDOBHijri
            : deceassedDOBHijri.value,
        burialDateHijri: burialDateHijri == null
            ? this.burialDateHijri
            : burialDateHijri.value,
        requestDetailsModel: requestDetailsModel ?? this.requestDetailsModel,
        editInfoSection: editInfoSection ?? this.editInfoSection,
        isDeceasedBtnEnabled: isDeceasedBtnEnabled ?? this.isDeceasedBtnEnabled,
        isDraft: isDraft ?? this.isDraft,
        maghsalaExist: maghsalaExist ?? this.maghsalaExist,
        cemeteryReservationMsg:
            cemeteryReservationMsg ?? this.cemeteryReservationMsg);
  }

  @override
  List<Object?> get props => [

        hospitals,
        isDeceasedBtnEnabled,
        deathCities,
        burialCities,
        countries,
        cemetries,
        prayers,
        specialTransportReasons,
        status,
        isVerified,
        isSpecialTransferNeeded,
        isBurialInsideDeathCity,
        requestDetailsModel,
        selectedNationalIdType,
        selectedCemetryType,
        selectedlaundry,
        selectedMosque,
        currentPageValue,
        lat,
        long,
        relation,
        deathLocation,
        selectedDeathCity,
        selectedtransportation,
        selectedCemetry,
        selectedPrayer,
        selectedSpecialTransportReason,
        selectedBurialCity,
        selectedBodyArrivalCity,
        selectedDeathCountry,
        selectedHospital,
        selectedNationality,
        // deceasedInfoDto,
        letter,
        agreementChecked,
        deceasedId,
        otherHospitalName,
        deceassedDOBGorgian,
        burialDateGregorian,
        madinahEmirateApprovalStatus,
        madinahEmirateApprovalDate,
        deathDateGregorian,
        deathDateHijri,
        deceassedDOBHijri,
        burialDateHijri,
        isDeathDatesDisabled,
        isBurialDatesDisabled,
        cemetryTypeItems,
        laundries,
        mosques,
        transportations,
        bodyArrivalCities,
        nationalities,
        nationalIdTypes,
        isDraft,
        editInfoSection

      ];

  LookUpItem? getDeathCityById(int? id) {
    if (deathCities != null && id != null) {
      for (int index = 0; index < deathCities!.length; index++) {
        if (deathCities![index].id == id) {
          return deathCities![index];
        }
      }
    }

    return null;
  }

  LookUpItem? getBurialCityById(int? id) {
    if (burialCities != null && id != null) {
      for (int index = 0; index < burialCities!.length; index++) {
        if (burialCities![index].id == id) {
          return burialCities![index];
        }
      }
    }

    return null;
  }

  LookUpItem? getHosptialById(int? id, String? name) {
    if (id != null) {
      if (hospitals != null) {
        for (int index = 0; index < hospitals!.length; index++) {
          if (hospitals![index].id == id) {
            return hospitals![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  bool isHosptialDisabled(int? id) {
    if (id != null &&
        requestDetailsModel?.deceasedInfo?.deceasedDataSource == "SEHA") {
      return true;
    }

    return false;
  }

  LookUpItem? getCountryById(int? id) {
    id ??= 1;
    if (countries != null) {
      for (int index = 0; index < countries!.length; index++) {
        if (countries![index].id == id) {
          return countries![index];
        }
      }
    }

    return null;
  }

  LookUpItem? getNationalityById(int? id, String? name) {
    if (id != null) {
      if (nationalities != null) {
        for (int index = 0; index < nationalities!.length; index++) {
          if (nationalities![index].id == id) {
            return nationalities![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  LookUpItem? getParyerById(int? id, String? name) {
    if (id != null) {
      if (prayers != null) {
        for (int index = 0; index < prayers!.length; index++) {
          if (prayers![index].id == id) {
            return prayers![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  LookUpItem? getCemtryById(int? id, String? name) {
    if (id != null) {
      if (cemetries != null) {
        for (int index = 0; index < cemetries!.length; index++) {
          if (cemetries![index].id == id) {
            return cemetries![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  LookUpItem? getCemtryTypeById(int? id, String? name) {
    if (id != null) {
      if (cemetryTypeItems != null) {
        for (int index = 0; index < cemetryTypeItems!.length; index++) {
          if (cemetryTypeItems![index].id == id) {
            return cemetryTypeItems![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  LookUpItem? getResoansTypeById(int? id) {
    if (specialTransportReasons != null && id != null) {
      for (int index = 0; index < specialTransportReasons!.length; index++) {
        if (specialTransportReasons![index].id == id) {
          return specialTransportReasons![index];
        }
      }
    }

    return null;
  }

  LookUpItem? getTransportTypeById(int? id, String? name) {
    if (id != null) {
      if (transportations != null) {
        for (int index = 0; index < transportations!.length; index++) {
          if (transportations![index].id == id) {
            return transportations![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  LookUpItem? getlaundriesById(int? id, String? name) {
    if (id != null) {
      if (laundries != null) {
        for (int index = 0; index < laundries!.length; index++) {
          if (laundries![index].id == id) {
            return laundries![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  LookUpItem? getMosquesById(int? id, String? name) {
    if (id != null) {
      if (mosques != null) {
        for (int index = 0; index < mosques!.length; index++) {
          if (mosques![index].id == id) {
            return mosques![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  LookUpItem? getNationalIdTypesById(int? id, String? name) {
    if (id != null) {
      if (nationalIdTypes != null) {
        for (int index = 0; index < nationalIdTypes!.length; index++) {
          if (nationalIdTypes![index].id == id) {
            return nationalIdTypes![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  LookUpItem? getPrayerById(int? id, String? name) {
    if (id != null) {
      if (prayers != null) {
        for (int index = 0; index < prayers!.length; index++) {
          if (prayers![index].id == id) {
            return prayers![index];
          }
        }
      } else if (name != null && name.isNotEmpty) {
        return LookUpItem(id: id, name: name);
      }
    }

    return null;
  }

  int? getselectedDeathCity() {
    if (requestDetailsModel?.deathInfo?.cityId != null) {
      return requestDetailsModel?.deathInfo?.cityId!;
    } else if (requestDetailsModel?.deathInfo?.corpseArrivalCityId != null) {
      return requestDetailsModel?.deathInfo?.corpseArrivalCityId!;
    }

    return null;
  }

  bool validateEmirateApprovalInfoSection() {
    if (valid == true) {
      return true;
    }
    return false;
  }

  bool validateDeceasedInfoSection(bool ShowErrorMessage) {
    if (requestDetailsModel != null) {
      if (requestDetailsModel?.deceasedInfo?.firstName == null ||
          requestDetailsModel!.deceasedInfo!.firstName!.isEmpty) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("lbl_first_name_hint2".tr());
        return false;
      } else if (requestDetailsModel?.deceasedInfo?.fourthName == null ||
          requestDetailsModel!.deceasedInfo!.fourthName!.isEmpty) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("enter_ekram_fourth_name".tr());
        return false;
      } else if (requestDetailsModel?.deceasedInfo?.nationalityId == null) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("enternationilaty".tr());
        return false;
      } else if (requestDetailsModel?.deceasedInfo?.gender == null) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("enter_gender".tr());
        return false;
      }

      return true;
    } else {
      if (ShowErrorMessage == true)
        CommonFunctions.showError("lbl_first_name_hint2".tr());
      return false;
    }
  }

  bool validateDeathAndBurialInfoSection(bool ShowErrorMessage) {
    if (requestDetailsModel != null) {
      if (requestDetailsModel?.deathInfo?.deathDate?.isEmpty ?? true) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("ekram_death_date_validation".tr());
        return false;
      } else if (requestDetailsModel?.deathInfo?.countryId == null) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("ekram_death_country_validation".tr());
        return false;
      } else if (requestDetailsModel?.deathInfo?.cityId == null || requestDetailsModel?.deathInfo?.cityId ==-1) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("ekram_death_city_validation".tr());
        return false;
      } else if (requestDetailsModel?.deathInfo?.hospitalId == null || requestDetailsModel?.deathInfo?.hospitalId == -1) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("ekram_death_hospital_validation".tr());
        return false;
      } else if (requestDetailsModel?.transportInfo?.charityId == null || requestDetailsModel?.transportInfo?.charityId == -1) {
        if (ShowErrorMessage == true)
          CommonFunctions.showError("ekram_transportation_validation".tr());
        return false;
      }
    }
    return true;
  }

  bool isNextButtonEnabled() {
    if (currentPageValue == 0) {
      return isVerified ?? false;
    }
    if (currentPageValue == 1) {
      return validateDeceasedInfoSection(false);
    } else if (currentPageValue == 2) {
      return true;
    } else if (currentPageValue == 3) {
      return validateDeathAndBurialInfoSection(false);
    } else if (currentPageValue == 4) {
      return validateEmirateApprovalInfoSection();
    }

    return true;
  }

  bool isFieldDisabled(String? dataSource,EditFiledActionEnum field,String? data)  {


    switch(field) {
      case EditFiledActionEnum.Country:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }

      case EditFiledActionEnum.DeathCity:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }
      case EditFiledActionEnum.Hospital:
        {
          if (dataSource == "BALADY")
            return false;
          else if (dataSource == "SEHA") {
            if (data != null)
              return true;
            else
              return false;
          }

          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }
      case EditFiledActionEnum.BurialCity:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return false;
          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }

      case EditFiledActionEnum.BurialDate:
        {
          if (dataSource == "BALADY")
          {

            if(isTodayOrTomorrow(data!) == true)
                return true;
            else
              return false;
          }
          else if (dataSource == "SEHA")
            return false;
          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }

      case EditFiledActionEnum.Prayer:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return false;
          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }
      case EditFiledActionEnum.GraveType:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return false;
          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }

    // TODO: Handle this case.

    // TODO: Handle this case.
      case EditFiledActionEnum.Cemetry:
        {
          if (dataSource == "BALADY")
           {
             if(isTodayOrTomorrow(data!) == true)
               return true;
             else
               return false;


           }
          else if (dataSource == "SEHA")
            return false;
          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }
    // TODO: Handle this case.
      case EditFiledActionEnum.Transport:
        return false;
      case EditFiledActionEnum.DeathDate:

        {
          if (dataSource == "BALADY")
            return false;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return false;
          else
            return false;

        }
    // TODO: Handle this case.

    // TODO: Handle this case.
      case EditFiledActionEnum.Name:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return true;
          else
            return false;

        }
      case EditFiledActionEnum.Nationality:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return true;
          else
            return false;
        }
      case EditFiledActionEnum.Gender:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return true;
          else
            return false;
        }
      case EditFiledActionEnum.Religon:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return true;
          else
            return false;
        }
      case EditFiledActionEnum.NationalityType:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return true;
          else
            return false;
        }
      case EditFiledActionEnum.BirthDate:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return true;
          else
            return false;
        }
      case EditFiledActionEnum.NationalityId:
        {
          if (dataSource == "BALADY")
            return true;
          else if (dataSource == "SEHA")
            return true;
          else if (dataSource == "NIC")
            return true;
          else
            return false;
        }
    }



  }



  bool isTodayOrTomorrow(String dateToCheck) {
    DateTime now = DateTime.now();
    DateFormat format = new DateFormat("yyyy/MM/dd");
    DateTime date = format.parse(dateToCheck);

    int days= DateTime(date.year, date.month, date.day).difference(DateTime(now.year, now.month, now.day)).inDays;

    if(days==0 || days==1) {
      return true;
    } else {
      return false;
    }

  }

}
