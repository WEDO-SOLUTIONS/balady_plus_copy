import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/icons/system_icons.dart';
import 'package:flutter/widgets.dart';

class ArrowBeige extends StatelessWidget {
  final Color? color;

  const ArrowBeige({super.key, this.color});

  @override
  Widget build(BuildContext context) => Icon(
        color: context.colors.foregroundDefault,
        switch (Directionality.of(context)) {
          TextDirection.rtl => SystemIcons.arrowCornerRightSmall,
          TextDirection.ltr => SystemIcons.arrowCornerLeftSmall,
        },
        textDirection: TextDirection.rtl,
      );
}
