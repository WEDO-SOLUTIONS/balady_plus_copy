import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/athkar/presentation/cubit/timer_bloc.dart';
import 'package:balady_plus/app/features/athkar/presentation/widgets/athkar_time_setup/athkar_time_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class AthkarAppBar extends StatelessWidget implements PreferredSize {
  const AthkarAppBar({
    required this.title,
    super.key,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
            )),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: <Color>[
                  AppColor.athkarAppbarGreen,
                  AppColor.athkarAppbarGreen2
                ]),
          ),
        ),
        centerTitle: true,
        actions: [
          /*
          IconButton(
              onPressed: () async {
                await BottomSheetDialog.showDraggableSheet(context,
                    isFullHeight: false,
                    child: BottomSheetWithActions(
                      title: "reminder".tr(),
                      body: BlocProvider(
                        create: (context) => TimePickerBloc(),
                        child: AthkarTimeSetup(),
                      ),
                    ));
              },
              icon: Icon(Icons.notifications))*/
        ],
        title: CustomTextWidget(
          title,
          fontSize: 20,
          fontWeight: AppFontWeight.bold,
        ));
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(92.0);
}
