// import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../core/utils/constants/paths/icon_paths.dart' show IconPath;
// import '../../../../core/utils/utils_exports.dart'
//     show AppColor, AppStyle, CommonFunctions;
// import '../../../_shared_feature_/shared_feature_exports.dart'
//     show CustomTextWidget, DrawIconBasedTypeWidget, ElevatedButtonWidget;
//
// class SignInCard extends StatelessWidget {
//   const SignInCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
//       margin: const EdgeInsets.all(16),
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(Radius.circular(16)),
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.darkSlateBlue6,
//             offset: Offset(0, -4),
//             blurRadius: 32,
//           )
//         ],
//         color: AppColor.blackModern50Light,
//       ),
//       child: Column(
//         children: [
//           const DrawIconBasedTypeWidget(
//             icon: IconPath.placeholder,
//             iconSize: 65,
//           ),
//           const SizedBox(height: 8),
//           CustomTextWidget(
//             "please_sign_in".tr(),
//             textStyle: AppStyle.signInFullTextStyle,
//             maxLines: 2,
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 8),
//           ElevatedButtonWidget.signIn(
//             onPressed: () {
//               CommonFunctions.onLogin(isMunicipality: true);
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
