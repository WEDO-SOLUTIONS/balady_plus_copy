part of 'cr_step4_shop_data_cubit.dart';

class CrStep4ShopDataState extends Equatable {
  final BlocStatus status;

  final BlocStatus accommodationTypesStatus;
  final BlocStatus boardContractsStatus;

  final BlocStatus contractsListStatus;
  final BlocStatus investmentListStatus;
  final BlocStatus deedOptionsStatus;
  final BlocStatus cleanOptionsStatus;
  final BlocStatus samalaReportFawryStatus;
  final BlocStatus samalaBillFawryStatus;
  final SaveLocationResponse? locationResponse;

  final bool? isFawryReport;
  final bool? isFawryBill;

  final List<String>? deedOptions;
  final CleanOptionResponse? cleanOptionResponse;

  final List<CrLookupsEntity>? accommodationTypes;
  final DropDownItem? selectedAccommodationType;
  final String? errorMessage;
  final List<CommercialBoardType>? selectedBoards;
  final List<DropDownItem>? boards;

  final bool? brand; //هل يوجد لديك علامة تجارية
  final String? shopName; //اسم المحل
  final String? shopUnitNumber; //رقم المحل
  final String? blockNumber; //رقم العقار
  final String? holesCount; //عدد الفتحات
  final String? floorCount; //عدد الأدوار في المحل
  final String? noOfCameras; //عدد الكاميرات في المحل
  final bool? hasElevator;
  final bool? existInMall;
  final String? floorNumber; //طابق المول
  final bool?
      isCitizenPledgedToClean; //هل أنت متعاقد مع إحدى شركات النظافة المؤهلة من الامانة وذلك لجمع ونقل النفايات ؟
  final String? cleanContractEndDate; //تاريخ انتهاء عقد النظافة

  final bool? salamaPermitExist; //هل لديك تصريح سلامة؟
  final String? salamaPermitNumber; //رقم تصريح سلامة
  final String? slamaReportNumber; //رقم التقرير الفني
  final String? slamaBillNumber; //رقم الفاتورة الفني

  final String? contractDate; //تاريخ عقد التملك او تاريخ انتهاء عقد الايجار
  final String? contractNumber; //رقم عقد التملك (الصك) او رقم عقد الايجار
  final String?
      contractOption; //ATTACH ( ارفاق عقد الايجار ارفاق عقد الاستثمار ارفاق عقد التملك) or SERVICE(استخدام رقم عقد الصك الالكلتروني، استخدام رقم عقد الاستثمار الالتروني)
  final String? contractType; //INVEST or DEED or EJAR
/**
 * Types for ownershipType: 
 *  IDENTITY :  الصك صادر بهوية مالك السجل التجاري 
* CR  : الصك صادر برقم السجل التجاري
 CR_700: الصك صادر برقم 700 في السجل التجاري
 */

  final String?
      ownershipType; //When using SERVICE(استخدام رقم عقد الصك الالكلتروني) in contractOption

  final CRSubmitterType? crSubmitterType;
  final CRContractType? crContractType;
  final CRContractOption? crContractOption;

  final CleanContractsResponse? cleanContractsResponse;
  final CleanContractItem? selectedCleanContract;

  final InvestmentContractResponse? investmentContractResponse;
  final InvestmentContractItem? selectedInvestmentContract;

  final bool? endorsmentAgreement;

  final bool? ejarVerified;
  final bool? deedVerified;

  final EjarInfoRequest? ejarInfoRequst;
  final DeedInfoRequest? deedInfoRequst;

  final String? deedOption;

  final List<QrLookUpItem>? mallsList;

  final QrLookUpItem? selectedMall;
  final BlocStatus mallsStatus;

  final bool? isSalamaPermitVerified;
  final bool? isSalamaBillVerified;

  final bool? isSalamaReportVerified;
  final bool? cameraAgreement;

  final String? boardContractSetting;
  final BoardContractItem? boardContractNumber;
  final List<BoardContractItem>? boardContractItems;
  final bool? draftLoaded;
  final BlocStatus draftStatus;
  final String? currentDistrctId;
  final bool? insidePetrolStation;
  final List<dynamic>? lstEndorsements;

