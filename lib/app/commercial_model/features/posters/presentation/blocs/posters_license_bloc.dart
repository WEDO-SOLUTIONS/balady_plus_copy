import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/commercial_model/features/posters/data/models/permit_poster_types_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:balady_plus/app/core/utils/extensions/date_time_extension.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/nullable.dart';
import 'package:collection/collection.dart';

import '../../data/models/allowed_actions_response.dart';
import '../../data/models/attachment_resposne_model.dart';
import '../../data/models/group_item_response_model.dart';
import '../../data/models/permit_license_response_model.dart';
import '../../data/models/permits_alerts_response.dart';
import '../../data/models/poster_request_details_model.dart' hide Poster;
import '../../data/models/posters_upload_response_model.dart';
import '../../domain/entities/permit_apply_group_request_params.dart';
import '../../domain/entities/permit_licenses_requests_params.dart';
import '../../domain/entities/permit_required_types_params.dart';
import '../../domain/entities/poster_item.dart';
import '../../domain/entities/save_poster_request_params.dart';
import '../../domain/use_case/add_indivisual_requests.dart';
import '../../domain/use_case/apply_permit_group.dart';
import '../../domain/use_case/apply_poster_licnse.dart';
import '../../domain/use_case/delete_license_from_request.dart';
import '../../domain/use_case/delete_poster_request.dart';
import '../../domain/use_case/get_groups_items.dart';
import '../../domain/use_case/get_license_permits.dart';
import '../../domain/use_case/get_permit_attachments.dart';
import '../../domain/use_case/get_poster_allowed_actions.dart';
import '../../domain/use_case/get_poster_request_details.dart';
import '../../domain/use_case/get_poster_types.dart';
import '../../domain/use_case/get_posters_alerts.dart';
import '../../domain/use_case/poster_submit.dart';
import '../../domain/use_case/save_poster.dart';
import '../../domain/use_case/upload_poster_file.dart';
import '../pages/steps/step1_page.dart';
import '../pages/steps/step2_page.dart';
import '../pages/steps/step3_page.dart';
import '../widgets/steps/step2/poster_item_widget.dart';

import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';

part 'posters_license_event.dart';
part 'posters_license_state.dart';

