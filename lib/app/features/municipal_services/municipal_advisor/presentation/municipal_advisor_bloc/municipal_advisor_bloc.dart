import 'dart:async';

import 'package:balady_plus/app/features/municipal_services/municipal_advisor/domain/use_cases/get_building_complince.dart';
import 'package:balady_plus/app/features/municipal_services/municipal_advisor/domain/use_cases/get_gis_image.dart';
import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:collection/collection.dart';

import '../../../../../../etmam_app/core/dependency_injection/injection_container.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../vd/vd_exports.dart' show GISParams, GISResponse, GetGISData;
import '../../domain/entities/building_compliance_entity.dart';
import '../../domain/entities/civil_defence_entity.dart';
import '../../domain/entities/validate_additional_activities_params.dart';
import '../../domain/use_cases/get_civil_defense_conditions.dart';
import '../../domain/use_cases/validate_addetional_activites.dart';
import '../../municipal_advisor_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

part 'municipal_advisor_event.dart';

part 'municipal_advisor_state.dart';

class MunicipalAdvisorBloc
    extends Bloc<MunicipalAdvisorEvent, MunicipalAdvisorState> {
  final GetConsultationKey _getConsultationKey;
  final GetIsicActivities _getIsicActivities;
  final GetIsicSubActivities _getIsicSubActivities;
  final GetAdditionalActivities _getAdditionalActivities;
  final GetActivityDetails _getActivityDetails;
  final SaveAdditionalActivities _saveAdditionalActivities;
  final GetGISData _getGISData;
  final GetCivilDefensePredefinedConditions
      _getCivilDefensePredefinedConditions;
  final GetCleaningMechanisms _getCleaningMechanisms;
  final GetCommercialOffices _getCommercialOffices;
  final GetEngineeringOffices _getEngineeringOffices;
  final GetIssuingPredefinedConditions _getIssuingPredefinedConditions;
  final GetLicensePermits _getLicensePermits;
  final GetSupervisingAuthorities _getSupervisingAuthorities;
  final SaveConsultationProgress _saveConsultationProgress;
  final GetAccommodationTypes _getAccommodationTypes;
  final SaveActivities _saveActivities;
  final GetLicenseYears _getLicenseYears;
  final GetBoardTypes _boardTypes;
  final CalculateLicenseFees _calculateLicenseFees;
  final SaveFinancialStudy _saveFinancialStudy;
  final GetShopOwnership _getShopOwnership;
  final GetConsultationAttachments _getConsultationAttachments;
  final GetMaxLicenseYears _getMaxLicenseYears;
  final GetConditionsUrls _getConditionsUrls;
  final GetFastflowConditions _getFastflowConditions;
  final GetRequestFlow _getRequestFlow;
  final GetRequestFlowRecommendations _getRequestFlowRecommendations;
  final UpdatePermit _updatePermit;
  final SaveInteractiveInfo _saveInteractiveInfo;
  final SubmitConsultation _submitConsultation;
  final GetBuildingCompliance _getBuildingCompliance;
  final GetGISImage _getGisImage;
  final GetCivilDefenseConditions _getCivilDefenseConditions;
  final ValidateAddetionalActivites _validateAddetionalActivites;

  MunicipalAdvisorBloc({
    required GetConsultationKey getConsultationKey,
    required GetIsicActivities getIsicActivities,
    required GetIsicSubActivities getIsicSubActivities,
    required GetAdditionalActivities getAdditionalActivities,
    required GetActivityDetails getActivityDetails,
    required GetGISData getGISData,
    required SaveAdditionalActivities saveAdditionalActivities,
    required GetCivilDefensePredefinedConditions
        getCivilDefensePredefinedConditions,
    required GetCleaningMechanisms getCleaningMechanisms,
    required GetCommercialOffices getCommercialOffices,
    required GetEngineeringOffices getEngineeringOffices,
    required GetIssuingPredefinedConditions getIssuingPredefinedConditions,
    required GetLicensePermits getLicensePermits,
    required GetSupervisingAuthorities getSupervisingAuthorities,
    required SaveConsultationProgress saveConsultationProgress,
    required GetAccommodationTypes getAccommodationTypes,
    required SaveActivities saveActivities,
    required GetLicenseYears getLicenseYears,
    required GetBoardTypes boardTypes,
    required CalculateLicenseFees calculateLicenseFeed,
    required SaveFinancialStudy saveFinancialStudy,
    required GetShopOwnership getShopOwnership,
    required GetConsultationAttachments getConsultationAttachments,
    required GetMaxLicenseYears getMaxLicenseYears,
    required GetConditionsUrls getConditionsUrls,
    required GetFastflowConditions getFastflowConditions,
    required GetRequestFlow getRequestFlow,
    required GetRequestFlowRecommendations getRequestFlowRecommendations,
    required UpdatePermit updatePermit,
    required SaveInteractiveInfo saveInteractiveInfo,
    required SubmitConsultation submitConsultation,
  })  : _getConsultationKey = getConsultationKey,
        _getIsicActivities = getIsicActivities,
        _getIsicSubActivities = getIsicSubActivities,
        _getAdditionalActivities = getAdditionalActivities,
        _getActivityDetails = getActivityDetails,
        _getGISData = getGISData,
        _saveAdditionalActivities = saveAdditionalActivities,
        _getCivilDefensePredefinedConditions =
            getCivilDefensePredefinedConditions,
        _getCleaningMechanisms = getCleaningMechanisms,
        _getCommercialOffices = getCommercialOffices,
        _getEngineeringOffices = getEngineeringOffices,
        _getIssuingPredefinedConditions = getIssuingPredefinedConditions,
        _getLicensePermits = getLicensePermits,
        _getSupervisingAuthorities = getSupervisingAuthorities,
        _saveConsultationProgress = saveConsultationProgress,
        _getAccommodationTypes = getAccommodationTypes,
        _saveActivities = saveActivities,
        _getLicenseYears = getLicenseYears,
        _boardTypes = boardTypes,
        _calculateLicenseFees = calculateLicenseFeed,
        _saveFinancialStudy = saveFinancialStudy,
        _getShopOwnership = getShopOwnership,
        _getConsultationAttachments = getConsultationAttachments,
        _getMaxLicenseYears = getMaxLicenseYears,
        _getConditionsUrls = getConditionsUrls,
        _getFastflowConditions = getFastflowConditions,
        _getRequestFlow = getRequestFlow,
        _getRequestFlowRecommendations = getRequestFlowRecommendations,
        _updatePermit = updatePermit,
        _saveInteractiveInfo = saveInteractiveInfo,
        _submitConsultation = submitConsultation,
        _getBuildingCompliance = sl<GetBuildingCompliance>(),
        _getGisImage = sl<GetGISImage>(),
        _getCivilDefenseConditions = GetCivilDefenseConditions(sl()),
        _validateAddetionalActivites = ValidateAddetionalActivites(sl()),
        super(const MunicipalAdvisorState()) {
    on<MunicipalAdvisorAddMessageEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
            topic:
                event.message == 'municipalAdvisorTopicAnswer4'.tr() ? 1 : null,
            messages: [
              ...state.messages,
              ChatMessage(
                message: event.message,
                step: event.step,
                data: event.data,
                customWidget:
                    event.step == MunicipalAdvisorSteps.start ? true : false,
                isResponse:
                    event.step == MunicipalAdvisorSteps.start ? true : false,
              )
            ],
          ),
        );

        if (event.step == MunicipalAdvisorSteps.start) {
          add(MunicipalAdvisorGetConsultationKeyEvent());
        } else if (event.step == MunicipalAdvisorSteps.location &&
            state.topic == 1) {
          add(GetImtethalStatusEvent());
        } else if (event.step == MunicipalAdvisorSteps.confirmLocation) {
          add(MunicipalAdvisorGetIsicActivitiesEvent());
        } else if (showNextSteps(event.step)) {
          final nextSteps = nextStep(
            event.step,
            event.data,
          );
          if (event.step != MunicipalAdvisorSteps.start) await delay();
          for (int i = 0; i < nextSteps.length; i++) {
            emit(botResponse(event, nextSteps[i], i < nextSteps.length - 1));
            if (i != nextSteps.length - 1) await delay();
          }
        }
      },
    );

    on<MunicipalAdvisorGetConsultationKeyEvent>(
      (event, emit) async {
        emit(state.copyWith(
          lastEvent: event,
          status: BlocRequestStatus.submissionGetLoading,
        ));

        final failureOrSuccess = await _getConsultationKey(NoParams());
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (consultationKey) => emit(
            state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                consultationKey: consultationKey.$1,
                id: consultationKey.$2),
          ),
        );
        if (failureOrSuccess.isLeft()) return;
        final nextSteps = nextStep(MunicipalAdvisorSteps.start);
        for (int i = 0; i < nextSteps.length; i++) {
          emit(botResponse(event, nextSteps[i], i < nextSteps.length - 1));
          if (i != nextSteps.length - 1) await delay();
        }
      },
    );

    on<MunicipalAdvisorGetGisLocationEvent>(
      (event, emit) async {
        emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
        final failureOrSuccess = await _getGISData(
          GISParams(x: event.latLng.longitude, y: event.latLng.latitude),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (gisResponse) {
            emit(
              state.copyWith(
                  status: BlocRequestStatus.submissionGetSuccess,
                  gisResponse: gisResponse,
                  location: GISParams(
                      x: event.latLng.longitude, y: event.latLng.latitude)),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectLocationEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            activityLocation: event.location,
            messages: [
              ...state.messages,
            ],
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.location.gisResponse.getFullAddress(),
          step: MunicipalAdvisorSteps.location,
          data: event.location.latLng,
        ));
      },
    );

    on<MunicipalAdvisorRemoveLastChatEvent>(
      (event, emit) {
        final messages = state.messages;
        messages.removeLast();
        messages.removeLast();
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            messages: [...messages],
          ),
        );
      },
    );

    on<MunicipalAdvisorGetIsicActivitiesEvent>(
      (event, emit) async {
        if (state.isicActivities.isNotEmpty) {
          emit(
            state.copyWith(
              status: BlocRequestStatus.submissionGetSuccess,
              messages: [
                ...state.messages,
                ...nextStep(MunicipalAdvisorSteps.confirmLocation),
              ],
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getIsicActivities(NoParams());
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (isicActivities) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                isicActivities: isicActivities,
                messages: [
                  ...state.messages,
                  ...nextStep(MunicipalAdvisorSteps.confirmLocation),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectIsicActivityEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedIsicActivity: event.isicActivity,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.isicActivity.name,
          step: MunicipalAdvisorSteps.activity,
          data: event.isicActivity.id,
        ));
        add(MunicipalAdvisorGetIsicSubActivitiesEvent(
          params: IsicSubActivityParams(
            id: event.isicActivity.id,
          ),
        ));
      },
    );

    on<MunicipalAdvisorGetIsicSubActivitiesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getIsicSubActivities(event.params);
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (isicSubActivities) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                isicSubActivities: isicSubActivities,
                messages: [
                  ...state.messages,
                  ...nextStep(MunicipalAdvisorSteps.activity),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectIsicSubActivityEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedIsicSubActivity: event.isicSubActivity,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.isicSubActivity.name,
          step: MunicipalAdvisorSteps.subActivity,
        ));
        add(MunicipalAdvisorGetAdditionalActivitiesEvent());
      },
    );

    on<MunicipalAdvisorGetAdditionalActivitiesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getAdditionalActivities(
          ActivityDetailsParams(
            id: state.selectedIsicSubActivity!.id,
          ),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (additionalActivities) {
            if (additionalActivities.isEmpty) {
              add(MunicipalAdvisorGetActivityDetailsEvent());
            } else {
              emit(
                state.copyWith(
                  status: BlocRequestStatus.submissionGetSuccess,
                  additionalActivities: additionalActivities,
                  /* messages: [
                    ...state.messages,
                    ...nextStep(MunicipalAdvisorSteps.subActivity),
                  ],*/
                ),
              );
              add(MunicipalAdvisorGetActivityDetailsEvent());
            }
          },
        );
      },
    );

    on<MunicipalAdvisorSelectAdditionalActivitiesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedAdditionalActivities: event.additionalActivities,
          ),
        );

        double totalShopArea = 0;
        for (var activity in state.selectedAdditionalActivities) {
          if (activity.inputArea != null && activity.inputArea!.isNotEmpty) {
            totalShopArea = totalShopArea + double.parse(activity.inputArea!);
          }
        }

        if (state.selectedArea != null) {
          totalShopArea = totalShopArea + state.selectedArea!;
        }

        final failOrSuccess = await _validateAddetionalActivites(
            ValidateAdditionalActivitiesParams(
                shopArea: totalShopArea,
                mainActivityId: state.selectedIsicSubActivity?.id ?? 0,
                addetionalActivites: state.selectedAdditionalActivities
                    .map((e) =>
                        (e.activityId, double.tryParse(e.inputArea ?? "")))
                    .toList()));

        failOrSuccess.fold((failure) => emitFailure(emit, failure),
            (r) => add(MunicipalAdvisorSaveConsultationProgressEvent()));
      },
    );

    on<MunicipalAdvisorGetActivityDetailsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final params = ActivityDetailsParams(
          id: state.selectedIsicSubActivity!.id,
        );
        final failureOrSuccess = await _getActivityDetails(params);
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (activityDetails) {
            emit(
              state.copyWith(
                activityDetails: activityDetails,
              ),
            );
            if (activityDetails.isHotel) {
              add(MunicipalAdvisorGetAccommodationTypesEvent());
            } else {
              emit(
                state.copyWith(
                  status: BlocRequestStatus.submissionGetSuccess,
                  messages: [
                    ...state.messages,
                    ...nextStep(MunicipalAdvisorSteps.subActivity),
                  ],
                ),
              );
            }
          },
        );
      },
    );

    on<MunicipalAdvisorGetAccommodationTypesEvent>(
      (event, emit) async {
        if (state.accommodationTypes.isNotEmpty) {
          emit(
            state.copyWith(
              status: BlocRequestStatus.submissionGetSuccess,
              messages: [
                ...state.messages,
                ...nextStep(MunicipalAdvisorSteps.subActivity),
              ],
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getAccommodationTypes(NoParams());
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (accommodationTypes) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                accommodationTypes: accommodationTypes,
                messages: [
                  ...state.messages,
                  ...nextStep(MunicipalAdvisorSteps.subActivity),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectAccommodationTypeEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedAccommodationType: event.accommodationType,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.accommodationType.name,
          step: MunicipalAdvisorSteps.accommodationType,
        ));
      },
    );

    on<MunicipalAdvisorSelectUnitCountEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            unitCount: event.unitCount,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.unitCount.toString(),
          step: MunicipalAdvisorSteps.unitCount,
        ));
      },
    );

    on<MunicipalAdvisorSelectATMEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            atmPaid: event.atm,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.atm ? 'yes'.tr() : 'no'.tr(),
          step: MunicipalAdvisorSteps.atm,
        ));
      },
    );

    on<MunicipalAdvisorSelectSalamaEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            hasSalama: Nullable(event.hasSalama),
            lastEvent: event,
          ),
        );

        add(MunicipalAdvisorAddMessageEvent(
          message: event.hasSalama ? 'yes'.tr() : 'no'.tr(),
          step: MunicipalAdvisorSteps.salamaPermitQuestion,
        ));
        add(MunicipalAdvisorGetIssuingPredefinedConditionsEvent());
      },
    );

    on<MunicipalAdvisorSelectAreaEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedArea: event.area,
            lastEvent: event,
          ),
        );
        if(event.isCostingFrees == false) {
          add(MunicipalAdvisorAddMessageEvent(
            message: '${event.area.toStringAsFixed(0)} ${"m2".tr()}',
            step: MunicipalAdvisorSteps.area,
          ));
        }
      },
    );

    on<MunicipalAdvisorChangeInfo>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.changeInfo ? 'yes'.tr() : 'no'.tr(),
          step: MunicipalAdvisorSteps.confirmInformation,
          data: event.changeInfo ? 'changeInfo' : null,
        ));
      },
    );

    on<MunicipalAdvisorContinueToFinancial>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.continueToFinancial ? 'yes'.tr() : 'noEndChat'.tr(),
          step: MunicipalAdvisorSteps.continueToFinancial,
          data: event.continueToFinancial ? 'continueToFinancial' : null,
        ));
      },
    );

    on<MunicipalAdvisorChangeStepEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            changingInfo: true,
            lastEvent: event,
            messages: [
              ...state.messages,
              ChatMessage(
                message: event.message,
                step: MunicipalAdvisorSteps.changeInformation,
                isResponse: false,
              )
            ],
          ),
        );
        await delay();
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            changingInfo: false,
            messages: [
              ...state.messages,
              ...nextStep(event.step),
            ],
          ),
        );
      },
    );

    on<MunicipalAdvisorSaveConsultationProgressEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );

        final failureOrSuccess = await _saveConsultationProgress(
          SaveConsultationProgressParams(
            consultationKey: state.consultationKey!,
            subMunicipalityGisCode:
                state.activityLocation?.gisResponse.municipalityuniquecode,
            districtCode: int.tryParse(
                state.activityLocation?.gisResponse.Balady_DistrictID ?? ""),
            streetCode: int.tryParse(
                state.activityLocation?.gisResponse.streetCode ?? ""),
            longitude:
                state.activityLocation?.latLng.longitude.toString() ?? "",
            latitude: state.activityLocation?.latLng.latitude.toString() ?? "",
            mapNo: null,
            landNo: null,
            mainActivityArea: state.selectedArea ?? 0,
            activityId: state.selectedIsicSubActivity?.id ?? 0,
            atmFeesOption: state.atmPaid,
            unitCount: state.unitCount,
            accommodationTypeId: state.selectedAccommodationType?.id,
            krokiUrl: state.activityLocation?.gisResponse.locationURL,
          ),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (_) {},
        );
        if (failureOrSuccess.isLeft()) return;

        final additionalActivities = state.selectedAdditionalActivities;

        double totalShopArea = 0;
        for (var activity in additionalActivities) {
          if (activity.inputArea != null && activity.inputArea!.isNotEmpty) {
            totalShopArea = totalShopArea + double.parse(activity.inputArea!);
          }
        }

        if (state.selectedArea != null) {
          totalShopArea = totalShopArea + state.selectedArea!;
        }


        emit(
          state.copyWith(totalShopArea: totalShopArea),
        );
        final saveAdditionalActivities = await _saveAdditionalActivities(
          AdditionalActivitiesParams(
              consultationKey: state.consultationKey!,
              ids: additionalActivities
                  .map(
                      (e) => (e.activityId, double.tryParse(e.inputArea ?? "")))
                  .toList(),
              hasSalamaPermit: state.hasSalama,
              mainActivityArea: state.selectedArea ?? 0,
              shopArea: totalShopArea),
        );
        if (failureOrSuccess.isLeft()) return;
        saveAdditionalActivities.fold(
          (failure) => emitFailure(emit, failure),
          (_) {
            if (state.selectedAdditionalActivities.isNotEmpty) {
              add(MunicipalAdvisorAddMessageEvent(
                message: state.selectedAdditionalActivities
                    .map((e) => '${e.activityName}\n${e.inputArea!} ${"m2".tr()}')
                    .join('\n'),
                step: MunicipalAdvisorSteps.additionalActivities,
              ));
            }
            add(MunicipalAdvisorGetCivilDefenceEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetIssuingPredefinedConditionsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess =
            await _getIssuingPredefinedConditions(NoParams());
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (issuingPredefinedConditions) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                issuingPredefinedConditions: issuingPredefinedConditions,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.requirements,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetLicensePermitsEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetLicensePermitsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getLicensePermits(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (licensePermits) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                licensePermits: licensePermits,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.issuingPredefinedConditions,
                  ),
                  ...nextStep(
                    MunicipalAdvisorSteps.licensePermits,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetCivilDefensePredefinedConditionsEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetCivilDefensePredefinedConditionsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getCivilDefensePredefinedConditions(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (civilDefensePredefinedConditions) {
            List<CivilDefenceEntity>? civilDefenceList = state.civilDefenceList;

            if (state.hasSalama == true) {
              civilDefenceList
                  ?.removeWhere((element) => element.id != "PERMIT");
            } else if (state.hasSalama == false) {
              civilDefenceList
                  ?.removeWhere((element) => element.id == "PERMIT");
            }
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                civilDefensePredefinedConditions: [
                  ...civilDefensePredefinedConditions,
                  ...civilDefenceList?.map((e) => e.name) ?? []
                ],
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.selectedAdditionalActivities,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetSupervisingAuthoritiesEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetSupervisingAuthoritiesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getSupervisingAuthorities(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (supervisingAuthorities) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                supervisingAuthorities: supervisingAuthorities,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.civilDefensePredefinedConditions,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetCleaningMechanismsEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetCleaningMechanismsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getCleaningMechanisms(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (cleaningMechanisms) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                cleaningMechanisms: cleaningMechanisms,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.supervisingAuthorities,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetCommercialOfficesEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetCommercialOfficesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getCommercialOffices(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (commercialOffices) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                commercialOffices: commercialOffices,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.cleaningMechanisms,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetEngineeringOfficesEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetEngineeringOfficesEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getEngineeringOffices(
          KeyParams(key: state.consultationKey!),
        );
        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (engineeringOffices) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                engineeringOffices: engineeringOffices,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.commercialOffices,
                  ),
                ],
              ),
            );
            add(MunicipalAdvisorGetAdditionalLicenseInfoEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorGetAdditionalLicenseInfoEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );

        final maxYears = await _getMaxLicenseYears(
          KeyParamsModel(key: state.consultationKey!),
        );

        maxYears.fold(
          (failure) => emitFailure(emit, failure),
          (maxYears) => emit(state.copyWith(maxYears: maxYears)),
        );

        if (maxYears.isLeft()) return;

        final conditionsUrls = await _getConditionsUrls(NoParams());

        conditionsUrls.fold(
          (failure) => emitFailure(emit, failure),
          (conditionsUrls) =>
              emit(state.copyWith(conditionsUrls: conditionsUrls)),
        );

        if (conditionsUrls.isLeft()) return;

        final fastflowConditions = await _getFastflowConditions(
          KeyParamsModel(key: state.consultationKey!),
        );

        fastflowConditions.fold(
          (failure) => emitFailure(emit, failure),
          (fastflowConditions) => emit(
            state.copyWith(
              status: BlocRequestStatus.submissionGetSuccess,
              fastflowConditions: fastflowConditions,
              messages: [
                ...state.messages,
                ...nextStep(
                  MunicipalAdvisorSteps.engineeringOffices,
                ),
              ],
            ),
          ),
        );
      },
    );

    on<MunicipalAdvisorLoadCalculationLookupsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );

        final saveActivities = await _saveActivities(
          SaveActivitiesParams(
            consultationKey: state.consultationKey!,
            activitiesIds: const [],
          ),
        );
        saveActivities.fold(
          (failure) => emitFailure(emit, failure),
          (saveActivities) {},
        );

        final licenseYears = await _getLicenseYears(
          GetLicenseYearsParams(
            activityId: '${state.selectedIsicSubActivity!.id}',
          ),
        );

        licenseYears.fold(
          (failure) => emitFailure(emit, failure),
          (licenseYears) {
            emit(
              state.copyWith(
                licenseYears: licenseYears,
                selectedLicenseYear: licenseYears.first,
              ),
            );
          },
        );

        final boardTypes = await _boardTypes(NoParams());


        boardTypes.fold(
          (failure) => emitFailure(emit, failure),
          (boardTypes) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                boardTypes: boardTypes,
                selectedPermits: [],
              ),
            );

            add(
              const MunicipalAdvisorCalculateLicenseEvent(
                firstCalculation: true,
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectLiceseYearEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedLicenseYear: event.year,
            lastEvent: event,
          ),
        );
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorSelectCleaningMechanismEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: event.calculateFees
                ? BlocRequestStatus.submissionGetLoading
                : null,
            selectedCleanMechanism: event.cleaningMechanism,
            lastEvent: event,
          ),
        );
        if (event.calculateFees) {
          add(const MunicipalAdvisorCalculateLicenseEvent());
        }
      },
    );

    on<MunicipalAdvisorAddCommercialBoardEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
              status: BlocRequestStatus.submissionGetLoading,
              boards: [
                ...state.boards,
                BoardsParams(
                    // typeId: state.boardTypes.first.id,
                    // area: 1,
                    )
              ]),
        );

        //  add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorRemoveCommercialBoardEvent>(
      (event, emit) async {
        final index = event.index;
        state.boards.removeAt(index);
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
          ),
        );
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorUpdateCommercialBoardEvent>(
      (event, emit) async {
        if (state.boards[event.index] == event.board) return;

        state.boards[event.index] = event.board;
        emit(
          state.copyWith(
            lastEvent: event,
          ),
        );
        if (event.board.area == null || event.board.typeId == null) return;
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );

        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorCalculateLicenseEvent>(
      (event, emit) async {
        try{

          emit(state.copyWith(lastEvent: event));
          if (event.firstCalculation || event.finalCalculation) {
            emit(
              state.copyWith(status: BlocRequestStatus.submissionGetLoading),
            );
          } else {
            EasyLoading.show(
              dismissOnTap: false,
              maskType: EasyLoadingMaskType.black,
            );
          }

          double totalShopArea = 0;
          for (var activity in state.selectedAdditionalActivities) {
            if (activity.inputArea != null && activity.inputArea!.isNotEmpty) {
              totalShopArea = totalShopArea + double.parse(activity.inputArea!);
            }
          }


          if (state.selectedArea != null) {

              totalShopArea = totalShopArea +state.selectedArea!;
            }
          final failureOrSuccess = await _calculateLicenseFees(
            CalculateFeesParams(
                consultationKey: state.consultationKey!,
                accommodationTypeId: null,
                municipalityGisCode:
                state.activityLocation!.gisResponse.municipalityuniquecode ??
                    "",
                longitude:
                state.activityLocation?.latLng.longitude.toString() ?? "",
                latitude:
                state.activityLocation?.latLng.latitude.toString() ?? "",
                activityId: state.selectedIsicSubActivity!.id,
                licensePeriod: state.selectedLicenseYear,
                shopArea: totalShopArea,
                cleanOption: state.selectedCleanMechanism?.id,
                unitCount: state.unitCount,
                atmFeesPaid: state.atmPaid,
                boards: state.boards,
                permits: state.selectedPermits,
                mainActivityArea: state.selectedArea!,
                additionalActivities: state.selectedAdditionalActivities
                    .map(
                        (e) => (e.activityId, double.tryParse(e.inputArea ?? "")))
                    .toList()),
          );
          if (!event.finalCalculation) EasyLoading.dismiss();
          failureOrSuccess.fold(
                (failure) => emitFailure(emit, failure),
                (licenseFees) {
              emit(
                state.copyWith(
                  status: BlocRequestStatus.submissionGetSuccess,
                  licenseFees: licenseFees,
                  messages: event.finalCalculation
                      ? [
                    ...state.messages,
                    ...nextStep(
                      MunicipalAdvisorSteps.licenseCost,
                    ),
                  ]
                      : event.firstCalculation
                      ? [
                    ...state.messages,
                    ChatMessage(
                      message: 'municipalAdvisorLicenseCost'.tr(),
                      step: MunicipalAdvisorSteps.licenseCost,
                      isResponse: true,
                      data: true,
                    ),
                    ChatMessage(
                      message: 'municipalAdvisorPermitsCost'.tr(),
                      step: MunicipalAdvisorSteps.licenseCost,
                      isResponse: true,
                      data: false,
                    ),
                  ]
                      : null,
                ),
              );
            },
          );
        } catch (error, stackTrace) {
          LogsViewModel().sendEventFromModel(
            event: ErrorExceptionModel(
              nameEvent: EventsName.handledException,
              message: error.toString(),
              stackTrace: stackTrace.toString(),
            ),
          );
        }
      },
    );

    on<MunicipalAdvisorSelectPermitEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final id = event.permit.permitTypeId;
        final index = state.selectedPermits.indexWhere(
          (element) => element.permitTypeId == id,
        );
        if (index == -1) {
          state.selectedPermits.add(
            PermitsParams(
              permitTypeId: id,
              permitName: event.permit.name,
              sideWalk: id == 1013 ? state.sideWalkParams : null,
              nonFoodVehicleCount:
                  id == 1037 ? state.nonFoodVehicleCount : null,
            ),
          );
        } else {
          state.selectedPermits.removeAt(index);
        }
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorUpdateSideWalkEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            sideWalkParams: state.sideWalkParams.copyWith(
              width: event.width,
              length: event.length,
              days: event.days,
            ),
            lastEvent: event,
          ),
        );
        final index = state.selectedPermits.indexWhere(
          (element) => element.permitTypeId == 1013,
        );
        if (index != -1) {
          state.selectedPermits[index] = state.selectedPermits[index].copyWith(
            sideWalk: state.sideWalkParams,
          );
          final failureOrSuccess = await _updatePermit(
            UpdatePermitParams(
              consultationKey: state.consultationKey!,
              permitTypeId: 1013,
              sideWalkLength: event.length,
              sideWalkWidth: event.width,
              sideWalkDays: event.days,
            ),
          );
          failureOrSuccess.fold(
            (failure) => emitFailure(emit, failure),
            (updatedPermit) {
              final index = state.licensePermits.indexWhere(
                (element) => element.permitTypeId == 1013,
              );
              if (index != -1) {
                state.licensePermits[index] = updatedPermit;
              }
            },
          );

          if (failureOrSuccess.isLeft()) return;
        }
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorUpdateNonFoodVehicleCountEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
            nonFoodVehicleCount: event.count,
          ),
        );
        final index = state.selectedPermits.indexWhere(
          (element) => element.permitTypeId == 1037,
        );
        if (index != -1) {
          state.selectedPermits[index] = state.selectedPermits[index].copyWith(
            nonFoodVehicleCount: state.nonFoodVehicleCount,
          );

          final failureOrSuccess = await _updatePermit(
            UpdatePermitParams(
              consultationKey: state.consultationKey!,
              permitTypeId: 1037,
              nonFoodVehicleCount: event.count,
            ),
          );

          failureOrSuccess.fold(
            (failure) => emitFailure(emit, failure),
            (updatedPermit) {
              final index = state.licensePermits.indexWhere(
                (element) => element.permitTypeId == 1037,
              );
              if (index != -1) {
                state.licensePermits[index] = updatedPermit;
              }
            },
          );

          if (failureOrSuccess.isLeft()) return;
        }
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorSaveFinancialStudyEvent>(
      (event, emit) async {
        state.messages.removeLast();
        state.messages.removeLast();
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );

        final failureOrSuccess = await _saveFinancialStudy(
          FinancialStudyParams(
            consultationKey: state.consultationKey!,
            licensePeriod: state.selectedLicenseYear,
            shopArea: state.selectedArea!,
            cleanOption: state.selectedCleanMechanism?.id,
            unitCount: state.unitCount,
            atmFeesPaid: state.atmPaid,
            boards: state.boards,
            permits: state.selectedPermits,
            accommodationTypeId: state.selectedAccommodationType?.id,
          ),
        );

        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (success) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                messages: [
                  ...state.messages,
                  ChatMessage(
                    message:
                        '1.${'issue_trade_license'.tr()}\n$issueTradeLicenseUser',
                    step: MunicipalAdvisorSteps.licenseCost,
                    isResponse: false,
                    customWidget: true,
                  ),
                  ChatMessage(
                    message: '2.${'permits'.tr()}\n$permitsUser',
                    step: MunicipalAdvisorSteps.licenseCost,
                    isResponse: false,
                    customWidget: true,
                  ),
                ],
              ),
            );
          },
        );

        final nextSteps = [
          ChatMessage(
            message: 'municipalAdvisorFinancialDetails'.tr(),
            step: MunicipalAdvisorSteps.licenseCost,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.licenseCost,
            isResponse: true,
            customWidget: true,
            data: 'tradeLicense',
          ),
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.licenseCost,
            isResponse: true,
            customWidget: true,
            data: 'permits',
          ),
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.licenseCost,
            isResponse: true,
            customWidget: true,
            data: 'total',
          ),
          ChatMessage(
            message: 'remainingQuestions'.tr(),
            step: MunicipalAdvisorSteps.licenseCost,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorAttachments'.tr(),
            step: MunicipalAdvisorSteps.continueToAttachments,
            isResponse: true,
          ),
        ];
        await delay();
        for (int i = 0; i < nextSteps.length; i++) {
          emit(botResponse(event, nextSteps[i], i < nextSteps.length - 1));
          if (i != nextSteps.length - 1) await delay();
        }
      },
    );

    on<MunicipalAdvisorContinueToAttachments>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.continueToAttachments ? 'yes'.tr() : 'noEndChat'.tr(),
          step: MunicipalAdvisorSteps.continueToAttachments,
          data: event.continueToAttachments ? 'continueToAttachments' : null,
        ));
      },
    );

    on<MunicipalAdvisorGetShopOwnershipEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );

        final failureOrSuccess = await _getShopOwnership(
          KeyParamsModel(
            key: state.consultationKey!,
          ),
        );

        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (success) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                shopOwnerships: success,
                messages: [
                  ...state.messages,
                  ChatMessage(
                    message: 'municipalAdvisorFillFields'.tr(),
                    step: MunicipalAdvisorSteps.attachments,
                    isResponse: true,
                    customWidget: true,
                  ),
                  ChatMessage(
                    message: 'municipalAdvisorAttachementsTitle'.tr(),
                    step: MunicipalAdvisorSteps.attachments,
                    isResponse: true,
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorSelectHasBrandEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            hasBrand: event.hasBrand,
          ),
        );
      },
    );

    on<MunicipalAdvisorSelectShopOwnershipEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            selectedShopOwnership: event.shopOwnership,
          ),
        );
      },
    );

    on<MunicipalAdvisorSelectShopContractOptionEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            selectedShopContractOption: event.shopContractOption,
          ),
        );
      },
    );

    on<MunicipalAdvisorGetConsultationAttachmentsEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );

        final failureOrSuccess = await _getConsultationAttachments(
          AttachmentParamsModel(
            consultationKey: state.consultationKey!,
            cleanOption: state.selectedCleanMechanism!.id,
            hasBrand: state.hasBrand!,
            contractType: state.selectedShopOwnership!.contractTypeId,
            contractOption: state.selectedShopContractOption!.id,
            hasShopImage: true,
          ),
        );

        final saveInteractiveInfo = await _saveInteractiveInfo(
          InteractiveInfoParams(
            consultationKey: state.consultationKey!,
            hasBrand: state.hasBrand!,
            contractType: state.selectedShopOwnership!.contractTypeId,
            contractOption: state.selectedShopContractOption!.id,
            cleanOption: state.selectedCleanMechanism!.id,
          ),
        );

        saveInteractiveInfo.fold(
          (failure) => emitFailure(emit, failure),
          (_) {},
        );

        if (failureOrSuccess.isLeft()) return;

        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (attachments) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                attachments: attachments,
                messages: [
                  ...state.messages,
                  ChatMessage(
                    message: '',
                    step: MunicipalAdvisorSteps.attachmentsRequired,
                    isResponse: false,
                    customWidget: true,
                    data: "userAttachments",
                  ),
                ],
              ),
            );
          },
        );

        final nextSteps = [
          ChatMessage(
            message: 'municipalAdvisorAttachmentsDetails'.tr(),
            step: MunicipalAdvisorSteps.attachmentsRequired,
            isResponse: true,
            customWidget: true,
          ),
          for (final attachment in state.attachments)
            ChatMessage(
              message: '',
              step: MunicipalAdvisorSteps.attachmentsRequired,
              isResponse: true,
              customWidget: true,
              data: attachment,
            ),
          ChatMessage(
            message: 'municipalAdvisorAttachmentsRemainingQuestions'.tr(),
            step: MunicipalAdvisorSteps.attachmentsRequired,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorRequestPath'.tr(),
            step: MunicipalAdvisorSteps.continueToRequestPath,
            isResponse: true,
          ),
        ];
        await delay();
        for (int i = 0; i < nextSteps.length; i++) {
          emit(botResponse(event, nextSteps[i], i < nextSteps.length - 1));
          if (i != nextSteps.length - 1) await delay();
        }
      },
    );

    on<MunicipalAdvisorContinueToRequestPath>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: event.continueToRequestPath ? 'yes'.tr() : 'noEndChat'.tr(),
          step: MunicipalAdvisorSteps.continueToRequestPath,
          data: event.continueToRequestPath ? 'continueToRequestPath' : null,
        ));
      },
    );

    on<MunicipalAdvisorGetRequestFlowEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        if (state.requestFlow.isEmpty) {
          final requestFlow = await _getRequestFlow(
            KeyParamsModel(
              key: state.consultationKey!,
            ),
          );

          requestFlow.fold(
            (failure) => emitFailure(emit, failure),
            (requestFlow) {
              requestFlow.sort((a, b) => a.index.compareTo(b.index));
              emit(
                state.copyWith(
                  requestFlow: requestFlow,
                ),
              );
            },
          );

          if (requestFlow.isLeft()) return;
        }
        final requestFlowRecommendations = await _getRequestFlowRecommendations(
          KeyParamsModel(
            key: state.consultationKey!,
          ),
        );
        requestFlowRecommendations.fold(
          (failure) => emitFailure(emit, failure),
          (requestFlowRecommendations) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                requestFlowRecommendations: requestFlowRecommendations,
                messages: [
                  ...state.messages,
                  ChatMessage(
                    message: 'municipalAdvisorRequestPathDetails'.tr(),
                    step: MunicipalAdvisorSteps.requestPath,
                    isResponse: true,
                    customWidget: true,
                  ),
                  ChatMessage(
                    message: 'requestPath'.tr(),
                    step: MunicipalAdvisorSteps.requestPath,
                    isResponse: true,
                    customWidget: true,
                    data: 'requestPath',
                  ),
                  ChatMessage(
                    message: 'municipalAdvisorRequestPathSuggestions'.tr(),
                    step: MunicipalAdvisorSteps.requestPath,
                    isResponse: true,
                    customWidget: true,
                    data: 'municipalAdvisorRequestPathSuggestions',
                  ),
                ],
              ),
            );

            add(MunicipalAdvisorSubmitConsultationEvent());
          },
        );
      },
    );

    on<MunicipalAdvisorSubmitConsultationEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );

        final failureOrSuccess = await _submitConsultation(
          KeyParamsModel(key: state.consultationKey!),
        );

        failureOrSuccess.fold(
          (failure) => emitFailure(emit, failure),
          (success) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                messages: [
                  ...state.messages,
                  ChatMessage(
                    message: "${'municipalAdvisorId'.tr()}: ${state.id}",
                    step: MunicipalAdvisorSteps.endChat,
                    isResponse: true,
                    customWidget: true,
                  ),
                  ChatMessage(
                    message: 'municipalAdvisorEndChat'.tr(),
                    step: MunicipalAdvisorSteps.endChat,
                    isResponse: true,
                    customWidget: true,
                  ),
                  ChatMessage(
                    message: 'thanks'.tr(),
                    step: MunicipalAdvisorSteps.endChat,
                    isResponse: true,
                    customWidget: true,
                  ),
                ],
              ),
            );
            CommonFunctions.sendUXCamEvent(
                UXCamEvents.finishServiceSmartAssistant);
          },
        );
      },
    );

    on<GetImtethalStatusEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        final failureOrSuccess = await _getBuildingCompliance(state.location!);
        failureOrSuccess.fold(
          (failure) {
            dynamic code = (failure as ServerFailure).errorCode;

            if (code != "GIS-5")
              emitFailure(emit, failure);
            else {
              emit(state.copyWith(
                status: BlocRequestStatus.failure,
                errorMessage: failure.errorMessage,
                messages: [
                  ...state.messages,
                  ...nextStep(MunicipalAdvisorSteps.retryLocation),
                ],
              ));
            }
          },
          (data) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                buildingComplince: data,
                messages: [
                  ...state.messages,
                  for (int i = 0; i < data.length; i++)
                    ChatMessage(
                      message:
                          '${'الأمانة'.tr()}: ${data[i].amananame}\n${'البلدية'.tr()}: ${data[i].municipalityname}\n${'الشارع'.tr()}: ${data[i].streetname}\n ${'المرحلة'.tr()}: ${data[i].stageno}\n${'حالة شهادة الامتثال'.tr()}: ${data[i].priorityarea}',
                      step: MunicipalAdvisorSteps.licenseCost,
                      isResponse: true,
                      customWidget: true,
                    ),
                  ...nextStep(MunicipalAdvisorSteps.imtethal),
                ],
              ),
            );
          },
        );
      },
    );

    on<MunicipalAdvisorRetryEvent>(
      (event, emit) {
        if (state.lastEvent != null) add(state.lastEvent!);
      },
    );

    on<MunicipalAdvisorGetCivilDefenceEvent>(
      (event, emit) async {
        emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
        final failOrSuccess = await _getCivilDefenseConditions(KeyParamsModel(
            key: state.consultationKey!,
            civilDefenseActivityRequestDtoList: state
                .selectedAdditionalActivities
                .map((e) => (e.activityId, double.tryParse(e.inputArea ?? "")))
                .toList()));

        await failOrSuccess.fold((failure) async {
          emitFailure(emit, failure);
        }, (r) async {
          print("RRRRRRRR $r");
          emit(state.copyWith(status: BlocRequestStatus.submissionGetSuccess));

          CivilDefenceEntity? permit =
              r.firstWhereOrNull((element) => element.id == "PERMIT");
          if (permit != null) {
            emit(state.copyWith(
              status: BlocRequestStatus.submissionGetSuccess,
              civilDefenceList: r,
              messages: [
                ...state.messages,
                ChatMessage(
                  message: 'step4groupName4'.tr(),
                  step: MunicipalAdvisorSteps.salamaPermitQuestion,
                  isResponse: true,
                ),
              ],
            ));
          } else {
            emit(state.copyWith(
              status: BlocRequestStatus.submissionGetSuccess,
              civilDefenceList: r,
              messages: [
                ...state.messages,
                ChatMessage(
                  message: 'municipalAdvisorRequirements'.tr(),
                  step: MunicipalAdvisorSteps.requirements,
                  isResponse: true,
                  customWidget: true,
                ),
              ],
            ));
            add(MunicipalAdvisorGetIssuingPredefinedConditionsEvent());
          }
        });
      },
    );
    on<ChangeAreaInAddetionalActivityEvent>((event, emit) async {
      List<ActivityDetailsEntity> selectedAdditionalActivities =
          state.selectedAdditionalActivities;
      int index = state.selectedAdditionalActivities.indexWhere(
          (element) => element.activityId == event.activityDetails.activityId);
      emit(state.copyWith(
          selectedAdditionalActivities: selectedAdditionalActivities,
          status: BlocRequestStatus.submissionGetLoading));

      if (index != -1) {
        selectedAdditionalActivities[index].inputArea = event.area;
      }

      emit(state.copyWith(
          selectedAdditionalActivities: selectedAdditionalActivities,
          status: BlocRequestStatus.submissionGetSuccess));
    });

    on<DeleteAddetionalActivityEvent>((event, emit) async {
      List<ActivityDetailsEntity> selectedAdditionalActivities =
          state.selectedAdditionalActivities;
      int index = state.selectedAdditionalActivities.indexWhere(
          (element) => element.activityId == event.activityDetails.activityId);
      emit(state.copyWith(
          selectedAdditionalActivities: selectedAdditionalActivities,
          status: BlocRequestStatus.submissionGetLoading));

      if (index != -1) {
        selectedAdditionalActivities.removeAt(index);
      }

      emit(state.copyWith(
          selectedAdditionalActivities: selectedAdditionalActivities,
          status: BlocRequestStatus.submissionGetSuccess));
    });

    on<AddAddetionalActivityEvent>((event, emit) async {
      emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));

      emit(state.copyWith(
          selectedAdditionalActivities: event.list,
          status: BlocRequestStatus.submissionGetSuccess));
    });

    add(MunicipalAdvisorAddMessageEvent(
      message: 'municipalAdvisorWelcome'.tr(),
      step: MunicipalAdvisorSteps.start,
    ));
  }

  String get issueTradeLicenseUser {
    String issueTradeLicense = '''
  \n${'LicenseYears'.tr()}: ${state.selectedLicenseYear}
  \n${'area'.tr()}: ${state.selectedArea}\n
  ''';

    if (state.selectedCleanMechanism != null) {
      issueTradeLicense +=
          '${'CleaningMechanisms'.tr()}: ${state.selectedCleanMechanism?.name}\n';
    }

    return issueTradeLicense;
  }

  String get permitsUser {
    String permits = '';
    for (final permit in state.licenseFees?.permits ?? <PermitsFeesEntity>[]) {
      permits += '${permit.actionTypeName}:\n';
      if (permit.actionTypeId == 1013) {
        permits +=
            '\n ${'Width'.tr()}: ${state.sideWalkParams.width} ${'Length'.tr()}: ${state.sideWalkParams.length} ${'days'.tr()}: ${state.sideWalkParams.days}\n';
      } else if (permit.actionTypeId == 1037) {
        permits += '\n ${'count'.tr()}: ${state.nonFoodVehicleCount}\n';
      } else {
        permits += '\n';
      }
    }

    return permits;
  }

  void emitFailure(
    Emitter<MunicipalAdvisorState> emit,
    Failure failure,
  ) {
    emit(
      state.copyWith(
        status: BlocRequestStatus.submissionGetFailure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ),
    );
  }

  Future<void> delay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  MunicipalAdvisorState botResponse(
    MunicipalAdvisorEvent event,
    ChatMessage message,
    bool loading,
  ) {
    return state.copyWith(
      status: loading
          ? BlocRequestStatus.submissionGetLoading
          : BlocRequestStatus.submissionGetSuccess,
      changingInfo: false,
      lastEvent: event,
      messages: [
        ...state.messages,
        message,
      ],
    );
  }

  bool showNextSteps(MunicipalAdvisorSteps step) {
    return step.index < MunicipalAdvisorSteps.confirmLocation.index ||
        step == MunicipalAdvisorSteps.accommodationType ||
        step == MunicipalAdvisorSteps.unitCount ||
        step == MunicipalAdvisorSteps.atm ||
        step == MunicipalAdvisorSteps.area ||
        step == MunicipalAdvisorSteps.inputSummary ||
        step == MunicipalAdvisorSteps.confirmInformation ||
        step == MunicipalAdvisorSteps.continueToFinancial ||
        step == MunicipalAdvisorSteps.continueToRequestPath ||
        step == MunicipalAdvisorSteps.continueToAttachments;
  }

  List<ChatMessage> nextStep(
    MunicipalAdvisorSteps step, [
    dynamic data,
  ]) {
    switch (step) {
      case MunicipalAdvisorSteps.start:
        return [
          /* ChatMessage(
            message: 'municipalAdvisorWelcome'.tr(),
            step: MunicipalAdvisorSteps.start,
            isResponse: true,
            customWidget: true,
          ),*/
          ChatMessage(
            message: 'municipalAdvisorHint'.tr(),
            step: MunicipalAdvisorSteps.start,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorTopic'.tr(),
            step: MunicipalAdvisorSteps.topic,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.topic:
        return [
          ChatMessage(
            message: 'municipalAdvisorLocation'.tr(),
            step: MunicipalAdvisorSteps.location,
            isResponse: true,
          ),
        ];

      case MunicipalAdvisorSteps.location:
        return [
          ChatMessage(
            message: 'municipalAdvisorLocationCorrect'.tr(),
            step: MunicipalAdvisorSteps.confirmLocation,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.confirmLocation:
        if (data == 'changingInfo') {
          return [
            ChatMessage(
              message: 'municipalAdvisorConfirmSummery'.tr(),
              step: MunicipalAdvisorSteps.confirmInformation,
              isResponse: true,
            ),
          ];
        }

        return [
          ChatMessage(
            message: 'municipalAdvisorActivity'.tr(),
            step: MunicipalAdvisorSteps.activity,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.activity:
        return [
          ChatMessage(
            message: 'municipalAdvisorSubActivity'.tr(),
            step: MunicipalAdvisorSteps.subActivity,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.subActivity:
        /* return [
          ChatMessage(
            message: 'municipalAdvisorAdditionalActivities'.tr(),
            step: MunicipalAdvisorSteps.additionalActivities,
            isResponse: true,
          ),
        ];*/

        if (state.changingInfo) {
          return [
            ChatMessage(
              message: 'municipalAdvisorArea'.tr(),
              step: MunicipalAdvisorSteps.area,
              isResponse: true,
            )
          ];
        }
        final messages = [
          ChatMessage(
            message:
                '${'facilityType'.tr()}: ${state.activityDetails!.facilityName}',
            step: MunicipalAdvisorSteps.area,
            isResponse: true,
            customWidget: true,
          ),
        ];
        if (state.activityDetails!.isHotel) {
          messages.add(
            ChatMessage(
              message: 'municipalAdvisorHotelType'.tr(),
              step: MunicipalAdvisorSteps.accommodationType,
              isResponse: true,
            ),
          );
        } else if (state.activityDetails!.isAtm) {
          messages.add(
            ChatMessage(
              message: 'municipalAdvisorATM'.tr(),
              step: MunicipalAdvisorSteps.atm,
              isResponse: true,
            ),
          );
        } else {
          messages.add(
            ChatMessage(
              message: 'municipalAdvisorArea'.tr(),
              step: MunicipalAdvisorSteps.area,
              isResponse: true,
            ),
          );
        }
        return messages;
      case MunicipalAdvisorSteps.additionalActivities:
        print("MunicipalAdvisorSteps.additionalActivities");
        return [
          ChatMessage(
            message: 'municipalAdvisorInputSummery'.tr(),
            step: MunicipalAdvisorSteps.inputSummary,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorConfirmSummery'.tr(),
            step: MunicipalAdvisorSteps.confirmInformation,
            isResponse: true,
          ),
        ];
      /* if (state.changingInfo) {
          return [
            ChatMessage(
              message: 'municipalAdvisorArea'.tr(),
              step: MunicipalAdvisorSteps.area,
              isResponse: true,
            )
          ];
        }
        final messages = [
          ChatMessage(
            message:
                '${'facilityType'.tr()}: ${state.activityDetails!.facilityName}',
            step: MunicipalAdvisorSteps.area,
            isResponse: true,
            customWidget: true,
          ),
        ];
        if (state.activityDetails!.isHotel) {
          messages.add(
            ChatMessage(
              message: 'municipalAdvisorHotelType'.tr(),
              step: MunicipalAdvisorSteps.accommodationType,
              isResponse: true,
            ),
          );
        } else if (state.activityDetails!.isAtm) {
          messages.add(
            ChatMessage(
              message: 'municipalAdvisorATM'.tr(),
              step: MunicipalAdvisorSteps.atm,
              isResponse: true,
            ),
          );
        } else {
          messages.add(
            ChatMessage(
              message: 'municipalAdvisorArea'.tr(),
              step: MunicipalAdvisorSteps.area,
              isResponse: true,
            ),
          );
        }
        return messages;*/
      case MunicipalAdvisorSteps.accommodationType:
        return [
          ChatMessage(
            message: 'municipalAdvisorUnitCount'.tr(),
            step: MunicipalAdvisorSteps.unitCount,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.unitCount:
        return [
          ChatMessage(
            message: 'municipalAdvisorArea'.tr(),
            step: MunicipalAdvisorSteps.area,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.atm:
        return [
          ChatMessage(
            message: 'municipalAdvisorArea'.tr(),
            step: MunicipalAdvisorSteps.area,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.area:
        if (state.additionalActivities.isEmpty) {
          return [
            ChatMessage(
              message: 'municipalAdvisorInputSummery'.tr(),
              step: MunicipalAdvisorSteps.inputSummary,
              isResponse: true,
              customWidget: true,
            ),
            ChatMessage(
              message: 'municipalAdvisorConfirmSummery'.tr(),
              step: MunicipalAdvisorSteps.confirmInformation,
              isResponse: true,
            ),
          ];
        } else {
          return [
            ChatMessage(
              message: 'municipalAdvisorAdditionalActivities'.tr(),
              step: MunicipalAdvisorSteps.additionalActivities,
              isResponse: true,
            ),
          ];
        }

      case MunicipalAdvisorSteps.salamaPermitQuestion:
        return [
          ChatMessage(
            message: 'municipalAdvisorRequirements'.tr(),
            step: MunicipalAdvisorSteps.requirements,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.inputSummary:
        return [
          ChatMessage(
            message: 'municipalAdvisorConfirmSummery'.tr(),
            step: MunicipalAdvisorSteps.confirmInformation,
            isResponse: true,
          ),
        ];

      case MunicipalAdvisorSteps.confirmInformation:
        if (data == 'changeInfo') {
          return [
            ChatMessage(
              message: 'municipalAdvisorChangeInfo'.tr(),
              step: MunicipalAdvisorSteps.changeInformation,
              isResponse: true,
            ),
          ];
        } else {
          Future.delayed(const Duration(seconds: 1)).then((value) {
            add(MunicipalAdvisorSaveConsultationProgressEvent());
          });

          return [];
        }
      case MunicipalAdvisorSteps.changeInformation:
        return [
          ChatMessage(
            message: 'municipalAdvisorInputSummery'.tr(),
            step: MunicipalAdvisorSteps.confirmInformation,
            isResponse: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorConfirmSummery'.tr(),
            step: MunicipalAdvisorSteps.confirmInformation,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.requirements:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.issuingPredefinedConditions,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.issuingPredefinedConditions:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.licensePermits,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.licensePermits:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.selectedAdditionalActivities,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.selectedAdditionalActivities:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.civilDefensePredefinedConditions,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.civilDefensePredefinedConditions:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.supervisingAuthorities,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.supervisingAuthorities:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.cleaningMechanisms,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.cleaningMechanisms:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.commercialOffices,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.commercialOffices:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.engineeringOffices,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.engineeringOffices:
        return [
          ChatMessage(
            message: '',
            step: MunicipalAdvisorSteps.additionalInformation,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: 'municipalAdvisorFinancial'.tr(),
            step: MunicipalAdvisorSteps.continueToFinancial,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.additionalInformation:
        return [];
      case MunicipalAdvisorSteps.continueToFinancial:
        if (data == 'continueToFinancial') {
          add(MunicipalAdvisorLoadCalculationLookupsEvent());
          return [];
        } else {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceSmartAssistant);
          return [
            ChatMessage(
              message: "${'municipalAdvisorId'.tr()}: ${state.id}",
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
            ChatMessage(
              message: 'municipalAdvisorEndChat'.tr(),
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
            ChatMessage(
              message: 'thanks'.tr(),
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
          ];
        }
      case MunicipalAdvisorSteps.licenseCost:
        return [];
      case MunicipalAdvisorSteps.continueToAttachments:
        if (data == 'continueToAttachments') {
          add(MunicipalAdvisorGetShopOwnershipEvent());
          return [];
        } else {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceSmartAssistant);
          return [
            ChatMessage(
              message: "${'municipalAdvisorId'.tr()}: ${state.id}",
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
            ChatMessage(
              message: 'municipalAdvisorEndChat'.tr(),
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
            ChatMessage(
              message: 'thanks'.tr(),
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
          ];
        }
      case MunicipalAdvisorSteps.attachments:
        return [];
      case MunicipalAdvisorSteps.attachmentsRequired:
        return [];
      case MunicipalAdvisorSteps.continueToRequestPath:
        if (data == 'continueToRequestPath') {
          add(MunicipalAdvisorGetRequestFlowEvent());
          return [];
        } else {
          CommonFunctions.sendUXCamEvent(
              UXCamEvents.finishServiceSmartAssistant);
          return [
            ChatMessage(
              message: "${'municipalAdvisorId'.tr()}: ${state.id}",
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
            ChatMessage(
              message: 'municipalAdvisorEndChat'.tr(),
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
            ChatMessage(
              message: 'thanks'.tr(),
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
              customWidget: true,
            ),
          ];
        }
      case MunicipalAdvisorSteps.imtethal:
        CommonFunctions.sendUXCamEvent(UXCamEvents.finishServiceSmartAssistant);

        return [
          ChatMessage(
            message: 'imtethalAdvisorResponse'.tr(),
            step: MunicipalAdvisorSteps.imtethal,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: 'imtethalAdvisorEndChat'.tr(),
            step: MunicipalAdvisorSteps.endChat,
            isResponse: true,
            customWidget: true,
          ),
          ChatMessage(
            message: 'thanks'.tr(),
            step: MunicipalAdvisorSteps.endChat,
            isResponse: true,
            customWidget: true,
          ),
        ];
      case MunicipalAdvisorSteps.requestPath:
        return [];
      case MunicipalAdvisorSteps.endChat:
        return [];
      case MunicipalAdvisorSteps.retryLocation:
        return [
          ChatMessage(
            message: 'municipalAdvisorLocationCorrect'.tr(),
            step: MunicipalAdvisorSteps.retryLocation,
            isResponse: true,
          ),
        ];
    }
  }
}