  const CrStep4ShopDataState(
      {this.accommodationTypesStatus = BlocStatus.initial,
      this.contractsListStatus = BlocStatus.initial,
      this.investmentListStatus = BlocStatus.initial,
      this.boardContractsStatus = BlocStatus.initial,
      this.status = BlocStatus.initial,
      this.deedOptionsStatus = BlocStatus.initial,
      this.cleanOptionsStatus = BlocStatus.initial,
      this.samalaReportFawryStatus = BlocStatus.initial,
      this.samalaBillFawryStatus = BlocStatus.initial,
      this.mallsStatus = BlocStatus.initial,
      this.mallsList,
      this.locationResponse,
      this.accommodationTypes,
      this.selectedAccommodationType,
      this.errorMessage,
      this.selectedBoards,
      this.boards,
      this.brand,
      this.shopName,
      this.shopUnitNumber,
      this.blockNumber,
      this.holesCount,
      this.floorCount,
      this.noOfCameras,
      this.hasElevator,
      this.existInMall,
      this.selectedMall,
      this.floorNumber,
      this.isCitizenPledgedToClean,
      this.cleanContractEndDate,
      this.salamaPermitExist,
      this.salamaPermitNumber,
      this.slamaReportNumber,
      this.slamaBillNumber,
      this.contractDate,
      this.contractNumber,
      this.contractOption,
      this.contractType,
      this.ownershipType,
      this.crSubmitterType,
      this.crContractType,
      this.crContractOption,
      this.cleanContractsResponse,
      this.selectedCleanContract,
      this.investmentContractResponse,
      this.selectedInvestmentContract,
      this.endorsmentAgreement,
      this.deedOptions,
      this.cleanOptionResponse,
      this.ejarVerified,
      this.deedVerified,
      this.isFawryReport,
      this.isFawryBill,
      this.ejarInfoRequst,
      this.deedInfoRequst,
      this.deedOption,
      this.isSalamaPermitVerified,
      this.isSalamaBillVerified,
      this.isSalamaReportVerified,
      this.cameraAgreement,
      this.boardContractSetting,
      this.boardContractNumber,
      this.boardContractItems,
      this.draftLoaded,
      this.currentDistrctId,
        this.lstEndorsements,
      this.insidePetrolStation = false,
      this.draftStatus = BlocStatus.initial});

  @override
  List<Object?> get props {
    return [
      status,
      deedOption,
      boardContractNumber,
      accommodationTypesStatus,
      accommodationTypes,
      selectedAccommodationType,
      errorMessage,
      selectedBoards,
      boards,
      brand,
      lstEndorsements,
      shopName,
      shopUnitNumber,
      blockNumber,
      holesCount,
      floorCount,
      noOfCameras,
      hasElevator,
      existInMall,
      selectedMall,
      floorNumber,
      isCitizenPledgedToClean,
      cleanContractEndDate,
      salamaPermitExist,
      salamaPermitNumber,
      slamaReportNumber,
      slamaBillNumber,
      contractDate,
      contractNumber,
      contractOption,
      contractType,
      ownershipType,
      crSubmitterType,
      crContractType,
      crContractOption,
      crSubmitterType,
      crContractType,
      crContractOption,
      contractsListStatus,
      cleanContractsResponse,
      selectedCleanContract,
      investmentListStatus,
      investmentContractResponse,
      selectedInvestmentContract,
      endorsmentAgreement,
      deedOptionsStatus,
      cleanOptionsStatus,
      deedOptions,
      cleanOptionResponse,
      ejarVerified,
      deedVerified,
      isFawryReport,
      isFawryBill,
      ejarInfoRequst,
      deedInfoRequst,
      locationResponse,
      mallsList,
      mallsStatus,
      isSalamaPermitVerified,
      isSalamaBillVerified,
      isSalamaReportVerified,
      cameraAgreement,
      boardContractSetting,
      boardContractsStatus,
      boardContractItems,
      draftLoaded,
      draftStatus,
      currentDistrctId,
      insidePetrolStation
    ];
  }

