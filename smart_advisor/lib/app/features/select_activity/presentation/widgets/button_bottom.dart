import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/core/utils/constants/route_names.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

class ButtonBottomWidget extends StatelessWidget {
  const ButtonBottomWidget({super.key, this.text, this.onPress});
  final String? text;
  final Function? onPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomCenter,
      padding: const EdgeInsets.only(top: 6, bottom: 16),
      decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      child: Column(
        children: [
          /* Center(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColor.textPrimaryColor.withOpacity(.10),
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                ),
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomButton(
                onPress: onPress!,
                //  () {
                //   Navigator.pushNamed(
                //       context, RouteName.permitsPage,
                //       arguments: widget.params.copyWith(
                //           addetionalActivites: state
                //                   .addetionalActivitesResponse
                //                   ?.map((e) {
                //                     if (e.isSelected == true) {
                //                       return e;
                //                     }
                //                   })
                //                   .toList()
                //                   .nonNulls
                //                   .toList() ??
                //               []));
                // },
                btnColor: AppColor.primary,
                btnHeight: 45,
                text: text ?? "next".tr()),
          ),
        ],
      ),
    );
  }
}