class PostersLicenseBloc
    extends Bloc<PostersLicenseEvent, PostersLicenseState> {
  PageController controller = PageController();
  ApplyPermitLicenseGroup _applyPermitLicenseGroup;
  GetGroupItems _getGroupItems;
  GetLicensePermits _getLicensePermits;
  GetAttachmentTypes _getAttachmentTypes;
  GetPermitPosterTypes _getPermitPosterTypes;
  SavePoster _savePoster;
  UploadPosterFile _uploadPosterFile;
  AddIndividualRequests _addIndividualRequests;
  PosterSubmit _posterSubmit;
  GetPosterRequestDetails _getPosterRequestDetails;
  DeletePosterRequest _deletePosterRequest;
  DeleteLicenseFromRequest _deleteLicenseFromRequest;
  GetPostersAlerts _getPostersAlerts;
  ApplyPosterLicense _applyPosterLicense;
  GetPosterAllowedActions _getPosterAllowedActions;
  PostersLicenseBloc(
      {int? groupId,
      int? licenseId,
      PermitsLicensesItem? selectedLicense,
      int? requestId})
      : _applyPermitLicenseGroup = ApplyPermitLicenseGroup(repository: sl()),
        _getGroupItems = GetGroupItems(repository: sl()),
        _getLicensePermits = GetLicensePermits(repository: sl()),
        _getAttachmentTypes = GetAttachmentTypes(repository: sl()),
        _getPermitPosterTypes = GetPermitPosterTypes(repository: sl()),
        _savePoster = SavePoster(repository: sl()),
        _uploadPosterFile = UploadPosterFile(repository: sl()),
        _addIndividualRequests = AddIndividualRequests(repository: sl()),
        _posterSubmit = PosterSubmit(repository: sl()),
        _getPosterRequestDetails = GetPosterRequestDetails(repository: sl()),
        _deletePosterRequest = DeletePosterRequest(repository: sl()),
        _deleteLicenseFromRequest = DeleteLicenseFromRequest(repository: sl()),
        _getPostersAlerts = GetPostersAlerts(repository: sl()),
        _applyPosterLicense = ApplyPosterLicense(repository: sl()),
        _getPosterAllowedActions = GetPosterAllowedActions(repository: sl()),
        super(PostersLicenseState(
            groupId: groupId,
            requestId: requestId,
            licenseId: licenseId,
            searchedParams: PermitLicenseRequestParams(
                page: 0,
                size: 30,
                crNumber: CommonProperties.selectedDelegator?.crNumber,
                groupId: groupId.toString()),
            selectedLicenses:
                selectedLicense != null ? [selectedLicense] : null)) {
    on<GoToNextPageEvent>(_goToNextPageHandler);
    on<GoToPreviousPageEvent>(_goToPreviousPageHandler);
    on<GetLicensePermitsEvents>(_getLicensePermitsHandler);

    on<ChangePermitStartDate>(_updateStartDateHandler);

    on<ChangePermitDurationEvent>(_updateDurationHandler);
    on<GetPosterTypesEvent>(_getPosterTypesHandler);

    on<AddPosterItemEvent>(_updatePostersHandler);

    on<UpdatePermitsLicenses>(_updateLicnsesHandler);
    on<ApplyPosterGroupEvent>(_applyPostersGroupHandler);
    on<SavePostersInfo>(_savePostersInfo);
    on<SubmitPosterEvent>(_submitPosterHandler);
    on<AddIndividualRequestsEvent>(_addIndividualRequestsHandler);
    on<GetPosterRequestDetailsEvent>(_getRequestDetails);
    on<GetPostersGroupsEvent>(_getGroupsItemsHandler);
    on<GetPostersAlertsEvent>(_getPostersAlertsHandler);
    on<DeleteLicenseFromRequestEvent>(_deleteLicsnseHandler);
    on<DeletePosterEvent>(_deletePosterEvent);
    on<ApplyLicenseEvent>(_applyLicenseHandler);
    on<DeletePosterRequestEvent>(_deleteRequestsHandler);
    on<ToggleAgreementEvent>(_toggleAgreementHandler);
    on<GetMoreLicensesEvent>(_getMoreSearchEventsHandler);

    add(const GetPosterTypesEvent());
    add(const GetPostersAlertsEvent());
  }

  Future<void> _toggleAgreementHandler(
      ToggleAgreementEvent e, Emitter emitter) async {
    emitter(state.copyWith(agreement: e.agreement));
  }

  Future<void> _deleteRequestsHandler(
      DeletePosterRequestEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _deletePosterRequest(state.requestId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success));
      add(GetPosterRequestDetailsEvent());
    });
  }

  Future<List<AllowedActionItem>?> getAllowedActions() async {
    emit(state.copyWith(status: BlocStatus.loading, error: ""));

    return (await _getPosterAllowedActions(state.requestId!)).fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) async {
      emit(state.copyWith(status: BlocStatus.success, error: ""));

      return r.result ?? [];
    });
  }

  Future<void> _applyLicenseHandler(
      ApplyLicenseEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _applyPosterLicense(state.licenseId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success, requestId: Nullable(r.requestId)));

      NavigationService.navigatorKey.currentState!
          .pushNamed(CommercialRouteName.postersDetailsPage, arguments: this);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.startServiceIndivisualPostersPermit);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Posters_Open_Create_Details_For_License_Event);
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Posters_Open_licenses_Step_For_License_Event);
    });
  }

  Future<void> _deletePosterEvent(DeletePosterEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<PosterItem> items = state.posters ?? [];

    items.removeAt(e.index);
    emitter(state.copyWith(status: BlocStatus.success, posters: items));
  }

  Future<void> _deleteLicsnseHandler(
      DeleteLicenseFromRequestEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _deleteLicenseFromRequest(
        (state.requestId!, state.selectedLicenses![e.index].licenseId!));

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      List<PermitsLicensesItem>? selectedLicenses =
          state.selectedLicenses ?? [];

      selectedLicenses.removeAt(e.index);

      emitter(state.copyWith(
          status: BlocStatus.success, selectedLicenses: selectedLicenses));
    });
  }

  Future<void> _getPostersAlertsHandler(
      GetPostersAlertsEvent e, Emitter emitter) async {
    emitter(state.copyWith(alertsStatus: BlocStatus.loading));
    final failOrSuccess = await _getPostersAlerts(NoParams());

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          alertsStatus: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(
          state.copyWith(alertsStatus: BlocStatus.success, alerts: r.result));
    });
  }

  Future<void> _updateLicnsesHandler(
      UpdatePermitsLicenses e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<PermitsLicensesItem> items = e.selectedValues;

    emitter(
        state.copyWith(status: BlocStatus.success, selectedLicenses: items));
  }

  Future<List<PermitAttachmentItem>?> getAttachments(int typeId) async {
    return (await _getAttachmentTypes(PermitRequiredTypesParams(
            typeId: typeId, requestId: state.requestId)))
        .fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) async => r.result ?? []);
  }

  Future<PostersUploadResponse?> uploadAttachment(
      PermitAttachmentItem item) async {
    emit(state.copyWith(status: BlocStatus.loading, error: ""));
    return (await _uploadPosterFile(item.copyWith(requestId: state.requestId)))
        .fold((l) {
      emit(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) async {
      emit(state.copyWith(status: BlocStatus.success, error: ""));
      return r;
    });
  }

  Future<void> _updatePostersHandler(
      AddPosterItemEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    List<PosterItem> posters = state.posters ?? [];

    if (e.index != null) {
      posters[e.index!] = e.item;
    } else {
      posters.add(e.item);
    }
    emitter(state.copyWith(status: BlocStatus.success, posters: posters));
  }

  Future<void> _getRequestDetails(
      GetPosterRequestDetailsEvent e, Emitter emitter) async {
    emitter(state.copyWith(detailsStatus: BlocStatus.loading));
    final failOrSuccess = await _getPosterRequestDetails(state.requestId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          detailsStatus: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(
          state.copyWith(detailsStatus: BlocStatus.success, requestDetails: r));
    });
  }

  Future<void> _getGroupsItemsHandler(
      GetPostersGroupsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _getGroupItems(NoParams());

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(
          state.copyWith(status: BlocStatus.success, permitGroups: r.result));
    });
  }

  Future<void> _submitPosterHandler(
      SubmitPosterEvent e, Emitter emitter) async {
    if (state.licenseId == null) {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Posters_Send_Request_For_Multiple_Event);
    } else {
      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Posters_Send_Request_For_License_Event);
    }

    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _posterSubmit(state.requestId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success));
      if (e.editMode) {
        add(GetPosterRequestDetailsEvent());

        NavigationService.navigatorKey.currentState!.pop();
      } else {
        r.isGrouped = state.licenseId == null;
        NavigationService.navigatorKey.currentState!.popAndPushNamed(
          CommercialRouteName.submitApplicationSuccessfullyPosters,
          arguments: r,
        );

        if (r.isGrouped) {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceMultiplePostersPermit);

          CommonFunctions.sendUXCamEvent(
              UXCamEvents.Posters_Open_Success_Page_For_Multiple_Event);
        } else {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceIndivisualPostersPermit);

          CommonFunctions.sendUXCamEvent(
              UXCamEvents.Posters_Open_Success_Page_For_License_Event);
        }
      }
    });
  }

  Future<void> _addIndividualRequestsHandler(
      AddIndividualRequestsEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _addIndividualRequests(state.requestId!);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success));
      add(GoToNextPageEvent());
    });
  }

  Future<void> _savePostersInfo(SavePostersInfo e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _savePoster(SavePosterRequestParams(
        requestId: state.requestId.toString(),
        duration: int.tryParse(state.duration ?? ""),
        permitStartDate: CommonFunctions.padHijriDate(state.startDate),
        posters: state.posters
            ?.map((e) => Poster(
                attachedDocuments:
                    e.attachedDocuments?.map((e) => e.key ?? "").toList() ?? [],
                length: e.length,
                width: e.width,
                typeId: e.posterType?.id,
                discountPercentage: e.discountPercentage,
                name: e.name))
            .toList()));

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
        status: BlocStatus.success,
      ));

      add(const GoToNextPageEvent());
    });
  }

  Future<void> _applyPostersGroupHandler(
      ApplyPosterGroupEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _applyPermitLicenseGroup(
        PermitApplyGroupRequestParams(
            licenses: state.selectedLicenses?.map((e) => e.licenseId!).toList(),
            crType: int.tryParse(CommonProperties.selectedDelegator!.crType),
            crNumber: CommonProperties.selectedDelegator?.crNumber));

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
          status: BlocStatus.success, requestId: Nullable(r.requestId)));
      NavigationService.navigatorKey.currentState!
          .pushNamed(CommercialRouteName.postersStartService, arguments: this);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.startServiceMultiplePostersPermit);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Posters_Open_Create_Details_For_Multiple_Event);

      CommonFunctions.sendUXCamEvent(
          UXCamEvents.Posters_Open_licenses_Step_For_Multiple_Event);
    });
  }

  Future<void> _getLicensePermitsHandler(
      GetLicensePermitsEvents e, Emitter emitter) async {
    print("GG");
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _getLicensePermits(state.searchedParams);

    failOrSuccess.fold((l) {
      print(l);
      emitter(state.copyWith(
          status: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      print(r);
      emitter(state.copyWith(
        permitsLiceses: r.result,
        status: BlocStatus.success,
        searchedParams: state.searchedParams
            .copyWith(page: (state.searchedParams.page ?? 0) + 1),
      ));
    });
  }

  Future<void> _getPosterTypesHandler(
      GetPosterTypesEvent e, Emitter emitter) async {
    emitter(state.copyWith(posterTypesStatus: BlocStatus.loading));
    final failOrSuccess = await _getPermitPosterTypes(NoParams());

    failOrSuccess.fold((l) {
      emitter(state.copyWith(
          posterTypesStatus: BlocStatus.failure,
          error: (l as ServerFailure).errorMessage));
    }, (r) {
      emitter(state.copyWith(
        posterTypes: r.result,
        posterTypesStatus: BlocStatus.success,
      ));
    });
  }

  Future<void> _goToNextPageHandler(
      GoToNextPageEvent e, Emitter emitter) async {
    if (isLastPage()) {
    } else {
      if (state.status == BlocStatus.performing) return;
      int nextPage = state.currentPageValue + 1;

      emitter(state.copyWith(status: BlocStatus.performing, error: ""));

      controller.jumpToPage(nextPage);
      sendNextPageEvent(nextPage);
      emitter(state.copyWith(
          error: "", status: BlocStatus.success, currentPageValue: nextPage));
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
      emitter(state.copyWith(status: BlocStatus.performing, error: ""));
      controller.jumpToPage(prvoiusPage);
      sendNextPageEvent(prvoiusPage);

      emitter(state.copyWith(
          error: "",
          status: BlocStatus.success,
          currentPageValue: prvoiusPage));
    }
    hideKeyboard();
  }

  Future<void> _getMoreSearchEventsHandler(
      GetMoreLicensesEvent e, Emitter emitter) async {
    print("Called 12");
    emitter(state.copyWith(
      status: BlocStatus.loadMore,
    ));
    print("Called 333");

    final failureOrSuccess = await _getLicensePermits(state.searchedParams);
    print("Called 444");

    failureOrSuccess.fold((l) {
      /* if (l == NoDataFoundFailure())
        emitter(
          state.copyWith(status: BlocStatus.failure, error: ""),
        );
      else {*/

      print("Called 1555 $l");

      emitter(
        state.copyWith(
            status: BlocStatus.failure,
            error: (l as ServerFailure).errorMessage),
      );
      //   }
    }, (r) {
      print("Called 666");

      List<PermitsLicensesItem>? items = state.permitsLiceses ?? [];
      items.addAll(r.result ?? []);
      emitter(state.copyWith(
        status: BlocStatus.success,
        permitsLiceses: items,
        searchedParams: state.searchedParams
            .copyWith(page: (state.searchedParams.page ?? 0) + 1),
        error: "",
      ));
    });
  }

  bool isLastPage() {
    return state.currentPageValue == (state.pagesList.length - 1);
  }

  Future<void> _updateStartDateHandler(
      ChangePermitStartDate e, Emitter emitter) async {
    emitter(state.copyWith(startDate: e.date, error: ""));
  }

  Future<void> _updateDurationHandler(
      ChangePermitDurationEvent e, Emitter emitter) async {
    emitter(state.copyWith(duration: e.value, error: ""));
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void sendNextPageEvent(int page) {
    String eventName = "";
    if (page == 0) {
      if (state.licenseId == null) {
        eventName = UXCamEvents.Posters_Open_licenses_Step_For_Multiple_Event;
      } else {
        eventName = UXCamEvents.Posters_Open_licenses_Step_For_License_Event;
      }
    } else if (page == 1) {
      if (state.licenseId == null) {
        eventName =
            UXCamEvents.Posters_Open_Posters_Data_Step_For_Multiple_Event;
      } else {
        eventName =
            UXCamEvents.Posters_Open_Posters_Data_Step_For_License_Event;
      }
    } else if (page == 2) {
      if (state.licenseId == null) {
        eventName = UXCamEvents.Posters_Open_Review_Step_For_Multiple_Event;
      } else {
        eventName = UXCamEvents.Posters_Open_Review_Step_For_License_Event;
      }
    }

    CommonFunctions.sendUXCamEvent(eventName);
  }
}
