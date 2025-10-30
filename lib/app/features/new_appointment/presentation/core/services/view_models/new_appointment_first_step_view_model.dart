import 'dart:async';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../pages/new_appointment_screens/new_appointment_first_step_screen.dart';
import '../../models/attachment_item_model.dart';
import '../../models/department_model.dart';
import '../../models/lookup_list_model.dart';
import '../../models/main_class_response.dart';
import '../../models/municipality_model.dart';
import '../../models/service_config_reseponse.dart';
import '../../models/sub_class_response.dart';
import '../../models/sub_municipalitiy_model.dart';
import 'new_appointment_view_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class NewAppointmentFirstStepViewModel extends BaseViewModel {
  bool withPreviousTransaction = false;
  bool isDraft = false;
  final dataModel = locator<NewAppointmentViewModel>();

  NewAppointmentFirstStepViewModel(
      {required this.withPreviousTransaction, required this.isDraft}) {
    dataModel.attachmentConfigList = [];

    locator<NewAppointmentViewModel>().withPreviousTransaction =
        withPreviousTransaction;
    // if (isDraft == false) locator<NewAppointmentViewModel>().init();
    dataModel.setShowSpecialConditionSection();
    dataModel.setShowSpecialConditionOld();
    dataModel.checkIfUserIsOld();
    validateForm();
    // setUpDraft();
  }

  /*void setUpDraft() async {
    notifyListeners();
    await dataModel.setUpDraft();

    Timer(Duration(seconds: 5), () {
      appointmentKey.currentState!.setState(() {});

      notifyListeners();
      validateForm();
      notifyListeners();
      appointmentKey.currentState!.setState(() {});
    });
  }*/

  //String get getNotes => dataModel.notes ?? "";

  String get appointmentDetails => dataModel.appointmentDetails ?? "";

  String get getTransactionNo => dataModel.transactionNo ?? "";
  bool? get getExistedWakeelVisit => dataModel.existedWakeelVisit;
  bool? get getAgreementStatus => dataModel.agreementChecked;
  bool get getprevTransNoRequired => dataModel.prevTransNoRequired ?? false;

  String get getServiceName => dataModel.serviceName ?? "";

  VisitType? get appointmentTypeItem => dataModel.appointmentTypeItem;

  List<AttachmentsConfig>? get lstAttachmentConfig =>
      dataModel.attachmentConfigList;

  LookUpItem? get specialConditionItem => dataModel.specialConditionItem;

  bool? get isSpecialConditionChecked => dataModel.isSpecialConditionChecked;

  set fromHomePage(bool? fromPage) =>
      dataModel.fromHomePage = fromPage ?? false;

  bool? get getFromHomePage => dataModel.fromHomePage;

  ServiceConfigResponse? get serviceConfigResponse =>
      dataModel.serviceConfigResponse;

  set setAppointmentDetails(String data) => dataModel.appointmentDetails = data;

  set setTransactionNo(String data) => dataModel.transactionNo = data;
  set setExistedWakeelVisit(bool data) => dataModel.existedWakeelVisit = data;
  set setAgreementStatus(bool data) => dataModel.agreementChecked = data;

  set setServiceName(String data) => dataModel.serviceName = data;

  set setAppointmentTypeItem(VisitType? data) =>
      dataModel.appointmentTypeItem = data;

  set specialConditionItem(LookUpItem? item) =>
      dataModel.specialConditionItem = item;

  set isSpecialConditionChecked(bool? item) =>
      dataModel.isSpecialConditionChecked = item;

  bool isFormValid = false;

  LookUpList? get getSpecialConditionList => dataModel.specialConditionTypeList;

  set setSpecialConditionList(LookUpList? data) =>
      dataModel.specialConditionTypeList = data;

  List<VisitType>? get appointmentTypeList => dataModel.appointmentTypeList;

  List<AttachmentItemModel> get attachmentsList => dataModel.atttachmentItems;

  bool showSpecialConditionSection() {
    //MM11
    return dataModel.specialConditionItem != null;
  }

  Municipality? get getMunicipalitiesResponse =>
      dataModel.municipalitiesResponse;

  List<DropDownItem> get municipalitiesList => dataModel.municipalitiesList;

  DropDownItem? get municipalityType => dataModel.municipalityType;

  set municipalityType(DropDownItem? data) {
    MunicipalityItem? e = getMunicipalitiesResponse?.data?.result
        ?.firstWhereOrNull((element) => element.id == data?.id);
    if (e != null) {
      dataModel.municipalityType = data;
      dataModel.selectedMunicipalityItem = e;
    }
    notifyListeners();
  }

  LookUpList? get getCategoryTypeResponse => dataModel.categoryTypeResponse;

  List<DropDownItem> get categoriesList => dataModel.categoryList;

  DropDownItem? get catetgoryType => dataModel.catetgoryType;

  set catetgoryType(DropDownItem? data) {
    LookUpItem? e = getCategoryTypeResponse?.data?.result?.firstWhereOrNull(
        (element) => element.id == int.tryParse(data?.id ?? ""));
    if (e != null) {
      dataModel.catetgoryType = data;
      dataModel.selectedCategoryType = e;
    }
    notifyListeners();
  }

  SubMunicipality? get getSubMunicipalitiesResponse =>
      dataModel.subMunicipalitiesResponse;

  List<DropDownItem> get subMunicipalitiesList =>
      dataModel.subMunicipalitiesList;

  Future<bool> getSubMunicipalities(DropDownItem item) async {
    subMunicipalityType = null;
    departmentType = null;
    bool isSuccess = false;
    isSuccess = await dataModel.getSubMunicipalities(item.id!);
    if (isSuccess) {
      resetForm(resetMainClass: true);
      municipalityType = item;
    }

    notifyListeners();
    validateForm();
    return true;
  }

  DropDownItem? get subMunicipalityType => dataModel.subMunicipalityType;

  set subMunicipalityType(DropDownItem? data) {
    SubMunicipalityItem? e = getSubMunicipalitiesResponse?.data?.result
        ?.firstWhereOrNull((element) => element.id == data?.id);
    if (e != null) {
      dataModel.subMunicipalityType = data;
      dataModel.selectedSubMunicipalityItem = e;
    } else {
      dataModel.subMunicipalityType = null;
      dataModel.selectedSubMunicipalityItem = null;
    }
    notifyListeners();
  }

  DepartmentList? get getDepartmentsResponse => dataModel.departmentsResponse;

  List<DropDownItem> get departmentsList => dataModel.departmentsList;

  Future<bool> getDepartments(DropDownItem item) async {
    bool isSuccess = false;
    isSuccess = await dataModel.getDepartments(item.id!);
    if (isSuccess) subMunicipalityType = item;
    notifyListeners();
    return true;
  }

  DropDownItem? get departmentType => dataModel.departmentType;

  set departmentType(DropDownItem? data) {
    DepartmentItem? e = getDepartmentsResponse?.data?.result
        ?.firstWhereOrNull((element) => element.id.toString() == data?.id);
    if (e != null) {
      dataModel.departmentType = data;
      dataModel.selectedDepartmentItem = e;
    }
    notifyListeners();
  }

  Future<bool> getDepartment1(DropDownItem item) async {
    departmentType = item;
    notifyListeners();
    return true;
  }

  MainClassResponse? get getMainClassResponse => dataModel.mainClassResponse;

  MainClassItem? get selectedMainClassItem => dataModel.selectedMainClassItem;

  List<DropDownItem> get mainClassList => dataModel.mainClassList;

  DropDownItem? get mainClassType => dataModel.mainClassType;

  set mainClassType(DropDownItem? data) {
    MainClassItem? e = getMainClassResponse?.data?.result
        ?.firstWhereOrNull((element) => element.id.toString() == data?.id);
    if (e != null) {
      dataModel.mainClassType = data;
      dataModel.selectedMainClassItem = e;
    }
    notifyListeners();
  }

  Future<bool> getMainClassifications(DropDownItem item) async {
    bool isSuccess = false;
    isSuccess = await dataModel.getMainClassifications(item.id!);
    if (isSuccess) {
      resetForm(resetSubClass: true);
      subMunicipalityType = item;
    }
    notifyListeners();
    validateForm();
    return true;
  }

  SubClassResponse? get getSubClassResponse => dataModel.subClassResponse;

  List<DropDownItem> get subClassList => dataModel.subClassList;

  DropDownItem? get subClassType => dataModel.subClassType;

  SubClassItem? get selectedSubClassItem => dataModel.selectedSubClassItem;

  set subClassType(DropDownItem? data) {
    SubClassItem? e = getSubClassResponse?.data?.result
        ?.firstWhereOrNull((element) => element.id.toString() == data?.id);
    if (e != null) {
      dataModel.subClassType = data;
      dataModel.selectedSubClassItem = e;
    }
    notifyListeners();
  }

  Future<bool> getSubClassifications(DropDownItem item) async {
    bool isSuccess = false;
    isSuccess = await dataModel.getSublassifications(
        subMunicipalityType!.id!, item.id!);

    if (isSuccess) {
      resetForm();

      mainClassType = item;
    }
    notifyListeners();
    validateForm();
    return isSuccess;
  }

  Future<bool> getServiceConfig(DropDownItem item) async {
    bool isSuccess = false;
    isSuccess =
        await dataModel.getServiceConfig(subMunicipalityType!.id!, item.id!);
    if (isSuccess) {
      subClassType = item;
      dataModel.atttachmentItems = [];

      resetIfSelectSubClass();
    }

    notifyListeners();
    validateForm();
    return isSuccess;
  }

  Future<bool> getAvailableDates() async {
    bool isSuccess = false;
    int? serviceId = serviceConfigResponse?.getServiceId();
    if (serviceId != null) {
      isSuccess = await dataModel.getAvailableDates(serviceId);
    }
    notifyListeners();
    return isSuccess;
  }

  validateForm() {
    try {
      bool isValid = false;
      if (municipalityType != null &&
          subMunicipalityType != null &&
          appointmentTypeItem != null &&
          appointmentDetails.isNotEmpty &&
          selectedMainClassItem != null &&
          selectedSubClassItem != null &&
          catetgoryType != null &&
          serviceConfigResponse != null &&
          serviceConfigResponse?.getServiceId() != null &&
          getExistedWakeelVisit != false &&
          getAgreementStatus != false) {
        if (getprevTransNoRequired) {
          if (getTransactionNo.isNotEmpty) {
            isValid = true;
          } else {
            isValid = false;
          }
        } else {
          isValid = true;
        }
        // if (catetgoryType?.id == "4") {
        //   if (getTransactionNo.isNotEmpty) {
        //     isValid = true;
        //   } else {
        //     isValid = false;
        //   }
        // } else {
        //   isValid = true;
        // }
      } else {
        isValid = false;
      }

      /*  if (selectedSubClassItem?.isOther == true && getServiceName.isEmpty) {
        isValid = false;
      }*/

      if (!CommonFunctions.hasArabicCharacters(appointmentDetails) &&
          CommonFunctions.isAppAR) {
        isValid = false;
      }
      if (!CommonFunctions.hasArabicAndEnglishCharacters(appointmentDetails) &&
          !CommonFunctions.isAppAR) {
        isValid = false;
      }

      /*if (isOtherService && 
          departmentType != null &&
          departmentType?.name == "أخرى" &&
          getServiceName.isEmpty) {
        isValid = false;
      }*/

      if (dataModel.isRealEstate()) {
        if (dataModel.requestRealStateVerified == false) {
          isValid = false;
        }

        /* if (dataModel.realEstateId?.isEmpty ?? true) {
          isValid = false;
        }*/
      }

      var value = checkAttachmentValidation();
      if (value != null && isValid == true) {
        isValid = value;
      }

      if (isFormValid != isValid) {
        isFormValid = isValid;
        notifyListeners();
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    notifyListeners();
  }

  bool? checkAttachmentValidation() {
    bool? isValide = true;
    if (lstAttachmentConfig != null) {
      for (var index = 0; index < lstAttachmentConfig!.length; index++) {
        if (lstAttachmentConfig![index].mandatory == true) {
          var lst = attachmentsList.where((attachment) =>
              attachment.attachmentId == lstAttachmentConfig![index].id);
          if (lst.isEmpty) {
            isValide = false;
          }
        }
      }
    } else {
      isValide = null;
    }

    return isValide;
  }

  void init() {
    dataModel.init();
    //  isFormValid = StreamController<bool>();
    isFormValid = false;
    dataModel.editedItem = null;
  }

  void resetVariables() {
    dataModel.init();
    // isFormValid = StreamController<bool>();
    isFormValid = false;
    municipalityType = null;
    subMunicipalityType = null;
    departmentType = null;
  }

  void resetForm({
    bool resetMainClass = false,
    bool resetSubClass = false,
  }) {
    /* if (resetSubMunicipality) {
      dataModel.selectedSubMunicipalityItem = null;
      dataModel.subMunicipalitiesResponse = null;
      dataModel.subMunicipalitiesList = [];
      dataModel.subMunicipalityType = null;
    }*/
    if (resetMainClass) {
      dataModel.mainClassResponse = null;
      dataModel.mainClassList = [];
    }
    if (resetMainClass || resetSubClass) {
      dataModel.subClassResponse = null;
      dataModel.subClassList = [];
      dataModel.mainClassType = null;
      dataModel.selectedMainClassItem = null;
    }

    dataModel.subClassType = null;
    dataModel.selectedSubClassItem = null;
    dataModel.serviceConfigResponse = null;

    dataModel.availableDatesResponse = null;
    //dataModel.availableTimesResponse = null;

    if (dataModel.saveDate == false) {
      dataModel.selectedDate = null;
      dataModel.selectedTime = null;
    }
    if (dataModel.saveDate == true) {
      dataModel.selectedDate?.times = [];
    }

    setAppointmentTypeItem = null;
    dataModel.appointmentTypeList = null;
  }

  void resetIfSelectSubClass() {
    setServiceName = "";
    dataModel.otherServiceNameController.text = "";
    dataModel.availableDatesResponse = null;
    //dataModel.availableTimesResponse = null;
    if (dataModel.saveDate == false) {
      dataModel.selectedDate = null;
      dataModel.selectedTime = null;
    }
    if (dataModel.saveDate == true) {
      dataModel.selectedDate?.times = [];
    }
  }

  void deleteAttachment(int index) async {
    dataModel.atttachmentItems.removeAt(index);
    // bool isSuccess = await dataModel.deleteAttachment( dataModel.atttachmentItems[index].attachmentUuid!);
    // if(isSuccess == true) {
    //
    //   notifyListeners();
    // }
  }

  void checkRealStateRequest() async {
    await dataModel.checkRealStateRequest();
    print("HERE");
    notifyListeners();
  }

  void saveAttachment(String filePath, String fileName, Uint8List base64,
      int? attachmentId) async {
    bool isSuccess = false;

    isSuccess =
        await dataModel.uploadFile(base64, fileName, filePath, attachmentId);
    validateForm();
    notifyListeners();
  }
}
