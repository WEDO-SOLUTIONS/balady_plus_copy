import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';

class LicenseCard extends StatelessWidget {
  const LicenseCard({
    super.key,
    required this.stateLicense,
    required this.ownerName,
    required this.copiedText,
    required this.expiryDate,
    this.margin,
  });
  final String stateLicense;
  final String ownerName;
  final String copiedText;
  final String expiryDate;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          transform: GradientRotation(74.37 * 3.1416 / 180),
          colors: [
            Color(0xFF93CF95),
            Color(0xFF568F64),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(IconPath.licensebg),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(IconPath.licensebg2),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 27, left: 27, right: 17, bottom: 17),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("رخصة تجارية",
                      style: AppStyle.callout1BoldStyle
                          .copyWith(color: AppColor.white, fontSize: 14)),
                  Text(' الرخصة $stateLicense',
                      style: AppStyle.callout1BoldStyle
                          .copyWith(color: AppColor.white, fontSize: 14)),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text("رخصة رقم",
                  style: AppStyle.callout1BoldStyle.copyWith(
                      color: AppColor.white.withOpacity(0.65), fontSize: 14)),
              const SizedBox(
                height: 8,
              ),
              Text(copiedText,
                  style: AppStyle.heading2BoldStyle
                      .copyWith(color: AppColor.white)),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("الاسم",
                            style: AppStyle.footNoteMediumStyle.copyWith(
                                color: AppColor.white.withOpacity(0.65),
                                fontSize: 12)),
                        Text(
                          ownerName,
                          style: AppStyle.callout1BoldStyle
                              .copyWith(color: AppColor.white, fontSize: 14),
                          maxLines: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("تنتهي",
                          style: AppStyle.footNoteMediumStyle.copyWith(
                              color: AppColor.white.withOpacity(0.65),
                              fontSize: 12)),
                      Text(expiryDate,
                          style: AppStyle.callout1BoldStyle
                              .copyWith(color: AppColor.white, fontSize: 14))
                      /*  Text(
                          "${DateFormat('MM').format(expiryDate)}/${DateFormat('yy').format(expiryDate)}",
                          style: AppStyle.callout1BoldStyle
                              .copyWith(color: AppColor.white, fontSize: 14)),*/
                    ],
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:smart_advisor/app/core/utils/constants/app_style.dart';

// class LicenseCard extends StatelessWidget {
//   const LicenseCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         gradient: const LinearGradient(
//           begin: Alignment(
//               -0.5558, -0.1474), // Approximate angle of 284.29 degrees
//           end: Alignment(0.935, 0.923), // 147.4% is roughly the end alignment
//           colors: [
//             Color(0xFF93CF95), // #568F64
//             Color(0xff568F64), // #93CF95
//           ],
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'رخصة تجارية',
//                 style: AppStyle.textRegularRomanStyle,
//               ),
//               Text(
//                 'سارية',
//                 style: AppStyle.textRegularRomanStyle,
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           const Text(
//             'رقم رخصة',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//             ),
//           ),
//           const Text(
//             '3827 4637 3103 7389',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 22,
//             ),
//           ),
//           const SizedBox(height: 20),
//           const Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'الاسم',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                   Text(
//                     'خالد محمد',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'تنتهي',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                     ),
//                   ),
//                   Text(
//                     '02/30',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 22,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
