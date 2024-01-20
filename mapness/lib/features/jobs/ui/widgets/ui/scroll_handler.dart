import 'package:flutter/cupertino.dart';

class DragHandle extends StatelessWidget {
  final BorderRadius? borderRadius;

  const DragHandle({super.key, this.borderRadius});

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(16),
            color: const Color(0xff1E2A36).withOpacity(0.1),
          ),
          height: 4,
          width: 40,
        ),
      );
}
