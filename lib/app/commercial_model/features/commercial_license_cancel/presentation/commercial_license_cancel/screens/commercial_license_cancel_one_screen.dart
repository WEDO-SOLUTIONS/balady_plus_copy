import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/presentation/commercial_license/widgets/cr_header_desc.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/blocs/commercial_license_cancel/commercial_license_cancel_bloc.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/request_attachments_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/data/models/reason_cancel.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_details/presentation/mvvm/commercial_license_reason_cancel_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import 'package:balady_plus/app/features/_shared_feature_/presentation/enhanced_widgets/pickers/hijri_picker/hijri_picker.dart'
    as hijri_picker;

class CommercialLicenseCancelOneScreen extends StatelessWidget {
  CommercialLicenseCancelOneScreen({Key? key}) : super(key: key);

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
                  CRHeaderDesc(header: "applicantInfo".tr()),
                  const SizedBox(height: 12),
                  BlocBuilder<CommercialLicenseCancelBloc,
                      CommercialLicenseCancelState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<CommercialLicenseReasonCancelViewModel>(
                            builder: (context, provider, child) {
                              return !provider.isLoading
                                  ? DropDownWithTitle(
                                      title: "reason_cancel".tr(),
                                      selectedValue: bloc.reasonCancel?.text,
                                      status: null,
                                      onRetry: () {
                                        // context.read<ComplianceBloc>().add(
                                        //   const GetMainUsagesEvent(),
                                        // );
                                      },
                                      onTap: () {
                                        // if (state.requestDetails?.usageDisable == true) return;
                                        BottomSheetDialog.showDraggableSheet(
                                          context,
                                          dialogKeyName:
                                              DialogName.reasonCancelDialog,
                                          currentRouteName: RouteName
                                              .commercialLicenseApplyCancel,
                                          child: GenericBottomSheetList<
                                              ReasonCancel>(
                                            title: "reason_cancel".tr(),
                                            items: provider.reasonCancelList,
                                            selectedValue: null,
                                            onTap: (item) {
                                              bloc.add(
                                                  SelectReasonCancel(item));
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      },
                                    )
                                  : const ShimmerEffectWidget(
                                      height: 55,
                                      borderRadius: 6,
                                    );
                            },
                          ),
                          const SizedBox(height: 16),
                          bloc.availableCloseDate
                              ?
                          Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextWidget(
                                      'activityCancellationDate'.tr(),
                                      textStyle:
                                          AppStyle.dropDownTitleTextStyle,
                                    ),
                                    const SizedBox(height: 6),
                                    CustomTextFieldWidget(
                                      onTap: () {
                                        hijri_picker.Picker(
                                          isAr: CommonFunctions.isAppAR,
                                          confirmTextStyle:
                                              AppStyle.textButtonStyle.copyWith(
                                            color: AppColor.primary900Light,
                                          ),
                                          cancelTextStyle:
                                              AppStyle.textButtonStyle.copyWith(
                                            color: AppColor.primary900Light,
                                          ),
                                          headercolor: AppColor.paleGrey,
                                          height: 270,
                                          confirmText: 'choose'.tr(),
                                          title: CustomTextWidget(
                                            'activityCancellationDate'.tr(),
                                            textStyle:
                                                AppStyle.dropDownTitleTextStyle,
                                          ),
                                          hideHeader: false,
                                          adapter: hijri_picker
                                              .DateTimePickerAdapter(
                                            // minValue: HijriCalendar.fromDate(DateTime.now()),
                                            maxValue: HijriCalendar.fromDate(
                                                DateTime.now()),
                                            customColumnType:
                                                CommonFunctions.isAppAR
                                                    ? [2, 1, 0]
                                                    : [0, 1, 2],
                                            value: HijriCalendar.fromDate(
                                                DateTime.now()),
                                          ),
                                          selectedTextStyle: const TextStyle(
                                              color: AppColor.primary900Light),
                                          onConfirm: (picker, value) {
                                            final date = (picker.adapter
                                                    as hijri_picker
                                                    .DateTimePickerAdapter)
                                                .value;
                                            if (date != null) {
                                              bloc.add(
                                                  SelectHijriCalendar(date));
                                            }
                                          },
                                          cancelText: 'cancel'.tr(),
                                        ).showModal(context);
                                      },
                                      suffixIcon: InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: const Icon(Icons.clear),
                                        ),
                                        onTap: () {
                                          bloc.add(
                                              const SelectHijriCalendar(null));
                                        },
                                      ),
                                      controller: bloc.controller,
                                      readOnly: true,
                                      disabledColor: Colors.transparent,

                                      // onValidate: (date) =>
                                      // date?.isNotEmpty ?? false
                                      //     ? null
                                      //     : "select_date".tr()
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      );
                    },
                  ),
                  Consumer<RequestAttachmentsViewModel>(
                    builder: (context, provider, child) {
                      return !provider.isLoading
                          ? Column(
                              children: provider.attachments
                                  .map(
                                    (attachment) => Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        CustomTextWidget(
                                          attachment.name ?? '',
                                          fontColor:
                                              AppColor.blackModern700Light,
                                          fontSize: 16,
                                          fontWeight: AppFontWeight.bold,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            FileDataItem? file =
                                                await CommonFunctions.pickFile(
                                                    context);
                                            if (file != null) {
                                              if ((file.sizeInMB * 1000) <=
                                                  (attachment.maxSize ?? 0)) {
                                                provider
                                                    .uploadCommercialLicenseCancelAttachments(
                                                  file,
                                                  attachment.id!,
                                                );
                                              } else {
                                                CommonFunctions.showError(
                                                    "file_max_size".tr());
                                              }
                                            }
                                          },
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(top: 6),
                                            padding: const EdgeInsets.all(16),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16)),
                                              border: Border.all(
                                                color: AppColor.primary800Light,
                                              ),
                                              color: Colors.transparent,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const CustomSvgIconWidget(
                                                  IconPath.add,
                                                  iconSize: 20,
                                                ),
                                                const SizedBox(width: 4),
                                                CustomTextWidget(
                                                  'attachment'.tr(),
                                                  fontColor:
                                                      AppColor.primary800Light,
                                                  fontSize: 16,
                                                  fontWeight:
                                                      AppFontWeight.bold,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        CustomTextWidget(
                                          '${'attachment_message_typ'.tr()} ${attachment.allowedFilesExtension ?? ''} ${'attachment_message_size'.tr()} ${(attachment.maxSize ?? 0) ~/ 1000} MB',
                                          fontColor:
                                              AppColor.blackModern700Light,
                                          fontSize: 16,
                                          fontWeight: AppFontWeight.bold,
                                          maxLines: 3,
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            )
                          : const ShimmerEffectWidget(
                              height: 65,
                              borderRadius: 8,
                            );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: BlocBuilder<CommercialLicenseCancelBloc,
              CommercialLicenseCancelState>(
            builder: (context, state) {
              if (state is CommercialLicenseCancelLoadingState) {
                return const ShimmerEffectWidget(
                  height: 60,
                  borderRadius: 8,
                );
              }

              bool isBtnDisabled =
                  !(bloc.reasonCancel != null && viewModel.fileDone);
              return Selector<RequestAttachmentsViewModel, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (_, isLoading, child) {
                  if (isLoading) {
                    isBtnDisabled = isLoading;
                  }
                  return EnhancedCustomElevatedButtonWidget(
                    btnColor: isBtnDisabled
                        ? AppColor.black200
                        : AppColor.primary900Light,
                    btnTextColor:
                        isBtnDisabled ? AppColor.black400 : AppColor.white,
                    btnPressed: isBtnDisabled
                        ? null
                        : () {
                            bloc.add(const SubmitFirstPage());
                          },
                    btnRadius: 8,
                    btnText: ("next").tr(),
                    btnTextSize: 16,
                    btnTextWeight: AppFontWeight.bold,
                    btnHeight: 56,
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 20)
      ],
    );
  }
}
