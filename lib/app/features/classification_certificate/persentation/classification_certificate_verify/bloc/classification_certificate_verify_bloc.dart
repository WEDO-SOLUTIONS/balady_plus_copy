import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/utility/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


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
          emit(
            NormalSearchVerifiedByClassificationCertificateState(
              normalSearchType: event.normalSearchType,
              typeMethod: state.typeMethod,
            ),
          );
    });
  }
}
