import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';

class CRStep1ApplicantData extends StatelessWidget {
  const CRStep1ApplicantData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CrStep1ApplicantDataCubit, CrStep1ApplicantDataState>(
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
                            if (state.recordInfo?.crInfo?.phoneNo != null &&
                                state.recordInfo!.crInfo!.phoneNo!
                                    .isNotEmpty) ...[
                              ReadOnlyField(
                                title: "phone_number".tr(),
                                subTitle: state.recordInfo?.crInfo?.phoneNo,
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
                              subTitle:
                                  state.recordInfo?.crInfo?.getLegalType ?? '',
                            ),
                            ReadOnlyField(
                              title: "crNumber".tr(),
                              subTitle: state.recordInfo?.crNumber ?? '',
                            ),
                            ReadOnlyField(
                              title: "entityName".tr(),
                              subTitle: state.recordInfo?.crInfo?.nameAr,
                            ),
                            ReadOnlyField(
                              title: "entityNumber".tr(),
                              subTitle:
                                  state.recordInfo?.crInfo?.nationalNumber,
                            ),
                            ReadOnlyField(
                              title: "crSource".tr(),
                              subTitle: state.recordInfo?.crInfo?.getCity,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CRPreviousNextButtons(
                      isBtnDisabled: false,
                      onPressed: () {
                        if (!state.isicActivitiesNotExistInBalady.isNotEmpty) {
                          BottomSheetDialog.showDraggableSheet(context,
                              child: BlocProvider.value(
                                  value: BlocProvider.of<
                                      CrStep1ApplicantDataCubit>(context),
                                  child:
                                      const IsicActivitiesDialogNotExistInBalady()));
                        } else {
                          context
                              .read<CommercialLicenseBloc>()
                              .add(const GoToNextPageEvent());
                        }
                      }),
                ],
              ),
            if (state.recordStatus.isSubmissionFailure)
              ErrorLoadingComponent(
                message: state.errorMessage,
                onTryAgain: () =>
                    context.read<CrStep1ApplicantDataCubit>().getRecordInfo(),
              ),
            if (state.recordStatus.isSubmissionLoading)
              const CustomCircularLoadingWidget(),
          ],
        );
      },
    );
  }
}
