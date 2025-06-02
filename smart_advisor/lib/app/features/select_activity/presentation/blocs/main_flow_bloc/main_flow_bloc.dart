import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_advisor/app/core/services/local/navigation_services.dart';
import 'package:smart_advisor/app/features/details/domain/entities/entity_activity_details_request_params.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/dialogs/follow_journey.dart';
import 'package:smart_advisor/app/features/map/domain/entities/gis_data_response.dart';
import 'package:smart_advisor/app/features/map/domain/entities/gis_data_request.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/suggested_area_model.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/work_flow_request_params.dart';
import 'package:smart_advisor/app/features/select_activity/domain/use_cases/get_cities.dart';
import 'package:smart_advisor/app/features/select_activity/domain/use_cases/get_districts.dart';
import 'package:smart_advisor/app/features/select_activity/domain/use_cases/get_work_flow.dart';
// import 'package:smart_advisor/app/features/select_activity/presentation/pages/main_flow_page.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/pages/steps/step1.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/pages/steps/step12.dart';
import 'package:smart_advisor/app/features/self_rating/presentation/dialogs/rating_dialog.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

import '../../../../../core/services/local/use_case.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../details/domain/entities/entity_activity_details_response.dart';
import '../../../../details/domain/use_cases/get_entity_activity_details.dart';
import '../../../../manage_license_flow/data/model/license_details_model.dart'
    hide MainActivity;
import '../../../../manage_license_flow/data/model/license_model.dart';
import '../../../../manage_license_flow/domain/entities/commercial_license_model.dart';
import '../../../../manage_license_flow/domain/entities/delegator_entity.dart';
import '../../../../manage_license_flow/domain/entities/license_request_params.dart';
import '../../../../manage_license_flow/domain/use-cases/get_delegators.dart';
import '../../../../manage_license_flow/domain/use-cases/get_license_details.dart';
import '../../../../manage_license_flow/domain/use-cases/get_licenses.dart';
import '../../../../manage_license_flow/domain/use-cases/issue_license.dart';
import '../../../../map/domain/use_cases/get_gis_data.dart';
import '../../../../self_rating/presentation/dialogs/login_dialog.dart';
import '../../../data/models/activity_item_model.dart';
import '../../../data/models/work_flow_model.dart';
import '../../../domain/entities/activity_details_page_params.dart';
import '../../../domain/entities/addetional_activites_response.dart';
import '../../../domain/entities/categories_request_params.dart';
import '../../../domain/entities/isics_request_params.dart';
import '../../../domain/entities/permit_request_params.dart';
import '../../../domain/entities/permits_activites_response.dart';
import '../../../domain/entities/rubrics_request_params.dart';
import '../../../domain/use_cases/get_Isics.dart';
import '../../../domain/use_cases/get_activity_details_info.dart';
import '../../../domain/use_cases/get_addetional_activites.dart';
import '../../../domain/use_cases/get_categories.dart';
import '../../../domain/use_cases/get_permits.dart';
import '../../../domain/use_cases/get_rubrics.dart';
import '../../../domain/use_cases/get_sectors.dart';
import '../../pages/steps/new_select_steps/step1.dart';
import '../../pages/steps/new_select_steps/step2.dart';
import '../../pages/steps/new_select_steps/step3.dart';
import '../../pages/steps/select_license_steps/step1.dart';
import '../../pages/steps/select_license_steps/step2.dart';
import '../../pages/steps/step10.dart';
import '../../pages/steps/step13.dart';
import '../../pages/steps/step2.dart';
import '../../pages/steps/step3.dart';
import '../../pages/steps/step4.dart';
import '../../pages/steps/step5.dart';
import '../../pages/steps/step11.dart';
import '../../pages/steps/step8.dart';
import '../../pages/steps/step6.dart';
import '../../pages/steps/step9.dart';
import '/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/features/select_activity/domain/entities/activites_page_params.dart';
import '/app/features/select_activity/domain/entities/activity_request_params.dart';
import '/app/features/select_activity/domain/entities/isics_page_params.dart';
import '/app/features/select_activity/domain/use_cases/get_activites.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../core/errors/errors_exports.dart' show ServerFailure;

