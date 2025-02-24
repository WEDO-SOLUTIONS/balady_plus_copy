import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/domain/entities/upload/upload_file_params.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../_shared_feature_/data/entities/validators/desc_validation.dart';
import '../../../../objectable_transactions/domain/entities/attachment_item.dart';
import '../../../../report_damaged_car/domain/use_cases/upload_file.dart';
import '../../../../vd/domain/entities/create_incident/create_incident_params.dart';
import '../../../data/model/create_retrive_car_request.dart';
import '../../../domain/entities/vehicle_item.dart';
import '../../../domain/use_cases/create_retrive_car.dart';
import '../../widgets/create_retrive_car/retreive_car_desc_section.dart';
import '../../widgets/create_retrive_car/retreive_car_information_section.dart';

part 'create_retrive_event.dart';

part 'create_retrive_state.dart';

class CreateRetriveCarBloc
    extends Bloc<CreateRetriveCarEvent, CreateRetriveCarState> {
  PageController controller = PageController();
  late List pagesList = [
    RetreiveCarInformationSection(),
    RetreiveCarDescSection(),
  ];

  final CreateReriveCarRequest _createIncidentRegistered;
  final UploadFile _uploadFile;

  CreateRetriveCarBloc({
    VehicleItem? vehicleItem,
    String? type,
  })  : _createIncidentRegistered = CreateReriveCarRequest(repository: sl()),
        _uploadFile = UploadFile(repository: sl()),
        super(CreateRetriveCarState(
            items: [], vehicleItem: vehicleItem, type: type)) {
    on<CreateRetriveCarEvent>((event, emit) {
      controller.addListener(() {});
    });

    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);

    /*--- Form Fields  Events --- */

    on<ChangeIssueDescEvent>(_changeIssueDescHandler);
    on<ChangeAgreementEvent>(_changeAgreementHandler);
    on<ChangeDateEvent>(_changeDateHandler);

    /*--- Submissions  Events --- */

    on<UploadFileEvent>(_uploadFileHandler);
    on<SubmitIncidentEvent>(_submitIncidentHandler);
    on<CreateIncidentRegisteredEvent>(_createIncidentRegisteredHandler);

    on<DeleteFileEvent>(_deleteFileEventHandler);
  }

  Future<void> _deleteFileEventHandler(
      DeleteFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(clearFile: true));
  }

  Future<void> _changeIssueDescHandler(
      ChangeIssueDescEvent e, Emitter emitter) async {
    emitter(state.copyWith(errorMessage: "", issueDesc: e.text));
  }

  Future<void> _changeAgreementHandler(
      ChangeAgreementEvent e, Emitter emitter) async {
    hideKeyboard();
    emitter(state.copyWith(agreement: e.isagree, errorMessage: ""));
  }

  Future<void> _changeDateHandler(ChangeDateEvent e, Emitter emitter) async {
    hideKeyboard();
    emitter(state.copyWith(date: e.date, errorMessage: ""));
  }

  Future<void> _submitIncidentHandler(
      SubmitIncidentEvent e, Emitter emitter) async {
    if (state.status == BlocStatus.loading) return;
    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));

    if (state.file != null && state.file?.id == null) {
      var failureOrSuccess = await _uploadFile(UploadFileParams(
          attachStream: state.file?.fileBase64,
          filePath: state.file?.filePath));
      await failureOrSuccess.fold((failure) {
        emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) {
        /*List<AttachmentItem> items = state.items.map((e) {
          if (e.index == e.index) {
            e.fileId = success.data?.result?.fileId;
          }
          return e;
        }).toList();*/
        FileDataItem? file =
            state.file?.copyWith(id: success.fileId, isUploaded: true);
        emitter(state.copyWith(
          status: BlocStatus.success,
          file: file,
          errorMessage: "",
        ));
        if (CommonProperties.isLoggedInMunicipality) {
          add(CreateIncidentRegisteredEvent());
        } else {}
      });
    } else {
      if (CommonProperties.isLoggedInMunicipality) {
        add(CreateIncidentRegisteredEvent());
      } else {}
    }
  }

  Future<void> _createIncidentRegisteredHandler(
      CreateIncidentRegisteredEvent e, Emitter emitter) async {
    hideKeyboard();
    emitter(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _createIncidentRegistered(
        CreateRetriveCarRequest(
            applicantNote: state.issueDesc ?? "",
            attachmentID: state.file?.id ?? "",
            expectionVechileDate: state.date?.replaceAll("/", "") ?? "",
            incidentID: state.vehicleItem?.pyId ?? ""));

    failureOrSuccess.fold((failure) {
      ServerFailure serverFailure = (failure as ServerFailure);

      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: serverFailure.errorMessage,
      ));
    }, (success) {
      bool Function(Route<dynamic>) predicate =
          ModalRoute.withName(RouteName.bottomNavigation);

      NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
          RouteName.successRoute, predicate,
          arguments: SuccessScreenArgs(
              type: PAGE_TYPE.vhr,
              fromHomePage: false,
              thanksMessage: success.data?.responseMessage));

      //     Helpers.sendEventToAnalytics(AppEvents.VD_Success_Registered_Submit);
    });
  }

  Future<void> _uploadFileHandler(UploadFileEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    /*  final failureOrSuccess = await _uploadFile(UploadFileParams(
        attachStream: e.params.fileBase64,
        category: "File",
        filePath: e.params.filePath,
        pxAttachName: e.params.fileName,
        pyMemo: e.params.fileName));
*/

    emitter(state.copyWith(
      status: BlocStatus.success,
      file: e.params,
      errorMessage: "",
    ));
/*
    failureOrSuccess.fold((failure) {
      emitter(state.copyWith(
        status: BlocStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) {
      List<AttachmentItem> items = state.items.map((e) {
        if (e.index == e.index) {
          e.fileId = success.data?.result?.fileId;
        }
        return e;
      }).toList();
      emitter(state.copyWith(
        status: BlocStatus.success,
        items: items,
        errorMessage: "",
      ));
    });*/
  }

  void cancelIncident() {
    hideKeyboard();
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

      await controller.animateToPage(nextPage,
          duration: Duration(milliseconds: 400), curve: Curves.easeIn);

      emitter(state.copyWith(
          status: BlocStatus.success, currentPageValue: nextPage));
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
          status: BlocStatus.success, currentPageValue: prvoiusPage));
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
