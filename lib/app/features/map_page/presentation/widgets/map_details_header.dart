import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';


class MapDetailsHeader extends StatelessWidget {
  final String name;
  final String address;
  const MapDetailsHeader(
      {super.key, required this.name, required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            width: double.infinity,
            decoration: ShapeDecoration(
              color: AppColor.primary900Light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              // image: DecorationImage(image: AssetImage())
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColor.white,
                    )),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CustomTextWidget(
                        name,
                        fontColor: AppColor.blackModern800Light,
                        fontWeight: AppFontWeight.bold,
                        fontSize: 18,
                      ),
                      CustomTextWidget(
                        address,
                        fontColor: AppColor.blackModern500Light,
                        fontWeight: AppFontWeight.semiBold,
                        fontSize: 14,
                      )
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }
}
