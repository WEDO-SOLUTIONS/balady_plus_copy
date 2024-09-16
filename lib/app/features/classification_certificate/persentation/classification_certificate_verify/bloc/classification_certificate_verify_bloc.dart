import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/search_request/advanced_search_request_model.dart';
import '../../../data/model/search_request/normal_search_request_model.dart';

part 'classification_certificate_verify_states.dart';

part 'classification_certificate_verify_events.dart';

class ClassificationCertificateVerifyBloc extends Bloc<
    ClassificationCertificateVerifyEvents,
    ClassificationCertificateVerifyState> {
  final formKey = GlobalKey<FormState>();

  ClassificationCertificateVerifyBloc()
      : super(const NormalSearchClassificationCertificateState(
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
            emit(
              AdvancedMethodClassificationCertificateState(
                typeMethod: event.typeMethod,
                searchRequestModel: AdvancedSearchRequestModel(),
              ),
            );
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

    // go to search Screen
    on<GoSearchScreenClassificationCertificateState>(
      (event, emit) async {},
    );
    // شركة الكبس الذهبي للخدمات البيئية
  }
}
