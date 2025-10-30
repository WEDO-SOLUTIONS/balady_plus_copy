import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';

import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../../transaction_inquiry/presentation/core/models/attachment_model.dart';
import '../../../../../transaction_inquiry/presentation/core/models/upload_file_result.dart';
import '../../../../data/models/daem_area_type_response.dart';
import '../../../../data/models/daem_create_ticket.dart';
import '../../../../data/models/daem_issue_type_response.dart';
import '../../../../data/models/daem_item.dart';
import '../../../../data/models/daem_submuncipality.response.dart';
import '../../../pages/new_daem_ticket.dart';
import '../../services/daem_repository.dart';
part 'new_daem_ticket_event.dart';
part 'new_daem_ticket_state.dart';

class NewDaemTicketBloc extends Bloc<NewDaemTicketEvent, NewDaemTicketState> {
  final DaemRepository _repository = DaemRepository();
  PageController controller = PageController();

  late List pagesList = [NewDaemTicket()];

  List<DaemItem> subCategoryTypeList;
  List<DaemItem>? areaList;
  List<DaemItem>? issueypeList;
  List<DaemItem>? municipalities;
  List<DaemItem>? subMunicipalities;

  NewDaemTicketBloc(
      {required DaemItem category,
      DaemItem? subCategory,
      DaemItem? area,
      DaemItem? issue,
      this.areaList,
      this.issueypeList,
      required this.subCategoryTypeList,
      required this.municipalities})
      : super(NewDaemTicketState(
            status: BlocStatus.initial,
            category: category,
            area: area,
            issueType: issue,
            subCategory: subCategory,
            uploadedFiles: [])) {
    on<GetDaemAreaListEvent>(_getAreaListHandler);
    on<GetDaemIssueTypeEvent>(_getIssueTypeListHandler);
    on<SetIssueTypeEvent>(_setIssueType);
    on<GetDaemSubMunicipalitiesEvent>(_getSubMuniciplaittiesHandler);
    on<SetSubMunicipalityEvent>(_setSubMunicipality);
    on<SetDescriptionEvent>(_setDescription);
    on<AddAttachmentFileEvent>(_addAttachmentFile);
    on<DeleteAttachmentFileEvent>(_deleteAttachmentFile);
    on<CreateTicketEvent>(_createTicket);
    on<UploadTicketFilesEvent>(_uploadTicketFiles);
    on<ValidateDaemFormEvent>(_validateForm);
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
  }

