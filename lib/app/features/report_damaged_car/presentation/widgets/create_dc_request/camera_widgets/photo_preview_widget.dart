import 'dart:io';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../blocs/create_dc_request/camera_bloc/dc_camera_bloc.dart';

class photoPreviewWidgetNew extends StatefulWidget {
  @override
  _photoPreviewWidgetState createState() => _photoPreviewWidgetState();
}

class _photoPreviewWidgetState extends State<photoPreviewWidgetNew> {
  bool showPhoto = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DCCameraBloc, DCCameraState>(
      builder: (context, state) {
        return Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColor.black200,
              child: !(state.showCamera ?? true)
                  ? Image.file(
                      File(state.files?.first.filePath ?? ""),
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: Container(
                margin: const EdgeInsetsDirectional.only(bottom: 30, end: 16),
                child: EnhancedCustomElevatedButtonWidget(
                  btnPressed: () {
                    context.read<DCCameraBloc>().add(GetUserLocationEvent());
                  },
                  btnText: ("next").tr(),
                  btnColor: AppColor.primary800Light,
                  btnHeight: 56,
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnWidth: 105,
                  btnRadius: 8,
                  icon: RotatedBox(
                    quarterTurns: CommonFunctions.isAppAR ? 0 : 2,
                    child: Image.asset(
                      IconPath.vdarrowLeftIcon,
                      height: 16,
                      width: 16,
                      color: AppColor.white,
                    ),
                  ),
                  buttonIconPosition: BUTTON_ICON_POSITION.left,
                ),
              ),
            ),
            //

            Align(
              alignment: AlignmentDirectional.bottomStart,
              child: Container(
                margin: const EdgeInsetsDirectional.only(
                    bottom: 30, end: 16, start: 16),
                child: EnhancedCustomElevatedButtonWidget(
                  btnText: ("take_photo_again").tr(),
                  btnHeight: 48,
                  btnWidth: 114,
                  btnRadius: 8,
                  btnColor: AppColor.white,
                  btnTextColor: AppColor.primary900Light,
                  btnPressed: () {
                    context.read<DCCameraBloc>().add(ReTakePhotoEvent());
                  },
                ),
              ),
            ),

            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 16,
                    left: 16,
                    right: 16),
                child: CustomIconButtonWidget(
                  icon: IconPath.vdCameraExit,
                  iconSize: 36,
                  btnHeight: 40,
                  btnWidth: 40,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            if (state.status == BlocStatus.loading)
              Align(
                  alignment: Alignment.center,
                  child: CustomCircularLoadingWidget())
          ],
        );
      },
    );
  }
}
