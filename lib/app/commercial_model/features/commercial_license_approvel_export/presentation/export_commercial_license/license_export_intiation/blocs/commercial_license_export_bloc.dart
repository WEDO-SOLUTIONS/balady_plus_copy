
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../domain/use_cases/step1_License_export_apply.dart';




part 'commercial_license_export_event.dart';

part 'commercial_license_export_state.dart';

class CommercialLicenseExportBloc
    extends Bloc<CommercialLicenseExportEvent, CommercialLicenseExportState> {
  PageController controller = PageController();
  final LicenseExportApply _LicenseExportApply;


  CommercialLicenseExportBloc()
      : _LicenseExportApply = LicenseExportApply(repository: sl()),
        super(const CommercialLicenseExportState()) {
  }








  Future<void> applyLicenseExport(int? issuingRequestId) async {
    emit(state.copyWith(detailsStatus: BlocStatus.success,requestId: Nullable(issuingRequestId)));

    // emit(state.copyWith(
    //   detailsStatus: BlocStatus.loading,
    // ));
    //
    // final response = await _LicenseExportApply(requestId!);
    // response.fold(
    //         (failure) {
    //
    //           emit(state.copyWith(detailsStatus: BlocStatus.failure,));
    //           CommonFunctions.showError(failure.toString());
    //
    //         }
    //
    //
    //     , (res) {
    //      emit(state.copyWith(detailsStatus: BlocStatus.success,requestId: Nullable(res)));
    //
    //
    //     // getCommercialRequestData(state.requestId!);
    //
    // });


  }

}