import '../../../../../core/utils/utils_exports.dart'
    show BlocStatus, RouteName;
import 'package:balady_plus/app/features/_shared_feature_/balady_features/services/services.dart';

part 'main_flow_event.dart';

part 'main_flow_state.dart';

class MainFlowBloc extends Bloc<MainFlowEvent, MainFlowState> {
  final List<Widget> steps = [
    const Step1Page(),

    // const RenweLicensePage(),
    // const EditLicensePage(),
    // const TransfarOwnerLicensePage(),
    // const CancelLicensePage(),
    // const Step1(),
    // const MainFlowPageManageLicense(),

    // Step2Page(),
    const NewStep1Page(),
    const NewStep2Page(),
    const NewStep3Page(),
    // Step3Page(), categories
    //Step4Page(),
    // Step5Page(),
    // Step6Page(),
    const Step8Page(),
    Step10Page(),
    const Step9Page(),
    const Step11Page(),
    const Step12page(),
    const Step13page(),
  ];

  final List<Widget> loggedInSteps = [
    SelectDelagatorStep(),
    SelectLicenseStep()
  ];
  PageController controller = PageController();

  final GetActivitesUc _getActivites;
  final GetAddetionalActivitesUc _getAddetionalActivites;
  final GetCategoriesUc _getCategories;
  final GetIsicsUc _getIsics;
  final GetPermitsUc _getPermits;
  final GetRubricsUc _getRubrics;
  final GetSectorUC _getSector;
  final GetCitiesUc _getCitiesUc;
  final GetDistrictsUc _getDistricts;
  final GetWorkFlowUc _getWorkFlowUc;
  final GetEntityActivityDetailssUc _getEntityActivityDetailssUc;
  final GetGISDataUC _getGISDataUC;
  final GetActivityDetailsInfo _getActivityDetailsInfo;
  final GetDelegators getDelegators;
  final GetLicenses getLicenses;
  final GetLicenseDetails getLicenseDetails;
  final IssueCommercialDraft issueCommercialDraft;

  ActivitesPageParams? args;

  MainFlowBloc()
      : _getActivites = GetActivitesUc(repository: sl()),
        _getAddetionalActivites = GetAddetionalActivitesUc(repository: sl()),
        _getCategories = GetCategoriesUc(repository: sl()),
        _getIsics = GetIsicsUc(repository: sl()),
        _getPermits = GetPermitsUc(repository: sl()),
        _getRubrics = GetRubricsUc(repository: sl()),
        _getSector = GetSectorUC(repository: sl()),
        _getCitiesUc = GetCitiesUc(repository: sl()),
        _getDistricts = GetDistrictsUc(repository: sl()),
        _getWorkFlowUc = GetWorkFlowUc(repository: sl()),
        _getGISDataUC = GetGISDataUC(repository: sl()),
        _getActivityDetailsInfo = GetActivityDetailsInfo(repository: sl()),
        _getEntityActivityDetailssUc =
            GetEntityActivityDetailssUc(repository: sl()),
        getDelegators = GetDelegators(sl()),
        getLicenseDetails = GetLicenseDetails(sl()),
        getLicenses = GetLicenses(sl()),
        issueCommercialDraft = IssueCommercialDraft(sl()),
        super(const MainFlowState()) {
    on<GetActivityInfoDetails>(getActivityDetails);
    on<NextPageEvent>(nextPageHandler);
    on<GetGISDataEvent>(getGISDataHandler);

    on<PrevPageEvent>(prevPageHandler);

    on<ChangeValuesEvent>(changeValuesHandler);

    on<GetSectorEvent>((event, emit) async {
      emit(state.copyWith(sectorStatus: BlocStatus.loading));

      final failureOrSuccess = await _getSector(NoParams());
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(sectorStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            sectorStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          emit(state.copyWith(
              sectorStatus: BlocStatus.success, sectors: success.items));
        },
      );
    });

