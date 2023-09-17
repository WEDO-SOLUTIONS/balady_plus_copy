import 'package:balady_plus/etmam_app/core/utils/constants/app_color.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';

class BiddingErrorsWidget extends StatelessWidget {
  final List<String>? errors;
  const BiddingErrorsWidget({super.key, this.errors});

  @override
  Widget build(BuildContext context) {
    return errors != null
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: errors?.length ?? 0,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                          color: AppColor.redForCancel,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                    CustomHorizontalSpace(width: 8),
                    CustomTextWidget(
                      textAlign: TextAlign.right,
                      errors!.first,
                      fontSize: 12,
                      fontColor: AppColor.redForCancel,
                    ),
                  ],
                ),
              );
            })
        : Container();
  }
}
