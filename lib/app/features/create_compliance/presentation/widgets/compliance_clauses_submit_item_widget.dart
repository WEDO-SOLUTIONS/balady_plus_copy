import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/radio_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:collection/collection.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../_shared_feature_/data/entities/file_data_item.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../home_page/presentation/widgets/home_tag.dart';
import '../../../objectable_transactions/presentation/widgets/create_objection_page/objection_attachment_item.dart';
import '../../../objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import '../../../objectable_transactions/presentation/widgets/objection_feedback_details_dialog.dart';
import '../../domain/entities/comliance_request_details.dart';
import '../dialogs/complince_notes_dialog.dart';
import 'compliance_submission/sixth_submit_step.dart';

class ComplianceClauseSubmitItem extends StatefulWidget {
  final EmtithalItem item;
  final bool isReturned;
  final int index;

  final Function onChange;
  final Function(EmtithalItem item) onSubmit;

  const ComplianceClauseSubmitItem(
      {super.key,
      required this.item,
      required this.index,
      required this.onChange,
      required this.isReturned,
      required this.onSubmit});

  @override
  State<ComplianceClauseSubmitItem> createState() =>
      _ComplianceClauseSubmitItemState();
}

class _ComplianceClauseSubmitItemState
    extends State<ComplianceClauseSubmitItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isExpanded = (widget.item.edit == true);
  }

  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    ItemData? lastNote = widget.item.itemData?.firstOrNull;
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 16, bottom: 16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: widget.item.edit != true ? AppColor.blackModern200Light : null,
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          border: Border.all(color: const Color(0xffD4D4D8), width: 1)),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomTextWidget(
                  "${"complinace_clause".tr()} ${widget.index + 1}",
                  fontColor: AppColor.blackModern800Light,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 14,
                ),
                Row(
                  children: [
                    if (widget.item.getCurrentAnswer() != null) ...[
                      HomeTag(
                        title: widget.item.getCurrentAnswer()!,
                        backgroundColor: AppColor.secondary100Light,
                      ),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                    Container(
                      decoration: const BoxDecoration(
                        color: AppColor.primary300Light,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColor.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Column(
              children: [
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomTextWidget(
                        widget.item.itemDesc ?? "",
                        fontColor: const Color(0xff6B6B6B),
                        fontWeight: AppFontWeight.bold,
                        fontSize: 14,
                        maxLines: 100,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SingleRatioOption(
                        value: 1,
                        selected: widget.item.submitterAnswer,
                        title: 'compliance'.tr(),
                        flex: true,
                        height: MediaQuery.of(context).size.height * 0.05,
                        titleStyle: AppStyle.complianceClausesOptionStyle,
                        onChanged: (int val) {
                        //  if (widget.item.edit == true) {
                            widget.item.submitterAnswer = 1;
                            widget.onChange(widget.item);
                            widget.onSubmit(widget.item);
                          //}
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      flex: 1,
                      child: SingleRatioOption(
                        title: 'nonـcompliance'.tr(),
                        value: 0,
                        flex: true,
                        selected: widget.item.submitterAnswer,
                        height: MediaQuery.of(context).size.height * 0.05,
                        titleStyle: AppStyle.complianceClausesOptionStyle,
                        onChanged: (int val) {
                        //  if (widget.item.edit == true) {
                            widget.item.submitterAnswer = 0;
                            widget.onChange(widget.item);
                            widget.onSubmit(widget.item);
                         // }
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    if (widget.item.showNotApplicable == true)
                      Expanded(
                        flex: 1,
                        child: SingleRatioOption(
                          title: 'Not_Applicable'.tr(),
                          value: 2,
                          flex: true,
                          selected: widget.item.submitterAnswer,
                          height: MediaQuery.of(context).size.height * 0.05,
                          titleStyle: AppStyle.complianceClausesOptionStyle,
                          onChanged: (int val) {
                           // if (widget.item.edit == true) {
                              widget.item.submitterAnswer = 2;
                              widget.onChange(widget.item);
                            //}
                          },
                        ),
                      ),
                  ],
                ),

                const SizedBox(
                  height: 16,
                ),
                if ((widget.item.showNoteAndAttachments(widget.isReturned)) &&
                    widget.item.edit == true) ...[
                  CustomTextFieldWidget(
                    label: "notes".tr(),
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp('[٠١٢٣٤٥٦٧٨٩]')),
                    ],
                    initialValue: widget.item.notes,
                    onChanged: (String t) {
                      widget.item.notes = t;
                      widget.onChange(widget.item);
                    },
                    maxLines: 5,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (widget.item.file == null)
                    ElevatedIconButtonWidget.upload(
                      onPressed: () async {
                        FileDataItem? file =
                            await CommonFunctions.pickFile(context);
                        if (file != null) {
                          widget.item.file = file;
                          widget.onChange(widget.item);

                          // context
                          //     .read<EnquiryObjectionBloc>()
                          //    .add(UploadFileEvent(params: file, index: index));
                        }
                      },
                    ),
                  if (widget.item.file != null)
                    ObjectionReasonAttachment(
                      onDelete: () {
                        // context
                        //    .read<EnquiryObjectionBloc>()
                        //   .add(RemoveFileEvent(index: index));

                        widget.item.file = null;
                        widget.onChange(widget.item);
                      },
                      fileName: widget.item.file?.fileName ?? "",
                      filePath: widget.item.file?.filePath ?? "",
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                ],

                // change by fawzi to show it only when anser is equal 2
               widget.item.submitterAnswer==2?
                ElevatedButtonWidget.custom(
                  isDisabled: (widget.item.submitterAnswer == null ||
                          widget.item
                                  .showNoteAndAttachments(widget.isReturned) &&
                              ((widget.item.isAttachmentRequired(
                                          widget.isReturned) &&
                                      widget.item.file == null) ||
                                  (widget.item
                                          .isNoteRequired(widget.isReturned)) &&
                                      (widget.item.notes?.isEmpty ?? true))) &&
                      widget.item.edit == true,
                  text: widget.item.edit != true
                      ? "complaince_edit_clause".tr()
                      : "complaince_save_clause".tr(),
                  onPressed: () {
                    if (widget.item.edit == true)
                      widget.onSubmit(widget.item);
                    else {
                      widget.item.edit = true;
                      widget.onChange(widget.item);
                    }
                  },
                ):Container(),
                if (widget.item.itemData?.isNotEmpty ?? false) ...[
                  if (lastNote != null)
                    ComplianceClauseNotesItem(item: lastNote),
                  SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      CustomPopUpsWidgets.showBottomSheet(
                          NavigationService.navigatorKey.currentContext!,
                          child: ComplainceNotesDialog(
                            itemData: widget.item.itemData,
                          ));
                    },
                    child: CustomTextWidget(
                      "compliance_show_prevoius_notes".tr(),
                      fontColor: AppColor.primary900Light,
                      fontSize: 16,
                    ),
                  )
                ]
              ],
            )
        ],
      ),
    );
  }
}

class ComplianceClauseNotesItem extends StatelessWidget {
  final ItemData item;
  const ComplianceClauseNotesItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 8, top: 8),
      decoration: BoxDecoration(
          color: Color(0xAACDE2E2), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                item.isBaladiaSource == true
                    ? "compliance_office_reply".tr()
                    : "compliance_submitter_reply".tr(),
                fontColor: AppColor.primary700Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 12,
              ),
              CustomTextWidget(
                item.date ?? "",
                fontColor: AppColor.blackModern500Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 14,
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          CustomTextWidget(
            item.note ?? "",
            fontColor: AppColor.blackModern600Light,
            fontWeight: AppFontWeight.medium,
            fontSize: 12,
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            children: [
              CustomTextWidget(
                "compliance_claues_status".tr(),
                fontColor: AppColor.blackModern500Light,
                fontWeight: AppFontWeight.bold,
                fontSize: 14,
              ),
              const SizedBox(
                width: 16,
              ),
              HomeTag(
                title: item.getCurrentAnswer().toString(),
                backgroundColor: AppColor.secondary100Light,
              )
            ],
          ),
          if (item.attachment?.downloadPath != null)
            ComplainceAttachment(
              url: item.attachment?.downloadPath?.toString() ?? "",
              name: item.attachment?.dmsAttachName.toString(),
            ),
        ],
      ),
    );
  }
}
