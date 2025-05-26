import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';

import 'package:balady_plus/app/features/ekram/presentation/blocs/driver_extra_data_bloc/extra_data_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';

import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';

import '../../../../_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/details_header.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../blocs/driver_identical_bloc/identical_list_bloc.dart';
import '../../widgets/driver/extra_data_card_widget.dart';


class ConfirmDialog extends StatelessWidget {
String? title;
String? message;
String? okTitle;
String? cancelTitle;
Function onOkCallback;
  ConfirmDialog({super.key,this.title,this.message,this.okTitle,required this.onOkCallback,this.cancelTitle});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      scrollable: true,

      content: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
        child:
        Column(
         mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomVerticalSpace(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget( title??"title".tr(),
                  fontColor: AppColor.blackModern900Light,
                  fontSize: 18,
                  fontWeight: AppFontWeight.bold,
                ),
              ],
            ),
            CustomVerticalSpace(height: 15),
            CustomTextWidget( message??"message".tr(),
              fontColor: AppColor.blackModern700Light,
              fontSize: 14,
              fontWeight: AppFontWeight.medium,
            ),
            SizedBox(height: 30,),

            ElevatedButtonWidget.primaryCustomBorder(
              color:AppColor.vermillion,
              height: 40,
              onPressed: () {
                onOkCallback();
              },
              text: okTitle??"ok".tr(),
            ),
            SizedBox(height: 10,),
            ElevatedButtonWidget.primaryCustom(
              btnColor: AppColor.primary800Light,
              height: 40,
              onPressed: () {
               Navigator.pop(context);
              },
              text: cancelTitle??"cancel".tr(),
            ),




          ],
        ),
      ),
    );



  }

}


