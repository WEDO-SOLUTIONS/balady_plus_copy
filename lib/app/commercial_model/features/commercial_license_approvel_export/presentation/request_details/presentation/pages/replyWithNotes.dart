import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/request_details/presentation/widgets/RequestDetailsBody.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/features/home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../../../../core/utils/constants/app_style.dart';
import '../../../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/cards/expandable_card.dart';
import '../../../../../../../features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import '../../../../../../../features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../../commercial_routes/commercial_route_names.dart';
import '../../bloc/commercial_license_details_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
class ReplyWithNotes extends StatelessWidget {
  final CommercialLicenseDetailsBloc bloc;
  final String noteId;
  ReplyWithNotes({super.key,required this.bloc,required this.noteId});

  String? note;


  @override
  Widget build(BuildContext context) {

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [

            CustomTextFieldWidget(
              label: "replyWithNotes".tr(),
              hintText: "replyWithNotes".tr(),
              initialValue:'',
              keyboardType: TextInputType.text,
              maxLines: 15,
              bottomMargin: 24,
              onChanged: (value) {
                note = value;
              },
            ),

               ElevatedButtonWidget.primaryCustom(
                text: "send".tr(),
                onPressed: () {
                  if(note != null && note!.isNotEmpty) {
                    bloc.ReplyNote(note!, noteId);
                  }
                })

          ]


        ),

    );
  }
}
