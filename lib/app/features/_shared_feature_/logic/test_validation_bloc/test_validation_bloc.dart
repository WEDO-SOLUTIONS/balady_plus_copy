import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart' show Formz;

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../shared_feature_exports.dart'
    show
        DateAfterValidation,
        DropDownItem,
        EmailValidation,
        OptionalFieldValidation,
        PhoneNumberValidation,
        RequiredDropDownValidation,
        RequiredFieldValidation;

part 'test_validation_event.dart';
part 'test_validation_state.dart';

class TestValidationBloc
    extends Bloc<TestValidationEvent, TestValidationState> {
  TestValidationBloc() : super(const TestValidationState()) {
    ///
    on<TestValidationOnChangeInfo>((event, emit) {
      emit(state.copyWith(
        phoneNumber: event.phoneNumber,
        email: event.email,
        startDate: event.startDate,
        endDate: event.endDate,
        address: event.address,
        description: event.description,
        city: event.city,
        status: BlocRequestStatus.requestChanged,
      ));
    });

    ///
    on<TestValidationOnSubmit>((event, emit) {
      emit(state.copyWith(status: BlocRequestStatus.submissionPostLoading));

      if (state.isFormValid) {
        emit(state.copyWith(status: BlocRequestStatus.submissionPostFailure));
        emit(state.copyWith(status: BlocRequestStatus.submissionPostSuccess));
      }
    });
  }
}