  CrStep4ShopDataState copyWith(
      {BlocStatus? accommodationTypesStatus,
      BlocStatus? contractsListStatus,
      BlocStatus? investmentListStatus,
      List<String>? deedOptions,
      SaveLocationResponse? locationResponse,
      CleanOptionResponse? cleanOptionResponse,
      BlocStatus? status,
      List<CrLookupsEntity>? accommodationTypes,
      DropDownItem? selectedAccommodationType,
      String? errorMessage,
      List<CommercialBoardType>? selectedBoards,
      List<DropDownItem>? boards,
      bool? brand,
      String? shopName,
      String? shopUnitNumber,
      String? blockNumber,
      String? holesCount,
      String? floorCount,
      String? noOfCameras,
      bool? hasElevator,
      bool? existInMall,
      Nullable<QrLookUpItem?>? selectedMall,
      String? floorNumber,
      Nullable<String?>? contractOption,
      Nullable<String?>? ownershipType,
      Nullable<String?>? cleanContractEndDate,
      bool? salamaPermitExist,
      Nullable<String?>? salamaPermitNumber,
      Nullable<String?>? slamaReportNumber,
      Nullable<String?>? slamaBillNumber,
      Nullable<String?>? contractDate,
      Nullable<String?>? contractNumber,
      Nullable<String?>? contractType,
      Nullable<bool?>? isCitizenPledgedToClean,
      Nullable<CRSubmitterType?>? crSubmitterType,
      Nullable<CRContractType?>? crContractType,
      Nullable<CRContractOption?>? crContractOption,
      CleanContractsResponse? cleanContractsResponse,
      Nullable<CleanContractItem?>? selectedCleanContract,
      InvestmentContractResponse? investmentContractResponse,
      Nullable<InvestmentContractItem?>? selectedInvestmentContract,
      bool? endorsmentAgreement,
      BlocStatus? deedOptionsStatus,
      BlocStatus? cleanOptionsStatus,
      BlocStatus? samalaReportFawryStatus,
      BlocStatus? samalaBillFawryStatus,
      Nullable<bool>? ejarVerified,
      Nullable<bool>? deedVerified,
      bool? isFawryReport,
      bool? isFawryBill,
      EjarInfoRequest? ejarInfoRequst,
      DeedInfoRequest? deedInfoRequst,
      String? deedOption,
      List<QrLookUpItem>? mallsList,
      BlocStatus? mallsStatus,
      Nullable<bool?>? isSalamaPermitVerified,
      Nullable<bool?>? isSalamaBillVerified,
      Nullable<bool?>? isSalamaReportVerified,
      final bool? cameraAgreement,
      Nullable<String?>? boardContractSetting,
      Nullable<BoardContractItem?>? boardContractNumber,
      BlocStatus? boardContractsStatus,
      List<BoardContractItem>? boardContractItems,
      bool? draftLoaded,
      BlocStatus? draftStatus,
      Nullable<String?>? currentDistrctId,
      bool? insidePetrolStation,
        List<dynamic>? lstEndorsements
      }) {
    return CrStep4ShopDataState(
        status: status ?? this.status,
        ejarVerified:
            ejarVerified == null ? this.ejarVerified : ejarVerified.value,
        deedVerified:
            deedVerified == null ? this.deedVerified : deedVerified.value,
        samalaReportFawryStatus:
            samalaReportFawryStatus ?? this.samalaReportFawryStatus,
        samalaBillFawryStatus:
            samalaBillFawryStatus ?? this.samalaBillFawryStatus,
        deedOptionsStatus: deedOptionsStatus ?? this.deedOptionsStatus,
        cleanOptionsStatus: cleanOptionsStatus ?? this.cleanOptionsStatus,
        deedOptions: deedOptions ?? this.deedOptions,
        cleanOptionResponse: cleanOptionResponse ?? this.cleanOptionResponse,
        investmentContractResponse:
            investmentContractResponse ?? this.investmentContractResponse,
        accommodationTypesStatus:
            accommodationTypesStatus ?? this.accommodationTypesStatus,
        contractsListStatus: contractsListStatus ?? this.contractsListStatus,
        accommodationTypes: accommodationTypes ?? this.accommodationTypes,
        selectedAccommodationType:
            selectedAccommodationType ?? this.selectedAccommodationType,
        errorMessage: errorMessage ?? this.errorMessage,
        selectedBoards: selectedBoards ?? this.selectedBoards,
        boards: boards ?? this.boards,
        brand: brand ?? this.brand,
        shopName: shopName ?? this.shopName,
        shopUnitNumber: shopUnitNumber ?? this.shopUnitNumber,
        blockNumber: blockNumber ?? this.blockNumber,
        holesCount: holesCount ?? this.holesCount,
        floorCount: floorCount ?? this.floorCount,
        noOfCameras: noOfCameras ?? this.noOfCameras,
        hasElevator: hasElevator ?? this.hasElevator,
        existInMall: existInMall ?? this.existInMall,
        selectedMall:
            selectedMall == null ? this.selectedMall : selectedMall.value,
        floorNumber: floorNumber ?? this.floorNumber,
        isCitizenPledgedToClean: isCitizenPledgedToClean == null
            ? this.isCitizenPledgedToClean
            : isCitizenPledgedToClean.value,
        cleanContractEndDate: cleanContractEndDate == null
            ? this.cleanContractEndDate
            : cleanContractEndDate.value,
        salamaPermitExist: salamaPermitExist ?? this.salamaPermitExist,
        salamaPermitNumber: salamaPermitNumber == null
            ? this.salamaPermitNumber
            : salamaPermitNumber.value,
        slamaReportNumber: slamaReportNumber == null
            ? this.slamaReportNumber
            : slamaReportNumber.value,
        slamaBillNumber: slamaBillNumber == null
            ? this.slamaBillNumber
            : slamaBillNumber.value,
        contractDate:
            contractDate == null ? this.contractDate : contractDate.value,
        contractNumber:
            contractNumber == null ? this.contractNumber : contractNumber.value,
        contractOption:
            contractOption == null ? this.contractOption : contractOption.value,
        contractType:
            contractType == null ? this.contractType : contractType.value,
        ownershipType:
            ownershipType == null ? this.ownershipType : ownershipType.value,
        crSubmitterType: crSubmitterType == null
            ? this.crSubmitterType
            : crSubmitterType.value,
        crContractType:
            crContractType == null ? this.crContractType : crContractType.value,
        crContractOption: crContractOption == null
            ? this.crContractOption
            : crContractOption.value,
        cleanContractsResponse:
            cleanContractsResponse ?? this.cleanContractsResponse,
        lstEndorsements:lstEndorsements??this.lstEndorsements,
        selectedCleanContract: selectedCleanContract == null
            ? this.selectedCleanContract
            : selectedCleanContract.value,
        investmentListStatus: investmentListStatus ?? this.investmentListStatus,
        selectedInvestmentContract: selectedInvestmentContract == null
            ? this.selectedInvestmentContract
            : selectedInvestmentContract.value,
        endorsmentAgreement: endorsmentAgreement ?? this.endorsmentAgreement,
        isFawryReport: isFawryReport ?? this.isFawryReport,
        isFawryBill: isFawryBill ?? this.isFawryBill,
        ejarInfoRequst: ejarInfoRequst ?? this.ejarInfoRequst,
        deedInfoRequst: deedInfoRequst ?? this.deedInfoRequst,
        locationResponse: locationResponse ?? this.locationResponse,
        deedOption: deedOption ?? this.deedOption,
        mallsList: mallsList ?? this.mallsList,
        mallsStatus: mallsStatus ?? this.mallsStatus,
        isSalamaPermitVerified: isSalamaPermitVerified == null
            ? this.isSalamaPermitVerified
            : isSalamaPermitVerified.value,
        isSalamaBillVerified: isSalamaBillVerified == null
            ? this.isSalamaBillVerified
            : isSalamaBillVerified.value,
        isSalamaReportVerified: isSalamaReportVerified == null
            ? this.isSalamaReportVerified
            : isSalamaReportVerified.value,
        cameraAgreement: cameraAgreement ?? this.cameraAgreement,
        boardContractSetting: boardContractSetting == null
            ? this.boardContractSetting
            : boardContractSetting.value,
        boardContractNumber: boardContractNumber == null
            ? this.boardContractNumber
            : boardContractNumber.value,
        boardContractsStatus: boardContractsStatus ?? this.boardContractsStatus,
        boardContractItems: boardContractItems ?? this.boardContractItems,
        draftLoaded: draftLoaded ?? this.draftLoaded,
        draftStatus: draftStatus ?? this.draftStatus,
        insidePetrolStation: insidePetrolStation ?? this.insidePetrolStation,
        currentDistrctId: currentDistrctId == null ? this.currentDistrctId : currentDistrctId.value);
  }

