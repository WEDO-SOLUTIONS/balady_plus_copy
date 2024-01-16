import 'package:balady_uikit/components/content_row/content_row.dart';
import 'package:balady_uikit/gen/base.dart';
import 'package:flutter/material.dart';
// import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'ContentRow',
  type: ContentRow,
)
ContentRow contentRowWork(BuildContext context) {
  return ContentRow(child:  Row(
    children: [
      ///TODO: wait for icons
      // SvgPicture.asset(
      //   'assets/icons/svg/ic_work.svg',
      //   package: PackageConfig.packageName,
      //   height: 24,
      //   width: 24,
      //   colorFilter: ColorFilter.mode(
      //     Base.black_100.withAlpha(125),
      //     BlendMode.srcATop,
      //   ),
      // ),
      const SizedBox(
        width: 8,
      ),
      Text(
        "context.l10n.work",
        style: const TextStyle(
          color: Base.black_100,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  ),);
}