    on<GetCategoriesEvent>((event, emit) async {
      emit(state.copyWith(categoriesStatus: BlocStatus.loading));

      final failureOrSuccess = await _getCategories(CategoriesRequestParams(
        sectorID: state.selectedSector?.id ?? 0,
      ));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(categoriesStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            categoriesStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          emit(state.copyWith(
            categoriesStatus: BlocStatus.success,
            categories: success,
          ));
          emit(state.copyWith(status: BlocStatus.loading));
          int currentPage = state.currentPage + 1;
          if (success.length == 1) {
            currentPage++;
            print("GGSDSDSD $success");
            add(ChangeValuesEvent(selectedCategory: success.first));
            add(const GetActivitesEvent());
          }
          controller.jumpToPage(
            currentPage,
          );
          emit(state.copyWith(
              status: BlocStatus.success, currentPage: currentPage));
        },
      );
    });

    on<GetRubricsEvent>((event, emit) async {
      emit(state.copyWith(rubricsStatus: BlocStatus.loading));

      final failureOrSuccess = await _getRubrics(RubricsRequestParams(
        rubricsID: state.selectedCategory?.id ?? 0,
      ));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(rubricsStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            rubricsStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          emit(state.copyWith(
            rubricsStatus: BlocStatus.success,
            rubrics: success,
          ));
        },
      );
    });

    on<GetIsicsEvent>((event, emit) async {
      emit(state.copyWith(isicsStatus: BlocStatus.loading));

      final failureOrSuccess = await _getIsics(IsicsRequestParams(
          rubricId: state.selectedRubric?.id ?? 0,
          categoryId: state.selectedCategory?.id ?? 0));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(isicsStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            isicsStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          emit(state.copyWith(
            isicsStatus: BlocStatus.success,
            isics: success,
          ));
        },
      );
    });

    on<GetActivitesEvent>((event, emit) async {
      emit(state.copyWith(activitesStatus: BlocStatus.loading));

      final failureOrSuccess = await _getActivites(ActivityRequestParams(
        // isicId: state.selectedIsic?.id ?? 0,
        isicId: state.selectedCategory?.id ?? 0,
      ));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(activitesStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            activitesStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          emit(state.copyWith(
            activitesStatus: BlocStatus.success,
            activites: success,
          ));

          if (success.length == 1) {
            emit(state.copyWith(
              status: BlocStatus.loading,
            ));
            int currentPage = state.currentPage + 1;

            add(ChangeValuesEvent(activity: success.first));
            add(const GetAddetionalActivites());
            controller.jumpToPage(
              currentPage,
            );

            emit(state.copyWith(
                status: BlocStatus.success, currentPage: currentPage));
          }
        },
      );
    });

    on<GetAddetionalActivites>((event, emit) async {
      emit(state.copyWith(addetionalActivitesStatus: BlocStatus.loading));

      final failureOrSuccess = await _getAddetionalActivites(
          state.selectedActivity?.id.toString() ?? "");
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(
              addetionalActivitesStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            addetionalActivitesStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));

          if (failure.errorCode == "2") {
            int currentPage = state.currentPage + 2;

            controller.jumpToPage(
              currentPage,
            );

            emit(state.copyWith(
                status: BlocStatus.success, currentPage: currentPage));
            add(const GetActivityInfoDetails());
          }
        },
        (success) async {
          print(success);

          List<AddetionalActivityItem> res = success ?? [];

          res = success;
          try {
            res = await sortOriginalByCount(res);
          } catch (ex) {}

          emit(state.copyWith(
            addetionalActivitesStatus: BlocStatus.success,
            addetionalActivitesResponse: res,
          ));

          int currentPage = state.currentPage + 1;
          if (success.isEmpty) {
            currentPage++;
            add(const GetPermitsEvent());
          }
          controller.jumpToPage(
            currentPage,
          );

          emit(state.copyWith(
              status: BlocStatus.success, currentPage: currentPage));
        },
      );
    });

    on<GetPermitsEvent>((event, emit) async {
      emit(state.copyWith(permitsStatus: BlocStatus.loading));
      List<AddetionalActivityItem> list = state.addetionalActivitesResponse
              ?.where((element) => (element.isSelected == true))
              .toList() ??
          [];

      List<int> activityIds = list.map((e) => e.activityId).toList();

      activityIds.add(state.selectedActivity?.id ?? 0);

      final failureOrSuccess = await _getPermits(PermitRequestParams(
          activityIds: activityIds,
          latitude: state.request!.lat,
          longitude: state.request!.lon));
      await failureOrSuccess.fold(
        (failure) async {
          print(failure);
          emit(state.copyWith(permitsStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            permitsStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          print(success);
          List<PermitItem> p = [];
          for (int i = 0; i < success.length; i++) {
            success[i].order = i;
            p.add(success[i]);
          }
          emit(state.copyWith(
            permitsStatus: BlocStatus.success,
            permits: p,
          ));
        },
      );
    });

    on<ToggleAddetionalActivity>(toggleAddetional);
    on<TogglePermitEvent>(togglePermits);
    on<GetCitiesEvent>(getCitiesEventHandler);
    on<GetDistricts>(getDistrictsEventHanlder);
    on<GetWorkFlowEvent>(getWorkFlowHandler);
    on<GetDetailsEvent>(getDetailsHandler);

    on<GetDelegatorsEvent>(getDelegatorsHandler);
    on<GetLicensesEvent>(getLicensesHanlder);
    on<SelectLicenseEvent>(selectLicenseHandler);
    on<SelectDelegatorEvent>(selectDelegatorHandler);
    on<ChangeAddetionalActivityEvent>(changeAddetionalActivityArea);

    on<ChangeAreaValueEvent>(changeAreaValue);
    on<ChangeShopAreaValueEvent>(changeShopAreaValue);

    on<ChangeUnitCountEvent>(changeUnitCount);
    on<ChangeAccomodationTypeEvent>(changeAccomodationType);
    on<ChangeWorkerTypeEvent>(changeWorkerType);

    // add(const GetSectorEvent());
    add(const GetCitiesEvent());
    loadData();
    // add(const GetDetailsEvent());
  }

  void changeShopAreaValue(ChangeShopAreaValueEvent event, Emitter emit) async {
    emit(state.copyWith(shopArea: int.tryParse(event.data)));
  }

  void changeAreaValue(ChangeAreaValueEvent event, Emitter emit) async {
    emit(state.copyWith(area: int.tryParse(event.data)));
  }

  void changeAddetionalActivityArea(
      ChangeAddetionalActivityEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<AddetionalActivityItem> addetionalActivitesResponse =
        state.addetionalActivitesResponse ?? [];
    int index = addetionalActivitesResponse
        .indexWhere((e) => e.activityId == event.index);

    addetionalActivitesResponse[index].area = double.tryParse(event.area);
    emit(state.copyWith(
        status: BlocStatus.success,
        addetionalActivitesResponse: addetionalActivitesResponse));
  }

  void changeAccomodationType(
      ChangeAccomodationTypeEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(
        status: BlocStatus.success, acomodationType: event.item));
  }

  void changeWorkerType(ChangeWorkerTypeEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(status: BlocStatus.success, workerType: event.item));
  }

  void changeUnitCount(ChangeUnitCountEvent event, Emitter emit) async {
    emit(state.copyWith(unitCount: event.data));
  }

  void openAddetioanlData() async {
    emit(state.copyWith(status: BlocStatus.loading));

    final failureOrSuccess = await issueCommercialDraft((CommercialLicenseModel(
      site: Site(
          krokiUrl: state.gisResponse?.locationUrl,
          landNumber: state.gisResponse?.parcelNo,
          latitude: state.request?.lat.toString(),
          longitude: state.request?.lon.toString(),
          mapNumber: state.gisResponse?.planNo),
      crNumber: int.tryParse(state.selectedDelegator?.crNumber ?? "") ?? 0,
      crType: int.tryParse(state.selectedDelegator?.crType ?? "") ?? 0,
      activities: Activities(
          unitCount: state.unitCount,
          accommodationTypeId: state.acomodationType?.id,
          addedActivities: state.addetionalActivitesResponse
              ?.where((e) => e.isSelected == true)
              .toList(),
          isAtmFeesPaid: state.atmOption == "ATTACH",
          workerTypeId: state.workerType?.id,
          mainActivity: MainActivity(
              detailedActivityId: state.selectedActivity?.id,
              area: state.getTotalArea()),
          shopArea: state.shopArea),
    )));

    failureOrSuccess.fold((l) {
      CommonFunctions.showError((l as ServerFailure).errorMessage);
    }, (r) async {
      BaladyServices.navigateToLicenseMangments();
      CommonFunctions.showSuccess("تم انشاء الطلب رقم ${r}");
    });

    emit(state.copyWith(status: BlocStatus.success));
  }

  void loadData() async {
    emit(state.copyWith(
      status: BlocStatus.loading,
    ));
    final String isics = await rootBundle.loadString(
        'packages/smart_advisor/smart_advisor_assets/files/ISIC_Count_Sorted.json');
    var data = await json.decode(isics);

    List<ActivityCount> isicsList = [];
    for (var item in data) {
      isicsList.add(ActivityCount.fromJson(item));
    }

    final String isicsDetails = await rootBundle.loadString(
        'packages/smart_advisor/smart_advisor_assets/files/Detailed_Count_Sorted.json');
    var data1 = await json.decode(isicsDetails);

    List<ActivityCount> detailsList = [];
    for (var item in data1) {
      detailsList.add(ActivityCount.fromJson(item));
    }

    final String categories = await rootBundle.loadString(
        'packages/smart_advisor/smart_advisor_assets/files/category_count.json');
    var data2 = await json.decode(categories);

    List<ActivityCount> categoryList = [];
    for (var item in data2) {
      categoryList.add(ActivityCount.fromJson(item));
    }

    emit(state.copyWith(
        status: BlocStatus.success,
        categoryCount: categoryList,
        isicsCount: isicsList,
        detailedCount: detailsList));
  }

  void selectLicenseHandler(SelectLicenseEvent event, Emitter emit) async {
    emit(state.copyWith(licenseDetailsStatus: BlocStatus.loading));

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
        emit(state.copyWith(
            licenseDetailsStatus: BlocStatus.success,
            selectedLicense: event.license,
            selectedLicenseDetails: success));

        add(GetGISDataEvent(
          fromRating: true,
          lat: double.tryParse(success.locationInfo?.latitude ?? "") ?? 0,
          lon: double.tryParse(success.locationInfo?.longitude ?? "") ?? 0,
        ));
      },
    );
  }

  void getActivityDetails(GetActivityInfoDetails event, Emitter emit) async {
    emit(state.copyWith(activityDetailsStatus: BlocStatus.loading));

    final failureOrSuccess =
        await _getActivityDetailsInfo(state.selectedActivity?.id ?? 0);
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
        LookUpItem? selectedActivity = state.selectedActivity;

        selectedActivity?.isATM = success.isAtm;
        selectedActivity?.maxArea = (success.maximumArea ?? 0).toDouble();
        selectedActivity?.minArea = (success.minimumArea ?? 0).toDouble();

        emit(state.copyWith(
            activityDetailsStatus: BlocStatus.success,
            selectedActivity: selectedActivity));

        add(const GetPermitsEvent());
      },
    );
  }

  void getDetailsHandler(GetDetailsEvent event, Emitter emit) async {
    emit(state.copyWith(detailsStatus: BlocStatus.loading));

    final failureOrSuccess = await _getEntityActivityDetailssUc(
        EntityActivityDetailRequestParams(
            mainActivityId: state.selectedActivity?.id ?? 0,
            latitude: state.request?.lat ?? 0,
            longitude: state.request?.lon ?? 0,
            serviceType: 1004,
            shopArea: (state.selectedArea?.to ?? state.selectedArea?.from ?? 0)
                .toDouble()));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(citiesStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          detailsStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
            detailsStatus: BlocStatus.success, details: success));
      },
    );
  }

  void getWorkFlowHandler(GetWorkFlowEvent event, Emitter emit) async {
    emit(state.copyWith(workFlowStatus: BlocStatus.loading));

    final failureOrSuccess = await _getWorkFlowUc(WorkFlowRequestParams(
        activityId: state.selectedActivity?.id ?? 0,
        municipalityId: state.gisResponse?.municipalityuniquecode ?? "",
        area: (state.selectedArea?.to ?? state.selectedArea?.from ?? 0.0)
            .toDouble(),
        x: state.request?.lon ?? 0,
        y: state.request?.lat ?? 0,
        requestTypeId: 1004,
        additionalActivities: state.addetionalActivitesResponse
                ?.where((e) => e.isSelected == true)
                .map((e) => e.activityId.toString())
                .toList() ??
            [],
        entityType: "SHOP",
        contractOption: state.contractOption ?? "",
        contractType: state.contractType ?? "",
        atmFeesOption: state.atmOption));
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(workFlowStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          workFlowStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
          workFlowStatus: BlocStatus.success,
          workFlow: success,
        ));

        NavigationService.navigatorKey.currentState!.pushNamed(
            RouteName.newDetails,
            arguments: ActivityDetailsPageParams(
                mainFlowBloc: this,
                workFlow: success,
                activityId: state.selectedActivity,
                addetionalActivites: state.addetionalActivitesResponse,
                permits: state.permits,
                sector: state.selectedSector,
                gisData: state.gisResponse,
                gisRequest: state.request,
                entityActivityDetailsResponse: state.details,
                suggestedArea: state.selectedArea,
                atmOption: state.atmOption));
      },
    );
  }

  void getCitiesEventHandler(GetCitiesEvent event, Emitter emit) async {
    emit(state.copyWith(citiesStatus: BlocStatus.loading));

    final failureOrSuccess = await _getCitiesUc(NoParams());
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(citiesStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          citiesStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
          citiesStatus: BlocStatus.success,
          cities: success,
        ));
      },
    );
  }

  void getDistrictsEventHanlder(GetDistricts event, Emitter emit) async {
    emit(state.copyWith(districtsStatus: BlocStatus.loading));

    final failureOrSuccess = await _getDistricts(event.city.id);
    await failureOrSuccess.fold(
      (failure) async {
        print(failure);
        emit(state.copyWith(districtsStatus: BlocStatus.closeLoading));
        emit(state.copyWith(
          districtsStatus: BlocStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      },
      (success) async {
        print(success);
        emit(state.copyWith(
            selectedCity: event.city,
            districtsStatus: BlocStatus.success,
            districts: success,
            clearDistrict: true));
      },
    );
  }

  void togglePermits(TogglePermitEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));
    List<PermitItem> addetionalActivitesResponse = state.permits ?? [];

    bool isSelected =
        addetionalActivitesResponse[event.index].isSelected ?? false;
    addetionalActivitesResponse[event.index].isSelected = !isSelected;

    emit(state.copyWith(
        status: BlocStatus.success, permits: addetionalActivitesResponse));
  }

  void toggleAddetional(ToggleAddetionalActivity event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    List<AddetionalActivityItem> addetionalActivitesResponse =
        state.addetionalActivitesResponse ?? [];

    bool isSelected =
        addetionalActivitesResponse[event.index].isSelected ?? false;
    addetionalActivitesResponse[event.index].isSelected = !isSelected;

    emit(state.copyWith(
        status: BlocStatus.success,
        addetionalActivitesResponse: addetionalActivitesResponse));
  }

  void changeValuesHandler(ChangeValuesEvent event, Emitter emit) async {
    emit(state.copyWith(
        selectedCategory: event.selectedCategory,
        selectedRubric: event.selectedRubric,
        selectedSector: event.selectedSector,
        selectedActivity: event.activity,
        selectedIsic: event.isic,
        request: event.gisDataRequest,
        selectedArea: event.selectedArea,
        gisResponse: event.gisDataResponse,
        selectedDistrict: event.district,
        locationOption: event.locationOption,
        contractOption: event.contractOption,
        contractType: event.contractType,
        atmOption: event.atmOption,
        step1Selection: event.step1Selection,
        raingSelectScenario: event.raingSelectScenario));

    if (event.district != null) {}
  }

  void prevPageHandler(PrevPageEvent event, Emitter emit) async {
    /*  if (state.currentPage == 5 && state.step1Selection == 1) {
      int currentPage = state.currentPage - 2;

      controller.jumpToPage(
        currentPage,
      );
      emit(
          state.copyWith(status: BlocStatus.success, currentPage: currentPage));
    } else */
    if (state.currentPage != 0) {
      emit(state.copyWith(status: BlocStatus.loading));

      int currentPage = state.currentPage - 1;
      controller.jumpToPage(
        currentPage,
      );

      emit(
          state.copyWith(status: BlocStatus.success, currentPage: currentPage));
    }
  }

  void showRatingLoggedIn() async {
    NavigationService.navigatorKey.currentState?.pop();
    await showModalBottomSheet(
      backgroundColor: const Color(0xff000000),
      isScrollControlled: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext ctx) {
        return RatingDialog(
            isGuest: false,
            onSelection: () async {
              add(ChangeValuesEvent(raingSelectScenario: 1));
            });
      },
    );
  }

  void showRatingNotLoggedIn() async {
    NavigationService.navigatorKey.currentState?.pop();
    await showModalBottomSheet(
      backgroundColor: const Color(0xff000000),
      isScrollControlled: true,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext ctx) {
        return RatingDialog(
            isGuest: true,
            onSelection: () async {
              int currentPage = state.currentPage + 1;
              controller.jumpToPage(
                currentPage,
              );
              emit(state.copyWith(
                  status: BlocStatus.success, currentPage: currentPage));

              add(const GetSectorEvent());
            });
      },
    );
  }

  void nextPageHandler(NextPageEvent event, Emitter emit) async {
    if (state.step1Selection == 1 &&
        state.currentPage == 0 &&
        state.raingSelectScenario == null) {
      await showModalBottomSheet(
        backgroundColor: const Color(0xff000000),
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext ctx) {
          return LoginDialog(onSelection: (bool isLogin) async {
            if (isLogin) {
              showRatingLoggedIn();
            } else {
              showRatingNotLoggedIn();
              add(ChangeValuesEvent(raingSelectScenario: 2));
            }
          });
        },
      );

      /*  await showModalBottomSheet(
        backgroundColor: const Color(0xff000000),
        isScrollControlled: true, 
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext ctx) {
          return RatingDialog(onSelection: () async {
            add(const GetSectorEvent());

            int currentPage = state.currentPage + 1;
            controller.jumpToPage(
              currentPage,
            );
            emit(state.copyWith(
                status: BlocStatus.success, currentPage: currentPage));
          });
        },
      );*/
    } else if (state.step1Selection == 2 && state.currentPage == 0) {
      await showModalBottomSheet(
        backgroundColor: const Color(0xff000000),
        isScrollControlled: true,
        context: NavigationService.navigatorKey.currentContext!,
        builder: (BuildContext ctx) {
          return FollowJourney(onSelection: () async {
            // add(const GetSectorEvent());

            int currentPage = state.currentPage + 1;
            controller.jumpToPage(
              currentPage,
            );
            emit(state.copyWith(
                status: BlocStatus.success, currentPage: currentPage));
          });
        },
      );
    } else if (state.currentPage == 1 && getStepsPages().length != 2) {
      add(const GetCategoriesEvent());
    }
    /*else if (state.currentPage == 3 && state.step1Selection == 1) {
      int currentPage = state.currentPage + 2;

      controller.jumpToPage(
        currentPage,
      );
      emit( 
          state.copyWith(status: BlocStatus.success, currentPage: currentPage));
    }*/
    else if ((state.currentPage == 3 && state.step1Selection == 1) ||
        ((state.currentPage == 1 &&
            state.step1Selection == 1 &&
            state.raingSelectScenario == 1 &&
            (state.selectedLicense != null)))) {
      NavigationService.navigatorKey.currentState!
          .pushNamed(RouteName.ratingItemsPage,
              arguments: ActivityDetailsPageParams(
                workFlow: [],
                isFromHome: true,
                activityId: state.selectedActivity ??
                    LookUpItem(
                        id: state.selectedLicense?.activityId ?? 0,
                        name: state.selectedLicense?.activityName ?? ""),
                gisData: state.gisResponse,
                licenseNo: state.selectedLicense?.licenseNo,
                gisRequest: state.request,
              ));
    } else if (state.currentPage == 3 && state.step1Selection == 0) {
      add(const GetAddetionalActivites());
    } else if (state.currentPage == steps.length - 1) {
      add(const GetWorkFlowEvent());
    } else if (state.selectedActivity?.isATM != true &&
        state.currentPage == steps.length - 2) {
      add(const GetWorkFlowEvent());
    } else {
      emit(state.copyWith(status: BlocStatus.loading));

      int currentPage = state.currentPage + 1;

      if (state.selectedActivity?.isATM != true && state.currentPage == 9) {
        currentPage++;
      }
      controller.jumpToPage(
        currentPage,
      );
      print("GGGGGGG ${currentPage}");
      if (currentPage == 1) {
        add(const GetSectorEvent());
      }

      if (currentPage == 3) {
        add(const GetActivitesEvent());
      }
      //if (currentPage == 4) {}
      if (currentPage == 6) {
        add(const GetActivityInfoDetails());
      }
      emit(
          state.copyWith(status: BlocStatus.success, currentPage: currentPage));
    }
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
      },
    );
  }

  String getTitle() {
    switch (state.currentPage) {
      case 0:
        return "الرخص التجارية للمحلات/المنشاَت";
      case 1:
        return "فتح محل / منشأة تجارية";
      case 2:
        return state.selectedSector?.name ?? "";
      case 3:
        return state.selectedCategory?.name ?? "";
        {}
      case 4:
        return state.selectedActivity?.name ?? "";
      case 5:
        return "تفاصيل الموقع";
      case 6:
        return "فتح محل/منشأة تجارية";
      case 7:
        return "فتح محل/منشأة تجارية";
      case 8:
        return "فتح محل/منشأة تجارية";
      case 9:
        return "فتح محل/منشأة تجارية";
      default:
        return "فتح محل/منشأة تجارية";
    }
  }

  Future<List<AddetionalActivityItem>> sortOriginalByCount(
      List<AddetionalActivityItem> originalList) async {
    final String isicsDetails = await rootBundle.loadString(
        'packages/smart_advisor/smart_advisor_assets/files/Detailed_Count_Sorted.json');
    var data1 = await json.decode(isicsDetails);

    List<ActivityCount> detailsList = [];
    for (var item in data1) {
      detailsList.add(ActivityCount.fromJson(item));
    }

    final countMap = {for (var item in detailsList) item.id: item.count};

    // Sort the original list based on the count in countMap
    return originalList.toList()
      ..sort((a, b) {
        final countA =
            countMap[a.activityId] ?? 0; // Default to 0 if id is not found
        final countB = countMap[b.activityId] ?? 0;
        return countB.compareTo(countA); // Sort in descending order by count
      });
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

  void selectDelegatorHandler(SelectDelegatorEvent event, Emitter emit) async {
    emit(state.copyWith(status: BlocStatus.loading));

    emit(state.copyWith(
        status: BlocStatus.success,
        selectedDelegator: event.delegator,
        licenses: []));
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

  List<Widget> getStepsPages() {
    if (state.step1Selection == 1 && state.raingSelectScenario == 1) {
      return loggedInSteps;
    }

    return steps;
  }
}
