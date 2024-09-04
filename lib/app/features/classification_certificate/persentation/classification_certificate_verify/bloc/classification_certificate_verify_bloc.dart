import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'classification_certificate_verify_states.dart';

part 'classification_certificate_verify_events.dart';

class ClassificationCertificateVerifyBloc extends Bloc<
    ClassificationCertificateVerifyEvents,
    ClassificationCertificateVerifyState> {


  ClassificationCertificateVerifyBloc()
      : super(ClassificationCertificateVerifyState()) {
    on<ClassificationCertificateVerifyEvents>((event, emit) async {
      emit(ClassificationCertificateVerifyState());
    });
  }



}
