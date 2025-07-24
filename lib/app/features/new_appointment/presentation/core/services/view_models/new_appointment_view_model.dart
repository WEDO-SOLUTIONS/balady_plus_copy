import 'dart:typed_data';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mime/mime.dart';
import 'package:tuple/tuple.dart';

import 'dart:async';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/constants/remote_config.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../models/appointment_details_model.dart';
import '../../models/attachment_item_model.dart';
import '../../models/available_dates_response.dart';
import '../../models/available_times_response.dart';
import '../../models/department_model.dart';
import '../../models/lookup_list_model.dart';
import '../../models/main_class_response.dart';
import '../../models/municipality_model.dart';
import '../../models/request_real_state_response_model.dart';
import '../../models/save_appointment_reseponse.dart';
import '../../models/service_config_reseponse.dart';
import '../../models/sub_class_response.dart';
import '../../models/sub_municipalitiy_model.dart';
import '../../models/upload_file_resepnse.dart';
import '../repository/appointment_repository.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class NewAppointmentViewModel extends BaseViewModel {
  final _repository = locator<AppointmentRepository>();
  final TextEditingController descController = TextEditingController();
  final TextEditingController transactionNoController = TextEditingController();
  final TextEditingController realEstateSurveyIdController =
      TextEditingController();
  final TextEditingController realEstateIdController = TextEditingController();
  final TextEditingController realEstateRequestIdController =
      TextEditingController();

  final TextEditingController otherServiceNameController =
      TextEditingController();

  bool saveDate = false;
  bool withPreviousTransaction = false;
  bool fromHomePage = false;
  AppointmentItemInfo? editedItem;
// service Category
  LookUpList? categoryTypeResponse;
  List<DropDownItem> categoryList = [];
  DropDownItem? catetgoryType;
  LookUpItem? selectedCategoryType;

  // municipality
  Municipality? municipalitiesResponse;
  List<DropDownItem> municipalitiesList = [];
  DropDownItem? municipalityType;
  MunicipalityItem? selectedMunicipalityItem;

  // sub municipality
  SubMunicipality? subMunicipalitiesResponse;
  List<DropDownItem> subMunicipalitiesList = [];
  DropDownItem? subMunicipalityType;
  SubMunicipalityItem? selectedSubMunicipalityItem;

  // departments
  DepartmentList? departmentsResponse;
  List<DropDownItem> departmentsList = [];
  DropDownItem? departmentType;
  DepartmentItem? selectedDepartmentItem;

  // main classifications
  MainClassResponse? mainClassResponse;
  List<DropDownItem> mainClassList = [];
  DropDownItem? mainClassType;
  MainClassItem? selectedMainClassItem;

// sub classifications
  SubClassResponse? subClassResponse;
  List<DropDownItem> subClassList = [];
  DropDownItem? subClassType;
  SubClassItem? selectedSubClassItem;

// Service Config
  ServiceConfigResponse? serviceConfigResponse;

//Dates
  AvailableDatesResponse? availableDatesResponse;
  DateItem? selectedDate;

  // times
  //AvailableTimesResponse? availableTimesResponse;
  TimeItem? selectedTime;

  // first step variables
  //String? notes;
  String? appointmentDetails;
  String? transactionNo;
  bool? existedWakeelVisit;
  bool? prevTransNoRequired;
  bool? agreementChecked;
  String? serviceName;
  LookUpItem? submitterTypeItem;
  VisitType? appointmentTypeItem;
  LookUpItem? specialConditionItem;
  LookUpItem? specialConditionItemOld;

  bool? isSpecialConditionChecked = false;
  bool isUserOld = false;
  bool? requestRealStateVerified = false;

