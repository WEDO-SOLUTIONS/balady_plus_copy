// import 'package:flutter/material.dart';
// import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
// import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
// import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
// import 'package:smart_advisor/app/features/shared_features/widgets/app_bar.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F8FB),
//       appBar: CustomAppBar(
//         //  title: widget.args.isic.name,
//         title: 'بحث',
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           const Textfield(),
//           const SizedBox(
//             height: 120,
//           ),
//           Image.asset(
//             "packages/smart_advisor/smart_advisor_assets/images/searchimg.png",
//             height: 122,
//             width: 150,
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'نتائج البحث',
//             style: AppStyle.calloutBoldStyle
//                 .copyWith(color: AppColor.textPrimaryColor),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'ابحث عن كل المنشآت التي ترغب في الاستعلام عنها',
//             textAlign: TextAlign.center,
//             style: AppStyle.textRegularRomanStyle
//                 .copyWith(color: const Color(0xFF566069)),
//           ),
//         ],
//       ),
//     );
//   }
// }
