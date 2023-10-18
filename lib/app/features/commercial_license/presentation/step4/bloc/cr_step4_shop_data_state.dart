part of 'cr_step4_shop_data_cubit.dart';

class CrStep4ShopDataState extends Equatable {
  final BlocStatus accommodationTypesStatus;

  final List<CrLookupsEntity>? accommodationTypes;
  final DropDownItem? selectedAccommodationType;
  final String? errorMessage;
  final List<CommercialBoardType>? selectedBoards;
  final List<DropDownItem>? boards;

  final bool? brand; //هل يوجد لديك علامة تجارية
  final String? shopName; //اسم المحل
  final String? shopUnitNumber; //رقم المحل
  final String? blockNumber; //رقم العقار
  final int? holesCount; //عدد الفتحات
  final int? floorCount; //عدد الأدوار في المحل
  final int? noOfCameras; //عدد الكاميرات في المحل
  final bool? hasElevator;
  final bool? existInMall;
  final DropDownItem? selectedMall;
  final int? floorNumber; //طابق المول
  final bool?
      isCitizenPledgedToClean; //هل أنت متعاقد مع إحدى شركات النظافة المؤهلة من الامانة وذلك لجمع ونقل النفايات ؟
  final String? cleanContractEndDate; //تاريخ انتهاء عقد النظافة

  final bool? salamaPermitExist; //هل لديك تصريح سلامة؟
  final String? salamaPermitNumber; //رقم تصريح سلامة
  final String? slamaReportNumber; //رقم التقرير الفني

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

  const CrStep4ShopDataState(
      {this.accommodationTypesStatus = BlocStatus.initial,
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
      this.contractDate,
      this.contractNumber,
      this.contractOption,
      this.contractType,
      this.ownershipType,
      this.crSubmitterType,
      this.crContractType,
      this.crContractOption});

  @override
  List<Object?> get props {
    return [
      accommodationTypesStatus,
      accommodationTypes,
      selectedAccommodationType,
      errorMessage,
      selectedBoards,
      boards,
      brand,
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
      crContractOption
    ];
  }

  CrStep4ShopDataState copyWith(
      {BlocStatus? accommodationTypesStatus,
      List<CrLookupsEntity>? accommodationTypes,
      DropDownItem? selectedAccommodationType,
      String? errorMessage,
      List<CommercialBoardType>? selectedBoards,
      List<DropDownItem>? boards,
      bool? brand,
      String? shopName,
      String? shopUnitNumber,
      String? blockNumber,
      int? holesCount,
      int? floorCount,
      int? noOfCameras,
      bool? hasElevator,
      bool? existInMall,
      DropDownItem? selectedMall,
      int? floorNumber,
      Nullable<String?>? contractOption,
      Nullable<String?>? ownershipType,
      String? cleanContractEndDate,
      bool? salamaPermitExist,
      Nullable<String?>? salamaPermitNumber,
      Nullable<String?>? slamaReportNumber,
      Nullable<String?>? contractDate,
      Nullable<String?>? contractNumber,
      Nullable<String?>? contractType,
      bool? isCitizenPledgedToClean,
      Nullable<CRSubmitterType?>? crSubmitterType,
      Nullable<CRContractType?>? crContractType,
      Nullable<CRContractOption?>? crContractOption}) {
    return CrStep4ShopDataState(
      accommodationTypesStatus:
          accommodationTypesStatus ?? this.accommodationTypesStatus,
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
      selectedMall: selectedMall ?? this.selectedMall,
      floorNumber: floorNumber ?? this.floorNumber,
      isCitizenPledgedToClean:
          isCitizenPledgedToClean ?? this.isCitizenPledgedToClean,
      cleanContractEndDate: cleanContractEndDate ?? this.cleanContractEndDate,
      salamaPermitExist: salamaPermitExist ?? this.salamaPermitExist,
      salamaPermitNumber: salamaPermitNumber == null
          ? this.salamaPermitNumber
          : salamaPermitNumber.value,
      slamaReportNumber: slamaReportNumber == null
          ? this.slamaReportNumber
          : slamaReportNumber.value,
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
    );
  }
}
