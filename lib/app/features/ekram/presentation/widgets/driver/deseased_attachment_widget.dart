import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../etmam_app/core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_line_widget.dart';
import '../../../data/model/driver/deceased_attachment.dart';
import '../../../data/model/driver/deceased_identical_item.dart';
import '../../../domain/entities/deceased_request_details/deceased_request_details.dart';
import '../../blocs/driver_extra_data_bloc/extra_data_bloc.dart';
import '../ekram_status_widget.dart';

class DeceasedAttachmentCardWidget extends StatelessWidget {
  final DeceasedAttachment item;
  final ExtraDataBloc bloc;


   DeceasedAttachmentCardWidget(
      {Key? key,
        required this.item,
        required this.bloc,
       })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(height: 15,),
        CustomTextWidget(
          item.name??(item.mandatory==true?" *":""),
          fontSize: 14,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
          fontWeight: AppFontWeight.bold,
          fontColor: AppColor.blackModern700Light,
        ),
        SizedBox(height: 10,),
        Row(
          children: [
            // InkWell(
            //   onTap: () async {
            //
            //   },
            //   child: Container(
            //     padding: const EdgeInsets.all(16),
            //     width: double.infinity,
            //     decoration:  BoxDecoration(color: Colors.transparent, border: Border.all(color: AppColor.blackModern300Light, width: 1), borderRadius: BorderRadius.circular(6)),
            //     //:BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         CustomTextWidget(
            //           ("compliance_image_upload").tr(),
            //           fontSize: 12,
            //           fontWeight: AppFontWeight.medium,
            //           fontColor: AppColor.black,
            //           textAlign: TextAlign.start,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            Expanded(
              flex: 4,
              child: ElevatedButtonWidget.primaryCustomBorderColor(
                borderColor: AppColor.kGreenBoarder,
                bgColor: Colors.transparent,
                color: AppColor.darkGreylight,
                fontSize:13,
                height:45,
                onPressed: () async {
              
                },
                text: ('compliance_image_upload').tr(),
              ),
            ),

            SizedBox(width: 10,),
            Expanded(
              flex: 1,
              child: IconButton(onPressed: () {
                bloc.add(DownLoadDeceasedAttachmentEvent(id: item.id!));
              },
                icon: Icon(IconData(0xf58e, fontFamily: 'MaterialIcons'),size: 20,color: AppColor.primary800Light,),
                iconSize: 45 ,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),),
            ),

          ],
        ),
     

      ],
    );
  }
}