// attachments

  /* String? attachmentUuid;
  String? attachmentFileName;
  String? attachmentPath;
  Uint8List? attachmentBase64;*/
  List<AttachmentItemModel> atttachmentItems = [];

  // lookup list
  LookUpList? submitterTypeList;

  LookUpList? specialConditionTypeList;
  List<VisitType>? appointmentTypeList;

  List<AttachmentsConfig>? attachmentConfigList = [];
  String? realEstateSurveyId;
  String? realEstateId;
  String? realEstateRequestId;

  init() {
    editedItem = null;
    descController.text = "";
    transactionNoController.text = "";
    realEstateSurveyIdController.text = "";
    realEstateIdController.text = "";
    realEstateRequestIdController.text = "";

    // municipalitiesResponse = null;
    municipalityType = null;
    selectedMunicipalityItem = null;
    // municipalitiesList = [];

    selectedSubMunicipalityItem = null;
    subMunicipalityType = null;
    subMunicipalitiesResponse = null;
    subMunicipalitiesList = [];

    selectedDepartmentItem = null;
    departmentType = null;
    departmentsResponse = null;
    departmentsList = [];

    // availableTimesResponse = null;
    selectedTime = null;

    //notes = null;
    appointmentDetails = null;

    realEstateSurveyId = null;
    realEstateId = null;
    realEstateRequestId = null;

    transactionNo = null;
    existedWakeelVisit = null;
    prevTransNoRequired = false;
    agreementChecked = null;
    serviceName = null;
    appointmentTypeItem = null;
    submitterTypeItem = null;
    appointmentTypeList = null;
    //submitterTypeList = null;
    // specialConditionTypeList = null;
    specialConditionItem = null;
    specialConditionItemOld = null;
    serviceConfigResponse = null;

    mainClassResponse = null;
    mainClassList = [];
    mainClassType = null;
    selectedMainClassItem = null;

    subClassResponse = null;
    subClassList = [];
    subClassType = null;
    selectedSubClassItem = null;

    availableDatesResponse = null;
    selectedDate = null;

    //  availableTimesResponse = null;
    selectedTime = null;
    /*  attachmentUuid = null;
    attachmentFileName = null;
    attachmentPath = null;
    attachmentBase64 = null;*/

    selectedCategoryType = null;
    catetgoryType = null;
    atttachmentItems = [];
    isSpecialConditionChecked = false;
    isUserOld = false;
    requestRealStateVerified = false;
    notifyListeners();
  }

  Future<bool> getLookUpList(String type, {bool showLoad = false}) async {
    if (showLoad) showLoading();
    Tuple3<bool?, String?, LookUpList?> response =
        await _repository.getLookupList(type);
    if (showLoad) hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      if (type == "SUBMITTER_TYPE") {
        submitterTypeList = response.item3;
      }
      if (type == "SPECIAL_CONDITION") {
        specialConditionTypeList = response.item3!;
      }

      if (type == "service-category") {
        categoryTypeResponse = response.item3!;
      }

      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  void setMunicipalities(Municipality? data) {
    municipalitiesResponse = data;
    municipalitiesList = municipalitiesResponse!.data!.result!
        .map<DropDownItem>((e) => DropDownItem(
            id: e.id,
            name: e.name ?? "",
            externalSystemUrl: e.externalSystemUrl ?? "",
            externalSystem: e.externalSystem ?? false))
        .toList();
  }

  Future<bool> getMunicipalities({bool showLoad = false}) async {
    // if (municipalitiesList.isNotEmpty) return true;
    if (showLoad) showLoading();
    Tuple3<bool?, String?, Municipality?> response =
        await _repository.getMunicipalities();
    if (showLoad) hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      setMunicipalities(response.item3);
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  void setCatetgories(LookUpList? data) {
    categoryTypeResponse = data;
    categoryList = categoryTypeResponse!.data!.result!
        .map<DropDownItem>(
            (e) => DropDownItem(id: e.id.toString(), name: e.name ?? ""))
        .toList();
  }

  void setSubMunicipalities(SubMunicipality? data) {
    subMunicipalitiesResponse = data;
    subMunicipalitiesList = subMunicipalitiesResponse!.data!.result!
        .map<DropDownItem>((e) => DropDownItem(id: e.id, name: e.name ?? ""))
        .toList();
  }

  Future<bool> getSubMunicipalities(String municipalityId) async {
    showLoading();
    Tuple3<bool?, String?, SubMunicipality?> response =
        await _repository.getSubMunicipalities(municipalityId);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      setSubMunicipalities(response.item3);
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  void setDepartments(DepartmentList? data) {
    departmentsResponse = data;
    departmentsList = departmentsResponse!.data!.result!
        .map<DropDownItem>(
            (e) => DropDownItem(id: e.id.toString(), name: e.name ?? ""))
        .toList();
  }

  void setMainClassifications(MainClassResponse? data) {
    mainClassResponse = data;
    mainClassList = mainClassResponse!.data!.result!
        .map<DropDownItem>(
            (e) => DropDownItem(id: e.id.toString(), name: e.name ?? ""))
        .toList();
  }

  void setSubClassifications(SubClassResponse? data) {
    subClassResponse = data;
    subClassList = subClassResponse!.data!.result!
        .map<DropDownItem>(
            (e) => DropDownItem(id: e.id.toString(), name: e.name ?? ""))
        .toList();
  }

  Future<bool> getDepartments(String subMunicipalityId) async {
    showLoading();
    Tuple3<bool?, String?, DepartmentList?> response =
        await _repository.getDepartments(subMunicipalityId);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      setDepartments(response.item3);
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getAvailableDates(int serviceId,
      {String? currentDraftTime}) async {
    showLoading();
    Tuple3<bool?, String?, AvailableDatesResponse?> response = await _repository
        .getAppointmentDates(serviceId, currentDraftTime: currentDraftTime);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      print("SAAAVED  $saveDate");
      if (saveDate != true) {
        selectedDate = null;
        selectedTime = null;
      }

      availableDatesResponse = response.item3;
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> checkRealStateRequest() async {
    if (realEstateRequestId?.isEmpty ?? true) return false;
    showLoading();
    Tuple3<bool?, String?, RequeestRealStateResponseModel?> response =
        await _repository.checkRealStateRequest(realEstateRequestId ?? "");
    hideLoading();
    if (response.item1 != null && response.item1!) {
      requestRealStateVerified = true;
      notifyListeners();
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    requestRealStateVerified = false;
    notifyListeners();

    return false;
  }
  /*Future<bool> getAvailableTimes(int serviceId, String date) async {
    showLoading();
    Tuple3<bool?, String?, AvailableTimesResponse?> response =
        await _repository.getAppointmentTimes(serviceId, date);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      availableTimesResponse = response.item3;
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }*/

  Future<bool> getMainClassifications(String subMunicipalityId) async {
    showLoading();
    Tuple3<bool?, String?, MainClassResponse?> response =
        await _repository.getMainClassifications(subMunicipalityId);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      setMainClassifications(response.item3);
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getSublassifications(
      String subMunicipalityId, String mainClassId) async {
    showLoading();
    Tuple3<bool?, String?, SubClassResponse?> response =
        await _repository.getSubClassifications(subMunicipalityId, mainClassId);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      setSubClassifications(response.item3);
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<SaveAppointmentResponse?> saveAppointment() async {
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Appointment_Booking_Send_Request_Event);

    String userId = CommonProperties.userInfo?.idNo ?? "";
    String email = CommonProperties.userInfo?.getEmail() ?? "";
    String name = CommonProperties.userInfo?.arName ?? "";

    String idType = CommonProperties.userInfo?.getIdType() ?? "";

    String birthDate = CommonProperties.userInfo?.getHijriBirthDate() ?? "";
    String mobile = CommonProperties.userInfo?.phone ?? "";
    showLoading();
    Tuple3<bool?, String?, SaveAppointmentResponse?> response =
        await _repository.saveAppointment({
      "serviceCategoryId": selectedCategoryType?.id,
      "appointmentDetails": appointmentDetails,
      "birthDate": birthDate,
      "departmentId": serviceConfigResponse!.data!.result![0].departmentId,
      "email": email,
      "identityNumber": userId,
      "identityTypeId": idType,
      "mobileNumber": mobile,
      "notes": "",
      "otherValueName": serviceName,
      "prevTrnNo": transactionNo,
      "serviceConfigId": serviceConfigResponse!.getServiceId(),
      if (specialConditionItem?.id != null &&
          (isSpecialConditionChecked ?? false))
        "specialCondition": specialConditionItem?.id,
      if ((specialConditionItemOld?.id != null &&
          isSpecialConditionChecked == false &&
          isUserOld))
        "specialCondition": specialConditionItemOld?.id,
      "subMunicipalityId": selectedSubMunicipalityItem!.id,
      "submitterName": name,
      //"submitterType": submitterTypeItem!.id,
      if (atttachmentItems.isNotEmpty)
        "uuid": atttachmentItems.map((e) => e.attachmentUuid).toList(),
      "visitDate": selectedDate!.date,
      "visitLinked": withPreviousTransaction,
      "visitTime": selectedTime!.timeKey,
      "visitTopic": "",
      "visitType": appointmentTypeItem!.id,

      if (isRealEstate()) ...{
        "realEstateSurveyId": realEstateSurveyId,
        "realEstateId": realEstateId,
        "realEstateRequestId": realEstateRequestId
      },
      "existsWakeelVisit": existedWakeelVisit,
    });
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute,
          ModalRoute.withName(RouteName.bottomNavigation),
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.appointmentScreen,
              idNumber: response.item3?.data?.result?.id.toString() ?? "",
              fromHomePage: true));
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Appointment_Booking_Open_Success_Page_Event);

      return response.item3;
    } else {
      showError(response.item2 ?? "");
    }
    return null;
  }

  Future<SaveAppointmentResponse?> updateAppointment() async {
    /*  CommonFunctions.sendUXCamEvent(
        UXCamEvents.Appointment_Booking_Send_Request_Event);
*/

    bool confirm = await showConfirmationUpdateMessages();

    if (confirm == false) return null;

    showLoading();
    try {
      Tuple3<bool?, String?, SaveAppointmentResponse?> response =
          await _repository.updateAppointment({
        "serviceCategoryId": selectedCategoryType?.id,
        "appointmentDetails": appointmentDetails,
        "departmentId": serviceConfigResponse!.data!.result![0].departmentId,
        "notes": "",
        "otherValueName": serviceName,
        "prevTrnNo": transactionNo,
        "serviceConfigId": serviceConfigResponse!.getServiceId(),
        if (specialConditionItem?.id != null &&
            (isSpecialConditionChecked ?? false))
          "specialCondition": specialConditionItem?.id,
        if ((specialConditionItemOld?.id != null &&
            isSpecialConditionChecked == false &&
            isUserOld))
          "specialCondition": specialConditionItemOld?.id,
        "subMunicipalityId": selectedSubMunicipalityItem!.id,
        //"submitterType": submitterTypeItem!.id,
        if (atttachmentItems.isNotEmpty)
          "uuid": atttachmentItems.map((e) => e.attachmentUuid).toList(),
        "visitDate": selectedDate!.date,
        "visitLinked": withPreviousTransaction,
        "visitTime": selectedTime!.timeKey,
        "visitTopic": "",
        "visitType": appointmentTypeItem!.id,
        if (isRealEstate()) ...{
          "realEstateSurveyId": realEstateSurveyId,
          "realEstateId": realEstateId,
          "realEstateRequestId": realEstateRequestId
        }
      }, editedItem!.id!);
      hideLoading();
      if (response.item1 == true) {
        NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            RouteName.successRoute,
            ModalRoute.withName(RouteName.bottomNavigation),
            arguments: SuccessScreenArgs(
                type: PAGE_TYPE.updateAppointment,
                thanksMessage: "update_appointment_success_msg".tr(),
                fromHomePage: true));
        /* CommonFunctions.sendUXCamEvent(
          UXCamEvents.Appointment_Booking_Open_Success_Page_Event);
*/
        return response.item3;
      } else {
        showError(response.item2 ?? "");
      }
      return null;
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      print(error);
      hideLoading();
    }
    return null;
  }

  Future<bool> getServiceConfig(
      String subMunicipalityId, String subClassId) async {
    showLoading();
    Tuple3<bool?, String?, ServiceConfigResponse?> response =
        await _repository.getServiceConfig(subMunicipalityId, subClassId);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      serviceConfigResponse = response.item3;
      appointmentTypeList = serviceConfigResponse?.data?.result?[0].visitType;
      if (appointmentTypeList?.length == 1) {
        appointmentTypeItem = appointmentTypeList?[0];
      }
      attachmentConfigList =
          serviceConfigResponse?.data?.result?[0].attachmentsConfig;
      prevTransNoRequired =
          serviceConfigResponse?.data?.result?[0].prevTransNoRequired;

      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> deleteAttachment(String udid) async {
    showLoading();
    Tuple3<bool?, String?, SaveAppointmentResponse?> response =
        await _repository.deleteAttachment(udid);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result?.uuid != null) {
      var attachmentUuid = response.item3?.data?.result?.uuid;

      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> uploadFile(
      Uint8List? attachmentBase64,
      String? attachmentFileName,
      String? attachmentPath,
      int? attachmentId) async {
    final mimeType = lookupMimeType(attachmentPath ?? ""); // 'image/jpeg'

    showLoading();
    Tuple3<bool?, String?, UploadFileResponse?> response =
        await _repository.uploadFile(attachmentBase64, attachmentFileName,
            attachmentPath, mimeType, attachmentId!);
    hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result?.uuid != null) {
      var attachmentUuid = response.item3?.data?.result?.uuid;

      int index = atttachmentItems
          .indexWhere((element) => element.attachmentId == attachmentId);

      if (index == -1) {
        atttachmentItems.add(AttachmentItemModel(
            attachmentId: attachmentId,
            attachmentUuid: attachmentUuid,
            attachmentFileName: attachmentFileName,
            attachmentPath: attachmentPath,
            updatable: true));
      } else {
        atttachmentItems.removeAt(index);
        atttachmentItems.insert(
            index,
            AttachmentItemModel(
                attachmentId: attachmentId,
                attachmentUuid: attachmentUuid,
                attachmentFileName: attachmentFileName,
                attachmentPath: attachmentPath,
                updatable: true));
      }
      return true;
    } else {
      showError(response.item2 ?? "");
    }
    return false;
  }

  Future<bool> getLookUpListSubmitter() async {
    bool isSuccess = false;
    if (submitterTypeList?.data?.result != null &&
        submitterTypeList!.data!.result!.isNotEmpty) {
      isSuccess = true;
    } else {
      isSuccess = await getLookUpList("SUBMITTER_TYPE");
    }
    if (isSuccess) {
      if (submitterTypeList != null) {
        //MM11 force unwrapping
      }
    }
    notifyListeners();
    return isSuccess;
  }

  Future<bool> getLookUpListCategory() async {
    bool isSuccess = false;
    // if (categoryTypeResponse?.data?.result != null &&
    //     categoryTypeResponse!.data!.result!.isNotEmpty) {
    //   isSuccess = true;
    // } else {
    isSuccess = await getLookUpList("service-category");
    // }
    if (isSuccess) {
      setCatetgories(categoryTypeResponse);
      if (categoryTypeResponse != null) {
        //MM11 force unwrapping
      }
    }
    notifyListeners();
    return isSuccess;
  }

  Future<bool> getLookUpListSpecialCondition() async {
    bool isSuccess = false;

    if (specialConditionTypeList?.data?.result != null &&
        specialConditionTypeList!.data!.result!.isNotEmpty) {
      isSuccess = true;
    } else {
      isSuccess = await getLookUpList("SPECIAL_CONDITION");
      if (isSuccess) {
        setShowSpecialConditionSection();
        setShowSpecialConditionOld();
      }
    }

    notifyListeners();
    return isSuccess;
  }

  bool setShowSpecialConditionSection() {
    //MM11, here used future and got called before the list is loaded.
    bool isSuccess = false;
    if (specialConditionTypeList != null) {
      specialConditionItem = specialConditionTypeList?.data?.result
          ?.firstWhereOrNull((element) =>
              element.id == RemoteConfig.specialConditionId ||
              element.name!.contains("ذوي"));
      if (specialConditionItem != null) {
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    }

    return isSuccess;
  }

  bool setShowSpecialConditionOld() {
    bool isSuccess = false;
    if (specialConditionTypeList != null) {
      specialConditionItemOld = specialConditionTypeList?.data?.result
          ?.firstWhereOrNull((element) =>
              element.id == RemoteConfig.specialConditionOldId ||
              element.name!.contains("كبير"));
      if (specialConditionItemOld != null) {
        isSuccess = true;
      } else {
        isSuccess = false;
      }
    }

    return isSuccess;
  }

  bool checkIfUserIsOld() {
    bool isOld = false;

    try {
      String? userDOB =
          CommonProperties.userInfo?.getFormattedBirthDate(withDash: true);
      if (userDOB != null) {
        DateTime date = DateTime.parse(userDOB);
        DateTime today = DateTime.now();
        DateTime now = today;

        if ((date.year > 1800 && date.year < 2100) &&
            (now.year > 1800 && now.year < 2100)) {
          int age = now.year - date.year;
          if (age > 65) {
            isOld = true;
          }
        }
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
    isUserOld = isOld;
    return isOld;
  }

  Future<bool> loadInitialData() async {
    // showLoading();
    List<bool> response = await Future.wait<bool>([
      getLookUpListSubmitter(),
      getLookUpListSpecialCondition(),
      getMunicipalities(),
      getLookUpListCategory()
    ]);
    // hideLoading();

    return !response.contains(false) ? true : false;
  }

  Future<bool> setUpDraft({AppointmentItemInfo? item}) async {
    editedItem = item;
    // municipality
    if (editedItem != null) {
      municipalityType = DropDownItem(
          id: editedItem?.municipalityId,
          value: editedItem?.municipalityId,
          code: editedItem?.municipalityId,
          name: editedItem?.municipalityName.toString() ?? "");
      selectedMunicipalityItem = MunicipalityItem(
          id: editedItem?.municipalityId,
          amanaId: editedItem?.municipalityId,
          name: editedItem?.municipalityName.toString() ?? "");

      // sub municipality
      subMunicipalityType = DropDownItem(
          code: editedItem?.subMunicipalityId,
          value: editedItem?.subMunicipalityId,
          id: editedItem?.subMunicipalityId,
          name: editedItem?.subMunicipalityName ?? "");
      selectedSubMunicipalityItem = SubMunicipalityItem(
          id: editedItem?.subMunicipalityId,
          amanaId: editedItem?.subMunicipalityId,
          name: editedItem?.subMunicipalityName ?? "");

      selectedMainClassItem = MainClassItem(
          id: editedItem?.mainClassId, name: editedItem?.mainClassName);

      mainClassType = DropDownItem(
          value: editedItem?.mainClassId.toString(),
          code: editedItem?.mainClassId.toString(),
          id: editedItem?.mainClassId,
          name: editedItem?.mainClassName ?? "");

      selectedSubClassItem = SubClassItem(
          id: editedItem?.subClassId, name: editedItem?.subClassName);

      subClassType = DropDownItem(
          value: editedItem?.subClassId.toString(),
          code: editedItem?.subClassId.toString(),
          id: editedItem?.subClassId,
          name: editedItem?.subClassName ?? "");

      selectedCategoryType = LookUpItem(
          name: editedItem?.serviceCategoryName,
          id: editedItem?.serviceCategoryId);
      catetgoryType = DropDownItem(
          name: editedItem?.serviceCategoryName ?? "",
          id: editedItem?.serviceCategoryId,
          code: editedItem?.serviceCategoryId.toString(),
          value: editedItem?.serviceCategoryId.toString());

      transactionNo = editedItem?.prevTrnNo;
      existedWakeelVisit = editedItem?.existedWakeelVisit;
      agreementChecked = editedItem?.accepted_agreement;
      appointmentDetails = editedItem?.appointmentDetails;
      realEstateSurveyId = editedItem?.realEstateSurveyId;
      realEstateId = editedItem?.realEstateId;
      realEstateRequestId = editedItem?.realEstateRequestId;
      descController.text = appointmentDetails ?? "";
      transactionNoController.text = transactionNo ?? "";

      realEstateSurveyIdController.text = realEstateSurveyId ?? "";
      realEstateIdController.text = realEstateId ?? "";
      realEstateRequestIdController.text = realEstateRequestId ?? "";

      atttachmentItems = editedItem?.attachments?.map((e) {
            return AttachmentItemModel(
                attachmentBase64: Uint8List(1),
                attachmentFileName: e.name,
                attachmentPath: e.attachUrl,
                attachmentUuid: e.uuid,
                updatable: e.updatable);
          }).toList() ??
          [];

      if (editedItem?.specialConditionId != null) {
        if (editedItem?.specialConditionId.toString() ==
            RemoteConfig.specialConditionId) {
          specialConditionItem = LookUpItem(
              id: editedItem?.specialConditionId,
              name: editedItem?.specialConditionName);

          isSpecialConditionChecked = true;
        }

        print("aaaaaaaaaa dd ff ${editedItem?.attachments?.length}");

        if (editedItem?.specialConditionId.toString() ==
            RemoteConfig.specialConditionOldId) {
          specialConditionItemOld = LookUpItem(
              id: editedItem?.specialConditionId,
              name: editedItem?.specialConditionName);
          isUserOld = true;
        }
        print("aaaaaaaaaa dd 66 ${editedItem?.attachments?.length}");
      }
      if (editedItem?.visitTypeId != null) {
        appointmentTypeItem = VisitType(
            id: editedItem?.visitTypeId, name: editedItem?.visitTypeName);
      }

      print("aaaaaaaaaa dd 11 ${appointmentTypeItem?.name}");

      print("aaaaaaaaaa dd 99 ${editedItem?.attachments?.length}");

      // otherServiceNameController.text = editedItem?.otherValueName;
      serviceName = editedItem?.otherValueName;
      print("aaaaaaaaaa dd 99 rr ${editedItem?.attachments?.length}");

      notifyListeners();

      print("GGGGGG");
      print(subClassType);
      showLoading();
      await Future.wait([
        getServiceConfig(editedItem?.subMunicipalityId ?? "",
            editedItem?.subClassId.toString() ?? ""),
        getSublassifications(editedItem?.subMunicipalityId ?? "",
            editedItem?.mainClassId.toString() ?? ""),
        getMainClassifications(editedItem?.subMunicipalityId ?? ""),
        getSubMunicipalities(editedItem?.municipalityId ?? ""),
      ]);
      hideLoading();

      int? serviceId = serviceConfigResponse?.getServiceId();
      if (serviceId != null) {
        await getAvailableDates(serviceId,
            currentDraftTime: editedItem?.visitTime);

        selectedDate = availableDatesResponse?.data?.result?.firstWhere(
            (element) => element.date == editedItem?.getFormattedVisitDate());
        selectedTime = TimeItem(
            timeKey: editedItem?.visitTime,
            timeValue: editedItem?.visitTime,
            availableTime: true);
        saveDate = true;
      }

      notifyListeners();

      notifyListeners();
    }
    /* Future<bool> getServiceConfig(
      String subMunicipalityId, String subClassId)


  Future<bool> getSublassifications(
      String subMunicipalityId, String mainClassId) async {


  Future<bool> getMainClassifications(String subMunicipalityId) async {

  Future<bool> getDepartments(String subMunicipalityId) async {
 Future<bool> getSubMunicipalities(String municipalityId) async {


*/
    return Future.value(false);
  }

  Future<bool> showConfirmationUpdateMessages() async {
    String message = "appointment_no_edits_confirm_msg".tr();

    if (selectedDate?.date == editedItem?.getFormattedVisitDate() &&
        selectedTime?.timeValue == editedItem?.visitTime &&
        selectedMainClassItem?.id == editedItem?.mainClassId &&
        selectedSubClassItem?.id == editedItem?.subClassId) {
      message = "appointment_no_edits_confirm_msg".tr();
    } else if (selectedDate?.date == editedItem?.getFormattedVisitDate() &&
        selectedTime?.timeValue == editedItem?.visitTime &&
        (selectedMainClassItem?.id != editedItem?.mainClassId ||
            selectedSubClassItem?.id != editedItem?.subClassId)) {
      message = "appointment_edit_service_confirm_msg".tr();
    } else if (selectedDate?.date != editedItem?.getFormattedVisitDate() ||
        selectedTime?.timeValue != editedItem?.visitTime) {
      print(selectedDate?.date);
      print(editedItem?.visitDate);

      print(selectedTime?.timeValue);
      print(editedItem?.visitTime);

      message = "appointment_edit_time_confirm_msg"
          .tr()
          .replaceAll("day", selectedDate?.dayName ?? "")
          .replaceAll("date", selectedDate?.date ?? "")
          .replaceAll("hour", selectedTime?.timeValue ?? "");
    }

    return await CustomPopUpsWidgets.showConfirmMessageDialog(
      NavigationService.navigatorKey.currentContext!,
      message,
    );
  }

  bool isRealEstate() {
    return serviceConfigResponse?.data?.result?.firstOrNull?.realEstate == true;
    /*&&
        selectedMunicipalityItem?.id == "-1"*/
  }
}
