import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/request_attachments_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/widgets/card_cost_info_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/widgets/card_desc_widget.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/widgets/attachment_show_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CommercialLicenseCancelTwoScreen extends StatelessWidget {
  const CommercialLicenseCancelTwoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CommercialLicenseCancelBloc bloc =
        context.watch<CommercialLicenseCancelBloc>();

    RequestAttachmentsViewModel viewModel =
        context.watch<RequestAttachmentsViewModel>();
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  CustomEnhancedExpansionPanelWidget(
                    title: 'request_data'.tr(),
                    isExpanded: true,
                    backgroundColor: AppColor.blackModern50Light,
                    leading:
                        const DrawIconBasedTypeWidget(icon: IconPath.clipboard),
                    // backgroundColor: const Color(0x80E6EFEF),
                    children: [
                      CardParameter(
                        title: 'reason_cancellation'.tr(),
                        value: bloc.reasonCancel!.text,
                      ),
                      bloc.hijriCalendar != null
                          ? CardParameter(
                              title: 'activityCancellationDate'.tr(),
                              value: bloc.hijriCalendar.toString(),
                            )
                          : const SizedBox(),
                      Column(
                        children: viewModel.attachments.map(
                          (attachment) {
                            return attachment.attachUrl?.isNotEmpty ?? false
                                ? AttachmentShowWidget(
                                    fileName: attachment.fileName ?? '',
                                    name: attachment.name ?? '',
                                    filePath: attachment.attachUrl ?? '',
                                  )
                                : const SizedBox();
                          },
                        ).toList(),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 16),
                  // CardDescWidget(
                  //   icon: IconPath.saveIcon,
                  //   title: 'note'.tr(),
                  //   description: 'notes_submit_commercial_description'.tr(),
                  // ),
                  const SizedBox(height: 16),
                  CardDescWidget(
                    icon: IconPath.saveIcon,
                    title: 'pledges'.tr(),
                    description: 'pledges_submit_commercial_description'.tr(),
                    widget: BlocBuilder<CommercialLicenseCancelBloc,
                        CommercialLicenseCancelState>(
                      builder: (context, state) {
                        return InkWell(
                          onTap: () {
                            bloc.add(SelectAcknowledgePledge(
                                !bloc.acknowledgePledge));
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: bloc.acknowledgePledge,
                                onChanged: (bool? value) {
                                  bloc.add(
                                      SelectAcknowledgePledge(value ?? false));
                                },
                              ),
                              const SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  'acknowledge_pledge'.tr(),
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: Colors.transparent,
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: Column(
            children: [
              const CardCostInfoWidget(),
              BlocBuilder<CommercialLicenseCancelBloc,
                  CommercialLicenseCancelState>(
                builder: (context, state) {
                  if (state is CommercialLicenseCancelLoadingState) {
                    return const ShimmerEffectWidget(
                      height: 60,
                      borderRadius: 8,
                    );
                  }
                  return EnhancedCustomElevatedButtonWidget(
                    btnColor: !bloc.acknowledgePledge
                        ? AppColor.black200
                        : AppColor.primary900Light,
                    btnTextColor: !bloc.acknowledgePledge
                        ? AppColor.black400
                        : AppColor.white,
                    btnPressed: !bloc.acknowledgePledge
                        ? null
                        : () {
                            bloc.add(const SubmitCancelRequestPage());
                          },
                    btnRadius: 8,
                    btnText: "submit_order".tr(),
                    btnTextSize: 16,
                    btnTextWeight: AppFontWeight.bold,
                    btnHeight: 56,
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