  bool isFormValid() {
    if (insidePetrolStation == null) return false;
    if (locationResponse?.endorsementText?.isNotEmpty ?? false) {
      if (endorsmentAgreement == false || endorsmentAgreement == null)
        return false;
    }

    if (boardContractSetting == "MANUAL" && (selectedBoards?.isEmpty ?? true)) {
      return false;
    }

    if ((crContractOption == CRContractOption.service) &&
        (crContractType == CRContractType.ejar) &&
        ejarVerified == false) return false;

    return (brand != null) &&
        (shopName != null && shopName!.isNotEmpty) &&
        (shopUnitNumber != null && shopUnitNumber!.isNotEmpty) &&
        (holesCount != null && holesCount!.isNotEmpty) &&
        (noOfCameras != null && noOfCameras!.isNotEmpty) &&
        hasElevator != null &&
        (floorCount != null && floorCount!.isNotEmpty);
  }

  bool showSalamaReport() {
    if (locationResponse?.slamaReportOptions?.contains("SERVICE") ?? false) {
      return true;
    }

    return false;
  }

  bool showSalamaBill() {
    if (locationResponse?.slamaBillOptions?.contains("SERVICE") ?? false) {
      return true;
    }
    return false;
  }

  bool showAttachDeed() {
    if (locationResponse?.contractOptionsResponseDto?.deedOptions
            ?.contains("ATTACH") ??
        false) {
      return true;
    }

    return false;
  }

