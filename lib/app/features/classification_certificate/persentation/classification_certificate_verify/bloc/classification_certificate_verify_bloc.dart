import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/widgets/normal_search/verified_by_first_widget.dart';
import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/widgets/normal_search/verified_by_second_widget.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/normal_search/verified_by_fourth_widget.dart';
import '../widgets/normal_search/verified_by_third_widget.dart';

part 'classification_certificate_verify_states.dart';

part 'classification_certificate_verify_events.dart';

class ClassificationCertificateVerifyBloc extends Bloc<
    ClassificationCertificateVerifyEvents,
    ClassificationCertificateVerifyState> {
  ClassificationCertificateVerifyBloc()
      : super(
          const NormalSearchClassificationCertificateState(
            typeMethod: SearchMethod.search,
            normalSearchTypeList: NormalSearchType.values,
          ),
        ) {
    // Select Type of search screen
    on<SelectSearchMethodClassificationCertificateState>((event, emit) async {
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
            ),
          );
      }
    });

    // select type search of normal search
    on<SelectNormalSearchTypeClassificationCertificateState>(
        (event, emit) async {
      switch (event.normalSearchType) {
        case NormalSearchType.byCertificationNumber:
          emit(
            NormalSearchVerifiedByClassificationCertificateState(
              normalSearchType: event.normalSearchType,
              typeMethod: state.typeMethod,
              verifiedByWidget: const VerifiedByFirstWidget(),
            ),
          );
          break;
          /////////////////////////////////////////////////////////////////////
        case NormalSearchType.byContractorEngineeringOfficeName:
          emit(
            NormalSearchVerifiedByClassificationCertificateState(
              normalSearchType: event.normalSearchType,
              typeMethod: state.typeMethod,
              verifiedByWidget: const VerifiedBySecondWidget(),
            ),
          );
          break;
        /////////////////////////////////////////////////////////////////////
        case NormalSearchType
              .byCommercialRegistrationNoEngineeringOfficeLicenseNumber:
          emit(
            NormalSearchVerifiedByClassificationCertificateState(
              normalSearchType: event.normalSearchType,
              typeMethod: state.typeMethod,
              verifiedByWidget: const VerifiedByThirdWidget(),
            ),
          );
          break;
        case NormalSearchType.byNationalID:
          emit(
            NormalSearchVerifiedByClassificationCertificateState(
              normalSearchType: event.normalSearchType,
              typeMethod: state.typeMethod,
              verifiedByWidget: const VerifiedByFourthWidget(),
            ),
          );
          break;
      }
    });
  }
}
