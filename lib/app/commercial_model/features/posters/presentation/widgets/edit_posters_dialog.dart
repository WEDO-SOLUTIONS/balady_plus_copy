import 'package:balady_plus/app/core/services/local/helpers.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:balady_plus/app/commercial_model/features/posters/presentation/widgets/steps/step2/poster_view_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import '../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../blocs/posters_license_bloc.dart';

class EditPostersDialog extends StatefulWidget {
  const EditPostersDialog({super.key});

  @override
  State<EditPostersDialog> createState() => _EditPostersDialogState();
}

class _EditPostersDialogState extends State<EditPostersDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostersLicenseBloc, PostersLicenseState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure) {
        CommonFunctions.showError(state.error ?? "");
      }
    }, builder: (context, state) {
      return Container(
        color: AppColor.white,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CustomTextWidget(
                  Helpers.translatingWord("edit_posters".tr()),
                  fontColor: AppColor.blackModern900Light,
                  fontWeight: AppFontWeight.bold,
                  maxLines: 10,
                ),
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleIcon(
                      icon: Icons.close,
                      iconColor: AppColor.primary600Light,
                      backgroundColor: AppColor.geyser.withOpacity(0.4),
                      iconSize: 18,
                    )),
              ]),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.requestDetails?.posters?.length ?? 0,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx, index) {
                    return ExpandableCard(
                        title: "poster_index"
                            .tr()
                            .replaceAll("{}", (index + 1).toString()),
                        icon: IconPath.vdSummuryDesc,
                        children: [
                          PosterViewItemWidget(
                            index: index + 1,
                            item: state.requestDetails!.posters![index],
                          ),
                        ]);
                  }),
              ElevatedButtonWidget.primaryCustom(
                  onPressed: () {
                    context
                        .read<PostersLicenseBloc>()
                        .add(SubmitPosterEvent(editMode: true));
                  },
                  text: "إرسال الطلب")
            ],
          ),
        ),
      );
    });
  }
}
