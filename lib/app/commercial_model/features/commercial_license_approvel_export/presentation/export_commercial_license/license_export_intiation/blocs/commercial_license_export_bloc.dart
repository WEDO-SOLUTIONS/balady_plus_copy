import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/save_location_response.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../../core/errors/failures.dart';
import '../../../../../../../features/vd/domain/entities/gis/gis_params.dart';
import '../../../../../../../features/vd/vd_exports.dart';
import '../../../../data/models/commercial_request_details_response_entity.dart';
import '../../../../data/models/qr/submit_commercial_response_model.dart';
import '../../../../domain/use_cases/get_commercial_request_response.dart';
import '../../../../domain/use_cases/step1_License_export_apply.dart';




part 'commercial_license_export_event.dart';

part 'commercial_license_export_state.dart';

class CommercialLicenseExportBloc
    extends Bloc<CommercialLicenseExportEvent, CommercialLicenseExportState> {
  PageController controller = PageController();
  final LicenseExportApply _LicenseExportApply;
  final GetExportRequestDetails _getExportRequestDetails;
  final GetGISData _getGisData;

  CommercialLicenseExportBloc()
      : _LicenseExportApply = LicenseExportApply(repository: sl()),
        _getExportRequestDetails = GetExportRequestDetails(repository: sl()),
        _getGisData = GetGISData(repository: sl()),
        super(const CommercialLicenseExportState()) {
  }








  Future<void> applyLicenseExport(int? requestId) async {
    emit(state.copyWith(
      detailsStatus: BlocStatus.loading,
    ));

    final response = await _LicenseExportApply(requestId!);
    response.fold(
            (failure) {

              emit(state.copyWith(detailsStatus: BlocStatus.failure,));

            }


        , (res) {
         emit(state.copyWith(detailsStatus: BlocStatus.success,requestId: Nullable(res)));


        // getCommercialRequestData(state.requestId!);

    });


  }

}
