import 'package:flutter/material.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class SplTypesCard extends StatelessWidget {
  final String cardText;
  final String cardIcon;
  final VoidCallback onCardPressed;
  final bool isSelected;

  SplTypesCard(
      {Key? key,
      required this.cardText,
      required this.cardIcon,
      required this.onCardPressed,
      required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardPressed,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: 160,
        width: 135,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          color: isSelected ? AppColor.primary100Light : AppColor.white,
          boxShadow: const [
            BoxShadow(
                color: Color(0x1a000000),
                offset: Offset(0, 1),
                blurRadius: 17,
                spreadRadius: 0)
          ],
        ),
        child: Column(
          children: [
            CustomVerticalSpace(height: 20),
            // icon
            CustomCachedNetworkImage(
              cardIcon,
              imageHeight: 42,
              imageWidth: 42,
              placeHolderWidget: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width * 0.6,
                height: 42,
              ),
            ),
            // CustomNetworkImageWidget(
            //   cardIcon,
            //   imageHeight: 42,
            //   imageWidth: 42,
            //   ssoAuth: true,
            // ),
            CustomVerticalSpace(height: 14),
            //  name
            // CustomTextWidget(
            //   cardText,
            //   fontColor: AppColor.black,
            //   fontSize: 14.0,
            //   maxLines: 2,
            // ),
            CustomAutoSizeTextWidget(
              cardText,
              fontColor: AppColor.black,
              maxFontSize: 14.0,
              minFontSize: 10,
              maxLines: 4,
              height: 1.3,
              textOverflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
