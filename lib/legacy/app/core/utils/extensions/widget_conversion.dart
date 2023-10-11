import 'package:flutter/material.dart'
    show
        Color,
        Column,
        CrossAxisAlignment,
        EdgeInsetsDirectional,
        Padding,
        SliverPadding,
        Widget;

import '../../../features/_shared_feature_/shared_feature_exports.dart'
    show DrawLineWidget;
import '../utils_exports.dart' show AppColor;

extension WidgetConversion on List<Widget> {
  List<Widget> addPadding({
    double start = 0.0,
    double top = 0.0,
    double end = 0.0,
    double bottom = 0.0,
    bool ignoreFirstItem = false,
    bool ignoreLastItem = true,
  }) =>
      map((child) =>
          ignoreLastItem && child == last || ignoreFirstItem && child == first
              ? child
              : Padding(
                  padding: EdgeInsetsDirectional.only(
                    start: start,
                    top: top,
                    end: end,
                    bottom: bottom,
                  ),
                  child: child,
                )).toList();

  List<Widget> addSliverPadding({
    double start = 0.0,
    double top = 0.0,
    double end = 0.0,
    double bottom = 0.0,
    bool ignoreFirstItem = false,
    bool ignoreLastItem = true,
  }) =>
      map((child) =>
          ignoreLastItem && child == last || ignoreFirstItem && child == first
              ? child
              : SliverPadding(
                  padding: EdgeInsetsDirectional.only(
                    start: start,
                    top: top,
                    end: end,
                    bottom: bottom,
                  ),
                  sliver: child,
                )).toList();

  List<Widget> addSeparator({
    Color color = AppColor.gray,
    double width = 1.0,
    double verticalSpace = 0.0,
    double horizontalSpace = 0.0,
    bool ignoreLastItem = true,
  }) =>
      map((child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              child,
              if (ignoreLastItem && child != last)
                DrawLineWidget(
                  lineColor: color,
                  lineHeight: width,
                  verticalMargin: verticalSpace,
                  horizontalMargin: horizontalSpace,
                ),
            ],
          )).toList();
}
