import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';
import 'package:smart_advisor/app/core/services/services_exports.dart';
import 'package:smart_advisor/app/features/manage_license_flow/data/model/license_details_model.dart'
    hide MainActivity;
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/guest/cancel_license_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/guest/edit_license_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/guest/renwe_license_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/guest/transfar_owner_license_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/main_flow_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/steps/step1.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/cancel_license/cancel_license_page_user.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/cancel_license/delete_license_last_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/edit_license_step/add_activities.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/edit_license_step/delete_activities.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/edit_license_step/edit_license_last_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/edit_license_step/edit_license_page_user.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/edit_license_step/list_of_names_changes.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/edit_license_step/select_activities.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/renew_license_step/renew_license_last_page.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/renew_license_step/renewal_period_page.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/renew_license_step/renwe_license_page_user.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/transfar_owner_license/new_owner_data.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/transfar_owner_license/permit_selection.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/transfar_owner_license/transfar_license_page_user.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/pages/user/transfar_owner_license/transfar_owner_license_user_page.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/widgets/renewal_terms_card.dart';

import 'package:smart_advisor/app/features/map/domain/entities/gis_data_response.dart';
import 'package:smart_advisor/app/features/map/domain/entities/gis_data_request.dart';

import 'package:smart_advisor/app/features/select_activity/domain/entities/activity_details_page_params.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/failures.dart';
import '../../../../../core/utils/utils_exports.dart'
    show BlocStatus, CommonFunctions, RouteName;
import '../../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../../details/data/models/entity_violation_activity_model.dart';
import '../../../../details/data/models/violation_details_vd_model.dart';
import '../../../../details/domain/entities/entity_activity_details_response.dart';
import '../../../../details/domain/entities/entity_violation_activity_request_params.dart';
import '../../../../details/domain/entities/regulation_request_params.dart';
import '../../../../details/domain/entities/regulation_response.dart';
import '../../../../details/domain/entities/violation_details_Vd_request_params.dart';
import '../../../../details/domain/use_cases/get_regulations.dart';
import '../../../../details/domain/use_cases/get_violation_details.dart';
import '../../../../details/domain/use_cases/get_violation_entity_activity_detailes.dart';
import '../../../../details/domain/use_cases/violation_details_vd.dart';
import '../../../../details/presentation/widgets/tabs/third/Details.dart';
import '../../../../map/domain/use_cases/get_gis_data.dart';
import '../../../../select_activity/domain/entities/addetional_activites_response.dart';
import '../../../../select_activity/domain/entities/suggested_area_model.dart';
import '../../../../select_activity/domain/use_cases/get_activity_details_info.dart';
import '../../../../select_activity/domain/use_cases/get_addetional_activites.dart';
import '../../../data/data_sources/remote_data_source.dart';
import '../../../data/model/license_model.dart';
import '../../../data/repository/repository_implementation.dart';
import '../../../domain/entities/commercial_license_model.dart';
import '../../../domain/entities/delegator_entity.dart';
import '../../../domain/entities/license_request_params.dart';
import '../../../domain/repositories/repository.dart';
import '../../../domain/use-cases/cancel_license.dart';
import '../../../domain/use-cases/get_delegators.dart';
import '../../../domain/use-cases/get_license_details.dart';
import '../../../domain/use-cases/get_licenses.dart';
import '../../../domain/use-cases/modify_license.dart';
import '../../../domain/use-cases/renew_license.dart';
import '../../../domain/use-cases/transfer_license.dart';
import '../../pages/steps/step2.dart';

part 'main_flow_event.dart';

part 'main_flow_state.dart';

