import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:balady_plus/app/features/posters/presentation/widgets/steps/step2/poster_item_widget.dart';
import 'package:balady_plus/app/features/posters/presentation/widgets/steps/step2/poster_view_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/enums/app_font_weights.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../blocs/posters_license_bloc.dart';

class EditPostersDialog extends StatefulWidget {
  const EditPostersDialog({super.key});

  @override
  State<EditPostersDialog> createState() => _EditPostersDialogState();
}

class _EditPostersDialogState extends State<EditPostersDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
        builder: (context, state) {
      print(state.requestDetails?.alerts);
      return Container(
        color: AppColor.white,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                CustomTextWidget(
                  Helpers.translatingWord("تعديل الملصقات".tr()),
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
                    return PosterViewItemWidget(
                      index: index + 1,
                      item: state.requestDetails!.posters![index],
                    );
                  }),
            ],
          ),
        ),
      );
    });
  }
}
