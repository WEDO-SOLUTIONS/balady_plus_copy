import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/file_data_item.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../objections/domain/entities/objection_details.dart';
import '../../../profile_features/violations/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import '../../domain/entities/enquiry_objection_reply_params.dart';
import '../enquiry_objection_bloc/enquiry_objection_bloc.dart';

class ObjectionFeedBackReplyDetailsDialog extends StatelessWidget {
  final EnquiryItem item;
  const ObjectionFeedBackReplyDetailsDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => EnquiryObjectionBloc(
              item: item,
            ),
        child: BlocConsumer<EnquiryObjectionBloc, EnquiryObjectionState>(
            listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        }, builder: (context, state) {
          return BottomSheetWithActions(
            title: "details".tr(),
            body: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      right: 20, left: 20, top: 26, bottom: 5),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            itemCount: state.requestDetails?.enquiryQuestionList
                                    ?.length ??
                                0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              EnquiryQuestionList item = state
                                  .requestDetails!.enquiryQuestionList![index];
                              return FeedBackQuestion(
                                  question: item.question ?? "",
                                  answer: item.answer,
                                  hasAnswer: true,
                                  questionDate: "",
                                  answerDate: "",
                                  questionAttachment: item
                                      .questionAttachmentList
                                      ?.firstOrNull
                                      ?.questionAttachmentLocation,
                                  questionAttachmentName: item
                                      .questionAttachmentList
                                      ?.firstOrNull
                                      ?.questionAttachmentName,
                                  answerAttachment: item.answerAttachmentList
                                      ?.firstOrNull?.answerAttachmentLocation,
                                  answerAttachmentName: item
                                      .answerAttachmentList
                                      ?.firstOrNull
                                      ?.answerAttachmentName,
                                  file: item
                                      .answerAttachmentList?.firstOrNull?.file,
                                  canReply: false,
                                  index: index);
                            }),
                        ElevatedButtonWidget.custom(
                            text: "objection_qnuiry_send".tr(),
                            onPressed: () {
                              context
                                  .read<EnquiryObjectionBloc>()
                                  .add(SubmitIncidentEvent());
                            })
                      ],
                    ),
                  ),
                ),
                if (state.status == BlocStatus.loading)
                  const CustomCircularLoadingWidget(),
              ],
            ),
          );
        }));
  }
}

class FeedBackQuestion extends StatelessWidget {
  final bool hasAnswer;
  final String question;
  final String? questionAttachment;
  final String? questionAttachmentName;

  final String? answer;
  final String? answerAttachment;
  final String? answerAttachmentName;

  final bool? canReply;
  final String? questionDate;
  final String? answerDate;
  final FileDataItem? file;
  final int index;

  const FeedBackQuestion(
      {super.key,
      required this.hasAnswer,
      required this.question,
      this.questionAttachment,
      this.questionAttachmentName,
      this.answerAttachmentName,
      this.answer,
      this.answerAttachment,
      this.canReply,
      this.questionDate,
      this.answerDate,
      this.file,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnquiryObjectionBloc, EnquiryObjectionState>(
        builder: (context, state) {
      return Container(
        padding: const EdgeInsetsDirectional.only(top: 12),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
            color: const Color(0xFFF3F7F7),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
                end: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F7F7),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        "objection_enquiry_question".tr(),
                        fontWeight: AppFontWeight.bold,
                        fontSize: 12,
                        fontColor: AppColor.primary700Light,
                      ),
                      CustomTextWidget(
                        questionDate ?? "",
                        fontWeight: AppFontWeight.bold,
                        fontSize: 12,
                        fontColor: AppColor.blackModern500Light,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextWidget(
                    question,
                    fontWeight: AppFontWeight.bold,
                    fontSize: 12,
                    fontColor: AppColor.blackModern600Light,
                  ),
                  if (questionAttachment?.isNotEmpty ?? false)
                    FeedbackAttachment(
                      url: CommonFunctions.getDMSUrl(questionAttachment ?? ""),
                      name: questionAttachmentName,
                    )
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsetsDirectional.only(start: 12, end: 12, top: 8),
              margin: const EdgeInsetsDirectional.only(
                top: 32,
              ),
              decoration: BoxDecoration(
                  color: AppColor.primary100Light,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFieldWidget(
                    label: "objection_enquiry_reply".tr(),
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColor.primary700Light,
                    ),
                    maxLines: 4,
                    onChanged: (String? t) {
                      context
                          .read<EnquiryObjectionBloc>()
                          .add(ChangeIssueDescEvent(text: t, index: index));
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  if (file == null)
                    ElevatedIconButtonWidget.upload(
                      onPressed: () async {
                        FileDataItem? file =
                            await CommonFunctions.pickFile(context);
                        if (file != null) {
                          context
                              .read<EnquiryObjectionBloc>()
                              .add(UploadFileEvent(params: file, index: index));
                        }
                      },
                    ),
                  if (file != null)
                    ObjectionReasonAttachment(
                      onDelete: () {
                        context
                            .read<EnquiryObjectionBloc>()
                            .add(RemoveFileEvent(index: index));
                      },
                      fileName: file?.fileName ?? "",
                      filePath: file?.filePath ?? "",
                    ),
                  const SizedBox(
                    height: 16,
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}

class FeedBackAnswer extends StatelessWidget {
  const FeedBackAnswer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FeedbackAttachment extends StatelessWidget {
  final String url;
  final String? name;
  const FeedbackAttachment({super.key, required this.url, this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          CommonFunctions.showApigeeFile(
              url, name ?? DateTime.now().millisecond.toString(),
              serviceId: 2);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0x80E6EFEF)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomTextWidget(
                "obkection_enquiry_show_file".tr(),
                fontColor: AppColor.primary900Light,
                fontSize: 12,
                fontWeight: AppFontWeight.bold,
              ),
              SizedBox(
                height: 32,
              ),
              const CustomSvgIconWidget(IconPath.receiveSquare, iconSize: 24.0),
            ],
          ),
        ));
  }
}
