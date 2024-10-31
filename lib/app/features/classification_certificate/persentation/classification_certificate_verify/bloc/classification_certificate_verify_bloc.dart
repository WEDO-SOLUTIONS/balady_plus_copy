import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/lookups/city_lookups_model.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/lookups_request_model.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/lookups/activity_lookups_model.dart';
import '../../../data/model/lookups/classification_certificate_lookup_model.dart';
import '../../../data/model/lookups/classification_certificate_lookups_model.dart';
import '../../../data/model/search_request/activities_request_model.dart';
import '../../../data/model/search_request/advanced_search_request_model.dart';
import '../../../data/model/search_request/normal_search_request_model.dart';
import '../../../domain/use_cases/classification_certificate_use_cases.dart';

part 'classification_certificate_verify_states.dart';

part 'classification_certificate_verify_events.dart';

class ClassificationCertificateVerifyBloc extends Bloc<
    ClassificationCertificateVerifyEvents,
    ClassificationCertificateVerifyState> {
  final formKey = GlobalKey<FormState>();

  final GetLookupsClassificationCertificateUseCases getLookups;
  final GetActivitiesClassificationCertificateUseCases getActivities;

  ClassificationCertificateLookupsModel? lookups;

  ClassificationCertificateVerifyBloc()
      : getLookups = sl<GetLookupsClassificationCertificateUseCases>(),
        getActivities = sl<GetActivitiesClassificationCertificateUseCases>(),
        super(const NormalSearchClassificationCertificateState(
          typeMethod: SearchMethod.search,
          normalSearchTypeList: NormalSearchType.values,
        )) {
    // Select Type of search screen
    on<SelectSearchMethodClassificationCertificateState>(
      (event, emit) async {
        switch (event.typeMethod) {
          case SearchMethod.search:
            emit(
              NormalSearchClassificationCertificateState(
                typeMethod: event.typeMethod,
                normalSearchTypeList: NormalSearchType.values,
              ),
            );
          case SearchMethod.advancedSearch:
            if (lookups == null) {
              add(const GetLookupsClassificationCertificateState());
            } else {
              emit(
                AdvancedSearchState(
                  typeMethod: event.typeMethod,
                  cities: lookups!.cities,
                  degrees: lookups!.degrees,
                  classificationType: lookups!.classificationType,
                  phoneNumberTextEditingController: TextEditingController(),
                  searchRequestModel: AdvancedSearchRequestModel(),
                ),
              );
            }
        }
      },
    );

    // select type search of normal search
    on<SelectNormalSearchTypeClassificationCertificateState>(
      (event, emit) async {
        late NormalSearchRequestModel searchRequestModel;
        switch (event.normalSearchType.verifiedBy) {
          case NormalSearchByType.byCertificationNumber:
            searchRequestModel = CertificateNumberSearchRequestModel(
              searchQuery: '',
            );
          case NormalSearchByType.byFacilityName:
            searchRequestModel = FacilityNameSearchRequestModel(
              searchQuery: '',
            );
          case NormalSearchByType.byCRLICNumber:
            searchRequestModel = CRLICNumberSearchRequestModel(
              searchQuery: '',
            );
          case NormalSearchByType.byEstablishmentId:
            searchRequestModel = EstablishmentIdSearchRequestModel(
              searchQuery: '',
            );
        }
        emit(
          NormalSearchVerifiedByClassificationCertificateState(
            normalSearchType: event.normalSearchType,
            typeMethod: state.typeMethod,
            searchRequestModel: searchRequestModel,
          ),
        );
      },
    );

    ////////////////////////////
    on<GetLookupsClassificationCertificateState>(
      (event, emit) async {
        emit(const AdvancedSearchLoadingState(
            typeMethod: SearchMethod.advancedSearch));
        var response = await getLookups(LookupsRequestModel());
        response.fold(
          (filer) {
            // emit state Advanced Search not working tray agyn latter
            emit(
              const AdvancedMethodNotWorkingState(
                typeMethod: SearchMethod.advancedSearch,
              ),
            );
          },
          (data) {
            lookups = data;
            emit(
              AdvancedSearchState(
                typeMethod: SearchMethod.advancedSearch,
                cities: lookups!.cities,
                degrees: lookups!.degrees,
                classificationType: lookups!.classificationType,
                searchRequestModel: AdvancedSearchRequestModel(),
                phoneNumberTextEditingController: TextEditingController(),
              ),
            );
          },
        );
      },
    );
    ///////////////////////////////////////////////////////////////////////////
    on<SelectClassificationTypeState>(
      (event, emit) async {
        var typeState = state;
        if (typeState is AdvancedSearchState) {
          var sectors = lookups!.sectors.where(
            (sector) {
              return (event.classificationType.code == 1 && sector.code == 6) ||
                  (event.classificationType.code == 0 && sector.code != 6);
            },
          ).toList();
          var services = lookups!.services.where(
            (service) {
              return (event.classificationType.code == 0 && service.code == 0) ||
                  (event.classificationType.code == 1 && service.code != 0);
            },
          ).toList();
          emit(
            AdvancedSearchByClassificationTypeState(
              sectors: sectors,
              services: services,
              typeMethod: typeState.typeMethod,
              searchRequestModel: typeState.searchRequestModel.copyWith(
                classificationType: event.classificationType,
                //  send null to delete if selected old choose
                deleteSector: true,
                deleteService: true,
                deleteActivity: true,
              ),
              classificationType: typeState.classificationType,
              degrees: typeState.degrees,
              cities: typeState.cities,
              phoneNumberTextEditingController: typeState.phoneNumberTextEditingController,
            ),
          );
        }
      },
    );

    on<SelectSectorState>(
      (event, emit) async {
        var typeState = state;
        if (typeState is AdvancedSearchByClassificationTypeState) {
          var response = await getActivities(
            ActivitiesRequestModel(sectors: event.sector.code),
          );
          response.fold(
            (filer) {
              // emit state Cant get activity
              // emit(
              //
              // );
              emit(state);
            },
            (activity) {
              if (activity.isNotEmpty) {
                emit(
                  AdvancedMethodBySectorsState(
                    sectors: typeState.sectors,
                    services: typeState.services,
                    typeMethod: typeState.typeMethod,
                    classificationType: typeState.classificationType,
                    degrees: typeState.degrees,
                    cities: typeState.cities,
                    ////////////////////////////////////////////////////////////
                    searchRequestModel: typeState.searchRequestModel.copyWith(
                      sector: event.sector,
                      //  send null to delete if selected old choose
                      deleteActivity: true,
                    ),
                    activity: activity,
                    phoneNumberTextEditingController: typeState.phoneNumberTextEditingController,
                  ),
                );
              }
            },
          );
        }
      },
    );

    on<UpdateRequestModelAdvancedSearchState>(
      (event, emit) async {
        AdvancedSearchState? typeState;
        if (state is AdvancedMethodBySectorsState) {
          typeState = state as AdvancedMethodBySectorsState;
        } else if (state is AdvancedSearchByClassificationTypeState) {
          typeState = state as AdvancedSearchByClassificationTypeState;
        } else if (state is AdvancedSearchState) {
          typeState = state as AdvancedSearchState;
        }
        if (typeState != null) {
          emit(
            typeState.copyWith(
              searchRequestModel: event.searchRequestModel,
            ),
          );
        }
      },
    );
    ///////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////////////////////////////////////////

    // // go to search Screen
    // on<GoSearchScreenClassificationCertificateState>(
    //   (event, emit) async {},
    // );
  }
}
