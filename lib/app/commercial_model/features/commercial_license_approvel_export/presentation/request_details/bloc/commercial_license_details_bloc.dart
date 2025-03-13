import 'package:balady_plus/app/app.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/domain/entities/save_location_response.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step1/page/cr_step1_applicant_data.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step2/page/step2_intial_approval__activity_data.dart';
import 'package:balady_plus/app/features/vd/domain/entities/gis/gis_response.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:meta/meta.dart';

import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import '../../../../../../core/errors/failures.dart';
import '../../../data/models/initialApproval/conclusion_response_entity.dart';
import '../../../data/models/initialApproval/request_details_model.dart';
import '../../../domain/entities/conclusion_section.dart';
import '../../../domain/use_cases/cancel_intial_approval.dart';
import '../../../domain/use_cases/get_commercial_conclusion.dart';
import '../../../domain/use_cases/get_initial_approval_request_details.dart';
import '../../../domain/use_cases/reply_with_note.dart';


part 'commercial_license_details_event.dart';

part 'commercial_license_details_state.dart';

class CommercialLicenseDetailsBloc
    extends Bloc<CommercialLicenseDetailsEvent, CommercialLicenseDetailsState> {
  PageController controller = PageController();
  final int requestId;
  final getInitialApprovalRequestDetails _getInitialApprovalRequestDetails;
  final ReplyWithNote _replyWithNote;
  final GetIntialApprovalConclusion _getCommercialConclusion;
  final CancelIntialApproval _cancelIntialApproval;
  CommercialLicenseDetailsBloc(this.requestId)
      : _getInitialApprovalRequestDetails = getInitialApprovalRequestDetails(repository: sl()),
        _getCommercialConclusion = GetIntialApprovalConclusion(repository: sl()),
        _replyWithNote= ReplyWithNote(repository: sl()),
        _cancelIntialApproval = CancelIntialApproval(repository: sl()),
        super(CommercialLicenseDetailsState(requestId: requestId)) {
          getCommercialRequestData();

  }








  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }


  Future<void> getCommercialRequestData() async {
    emit(state.copyWith(status: BlocStatus.loading,));

    final response = await _getInitialApprovalRequestDetails(state.requestId!);
    response.fold(
            (failure) {

              emit(state.copyWith(status: BlocStatus.failure,));

            }

        , (res) {

              RequestDetailsModel? model;
              if(res.data?.result != null)
                {
                  model = res.data?.result;
                  model?.allowedActions!.removeWhere((item) => item.id == "view-details");
                  model?.allowedActions!.removeWhere((item) => item.id == "print");
                }
              emit(state.copyWith(requestDetails: model,status:BlocStatus.success ));
    });
  }

  Future<void> cancelIntialApproval() async {
    emit(state.copyWith(status: BlocStatus.loading,));

    final response = await _cancelIntialApproval(state.requestId!);
    response.fold(
            (failure) {
              CommonFunctions.showError("cannotdothisaction".tr());
           emit(state.copyWith(status: BlocStatus.failure,));


        }

        , (res) {

      CommonFunctions.showSuccess("commerical_add_activity_sucessfull".tr());
      emit(state.copyWith(status:BlocStatus.success ));

    });

  }

  Future<void> ReplyNote(String note,String noteId) async {
    emit(state.copyWith(status: BlocStatus.loading,));

    final response = await _replyWithNote(["${state.requestId!}",note,noteId]);
    response.fold(
            (failure) {

          CommonFunctions.showError("cannotdothisaction".tr());
          emit(state.copyWith(status: BlocStatus.failure,));



        }

        , (res) {

      NavigationService.navigatorKey.currentContext!.popDialog();
      CommonFunctions.showSuccess("commerical_add_activity_sucessfull".tr());
      emit(state.copyWith(status:BlocStatus.success ));


    });

  }


  void  getConclusion() async {

   // emit(state.copyWith(status: BlocStatus.loading));
    final response = await _getCommercialConclusion(state.requestId!);

    response.fold(
            (failure) {
          emit(state.copyWith(status: BlocStatus.failure,));
          CommonFunctions.showError((failure as ServerFailure).errorMessage);
        },


            (res) {
          emit(state.copyWith(issueCommercialConculsionEntity:res,status: BlocStatus.success));

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
