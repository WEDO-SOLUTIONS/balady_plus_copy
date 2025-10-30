import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../create_objection_bloc/create_objection_bloc.dart';
import '../create_objection_page/objection_reason_attachment.dart';

class DescriptionSummuryWidget extends StatelessWidget {
  const DescriptionSummuryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
      builder: (context, state) {
        return CustomExpansionPanelWidget(
          title: ("objection_details_objections_list").tr(),
          leading: SvgPicture.asset(IconPath.vdSummuryDesc),
          children: [
            MediaQuery.removePadding(
              removeTop: true,
              removeBottom: true,
              context: context,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.reasons?.length ?? 0,
                itemBuilder: ((context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTextWidget(
                        state.reasons?[index].notes ?? "",
                        fontColor: AppColor.blackModern700Light,
                        maxLines: 90,
                        textAlign: TextAlign.start,
                      ),
                      if (state.reasons?[index].file != null)
                        ObjectionReasonAttachment(
                          onDelete: () {},
                          fileName: state.reasons?[index].file?.fileName ?? "",
                          filePath: state.reasons?[index].file?.filePath ?? "",
                        ),
                      const CustomVerticalSpace(height: 32),
                    ],
                  );
                }),
              ),
            )
          ],
        );
      },
    );
  }
}
