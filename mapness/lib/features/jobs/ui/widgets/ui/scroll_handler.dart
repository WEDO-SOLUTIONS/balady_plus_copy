import 'package:flutter/cupertino.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class DragHandle extends StatelessWidget {

  const DragHandle({super.key, this.borderRadius});
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            color: context.color.textAndIconsBasePrimary.withOpacity(0.1),
          ),
          height: 4,
          width: 40,
        ),
      );
}
