import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        BtnIconPrimaryIconWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        EtmamProviderLogoIcon,
        CustomHorizontalSpace;
import 'package:flutter/material.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, IconPath;

// class ProviderDetailsHeader extends StatelessWidget {
//   final String imageUrl;
//
//   const ProviderDetailsHeader({Key? key, required this.imageUrl})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColor.white,
//       height: 172,
//       child: Stack(children: [
//         const ClipRRect(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(12), topRight: Radius.circular(12)),
//             child: SizedBox(
//               height: 148,
//               width: double.infinity,
//               child: CustomSvgIconWidget(
//                 IconPath.providerDetailsBg,
//                 iconHeight: 148,
//                 iconWidth: double.infinity,
//                 iconFit: BoxFit.fill,
//               ),
//             )),
//         Align(
//           alignment: AlignmentDirectional.bottomStart,
//           child: ProviderLogoIcon(
//             imageUrl: imageUrl,
//             imageMargin: const EdgeInsetsDirectional.only(start: 16),
//           ),
//         ),
//         Align(
//           alignment: AlignmentDirectional.topStart,
//           child: Container(
//             margin: EdgeInsetsDirectional.only(
//                 start: 16, top: MediaQuery.of(context).padding.top + 10),
//             child: BtnIconPrimaryIconWidget(
//               iconSize: 20,
//               iconPath: IconPath.back,
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//           ),
//         ),
// /*        Align(
//           alignment: AlignmentDirectional.topEnd,
//           child: Container(
//             margin: EdgeInsetsDirectional.only(
//                 end: 16, top: MediaQuery.of(context).padding.top + 10),
//             child: CustomIconButtonWidget(
//                 padding: EdgeInsets.zero,
//                 btnPressed: () => print('providerDetailsBookmark'),
//                 icon: const CustomSvgIconWidget(
//                   IconPath.providerDetailsBookmark,
//                   iconSize: 32,
//                 )),
//           ),
//         )*/
//       ]),
//     );
//   }
// }

class ProviderDetailsHeader extends StatelessWidget {
  final String imageUrl;
  final String providerName;

  const ProviderDetailsHeader(
      {Key? key, required this.imageUrl, required this.providerName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      decoration: new BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Color(0x14000000),
              offset: Offset(0, 2),
              blurRadius: 15,
              spreadRadius: 0)
        ],
        color: AppColor.white,
      ),
      //  height: 172,
      child: Container(
        margin: EdgeInsetsDirectional.only(
            start: 16,
            top: MediaQuery.of(context).padding.top + 10,
            end: 16,
            bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BtnIconPrimaryIconWidget(
              iconSize: 20,
              iconPath: IconPath.appbarBackArrow,
              onPressed: () => Navigator.of(context).pop(),
            ),
            CustomVerticalSpace(height: 16),
            Row(children: [
              EtmamProviderLogoIcon(imageUrl: imageUrl),
              CustomHorizontalSpace(width: 16),
              Expanded(
                child: CustomTextWidget(
                  providerName,
                  fontColor: AppColor.hunterGreen,
                  fontWeight: AppFontWeight.bold,
                  fontSize: 22,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
