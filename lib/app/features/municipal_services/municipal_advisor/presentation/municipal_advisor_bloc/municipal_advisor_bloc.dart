import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../vd/vd_exports.dart' show GISParams, GISResponse, GetGISData;
import '../../municipal_advisor_exports.dart';

part 'municipal_advisor_event.dart';
part 'municipal_advisor_state.dart';

class MunicipalAdvisorBloc
    extends Bloc<MunicipalAdvisorEvent, MunicipalAdvisorState> {
  final GetConsultationKey _getConsultationKey;
  final GetIsicActivities _getIsicActivities;
  final GetIsicSubActivities _getIsicSubActivities;
  final GetActivityDetails _getActivityDetails;
  final GetGISData _getGISData;
  final GetCivilDefensePredefinedConditions
      _getCivilDefensePredefinedConditions;
  final GetCleaningMechanisms _getCleaningMechanisms;
  final GetCommercialOffices _getCommercialOffices;
  final GetIssuingPredefinedConditions _getIssuingPredefinedConditions;
  final GetLicensePermits _getLicensePermits;
  final GetSupervisingAuthorities _getSupervisingAuthorities;
  final SaveConsultationProgress _saveConsultationProgress;
  final GetAccommodationTypes _getAccommodationTypes;
  final SaveActivities _saveActivities;
  final GetLicenseYears _getLicenseYears;
  // final GetBoardTypes _boardTypes;
  final CalculateLicenseFees _calculateLicenseFees;

  MunicipalAdvisorBloc({
    required GetConsultationKey getConsultationKey,
    required GetIsicActivities getIsicActivities,
    required GetIsicSubActivities getIsicSubActivities,
    required GetActivityDetails getActivityDetails,
    required GetGISData getGISData,
    required GetCivilDefensePredefinedConditions
        getCivilDefensePredefinedConditions,
    required GetCleaningMechanisms getCleaningMechanisms,
    required GetCommercialOffices getCommercialOffices,
    required GetIssuingPredefinedConditions getIssuingPredefinedConditions,
    required GetLicensePermits getLicensePermits,
    required GetSupervisingAuthorities getSupervisingAuthorities,
    required SaveConsultationProgress saveConsultationProgress,
    required GetAccommodationTypes getAccommodationTypes,
    required SaveActivities saveActivities,
    required GetLicenseYears getLicenseYears,
    required GetBoardTypes boardTypes,
    required CalculateLicenseFees calculateLicenseFeed,
  })  : _getConsultationKey = getConsultationKey,
        _getIsicActivities = getIsicActivities,
        _getIsicSubActivities = getIsicSubActivities,
        _getActivityDetails = getActivityDetails,
        _getGISData = getGISData,
        _getCivilDefensePredefinedConditions =
            getCivilDefensePredefinedConditions,
        _getCleaningMechanisms = getCleaningMechanisms,
        _getCommercialOffices = getCommercialOffices,
        _getIssuingPredefinedConditions = getIssuingPredefinedConditions,
        _getLicensePermits = getLicensePermits,
        _getSupervisingAuthorities = getSupervisingAuthorities,
        _saveConsultationProgress = saveConsultationProgress,
        _getAccommodationTypes = getAccommodationTypes,
        _saveActivities = saveActivities,
        _getLicenseYears = getLicenseYears,
        // _boardTypes = boardTypes,
        _calculateLicenseFees = calculateLicenseFeed,
        super(const MunicipalAdvisorState()) {
    on<MunicipalAdvisorAddMessageEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
            messages: [
              ...state.messages,
              ChatMessage(
                message: event.message,
                step: event.step,
                data: event.data,
                isResponse: false,
              )
            ],
          ),
        );
        if (event.step == MunicipalAdvisorSteps.start) {
          final didGetKey = await getConsultationKeyEventHandler(event, emit);
          if (!didGetKey) {
            return;
          }
        }
        if (showNextSteps(event.step)) {
          final nextSteps = nextStep(
            state.changingInfo
                ? MunicipalAdvisorSteps.inputSummary
                : event.step,
            event.data,
          );
          if (event.step != MunicipalAdvisorSteps.start) await delay();
          for (int i = 0; i < nextSteps.length; i++) {
            emit(botResponse(event, nextSteps[i], i < nextSteps.length - 1));
            if (i != nextSteps.length - 1) await delay();
          }
        } else if (event.step == MunicipalAdvisorSteps.confirmLocation) {
          add(MunicipalAdvisorGetIsicActivitiesEvent());
        }
      },
    );

    on<MunicipalAdvisorGetConsultationKeyEvent>(
      (event, emit) async {
        await getConsultationKeyEventHandler(event, emit);
      },
    );

    on<MunicipalAdvisorGetGisLocationEvent>(
      (event, emit) async {
        emit(state.copyWith(status: BlocRequestStatus.submissionGetLoading));
        final failureOrSuccess = await _getGISData(
          GISParams(x: event.latLng.longitude, y: event.latLng.latitude),
        );
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (gisResponse) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                gisResponse: gisResponse,
              ),
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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
        add(MunicipalAdvisorGetActivityDetailsEvent());
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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

    on<MunicipalAdvisorSelectAreaEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            selectedArea: event.area,
            lastEvent: event,
          ),
        );
        add(MunicipalAdvisorAddMessageEvent(
          message: '${event.area.toStringAsFixed(0)} ${"m2".tr()}',
          step: MunicipalAdvisorSteps.area,
        ));
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
                // state.activityLocation?.gisResponse.subMunicipalityId ??
                "013001002",
            districtCode: int.tryParse(
                    state.activityLocation?.gisResponse.districtId ?? "") ??
                1010106,
            streetCode: 1010106005,
            longitude:
                state.activityLocation?.latLng.longitude.toString() ?? "",
            latitude: state.activityLocation?.latLng.latitude.toString() ?? "",
            mapNo: "",
            landNo: "",
            shopArea: state.selectedArea ?? 0,
            activityId: state.selectedIsicSubActivity?.id ?? 0,
            atmFeesOption: null,
            unitCount: null,
            accommodationTypeId: null,
            krokiUrl: "http://gisimages.momra.gov.sa/",
          ),
        );
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (_) {
            add(MunicipalAdvisorGetIssuingPredefinedConditionsEvent());
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (licensePermits) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                licensePermits: licensePermits,
                messages: [
                  ...state.messages,
                  ...nextStep(
                      MunicipalAdvisorSteps.issuingPredefinedConditions),
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (civilDefensePredefinedConditions) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetSuccess,
                civilDefensePredefinedConditions:
                    civilDefensePredefinedConditions,
                messages: [
                  ...state.messages,
                  ...nextStep(
                    MunicipalAdvisorSteps.licensePermits,
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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
          },
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

        //call SaveActivities  and GetLicenseYears and GetBoardTypes
        final saveActivities = await _saveActivities(
          SaveActivitiesParams(
            consultationKey: state.consultationKey!,
            activitiesIds: const [],
          ),
        );
        saveActivities.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
          (saveActivities) {},
        );

        final licenseYears = await _getLicenseYears(
          GetLicenseYearsParams(
            activityId: '${state.selectedIsicSubActivity!.id}',
          ),
        );

        licenseYears.fold(
          (failure) => emit(
            state.copyWith(
              status: BlocRequestStatus.submissionGetFailure,
              errorMessage: (failure as ServerFailure).errorMessage,
            ),
          ),
          (licenseYears) {
            add(
              const MunicipalAdvisorCalculateLicenseEvent(
                firstCalculation: true,
              ),
            );
            emit(
              state.copyWith(
                licenseYears: licenseYears,
                selectedLicenseYear: licenseYears.first,
                selectedPermits: [],
              ),
            );
          },
        );

        // final boardTypes = await _boardTypes(NoParams());

        // boardTypes.fold(
        //   (failure) => emit(
        //     state.copyWith(
        //       status: BlocRequestStatus.submissionGetFailure,
        //       errorMessage: (failure as ServerFailure).errorMessage,
        //     ),
        //   ),
        //   (boardTypes) => emit(
        //     state.copyWith(
        //       status: BlocRequestStatus.submissionGetSuccess,
        //       boardTypes: boardTypes,
        //     ),
        //   ),
        // );
      },
    );

    on<MunicipalAdvisorSelectLiceseYearEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
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
            status: BlocRequestStatus.submissionGetLoading,
            selectedCleanMechanism: event.cleaningMechanism,
            lastEvent: event,
          ),
        );
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorAddCommercialBoardEvent>(
      (event, emit) async {
        emit(
          state.copyWith(
              status: BlocRequestStatus.submissionGetLoading,
              lastEvent: event,
              boards: [
                ...state.boards,
                BoardsParams(
                  typeId: state.boardTypes.first.id,
                  area: 1,
                )
              ]),
        );
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorRemoveCommercialBoardEvent>(
      (event, emit) async {
        final index = event.index;
        state.boards.removeAt(index);
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorUpdateCommercialBoardEvent>(
      (event, emit) async {
        state.boards[event.index] = event.board;
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
        if (event.firstCalculation || event.finalCalculation) {
          emit(
            state.copyWith(
              status: BlocRequestStatus.submissionGetLoading,
              lastEvent: event,
            ),
          );
        } else {
          EasyLoading.show(
            dismissOnTap: false,
            maskType: EasyLoadingMaskType.black,
          );
        }
        final failureOrSuccess = await _calculateLicenseFees(
          CalculateFeesParams(
            consultationKey: state.consultationKey!,
            accommodationTypeId: null,
            municipalityGisCode: "013001002",
            longitude:
                state.activityLocation?.latLng.longitude.toString() ?? "",
            latitude: state.activityLocation?.latLng.latitude.toString() ?? "",
            activityId: state.selectedIsicSubActivity!.id,
            licensePeriod: state.selectedLicenseYear,
            shopArea: state.selectedArea!,
            cleanOption: state.selectedCleanMechanism?.id,
            unitCount: state.unitCount,
            atmFeesPaid: state.atmPaid,
            boards: state.boards,
            permits: state.selectedPermits,
          ),
        );
        if (!event.finalCalculation) EasyLoading.dismiss();
        failureOrSuccess.fold(
          (failure) {
            emit(
              state.copyWith(
                status: BlocRequestStatus.submissionGetFailure,
                errorMessage: (failure as ServerFailure).errorMessage,
              ),
            );
          },
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
      },
    );

    on<MunicipalAdvisorSelectPermitEvent>(
      (event, emit) async {
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
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
          ),
        );
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
        }
        add(const MunicipalAdvisorCalculateLicenseEvent());
      },
    );

    on<MunicipalAdvisorEndCalculateLicenseEvent>(
      (event, emit) async {
        state.messages.removeLast();
        state.messages.removeLast();
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetLoading,
            lastEvent: event,
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
            message: 'municipalAdvisorFinancial'.tr(),
            step: MunicipalAdvisorSteps.addAttachments,
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

    on<MunicipalAdvisorRetryEvent>(
      (event, emit) {
        if (state.lastEvent != null) add(state.lastEvent!);
      },
    );
  }

  String get issueTradeLicenseUser {
    String issueTradeLicense = '''
  ${'LicenseYears'.tr()}: ${state.selectedLicenseYear}
  ${'area'.tr()}: ${state.selectedArea}
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
      permits += '${permit.actionTypeName}\n';
      if (permit.actionTypeId == 1013) {
        permits +=
            ':\n ${'Width'.tr()}: ${state.sideWalkParams.width} ${'Length'.tr()}: ${state.sideWalkParams.length} ${'days'.tr()}: ${state.sideWalkParams.days}\n';
      } else if (permit.actionTypeId == 1037) {
        permits += ':\n ${'count'.tr()}: ${state.nonFoodVehicleCount}\n';
      } else {
        permits += '\n';
      }
    }

    return permits;
  }

  Future<bool> getConsultationKeyEventHandler(event, emit) async {
    final userInfo = CommonProperties.userInfo;
    if (userInfo == null) {
      emit(
        state.copyWith(
          status: BlocRequestStatus.submissionGetFailure,
          errorMessage: 'user not found',
        ),
      );
    }
    emit(state.copyWith(
      lastEvent: MunicipalAdvisorGetConsultationKeyEvent(),
      status: BlocRequestStatus.submissionGetLoading,
    ));
    final failureOrSuccess = await _getConsultationKey(
      ConsultationKeyParams(
        mobile: userInfo!.getPhone(),
        submitterBirthDate: "1378/07/01",
        gender: userInfo.sex ?? "1",
      ),
    );
    return failureOrSuccess.fold(
      (failure) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetFailure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ),
        );
        return false;
      },
      (consultationKey) {
        emit(
          state.copyWith(
            status: BlocRequestStatus.submissionGetSuccess,
            consultationKey: consultationKey,
          ),
        );
        return true;
      },
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
        step == MunicipalAdvisorSteps.continueToFinancial;
  }

  List<ChatMessage> nextStep(MunicipalAdvisorSteps step, [dynamic data]) {
    switch (step) {
      case MunicipalAdvisorSteps.start:
        return [
          ChatMessage(
            message: 'municipalAdvisorWelcome'.tr(),
            step: MunicipalAdvisorSteps.start,
            isResponse: true,
            customWidget: true,
          ),
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

          return [
            ChatMessage(
              message: 'municipalAdvisorRequirements'.tr(),
              step: MunicipalAdvisorSteps.requirements,
              isResponse: true,
              customWidget: true,
            ),
          ];
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
          ChatMessage(
            message: 'municipalAdvisorFinancial'.tr(),
            step: MunicipalAdvisorSteps.continueToFinancial,
            isResponse: true,
          ),
        ];
      case MunicipalAdvisorSteps.commercialOffices:
        return [];
      case MunicipalAdvisorSteps.continueToFinancial:
        if (data == 'continueToFinancial') {
          add(MunicipalAdvisorLoadCalculationLookupsEvent());
          return [
            // ChatMessage(
            //   message: 'municipalAdvisorLicenseCost'.tr(),
            //   step: MunicipalAdvisorSteps.licenseCost,
            //   isResponse: true,
            //   data: true,
            // ),
            // ChatMessage(
            //   message: 'municipalAdvisorPermitsCost'.tr(),
            //   step: MunicipalAdvisorSteps.licenseCost,
            //   isResponse: true,
            //   data: false,
            // ),
          ];
        } else {
          return [
            ChatMessage(
              message: 'municipalAdvisorEndChat'.tr(),
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
            ),
            ChatMessage(
              message: 'thanks'.tr(),
              step: MunicipalAdvisorSteps.endChat,
              isResponse: true,
            ),
          ];
        }
      case MunicipalAdvisorSteps.endChat:
        return [];
      case MunicipalAdvisorSteps.licenseCost:
        return [];
      case MunicipalAdvisorSteps.addAttachments:
        return [];
    }
  }
}
