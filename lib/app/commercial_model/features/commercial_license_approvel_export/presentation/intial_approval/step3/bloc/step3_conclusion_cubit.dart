import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/data/models/initialApproval/add_isic_activity_data.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/use_cases/step1_add_isic_activities.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import '../../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../commercial_routes/commercial_route_names.dart';
import '../../../../data/models/initialApproval/isics_main_activity.dart';
import '../../../../data/models/initialApproval/request_details_model.dart';
import '../../../../domain/use_cases/step3_initial_approval_submit.dart';
import '../../commercial_license/blocs/commercial_license_initial_Approval_bloc.dart';

part 'step3_conclusion_state.dart';

class Step3ConclusionCubit extends Cubit<Step3ConclusionState> {
  final InitialApprovalSubmit _initialApprovalSubmit;
  final CommercialLicenseInitialAprrovalBloc commercialLicenseBloc;

  Step3ConclusionCubit()
      :_initialApprovalSubmit = InitialApprovalSubmit(repository: sl()),
        commercialLicenseBloc = sl<CommercialLicenseInitialAprrovalBloc>(),

        super(const Step3ConclusionState());



  void SubmitInitialApproval() async {


      emit(state.copyWith(status: BlocStatus.loading));
      final response = await _initialApprovalSubmit(sl<CommercialLicenseInitialAprrovalBloc>().state.requestId!);

      response.fold(
              (failure) {
                emit(state.copyWith(status: BlocStatus.failure,));
                CommonFunctions.showError((failure as ServerFailure).errorMessage);
              },


              (success) {

        emit(state.copyWith(status: BlocStatus.success));
        NavigationService.navigatorKey.currentState!.popAndPushNamed(
          CommercialRouteName.IntialApprovalSuccessfullyPage,
          arguments: (success),
        );




      });

  }
}
