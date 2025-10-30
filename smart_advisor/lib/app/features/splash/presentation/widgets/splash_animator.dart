// import 'package:flutter/material.dart';
//
// import '../../../../core/utils/utils_exports.dart' show AppColor;
// import '../../splash_exports.dart'
//     show
//         BottomLeftLogoWidget,
//         CenterLogoWidget,
//         SplashAnimation,
//         TopRightLogoWidget;
//
// class SplashAnimator extends StatelessWidget {
//   final SplashAnimation _animation;
//   SplashAnimator({super.key, required AnimationController controller})
//       : _animation = SplashAnimation(controller);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColor.primary5/*AppColor.blue.withOpacity(0.45)*/,
//       body: AnimatedBuilder(
//         animation: _animation.controller,
//         // Leave it as a Stack widget to have a flexibility
//         // of adding Logo above shapes or another widgets
//         // or move widgets in the fly space
//         builder: (_, __) => Stack(
//           fit: StackFit.expand,
//           children: [
//             // // Bottom Left Light Shape widget
//             // BottomLeftLogoWidget(animation: _animation),
//             // // Bottom Left Dark Shape widget
//             // TopRightLogoWidget(animation: _animation),
//             // Center Logo widget
//             CenterLogoWidget(animation: _animation),
//           ],
//         ),
//       ),
//     );
//   }
// }
