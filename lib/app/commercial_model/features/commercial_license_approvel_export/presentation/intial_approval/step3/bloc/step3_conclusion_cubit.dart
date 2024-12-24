import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../../../core/services/local/navigation_services.dart';
import '../../../../../../commercial_routes/commercial_route_names.dart';

import '../../../../data/models/initialApproval/conclusion_response_entity.dart';
import '../../../../data/models/initialApproval/isics_main_activity.dart';
import '../../../../domain/entities/conclusion_section.dart';
import '../../../../domain/entities/sub_activity_details_entity.dart';
import '../../../../domain/use_cases/get_commercial_conclusion.dart';
import '../../../../domain/use_cases/step3_initial_approval_submit.dart';
import '../../commercial_license/blocs/commercial_license_initial_Approval_bloc.dart';
part 'step3_conclusion_state.dart';

class Step3ConclusionCubit extends Cubit<Step3ConclusionState> {
  final GetIntialApprovalConclusion _getCommercialConclusion;
  final InitialApprovalSubmit _initialApprovalSubmit;

  Step3ConclusionCubit()
      : _getCommercialConclusion = GetIntialApprovalConclusion(repository: sl()),
        _initialApprovalSubmit = InitialApprovalSubmit(repository: sl()),

        super(const Step3ConclusionState());

  void  getConclusion() async {

    emit(state.copyWith(status: BlocStatus.loading));
    final response = await _getCommercialConclusion(sl<CommercialLicenseInitialAprrovalBloc>().state.requestId!);

    response.fold(
            (failure) {
          emit(state.copyWith(status: BlocStatus.failure,));
          CommonFunctions.showError((failure as ServerFailure).errorMessage);
        },


            (res) {

          emit(state.copyWith(issueCommercialConculsionEntity:res,status: BlocStatus.success));




        });

  }

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



  ConclusionSection? getConclusionSection(List<RequestFlow>? requestFlow) {


    if(requestFlow != null&& requestFlow.isNotEmpty)
      {
        ConclusionSection obj = ConclusionSection();
        obj.sectionName = "requestFlow".tr();

        Content section = Content();
        section.label="requirements".tr();
        section.value=[];
        requestFlow.asMap().forEach((index, value) {
          section.value?.add(value.stepName!);
        });
        obj.sectionContent = section;

        return obj;
      }

    return null;


  }
}
