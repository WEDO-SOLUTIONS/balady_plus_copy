import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AppColor;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomHorizontalSpace, SubServicePrimaryIconWidget;
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show SearchTitle;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchResultItem extends StatelessWidget {
  String? title;
  String? icon;
  Function onPressed;

  SearchResultItem({Key? key, this.title, this.icon, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Container(
          height: 67,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.only(left: 16, right: 16),
          decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SubServicePrimaryIconWidget(
                icon: icon ?? "",
                iconSize: 20,
                containerSize: 32,
                margin: EdgeInsets.zero,
              ),
              // SearchImage(url: ""),
              CustomHorizontalSpace(width: 16),
              SearchTitle(
                text: title ?? "",
              )
            ],
          )),
    );
  }
}
