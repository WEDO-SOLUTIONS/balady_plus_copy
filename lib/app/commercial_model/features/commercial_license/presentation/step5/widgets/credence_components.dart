import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../features/_shared_feature_/data/entities/file_data_item.dart';
import '../../../../../../features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/create_objection_page/objection_reason_attachment.dart';
import '../../../domain/entities/credence_response.dart';
import '../../commercial_license/widgets/cr_header_desc.dart';
import '../bloc/cr_step5_attachment_data_cubit.dart';

class CredenceComponents extends StatelessWidget {
  const CredenceComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CRStep5AttachmentCubit, CRStep5AttachmentState>(
        builder: (context, state) {
      return state.crdences != null && state.crdences!.isNotEmpty
          ? Builder(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CRHeaderDesc(
                    maxLines: null,
                    textHeight: 1.5,
                    header: "cr_credence".tr(),
                    desc: "cr_credence_agreements".tr(),
                  ),
                  const CustomVerticalSpace(height: 16),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.crdences?.length ?? 0,
                      itemBuilder: (ctx, index) {
                        return CredenceItemComponent(
                          index: index,
                          item: state.crdences![index],
                          onDelete: () {
                            context
                                .read<CRStep5AttachmentCubit>()
                                .deleteCredence(index);
                          },
                          onUpload: (FileDataItem? item) {
                            context
                                .read<CRStep5AttachmentCubit>()
                                .uploadCrednece(item!, index);
                          },
                        );
                      })
                ],
              );
            })
          : Container();
    });
  }
}

class CredenceItemComponent extends StatelessWidget {
  final CredenceItem item;
  final int index;
  final Function(FileDataItem? file) onUpload;
  final Function onDelete;
  const CredenceItemComponent(
      {super.key,
      required this.item,
      required this.onUpload,
      required this.onDelete,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Color(0x80E6EFEF), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldData(
            title: "authority".tr(),
            subTitle: item.credenceName ?? "",
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          FieldData(
            title: "approvalType".tr(),
            subTitle: item.credenceTypeName ?? "",
          ),
          const CustomVerticalSpace(
            height: 16,
          ),
          if (item.credenceTypeId == 2) ...[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: CustomTextWidget(
                "print_credence_letter".tr(),
                fontColor: AppColor.primary700Light,
                fontSize: 12,
                maxLines: 10,
                fontWeight: AppFontWeight.semiBold,
              ),
            ),
            CustomElevatedIconButtonWidget(
              text: "letter".tr(),
              btnColor: Colors.transparent,
              btnHeight: 56,
              btnPadding: EdgeInsets.symmetric(horizontal: 16),
              btnBorderColor: Colors.transparent,
              textStyle: AppStyle.elevatedButtonStyle.copyWith(
                color: AppColor.blackModern700Light,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              btnAlignment: MainAxisAlignment.spaceBetween,
              iconAlignment: AlignmentDirectional.centerEnd,
              icon: const CustomSvgIconWidget(IconPath.receiveSquare,
                  iconSize: 20.0),
              onPressed: () {
                CommonFunctions.externalLaunch(item.letterUrl);
              },
            ),
            if (item.attachmentUrl == null)
              ElevatedIconButtonWidget.upload(
                onPressed: () async {
                  FileDataItem? file = await CommonFunctions.pickFile(context);
                  if (file != null) onUpload(file);
                },
              ),
            if (item.attachmentUrl != null)
              ObjectionReasonAttachment(
                onDelete: () {
                  onDelete();
                },
                fileName: item.attachmentUrl ?? "",
                filePath: item.attachmentUrl ?? "",
              )
          ]
        ],
      ),
    );
  }
}
