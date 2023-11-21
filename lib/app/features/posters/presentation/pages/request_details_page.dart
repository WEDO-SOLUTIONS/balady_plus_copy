import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/posters/presentation/blocs/posters_license_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:collection/collection.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../data/models/allowed_actions_response.dart';
import '../widgets/edit_posters_dialog.dart';
import '../widgets/steps/step2/poster_view_item_widget.dart';

class PostersReqeuestDetailsPage extends StatelessWidget {
  const PostersReqeuestDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    int? detailsRequestNumber =
        ModalRoute.of(context)!.settings.arguments as int?;
    return BlocProvider(
      create: (context) => PostersLicenseBloc(requestId: detailsRequestNumber)
        ..add(GetPosterRequestDetailsEvent()),
      child: BlocListener<PostersLicenseBloc, PostersLicenseState>(
        listener: (context, state) {},
        child: BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
          listener: (context, state) {
            if (state.detailsStatus == BlocStatus.failure) {
              CommonFunctions.showError(state.error ?? "");
            }
          },
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColor.white2,
              appBar: DetailsHeader(
                title: "order_details".tr(),
                procedures: () async {
                  List<AllowedActionItem> act = await context
                          .read<PostersLicenseBloc>()
                          .getAllowedActions() ??
                      [];
                  await BottomSheetDialog.showDraggableSheet(context,
                      isFullHeight: false,
                      height: 250, //MM
                      //   dialogKeyName: DialogName.complianceRequestActionsDialog,
                      //  currentRouteName: RouteName.complianceDetailsPage,
                      child: BottomSheetWithActions(
                        title: "actions".tr(),
                        body: Column(
                            children: act!.map((e) {
                          return GestureDetector(
                            onTap: () async {
                              print(state.requestDetails?.alerts);
                              if (e.id == "edit") {
                                await BottomSheetDialog.showDraggableSheet(
                                    context,
                                    isFullHeight: true,
                                    child: BlocProvider.value(
                                        value:
                                            context.read<PostersLicenseBloc>(),
                                        child: EditPostersDialog()));
                              }

                              if (e.id == "cancel") {
                                context
                                    .read<PostersLicenseBloc>()
                                    .add(DeletePosterRequestEvent());
                                Navigator.of(context).pop();
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8.0),
                              child: FieldData(
                                title: e.actionName ?? "",
                              ),
                            ),
                          );
                        }).toList()),
                      ));
                },
              ),
              body: Stack(
                children: [
                  if (state.detailsStatus == BlocStatus.success)
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                            child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      IconPath.calendarIcon,
                                      width: 24,
                                      height: 24,
                                    ),
                                    CustomHorizontalSpace(width: 8),
                                    CustomTextWidget(
                                      state.requestDetails?.creationDate ?? "",
                                      fontColor: AppColor.blackModern500Light,
                                      fontSize: 12,
                                      fontWeight: AppFontWeight.bold,
                                    )
                                  ],
                                ),
                                HomeTag(
                                  title: state.requestDetails?.requestStatus
                                          ?.name ??
                                      "",
                                  backgroundColor: AppColor.secondary100Light,
                                )
                              ],
                            ),
                            const CustomVerticalSpace(height: 16),
                            Step1SummeryWidget(),
                            /*  Step1SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step2SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step2_2SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step3SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            LocationSummuryWidget(),
                            Step4SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            if (state.requestDetails?.submitterThrough ==
                                "BENEFICARY")
                              Step5SummeryWidget(),
                            CustomVerticalSpace(height: 16),
                            Step6SummeryWidget(),*/
                            CustomVerticalSpace(height: 16),
                          ],
                        ))),
                  if (state.detailsStatus == BlocStatus.loading ||
                      state.status == BlocStatus.loading)
                    CustomCircularLoadingWidget(),
                  if (state.detailsStatus == BlocStatus.failure)
                    ReloadWidget(
                      onTab: () {
                        context
                            .read<PostersLicenseBloc>()
                            .add(const GetPosterRequestDetailsEvent());
                      },
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class Step1SummeryWidget extends StatelessWidget {
  const Step1SummeryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("بيانات الملصقات").tr(),
          leading: SvgPicture.asset(IconPath.vdSummurySPL),
          children: (state.requestDetails?.posters ?? []).mapIndexed((i, e) {
            return PosterViewItemWidget(
              index: i + 1,
              item: e,
              showChangeImage: false,
            );
          }).toList(),
        );
      },
    );
  }
}
