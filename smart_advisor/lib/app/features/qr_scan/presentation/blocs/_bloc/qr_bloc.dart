import 'package:smart_advisor/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:smart_advisor/app/features/select_activity/domain/entities/suggested_area_model.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/route_names.dart';
import '../../../../map/domain/entities/gis_data_request.dart';
import '../../../../select_activity/domain/entities/activity_details_page_params.dart';
import '/app/core/dependency_injection/injection_container.dart';
import '/app/core/errors/failures.dart';
import '/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/qr_license_details_response_model.dart';
import '../../../domain/use_cases/get_qr_details.dart';
part 'qr_event.dart';

part 'qr_state.dart';

class QRBloc extends Bloc<QrEvent, QrState> {
  final GetQRDataDetails _getQRDataDetails;

  QRBloc()
      : _getQRDataDetails = GetQRDataDetails(repository: sl()),
        super(const QrState()) {
    ///
    on<GetQrDetailsEvent>((event, emit) async {
      emit(state.copyWith(qrStatus: BlocStatus.loading));

      final failureOrSuccess = await _getQRDataDetails(event.qr);
      await failureOrSuccess.fold(
        (failure) async {
          emit(state.copyWith(qrStatus: BlocStatus.closeLoading));
          emit(state.copyWith(
            qrStatus: BlocStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        },
        (success) async {
          emit(state.copyWith(
              qrStatus: BlocStatus.success, qrResponse: success));

          NavigationService.navigatorKey.currentState!.pushReplacementNamed(
              RouteName.newDetails,
              arguments: ActivityDetailsPageParams(
                  area: success.comLicenseInfo?.shopArea?.toDouble(),
                  activityId: LookUpItem(
                      id: success.comLicenseInfo?.activityInfo?.mainActivity
                              ?.activityDetailId ??
                          0,
                      name: success.comLicenseInfo?.activityInfo?.mainActivity
                              ?.activityDetailName ??
                          ""),
                  suggestedArea: SuggestedAreaModel(
                      id: 1,
                      isActive: true,
                      desc: "",
                      from: success.comLicenseInfo?.shopArea?.toInt(),
                      to: success.comLicenseInfo?.shopArea?.toInt()),
                  gisRequest: GISDataRequest(
                      lat:
                          double.tryParse(success.comLicenseInfo?.locationInfo?.latitude ?? "") ??
                              0,
                      lon: double.tryParse(success.comLicenseInfo?.locationInfo?.longitude ?? "") ?? 0)));
        },
      );
    });
  }
}
