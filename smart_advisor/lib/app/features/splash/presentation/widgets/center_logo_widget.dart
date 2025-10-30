// import 'package:flutter/material.dart';
//
// import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
// import '../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
// import '../../splash_exports.dart' show SplashAnimation;
//
// class CenterLogoWidget extends StatelessWidget {
//   final SplashAnimation _animation;
//   const CenterLogoWidget({super.key, required SplashAnimation animation})
//       : _animation = animation;
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       // child: FadeTransition(
//       //   opacity: _animation.centerLogoFade,
//       child: Transform(
//         alignment: Alignment.center,
//         transform: Matrix4.diagonal3Values(
//           _animation.centerShapeSize.value,
//           _animation.centerShapeSize.value,
//           1.0,
//         ),
//         child: const CustomIconWidget(IconPath.logo,
//             iconHeight: 297, iconFit: BoxFit.fitWidth),
//       ),
//     );
//   }
// }
