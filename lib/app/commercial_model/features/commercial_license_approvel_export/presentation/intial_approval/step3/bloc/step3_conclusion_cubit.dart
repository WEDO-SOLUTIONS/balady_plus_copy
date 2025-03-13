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
            // res= res.copyWith(engOffices: [EngOffices(cityName: "riyadh",officeName: "test1",officeMobile: "0562718752"),EngOffices(cityName: "riyadh",officeName: "test2",officeMobile: "0562718752")]);
            // res= res.copyWith(commercialOffices: [CommercialOffices(cityName: "riyadh",officeName: "test1 com",officeMobile: "0562718752"),CommercialOffices(cityName: "riyadh",officeName: "test2 com",officeMobile: "0562718752")]);
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


  ConclusionSection? getConclusionSection({List<RequestFlow>? requestFlow,List<AllowedPermits>? allowedPermits
    ,List<CivilDefenseAllowedDocuments>? civilDefenseDocuments,List<CleaningOptions>? cleaningOptions,
    List<CommercialOffices>? commercialOffices, List<EngOffices>? engOffices,
    List<PreDefinedConditionTypes>? preDefinedConditionTypes,
    List<SupervisingAuthoritiesForActivities>? lstSupervisingAuthorities,
    List<PreDefinedConditionsByType>? lstPreDefinedConditionsByType,
    List<FastFlowConditions>? lstFastFlowConditions,List<String>? lstboardContractRequirementMessage

  }) {


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
    else  if(allowedPermits != null&& allowedPermits.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "permits".tr();

      Content section = Content();
      section.label="permits".tr();
      section.value=[];
      allowedPermits.asMap().forEach((index, value) {
        section.value?.add(value.name!);
      });
      obj.sectionContent = section;

      return obj;
    }
    else  if(civilDefenseDocuments != null&& civilDefenseDocuments.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "municipalAdvisorCivilDefenseTitle".tr();
      Content section = Content();
      section.label="municipalAdvisorCivilDefenseTitle".tr();
      section.value=[];
      civilDefenseDocuments.asMap().forEach((index, value) {
        section.value?.add(value.name!);
      });
      obj.sectionContent = section;

      return obj;
    }
    else  if(cleaningOptions != null&& cleaningOptions.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "municipalAdvisorCleaningMechanismsTitle".tr();
      Content section = Content();
      section.label="municipalAdvisorCleaningMechanismsTitle".tr();
      section.value=[];
      cleaningOptions.asMap().forEach((index, value) {
        section.value?.add(value.name!);
      });
      obj.sectionContent = section;

      return obj;
    }
    else  if(preDefinedConditionTypes != null&& preDefinedConditionTypes.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "preDefinedConditionTypesTitle".tr();
      Content section = Content();
      section.label="preDefinedConditionTypesTitle".tr();
      section.value=[];
      preDefinedConditionTypes.asMap().forEach((index, value) {
        section.value?.add(value.name!);
      });
      obj.sectionContent = section;
      return obj;
    }

    else  if(lstPreDefinedConditionsByType != null&& lstPreDefinedConditionsByType.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "PreDefinedConditionsByTypeTitle".tr();
      Content section = Content();
      section.label="PreDefinedConditionsByTypeTitle".tr();
      section.value=[];
      lstPreDefinedConditionsByType.asMap().forEach((index, value) {
        section.value?.add(value.name!);
      });
      obj.sectionContent = section;
      return obj;
    }

    else  if(lstboardContractRequirementMessage != null&& lstboardContractRequirementMessage.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "boardContractRequirementMessage".tr();
      Content section = Content();
      section.label="boardContractRequirementMessage".tr();
      section.value=[];
      lstboardContractRequirementMessage.asMap().forEach((index, value) {
        section.value?.add(value);
      });
      obj.sectionContent = section;
      return obj;
    }

    else  if(lstFastFlowConditions != null&& lstFastFlowConditions.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "fastFlowConditions".tr();
      Content section = Content();
      section.label="fastFlowConditions".tr();
      section.value=[];
      lstFastFlowConditions.asMap().forEach((index, value) {
        section.value?.add(value.conditionName!);
      });
      obj.sectionContent = section;
      return obj;
    }



    else  if(lstSupervisingAuthorities != null&& lstSupervisingAuthorities.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "SupervisingAuthorities".tr();
      Content section = Content();
      section.label="SupervisingAuthorities".tr();
      section.value=[];
      lstSupervisingAuthorities[0].supervisions?.asMap().forEach((index, value) {
        section.value?.add(value.agencyName!);
      });
      obj.sectionContent = section;
      return obj;
    }

    else  if(commercialOffices != null&& commercialOffices.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "commercialOffice".tr();
      Content section = Content();
      section.label="commercialOffice".tr();
      section.offices=[];
      commercialOffices.asMap().forEach((index, value) {
        section.offices?.add(OfficeSection(officeName:value.officeName,officeMobile: value.officeMobile,cityName: value.cityName));
      });
      obj.sectionContent = section;

      return obj;
    }
    else  if(engOffices != null&& engOffices.isNotEmpty)
    {
      ConclusionSection obj = ConclusionSection();
      obj.sectionName = "municipalAdvisorEngineeringOfficesTitle".tr();
      Content section = Content();
      section.label="municipalAdvisorEngineeringOfficesTitle".tr();
      section.offices=[];
      engOffices.asMap().forEach((index, value) {
        section.offices?.add(OfficeSection(officeName:value.officeName,officeMobile: value.officeMobile,cityName: value.cityName));
      });
      obj.sectionContent = section;

      return obj;
    }

    return null;


  }

}
