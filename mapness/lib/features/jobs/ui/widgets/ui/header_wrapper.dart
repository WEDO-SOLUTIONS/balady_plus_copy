import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/close_button.dart';

class HeaderWrapper extends StatelessWidget {
  const HeaderWrapper({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          child,
          const Positioned(top: 8, left: 0, right: 0, child: Center(child: SheetDragger())),
          Positioned.directional(
            textDirection: Directionality.of(context),
            top: 16,
            end: 16,
            child: CloseButton(
              onTap: () => context.pop(),
            ),
          ),
        ],
      );
}
