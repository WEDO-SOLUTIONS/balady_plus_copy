import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/enums/enums.dart';

List<RequestsType> types = [
  RequestsType.MUN,
  RequestsType.REQ,
  RequestsType.INQ,
  RequestsType.TSR,
  RequestsType.DC,
  RequestsType.VHR
];

class RequestTypeHorizontalList extends StatelessWidget {
  final RequestsType selected;
  final Function(RequestsType type) onSelect;
  const RequestTypeHorizontalList(
      {super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      child: ListView.builder(
          itemCount: types.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return InkWell(
              onTap: () => onSelect(types[index]),
              child: Container(
                height: 34,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                margin: const EdgeInsetsDirectional.only(end: 8),
                decoration: ShapeDecoration(
                  color: selected == types[index]
                      ? AppColor.primary900Light
                      : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x0F0C243C),
                      blurRadius: 32,
                      offset: Offset(0, 8),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: CustomTextWidget(
                  types[index].title.tr(),
                  fontColor: selected == types[index]
                      ? AppColor.white
                      : AppColor.blackModern500Light,
                  fontSize: 11,
                  fontWeight: AppFontWeight.bold,
                ),
              ),
            );
          }),
    );
  }
}
