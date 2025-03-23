import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step1/bloc/step1_applicant_data_export_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/intial_approval/step1/widgets/isic_activities_dialog_not_exist_in_balady.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import '../../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../../../features/_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../../../commercial_license/presentation/commercial_license/widgets/cr_header_desc.dart';
import '../../commercial_license/blocs/commercial_license_initial_Approval_bloc.dart';
import '../../commercial_license/widgets/intial_approval_previous_next_button.dart';


class CRStep1ApplicantData extends StatelessWidget {
  const CRStep1ApplicantData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Step1ApplicantDataExportCubit, Step1ApplicantDataExportState>(
      listener: (context, state) {
        if (state.recordStatus == BlocStatus.failure ||
            state.status == BlocStatus.failure ||
            state.addIsicActivitiesStatus == BlocStatus.failure) {
          CommonFunctions.showError(state.errorMessage,true);
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            if (state.recordStatus.isSubmissionSuccess)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CRHeaderDesc(header: "applicantInfo".tr()),
                            const SizedBox(height: 12),
                            if (state.requestDetails?.submitter?.mobileNumber != null &&
                                state.requestDetails!.submitter!.mobileNumber!.isNotEmpty) ...[
                              ReadOnlyField(
                                title: "phone_number".tr(),
                                subTitle: CommonProperties.userInfo?.getPhone(),
                                showSpace: false,
                              ),
                              const SizedBox(height: 8),
                              NotesWidget(
                                notes: [
                                  "phoneNote".tr(),
                                ],
                              ),
                            ],
                            ReadOnlyField(
                              title: "applicantDesc".tr(),
                              subTitle: CommonProperties
                                      .selectedDelegator?.roleName ??
                                  '',
                            ),
                            ReadOnlyField(
                              title: "crNumber".tr(),
                              subTitle: state.requestDetails?.owner?.crNumber ?? '',
                            ),
                            ReadOnlyField(
                              title: "entityName".tr(),
                              subTitle: state.requestDetails?.owner?.ownerName,
                            ),
                            // ReadOnlyField(
                            //   title: "entityNumber".tr(),
                            //   subTitle:
                            //       state.recordInfo?.crInfo?.nationalNumber,
                            // ),
                            // ReadOnlyField(
                            //   title: "crSource".tr(),
                            //   subTitle: state.recordInfo?.crInfo?.getCity,
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  (state.recordStatus.isSubmissionLoading ||
                          state.status.isSubmissionLoading)
                      ? const Center(child: CustomCircularLoadingWidget())
                      : IntialApprovalPreviousNextButtons(
                          isBtnDisabled: false,
                          onPressed: () {
                            if (state
                                .isicActivitiesNotExistInBalady.isNotEmpty) {
                              BottomSheetDialog.showDraggableSheet(context,
                                  child: BlocProvider.value(
                                      value: BlocProvider.of<
                                          Step1ApplicantDataExportCubit>(context),
                                      child:
                                          const IsicActivitiesDialogNotExistInBalady()));
                            } else {

                              sl<CommercialLicenseInitialAprrovalBloc>().add((const NextPageEvent()));


                            }
                          }),
                ],
              ),
            if (state.recordStatus.isSubmissionFailure)
              ErrorLoadingComponent(
                message: state.errorMessage,
                onTryAgain: () =>
                    context.read<Step1ApplicantDataExportCubit>().getMainActivites(),
              ),
            if (state.recordStatus.isSubmissionLoading ||
                state.status.isSubmissionLoading)
              const Center(child: CustomCircularLoadingWidget())
          ],
        );
      },
    );
  }
}
