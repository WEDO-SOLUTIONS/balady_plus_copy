import 'package:balady_plus/app/core/errors/failures.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import '../../../../renew_commercial_license_exports.dart'
    show RenewApply, RenewApplyRequest, ValidateRenewBeforeApply;

part 'renew_commercial_license_event.dart';

part 'renew_commercial_license_state.dart';

class RenewStartServiceBloc
    extends Bloc<RenewStartServiceEvent, RenewStartServiceState> {
  final ValidateRenewBeforeApply _validateRenewBeforeApply;
  final RenewApply _renewApply;

  RenewStartServiceBloc({
    required int licenseId,
  })  : _validateRenewBeforeApply = ValidateRenewBeforeApply(repository: sl()),
        _renewApply = RenewApply(repository: sl()),
        super(RenewStartServiceState(licenseId: licenseId)) {
    on<ValidateBeforeApplyEvent>(_validateBeforeApply);
    on<RenewApplyEvent>(_renewApplyEvent);
  }

  Future<void> _validateBeforeApply(
      ValidateBeforeApplyEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _validateRenewBeforeApply(state.licenseId!);

    failOrSuccess.fold((l) {
      emitter(
        state.copyWith(
          status: BlocStatus.failure,
          errorMessage: (l as ServerFailure).errorMessage,
        ),
      );
    }, (r) {
      emitter(state.copyWith(status: BlocStatus.success));
      add(const RenewApplyEvent());
    });
  }

  Future<void> _renewApplyEvent(RenewApplyEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));
    final failOrSuccess = await _renewApply(
      RenewApplyRequest(
        licenseId: state.licenseId!,
        mobileNumber: CommonProperties.userInfo!.getPhone(),
        submitterBirthDate: CommonProperties.userInfo!.getHijriBirthDate(),
      ),
    );

    failOrSuccess.fold(
      (l) {
        emitter(state.copyWith(
            status: BlocStatus.failure,
            errorMessage: (l as ServerFailure).errorMessage));
      },
      (r) {
        emitter(state.copyWith(status: BlocStatus.success));
        NavigationService.navigatorKey.currentState?.pushNamed(
          CommercialRouteName.renewCommercialLicenseSubmitForm,
          arguments: r.data!.result,
        );

        CommonFunctions.sendUXCamEvent(
          UXCamEvents.startServiceRenewLicenseService,
        );
      },
    );
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