  Future<void> _getAreaListHandler(
      GetDaemAreaListEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, DaemAreaTypeResponse?> response =
        await _repository.getDaemAreaList(
            category: e.category.id ?? "", subCategory: e.subCategory.id ?? "");
    emitter(state.copyWith(status: BlocStatus.loaded));
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.areaList != null &&
        response.item3!.areaList!.isNotEmpty) {
      this.areaList = response.item3!.getList();
      this.issueypeList = null;

      emitter(state.copyWith(
          status: BlocStatus.success,
          subCategory: e.subCategory,
          clearArea: true,
          clearIssueType: true));
      add(ValidateDaemFormEvent());
    } else {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: response.item2 ?? ("errors_server_error_1").tr()));
    }
  }

  Future<void> _getIssueTypeListHandler(
      GetDaemIssueTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, DaemIssueTypeResponse?> response =
        await _repository.getDaemIssueTypeList(
            category: e.category.id ?? "",
            subCategory: e.subCategory.id ?? "",
            area: e.area.id ?? "");
    emitter(state.copyWith(status: BlocStatus.loaded));
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.categoryTypeList != null &&
        response.item3!.categoryTypeList!.isNotEmpty) {
      issueypeList = response.item3!.getList();
      DaemItem? issue;
      if (this.issueypeList?.length == 1) {
        issue = this.issueypeList?.first;
      }
      emitter(state.copyWith(
          status: BlocStatus.success,
          area: e.area,
          clearIssueType: issue == null ? true : false,
          issueType: issue));

      add(ValidateDaemFormEvent());
    } else {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: response.item2 ?? ("errors_server_error_1").tr()));
    }
  }

  Future<void> _setIssueType(SetIssueTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.success, issueType: e.issueType));

    add(ValidateDaemFormEvent());
  }

  Future<void> _getSubMuniciplaittiesHandler(
      GetDaemSubMunicipalitiesEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, DaemSubMunicipalityResponse?> response =
        await _repository.getBaladiat(amanaID: e.municipality.id ?? "");
    emitter(state.copyWith(status: BlocStatus.loaded));
    List<DaemItem>? subMunnicipalities = response.item3?.getList();
    if (response.item1 != null &&
        response.item1! &&
        subMunnicipalities != null &&
        subMunnicipalities.isNotEmpty) {
      this.subMunicipalities = subMunnicipalities;
      emitter(state.copyWith(
          status: BlocStatus.success,
          municipality: e.municipality,
          clearSubMunicipality: true));
      add(ValidateDaemFormEvent());
    } else {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: response.item2 ?? ("errors_server_error_1".tr())));
    }
  }

  Future<void> _setSubMunicipality(
      SetSubMunicipalityEvent e, Emitter emitter) async {
    emitter(state.copyWith(
        status: BlocStatus.success, subMunicipality: e.subMunicipality));

    add(ValidateDaemFormEvent());
  }

  Future<void> _setDescription(SetDescriptionEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.success, description: e.text));

    add(ValidateDaemFormEvent());
  }

  Future<void> _createTicket(CreateTicketEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    CommonFunctions.sendUXCamEvent(UXCamEvents.Daem_Send_Request_Event);

    emitter(state.copyWith(status: BlocStatus.loading));

    String category = state.category!.id!;
    String subCategory = state.subCategory!.id!;
    String area = state.area!.id!;
    String issueType = state.issueType!.id!;
    String endUserLocation = state.municipality!.id!;
    String baladiah = state.subMunicipality!.id!;
    String phone = CommonProperties.userInfo?.getPhone() ?? "";
    String description = state.description!;
    String citizenCompanyName = CommonProperties.userInfo?.arName ?? "";
    String IdNumber = CommonProperties.userInfo?.idNo ?? "";
    String contactEmail = CommonProperties.userInfo?.getEmail() ?? "";

    Tuple3<bool?, String?, DaemCreateTicket?> response =
        await _repository.createTicket(
            IdNumber: IdNumber,
            phone: phone,
            citizenCompanyName: citizenCompanyName,
            contactEmail: contactEmail,
            category: category,
            subCategory: subCategory,
            area: area,
            issueType: issueType,
            endUserLocation: endUserLocation,
            baladiah: baladiah,
            description: description);

    emitter(state.copyWith(status: BlocStatus.loaded));
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.incidentId != null &&
        response.item3!.incidentId!.isNotEmpty) {
      emitter(state.copyWith(
          status: BlocStatus.success, daemId: response.item3!.incidentId!));
      add(UploadTicketFilesEvent());
    } else {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: response.item2 ?? ("errors_server_error_1").tr()));
    }
  }

  Future<void> _addAttachmentFile(
      AddAttachmentFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<AttachmentData>? uploadedFiles = state.uploadedFiles;
    uploadedFiles.add(AttachmentData(
        id: e.index.toString(),
        isUploaded: false,
        filePath: e.filePath,
        fileName: e.fileName,
        base64: e.base64,
        isRequired: true,
        title: e.fileName,
        memo: e.fileName));
    emitter(state.copyWith(
        status: BlocStatus.success, uploadedFiles: uploadedFiles));

    add(ValidateDaemFormEvent());
  }

  Future<void> _deleteAttachmentFile(
      DeleteAttachmentFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    List<AttachmentData>? uploadedFiles = state.uploadedFiles;
    uploadedFiles.removeAt(e.index);
    emitter(state.copyWith(
        status: BlocStatus.success, uploadedFiles: uploadedFiles));

    add(ValidateDaemFormEvent());
  }

  Future<void> _uploadTicketFiles(
      UploadTicketFilesEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    emitter(state.copyWith(status: BlocStatus.loading));

    final caseID = state.daemId;
    List<AttachmentData> uploadedFiles = state.uploadedFiles;
    final responses = await Future.wait(uploadedFiles.map(
      (value) async {
        if (value.filePath != null &&
            value.base64 != null &&
            value.isUploaded == false) {
          bool isUploaded = await uploadFile(
            caseID: caseID,
            fileName: value.fileName,
            fileBase64: value.base64,
            fileMemo: value.memo,
            categoery: "Daem",
          );

          int index =
              uploadedFiles.indexWhere((element) => element.id == value.id);
          uploadedFiles[index].isUploaded = isUploaded;

          return isUploaded;
        }
      },
    ));

    if (responses.contains(false)) {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          uploadedFiles: uploadedFiles,
          error: ("problem_in_uploading_files").tr(),
          errorInUploading: true));
    } else {
      emitter(state.copyWith(
          status: BlocStatus.success,
          uploadedFiles: uploadedFiles,
          error: "",
          errorInUploading: false));

      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute,
          ModalRoute.withName(RouteName.bottomNavigation),
          arguments:
              SuccessScreenArgs(type: PAGE_TYPE.daem, idNumber: state.daemId));

      CommonFunctions.sendUXCamEvent(UXCamEvents.Daem_Open_Success_Page_Event);
    }
  }

  Future uploadFile(
      {String? caseID,
      String? fileName,
      String? fileBase64,
      String? fileMemo,
      String? lastMemo,
      String? pyDescription,
      String? categoery}) async {
    Tuple3<bool?, String?, UploadFileResult?> response;
    try {
      response = await _repository.uploadFile(caseID, fileName, fileBase64,
          fileMemo, lastMemo, pyDescription, categoery);

      if (response.item1 == true) {
        return Future.value(true);
      } else {
        response = await _repository.uploadFile(caseID, fileName, fileBase64,
            fileMemo, lastMemo, pyDescription, categoery);
        if (response.item1 == true) {
          return Future.value(true);
        } else {
          return Future.value(false);
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
      return Future.value(false);
    }
  }

  Future<void> _validateForm(ValidateDaemFormEvent e, Emitter emitter) async {
    bool isValid = false;
    if (state.area != null &&
        state.category != null &&
        state.description != null &&
        state.issueType != null &&
        state.municipality != null &&
        state.subCategory != null &&
        state.subMunicipality != null) isValid = true;

    if (state.description != null &&
        !CommonFunctions.doesContainsLettrs(state.description!)) {
      isValid = false;
    }

    emitter(state.copyWith(isFormValid: isValid));
  }

  bool showSubMunicipalityList() {
    return state.municipality != null && (subMunicipalities != null);
  }

  bool showAreaList() {
    return state.subCategory != null && (areaList != null);
  }

  bool showIssueTypeList() {
    return state.area != null && (issueypeList != null);
  }

  void cancelIncident() {
    hideKeyboard(); //MM
    bool Function(Route<dynamic>) predicate =
        ModalRoute.withName(RouteName.bottomNavigation);
    NavigationService.navigatorKey.currentState!.popUntil((predicate));
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));

      if (nextPage == 1) {
        hideKeyboard();
      } else if (nextPage == pagesList.length - 1) {
      } else {
        await controller.animateToPage(nextPage,
            duration: Duration(milliseconds: 400), curve: Curves.easeIn);

        emitter(state.copyWith(
            status: BlocStatus.success, currentPageValue: nextPage, error: ""));
      }
    }
    hideKeyboard();
  }

  Future<void> _goToPreviousPageHandler(
      GoToPreviousPageEvent e, Emitter emitter) async {
    if (state.currentPageValue == 0.0) {
      NavigationService.navigatorKey.currentState!.pop();
    } else {
      if (state.status == BlocStatus.performing) return;
      int prvoiusPage = state.currentPageValue - 1;
      emitter(state.copyWith(
        status: BlocStatus.performing,
      ));
      await controller.animateToPage(prvoiusPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      emitter(state.copyWith(
          status: BlocStatus.success,
          currentPageValue: prvoiusPage,
          error: ""));
    }
    hideKeyboard();
  }

  bool isLastPage() {
    return state.currentPageValue == (pagesList.length - 1);
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
