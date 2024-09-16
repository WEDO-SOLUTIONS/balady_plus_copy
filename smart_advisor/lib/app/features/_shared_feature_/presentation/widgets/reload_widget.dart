import '/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

class ReloadWidget extends StatelessWidget {
  final double widgetHeight;
  final VoidCallback onTab;

  const ReloadWidget({Key? key, this.widgetHeight = 150, required this.onTab})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: Container(
        width: double.infinity,
        height: widgetHeight,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: AppColor.white, width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, 4), // changes position of shadow
              )
            ]),
        child: Center(
          child: Text(
            trans('reload'),
            style: AppStyle.mainTextStyle
                .copyWith(color: AppColor.statusAccentColor),
          ),
        ),
      ),
    );
  }
}
