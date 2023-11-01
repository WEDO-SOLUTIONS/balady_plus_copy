import 'package:balady_plus/app/core/services/local/use_case.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/dependency_injection_exports.dart';
import '../../../../../core/errors/errors_exports.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/etmam_route_exports.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/data/entities/success_screen_args.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../../../domain/entities/cr_submit_request.dart';
import '../../../domain/use_cases/submit_cr.dart';

part 'cr_step13_review_state.dart';

class CrStep13ReviewDataCubit extends Cubit<CrStep13ReviewState> {
  final SubmitCR _submitCR;

  CrStep13ReviewDataCubit()
      : _submitCR = SubmitCR(repository: sl()),
        super(const CrStep13ReviewState());

  void onSelectSaddadYear(IsicActivity isicActivity) async {}

  void save() async {
    try {
      int requestId = sl<CommercialLicenseBloc>().state.requestId!;
      String saddadPeriod = sl<CommercialLicenseBloc>().state.selectedPeriod!;

      emit(state.copyWith(status: BlocStatus.loading, errorMessage: ""));
      final response = await _submitCR(CrSubmitRequest(
          requestId: requestId, sadadPeriod: int.tryParse(saddadPeriod)));
      response.fold(
          (failure) => emit(state.copyWith(
                status: BlocStatus.failure,
                errorMessage: (failure as ServerFailure).errorMessage,
              )), (success) {
        emit(state.copyWith(status: BlocStatus.success));

        /*    bool Function(Route<dynamic>) predicate =
            ModalRoute.withName(RouteName.bottomNavigation);
        NavigationService.navigatorKey.currentState!.pushNamedAndRemoveUntil(
            RouteName.successRoute, predicate,
            arguments: SuccessScreenArgs(
                type: PAGE_TYPE.renewCommercial,
                fromHomePage: false,
                thanksMessage: success.data?.result?.message));

                */

        /*  NavigationService.navigatorKey.currentState!.popAndPushNamed(
          RouteName.submitApplicationSuccessfullyNew,
          arguments: (
            "",
            success.data?.result,
            sl<CommercialLicenseBloc>().state.crCalculateFeesResponse?.totalCost
          ),
        );*/
      });
    } catch (ex) {
      print(ex);
    }
  }
}
