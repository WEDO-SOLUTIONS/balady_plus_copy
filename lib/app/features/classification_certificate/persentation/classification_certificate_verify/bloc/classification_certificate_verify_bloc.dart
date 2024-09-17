import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/classification_certificate/data/model/search_request/lookups_request_model.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/lookups/classification_certificate_lookups_model.dart';
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
                AdvancedMethodClassificationCertificateState(
                  typeMethod: event.typeMethod,
                  searchRequestModel: AdvancedSearchRequestModel(),
                ),
              );
            }
        }
      },
    );

    on<GetLookupsClassificationCertificateState>(
      (event, emit) async {
        var response = await getLookups(LookupsRequestModel());
        response.fold(
          (filer) {
            // emit state Advanced Search not working tray agyn latter
            emit(
              const AdvancedMethodNotWorkingClassificationCertificateState(
                typeMethod: SearchMethod.advancedSearch,
              ),
            );
          },
          (data) {
            lookups = data;
            emit(
              AdvancedMethodClassificationCertificateState(
                typeMethod: SearchMethod.advancedSearch,
                searchRequestModel: AdvancedSearchRequestModel(),
              ),
            );
          },
        );
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

    // // go to search Screen
    // on<GoSearchScreenClassificationCertificateState>(
    //   (event, emit) async {},
    // );
  }
}