  bool showAttachEjar() {
    if (locationResponse?.contractOptionsResponseDto?.ejarOptions
            ?.contains("ATTACH") ??
        false) {
      return true;
    }
    return false;
  }

  bool showAttachInvest() {
    if (locationResponse?.contractOptionsResponseDto?.investOptions
            ?.contains("ATTACH") ??
        false) {
      return true;
    }
    return false;
  }

  bool showServicehDeed() {
    if (locationResponse?.contractOptionsResponseDto?.deedOptions
            ?.contains("SERVICE") ??
        false) {
      return true;
    }

    return false;
  }

  bool showServiceEjar() {
    if (locationResponse?.contractOptionsResponseDto?.ejarOptions
            ?.contains("SERVICE") ??
        false) {
      return true;
    }
    return false;
  }

  bool showServiceInvest() {
    if (locationResponse?.contractOptionsResponseDto?.investOptions
            ?.contains("SERVICE") ??
        false) {
      return true;
    }
    return false;
  }

  bool cleanOptionBALADIASADAD() {
    return cleanOptionResponse?.cleanOption == "BALADIA_SADAD";
  }

  bool cleanOptionCLEANCONTRACT() {
    return cleanOptionResponse?.cleanOption == "CLEAN_CONTRACT";
  }

  bool cleanOptionOPTIONAL() {
    return cleanOptionResponse?.cleanOption == "OPTIONAL";
  }

  bool cleanTypeAttach() {
    return cleanOptionResponse?.contractOption == "ATTACH";
  }

  bool cleanTypeService() {
    return cleanOptionResponse?.contractOption == "SERVICE";
  }

  bool cleanTypeATTACHSERVICE() {
    return cleanOptionResponse?.contractOption == "ATTACH,SERVICE";
  }

  bool cleanContractshowPayAll() {
    return cleanOptionBALADIASADAD() || cleanOptionOPTIONAL();
  }

  bool cleanContractshowAttach() {
    return (cleanTypeATTACHSERVICE() || cleanTypeAttach());
  }

  bool cleanContractshowService() {
    return (cleanTypeATTACHSERVICE() || cleanTypeService());
  }


  bool boardContractsOPTINAL() {
    return locationResponse?.boardContractSetting == "OPTIONAL";
  }

  bool boardContractsContract() {
    return locationResponse?.boardContractSetting == "CONTRACT";
  }

  bool boardContractsMANUAL() {
    return locationResponse?.boardContractSetting == "MANUAL";
  }
}