class ManageMainFlowBloc
    extends Bloc<ManageMainFlowEvent, ManageMainFlowState> {
  ActivityDetailsPageParams? args;

  GetDelegators getDelegators;
  GetLicenses getLicenses;

  final GetLicenseDetails getLicenseDetails;
  final GetRegulationsUc _getRegulationsUc;
  final GetViolationEntityActivityDetailsUC
      _getViolationEntityActivityDetailsUC;

  final GetViolationDetailsUC _getViolationDetails;

  final GetViolationVDUC _getViolationVD;
  final GetActivityDetailsInfo _getActivityDetailsInfo;
  final GetGISDataUC _getGISDataUC;
  final RenewCommercialDraft _renewCommercialDraft;
  final CancelCommercialDraft _cancelCommercialDraft;
  final GetAddetionalActivitesUc _getAddetionalActivites;
  final ModifyCommercialDraft _modifyCommercialDraft;

  final TransferLicenseDraft _transferLicenseDraft;
  bool? isGuest;

  final List<Widget> defaultPage = [const Step1()];

  final List<Widget> renewLicensePagesForUser = [
    const Step1(),
    const CommercialRegisterPageUser(),
    const RenweLicensePageUser(),
    //const RenewalPeriodPage(),
  ];

  final List<Widget> editLicensePagesForUser = [
    const Step1(),
    const CommercialRegisterPageUser(),
    const EditLicensePageUser(),
    // const ListOfNamesChanges(),
    // const SelectActivities(),
    // const AddActivities(),
    // const DeleteActivitives(),
  ];

  final List<Widget> cancelLicensePagesForUser = [
    const Step1(),
    const CommercialRegisterPageUser(),
    const CancelLicensePageUser(),
  ];

  final List<Widget> transfarLicensePagesForUser = [
    const Step1(),
    const CommercialRegisterPageUser(),
    const TransfarLicensePageUser(),
    const PermitSelection(),
    const NewOwnerData(),
  ];

  PageController controller = PageController();

  ManageMainFlowBloc({required this.isGuest})
      : getDelegators = GetDelegators(sl()),
        getLicenses = GetLicenses(sl()),
        getLicenseDetails = GetLicenseDetails(sl()),
        _getActivityDetailsInfo = GetActivityDetailsInfo(repository: sl()),
        _getViolationVD = GetViolationVDUC(repository: sl()),
        _getRegulationsUc = GetRegulationsUc(repository: sl()),
        _getViolationEntityActivityDetailsUC =
            GetViolationEntityActivityDetailsUC(repository: sl()),
        _getViolationDetails = GetViolationDetailsUC(repository: sl()),
        _getGISDataUC = GetGISDataUC(repository: sl()),
        _renewCommercialDraft = RenewCommercialDraft(sl()),
        _cancelCommercialDraft = CancelCommercialDraft(sl()),
        _getAddetionalActivites = GetAddetionalActivitesUc(repository: sl()),
        _modifyCommercialDraft = ModifyCommercialDraft(sl()),
        _transferLicenseDraft = TransferLicenseDraft(sl()),
        super(ManageMainFlowState()) {
    on<NextScreenEvent>(nextScreenHandler);
    on<PrevScreenEvent>(prevScreenHandler);
    on<ChangeValueEvent>(changeValuesHandler);
    on<GetDelegatorsEvent>(getDelegatorsHandler);
    on<GetLicensesEvent>(getLicensesHanlder);
    on<SelectLicenseEvent>(selectLicenseHandler);
    on<GetRegulationsEvent>(_getRegulations);
    on<GetActivityInfoDetails>(getActivityDetails);
    on<GetViolationsListEvent>(_getViolationsList);
    on<GetViolationVD>(_getVDViolation);
    on<GetViolationDetailsEvent>(_getViolationDetailsHanlder);
    on<SelectDelegatorEvent>(selectDelegatorHandler);
    on<GetGISDataEvent>(getGISDataHandler);
    on<SaveRenewDraft>(renewDraft);

    on<SaveCencelDraft>(saveCencelDraft);
    on<GetAddetionalActivites>(getAddetionalActivitesHandler);
    on<AddAddetionalActivityItemEvent>(addAddetionalActivity);
    on<UpdatePermitsInTransferEvent>(updatePermitsHandler);
    if (isGuest == false) {
      add(const GetDelegatorsEvent());
    }

    emit(state.copyWith(step1User: isGuest == true ? 0 : 1));

    print("INNNITS");
  }

  void updatePermitsHandler(
      UpdatePermitsInTransferEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<int> selectedAddetainalActivites = state.selectedTransferPermits ?? [];

    selectedAddetainalActivites.add(event.id);
    emit(state.copyWith(
        status: BlocStatus.success,
        selectedTransferPermits: selectedAddetainalActivites));
  }

  void addAddetionalActivity(
      AddAddetionalActivityItemEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<AddetionalActivityItem> selectedAddetainalActivites =
        state.selectedAddetainalActivites ?? [];

    selectedAddetainalActivites.add(event.addetionalActivityItem);
    emit(state.copyWith(
        status: BlocStatus.success,
        selectedAddetainalActivites: selectedAddetainalActivites));
  }

  void getGISDataHandler(GetGISDataEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getGISDataUC(GISDataRequest(
      lon: event.lon,
      lat: event.lat,
    ));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(status: BlocStatus.closeLoading));
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
            status: BlocStatus.success,
            gisResponse: success,
            request: GISDataRequest(
              lon: event.lon,
              lat: event.lat,
            )));
        args?.gisData = success;

        // add(GetRegulationsEvent());
        add(GetViolationVD());
        add(GetViolationsListEvent());
      },
    );
  }

  void _getRegulations(GetRegulationsEvent event, Emitter emit) async {
    if (state.regulationStatus == BlocStatus.success) return;
    emit(state.copyWith(regulationStatus: BlocStatus.loading));
    final result = await _getRegulationsUc(RegulationRequestParams(
        activityId: args?.activityId?.id ?? 0,
        lat: args?.gisRequest?.lat ?? 0,
        lng: args?.gisRequest?.lon ?? 0,
        serviceType: 1004,
        area: (args?.suggestedArea?.to ?? args?.suggestedArea?.from ?? 0)
            .toDouble()));

    result.fold((failure) {
      emit(state.copyWith(
          regulationStatus: BlocStatus.failure,
          regulationErrorMsg: (failure as ServerFailure).errorMessage));
    }, (success) {
      emit(state.copyWith(
          regulationStatus: BlocStatus.success, regulationResponse: success));
    });
  }

  void _getVDViolation(GetViolationVD event, Emitter emit) async {
    emit(state.copyWith(vdViolationStatus: BlocStatus.loading));
    final result = await _getViolationVD(ViolationDetailsVdRequestParams(
        activityId: args?.activityId?.id ?? 0,
        latitude: args?.gisRequest?.lat ?? 0,
        longitude: args?.gisRequest?.lon ?? 0,
        municipalityId: args?.gisData?.municipalityId ?? "",
        submunicipalityId: args?.gisData?.subMunicipalityId ?? "",
        isVillage: args?.gisData?.isVillage ?? false));

    result.fold((failure) {
      emit(state.copyWith(
          vdViolationStatus: BlocStatus.failure,
          regulationErrorMsg: (failure as ServerFailure).errorMessage));
    }, (success) {
      emit(state.copyWith(
          vdViolationStatus: BlocStatus.success, vdViolationList: success));
    });
  }

  void _getViolationDetailsHanlder(
      GetViolationDetailsEvent event, Emitter emit) async {
    showModalBottomSheet(
      backgroundColor: const Color(0xff000000),
      isScrollControlled: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) => ViolationDetails(
        args: args!,
        linkId: event.item.linkId ?? "",
      ),
    );
  }

  void _getViolationsList(GetViolationsListEvent event, Emitter emit) async {
    if (state.violationStatus == BlocStatus.success) return;
    emit(state.copyWith(violationStatus: BlocStatus.loading));
    final result = await _getViolationEntityActivityDetailsUC(
        EntityViolationActivityRequestParams(
            activityId: args?.activityId?.id ?? 0,
            latitude: args?.gisRequest?.lat ?? 0,
            longitude: args?.gisRequest?.lon ?? 0,
            municipalityId: args?.gisData?.municipalityId ?? "",
            submunicipalityId: args?.gisData?.subMunicipalityId ?? "",
            isVillage: args?.gisData?.isVillage ?? false));

    result.fold((failure) {
      emit(state.copyWith(
          violationStatus: BlocStatus.failure,
          regulationErrorMsg: (failure as ServerFailure).errorMessage));
    }, (success) {
      emit(state.copyWith(
          violationStatus: BlocStatus.success, violations: success));
    });
  }

  void getActivityDetails(GetActivityInfoDetails event, Emitter emit) async {
    emit(state.copyWith(activityDetailsStatus: BlocStatus.loading));

    final failureOrSuccess =
        await _getActivityDetailsInfo(state.selectedLicense?.activityId ?? 0);
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(activityDetailsStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          activityDetailsStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        LookUpItem? selectedActivity = LookUpItem(
            id: state.selectedLicense?.activityId ?? 0,
            name: state.selectedLicense?.activityName ?? "");

        selectedActivity.isATM = success.isAtm;
        selectedActivity.maxArea = (success.maximumArea ?? 0).toDouble();
        selectedActivity.minArea = (success.minimumArea ?? 0).toDouble();

        emit(state.copyWith(
            activityDetailsStatus: BlocStatus.success,
            selectedActivity: selectedActivity));
        args?.activityId = selectedActivity;
        add(GetGISDataEvent(
            lat: args?.gisRequest?.lat ?? 0, lon: args?.gisRequest?.lon ?? 0));
      },
    );
  }

  void nextScreenHandler(NextScreenEvent event, Emitter emit) async {
    int page = state.currentPages;

    if (page == getPageContent().length - 1 || state.step1User == 0) {
      // Renew license for Guest
      if (state.actionNumber == 1 && state.step1User == 0) {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const RenweLicensePage(),
          ),
        );
        return;
      } else if (state.actionNumber == 2 && state.step1User == 0) {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const EditLicensePage(),
          ),
        );
        return;
      } else if (state.actionNumber == 3 && state.step1User == 0) {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const CancelLicensePage(),
          ),
        );
        return;
      } else if (state.actionNumber == 4 && state.step1User == 0) {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => const TransfarOwnerLicensePage(),
          ),
        );
        return;
      }

      // Renew license for User
      else if (state.actionNumber == 1 && state.step1User == 1) {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: this,
              child: RenewLicenseLastPage(
                  isRejectRenew: false,
                  args: ActivityDetailsPageParams(isFromHome: false)),
            ),
          ),
        );
        return;
      } else if (state.actionNumber == 2 && state.step1User == 1) {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: this,
              child: EditLicenseLastPage(
                  isAddOrCancel: state.editSelection == 0 ? false : true,
                  isAdd: state.editSelection == 1 ? true : false),
            ),
          ),
        );
        return;
      } else if (state.actionNumber == 3 && state.step1User == 1) {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: this,
              child: const DeleteLicenseLastPage(),
            ),
          ),
        );
        return;
      } else if (state.actionNumber == 4 && state.step1User == 1) {
        NavigationService.navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(
              value: this,
              child: const TransfarOwnerLicenseUserPage(),
            ),
          ),
        );
        return;
      }
      emit(state.copyWith(
        status: BlocStatus.success,
      ));
    } else {
      page++;

      emit(state.copyWith(currentPages: page));
      controller.jumpToPage(page);
    }
  }

  void prevScreenHandler(PrevScreenEvent event, Emitter emit) async {
    int page = state.currentPages;

    if (page != 0) {
      page--;

      emit(state.copyWith(status: BlocStatus.success, currentPages: page));
      controller.jumpToPage(page);
    } else {
      NavigationService.navigatorKey.currentState!.pop();
    }
  }

  void changeValuesHandler(ChangeValueEvent event, Emitter emit) async {
    emit(state.copyWith(
        currentPages: event.currentPagesNumber,
        step1User: event.step1User,
        actionNumber: event.actionNumber,
        editSelection: event.editSelection,
        isLastTransfarPage: event.isLastTransfarPage,
        isLastRenewPage: event.isLastRenewPage,
        isLastCancelPage: event.isLastCancelPage,
        isLastEditPage: event.isLastEditPage,
        selectedActivity: event.selectedActivity,
        clearDelegate: event.actionNumber != null,
        clearLicense: event.actionNumber != null,
        newCRNumber: event.cr));
  }

  void getDelegatorsHandler(GetDelegatorsEvent event, Emitter emit) async {
    emit(state.copyWith(delegatorsStatus: BlocStatus.loading));

    final failureOrSuccess = await getDelegators(NoParams());
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(delegatorsStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          delegatorsStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
          delegatorsStatus: BlocStatus.success,
          delegators: success,
        ));
      },
    );
  }

  void getAddetionalActivitesHandler(
      GetAddetionalActivites event, Emitter emit) async {
    print("GET Assetional ");
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _getAddetionalActivites(
        state.selectedLicense?.activityId.toString() ?? "");
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(status: BlocStatus.closeLoading));
        emit(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
          status: BlocStatus.success,
          addetainalActivites: success,
        ));
      },
    );
  }

  void selectDelegatorHandler(SelectDelegatorEvent event, Emitter emit) async {
    emit(state.copyWith(
        status: BlocStatus.loading, clearDelegate: true, clearLicense: true));

    emit(state.copyWith(
      status: BlocStatus.success,
      selectedDelegator: event.delegator,
      licenses: [],
    ));
  }

  void selectLicenseHandler(SelectLicenseEvent event, Emitter emit) async {
    emit(state.copyWith(
        licenseDetailsStatus: BlocStatus.loading, clearLicense: true));

    //  emit(state.copyWith(
    //    status: BlocStatus.success, selectedLicense: event.license));

    final failureOrSuccess =
        await getLicenseDetails(event.license.licenseNo.toString());
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(licenseDetailsStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          licenseDetailsStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
            licenseDetailsStatus: BlocStatus.success,
            selectedLicense: event.license,
            selectedLicenseDetails: success));

        args = ActivityDetailsPageParams(
            area: (success.mainActivityArea ?? 0).toDouble(),
            activityId: LookUpItem(
                id: success.activityInfo?.mainActivity?.detailedActivityId ?? 0,
                name:
                    success.activityInfo?.mainActivity?.detailedActivityName ??
                        ""),
            gisRequest: GISDataRequest(
                lat: double.tryParse(success.locationInfo?.latitude ?? "") ?? 0,
                lon: double.tryParse(success.locationInfo?.longitude ?? "") ??
                    0),
            suggestedArea: SuggestedAreaModel(
                from: success.mainActivityArea?.toInt(),
                to: success.mainActivityArea?.toInt(),
                id: 0,
                desc: "",
                isActive: true));

        add(GetActivityInfoDetails());

        add(GetAddetionalActivites());
      },
    );
  }

  void getLicensesHanlder(GetLicensesEvent event, Emitter emit) async {
    emit(state.copyWith(licenseStatus: BlocStatus.loading));

    final failureOrSuccess = await getLicenses(LicenseRequestParams(
        crNumber: state.selectedDelegator?.crNumber ?? "",
        crType: state.selectedDelegator?.crType ?? "",
        licenseType: event.licenseType,
        role: state.selectedDelegator?.getRole() ?? ""));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(delegatorsStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          licenseStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
          licenseStatus: BlocStatus.success,
          licenses: success,
        ));
      },
    );
  }

  void renewDraft(SaveRenewDraft event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess =
        await _renewCommercialDraft(state.selectedLicense?.licenseNo ?? 0);

    failureOrSuccess.fold((l) {
      CommonFunctions.showError((l as ServerFailure).errorMessage);
    }, (r) {
      BaladyServices.navigateToLicense();
      CommonFunctions.showSuccess("تم انشاء الطلب رقم ${r}");
    });

    emit(state.copyWith(status: BlocStatus.success));
  }

  void saveCencelDraft(SaveCencelDraft event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess =
        await _cancelCommercialDraft(state.selectedLicense?.licenseNo ?? 0);

    failureOrSuccess.fold((l) {
      CommonFunctions.showError((l as ServerFailure).errorMessage);
    }, (r) {
      BaladyServices.navigateToLicense();
      CommonFunctions.showSuccess("تم انشاء الطلب رقم ${r}");
    });

    emit(state.copyWith(status: BlocStatus.success));
  }

  void modifyLicenseDraft() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _modifyCommercialDraft((
      state.selectedLicense?.licenseNo ?? 0,
      CommercialLicenseModel(
          /*  activities: Activities(
            addedActivities: state.selectedAddetainalActivites,
            isAtmFeesPaid:
                state.selectedLicenseDetails?.activityInfo?.atmFeesPaid,
            workerTypeId:
                state.selectedLicenseDetails?.activityInfo?.workerTypeId,
            mainActivity: MainActivity(
                detailedActivityId: state.selectedActivity?.id,
                area: state.selectedLicenseDetails?.mainActivityArea),
            shopArea: state.selectedLicenseDetails?.shopMaximumArea),*/
          )
    ));

    failureOrSuccess.fold((l) {
      CommonFunctions.showError((l as ServerFailure).errorMessage);
    }, (r) {
      BaladyServices.navigateToLicense();
      CommonFunctions.showSuccess("تم انشاء الطلب رقم ${r}");
    });

    emit(state.copyWith(status: BlocStatus.success));
  }

  void transfer() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await _transferLicenseDraft((
      state.selectedLicense?.licenseNo ?? 0,
      CommercialLicenseModel(
          crNumber: int.tryParse(state.newCRNumber ?? "") ?? 0,
          permits: state.selectedTransferPermits
          /*  activities: Activities(
            addedActivities: state.selectedAddetainalActivites,
            isAtmFeesPaid:
                state.selectedLicenseDetails?.activityInfo?.atmFeesPaid,
            workerTypeId:
                state.selectedLicenseDetails?.activityInfo?.workerTypeId,
            mainActivity: MainActivity(
                detailedActivityId: state.selectedActivity?.id,
                area: state.selectedLicenseDetails?.mainActivityArea),
            shopArea: state.selectedLicenseDetails?.shopMaximumArea),*/
          )
    ));

    failureOrSuccess.fold((l) {
      CommonFunctions.showError((l as ServerFailure).errorMessage);
    }, (r) {
      BaladyServices.navigateToLicense();
      CommonFunctions.showSuccess("تم انشاء الطلب رقم ${r}");
    });

    emit(state.copyWith(status: BlocStatus.success));
  }

  List<Widget> getPageContent() {
    if (state.actionNumber == 1 && state.step1User == 1) {
      return renewLicensePagesForUser;
    } else if (state.actionNumber == 2 && state.step1User == 1) {
      return editLicensePagesForUser;
    } else if (state.actionNumber == 3 && state.step1User == 1) {
      return cancelLicensePagesForUser;
    } else if (state.actionNumber == 4 && state.step1User == 1) {
      return transfarLicensePagesForUser;
    }

    return defaultPage;
  }
}
