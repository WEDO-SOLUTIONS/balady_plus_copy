import 'package:flutter/material.dart';
import '../../../../core/utils/utils_exports.dart';

class ReadOnlyField extends StatelessWidget {
  const ReadOnlyField({
    Key? key,
    required this.label,
    required this.value,
    this.withBottomMargin = true,
  }) : super(key: key);

  final String label;
  final String? value;
  final bool withBottomMargin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyle.mainTextSecondaryStyle.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColor.blackModern700Light),
        ),
        const SizedBox(height: 8),
        Container(
          width: MediaQuery.sizeOf(context).width,
          padding: const EdgeInsets.all(16),
          decoration:  BoxDecoration(
            color: AppColor.kGray230.withOpacity(0.5),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: Text(
            value ?? '',
            style: AppStyle.mainTextThirdStyle.copyWith(
              fontSize: 13.0,
              color: AppColor.black,
            ),
          ),
        ),
        if(withBottomMargin)const SizedBox(height: 24),
      ],
    );
  }
}
