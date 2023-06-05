import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart' show Formz, FormzStatusX;
import 'package:localize_and_translate/localize_and_translate.dart'
    show Translation;
//import 'package:test_package/app/core/services/services_exports.dart';
//import 'package:test_package/app/features/_base_/logic/base_class.dart';

import '../../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../../../core/errors/errors_exports.dart' show ServerFailure;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show AuthData, PhoneNumberValidation, RequiredFieldValidation;
import '../../../../../../core/utils/utils_exports.dart' show BlocStatus;
import '../../../../../entry_point/entry_point_exports.dart'
    show EntryPointCubit;
import '../../../sign_in_exports.dart'
    show SignInByPhoneNumber, SignInByUsernameAndPassword, SignInParams;

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInByPhoneNumber _signInByPhoneNumber;
  final SignInByUsernameAndPassword _signInByUsernameAndPassword;
  final EntryPointCubit _entryPointCubit;
  SignInBloc({
    required SignInByPhoneNumber signInByPhoneNumber,
    required SignInByUsernameAndPassword signInByUsernameAndPassword,
    required EntryPointCubit entryPointCubit,
  })  : _signInByPhoneNumber = signInByPhoneNumber,
        _signInByUsernameAndPassword = signInByUsernameAndPassword,
        _entryPointCubit = entryPointCubit,
        super(const SignInState()) {
    ///
    on<SignInOnChangeInfo>((event, emit) {
      emit(state.copyWith(
        phone: event.phone,
        username: event.username,
        password: event.password,
        requestStatus: BlocStatus.requestChanged,
      ));
    });

    ///
    on<SignInOnShowHidePassword>((event, emit) {
      emit(state.copyWith(hidePassword: !state.hidePassword));
    });

    ///
    on<OnSignIn>((event, emit) async {
      //! Validate all fields before submitting request

      /*SFOC.open(
          info: SFOCModel(
              context: NavigationService.navigatorKey.currentContext!,
              token: "f",
              langCode: "ar"));*/
    });
  }

  SignInParams get _params => sl<SignInParams>().copyWith(
        phoneNumber: state.phone,
        username: state.username,
        password: state.password,
      );
}
