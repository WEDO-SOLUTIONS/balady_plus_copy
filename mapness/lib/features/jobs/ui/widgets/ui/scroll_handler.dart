import 'package:flutter/cupertino.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class DragHandle extends StatelessWidget {
  final BorderRadius? borderRadius;

  const DragHandle({super.key, this.borderRadius});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            color: context.color.text_and_icons_base_primary.withOpacity(0.1),
          ),
          height: 4,
          width: 40,
        ),
      );
}
