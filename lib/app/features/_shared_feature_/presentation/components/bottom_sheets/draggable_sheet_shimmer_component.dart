import 'package:flutter/material.dart';

import '../../../../../core/services/services_exports.dart'
    show NavigationService;
import '../../../../../core/utils/utils_exports.dart'
    show ContextConversion, UIHelper, WidgetConversion;
import '../../../shared_feature_exports.dart'
    show
        GlowingScrollWidget,
        ShimmerEffectWidget,
        TitleSubtitleShimmerComponent;

class DraggableSheetShimmerComponent extends StatelessWidget {
  final double? height;
  final int numOfBodyFields;
  const DraggableSheetShimmerComponent({
    super.key,
    this.height,
    this.numOfBodyFields = 6,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: height ?? 0.6,
      minChildSize: height ?? 0.6,
      maxChildSize: 0.94,
      expand: false,
      builder: (_, controller) => Padding(
        padding: padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Line widget
            const ShimmerEffectWidget(height: 17.0, width: 100.0),
            // Title
            const ShimmerEffectWidget(
              height: 45.0,
              width: 200.0,
              borderRadius: 8.0,
            ),
            // Body
            Expanded(
              child: GlowingScrollWidget(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: List.filled(
                    numOfBodyFields,
                    const Padding(
                      padding: EdgeInsets.only(bottom: UIHelper.middlePadding),
                      child: TitleSubtitleShimmerComponent(),
                    ),
                  ),
                ),
              ),
            ),
          ].addPadding(bottom: 24.0),
        ),
      ),
    );
  }

  EdgeInsetsGeometry get padding => EdgeInsets.only(
        right: UIHelper.mediumPadding,
        left: UIHelper.mediumPadding,
        top: UIHelper.smallPadding,
        bottom: context.bottomPadding,
      );
  BuildContext get context => NavigationService.navigatorKey.currentContext!;
}
