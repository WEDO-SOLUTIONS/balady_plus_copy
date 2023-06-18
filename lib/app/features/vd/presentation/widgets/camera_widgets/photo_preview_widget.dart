import 'dart:io';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';

class photoPreviewWidgetNew extends StatefulWidget {
  @override
  _photoPreviewWidgetState createState() => _photoPreviewWidgetState();
}

class _photoPreviewWidgetState extends State<photoPreviewWidgetNew> {
  bool showPhoto = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraBloc, CameraState>(
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
                    // CreateVDParamsPage
                    context.read<CameraBloc>().add(GetUserLocationEvent());

                    /* context.read<CameraBloc>().add(GetSplListEvent(
                        createVDBloc: context.read<CreateVDBloc>(),
                        params: SplParams(
                            categoryID:
                                state.selectedCattegory.categoryId ?? "")));*/
                  },
                  btnText: ("bookNewAppointmentNextToButtonWord").tr(),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnHeight: 56,
                  btnWidth: 105,
                  icon: Image.asset(
                    IconPath.vdarrowLeftIcon,
                    height: 16,
                    width: 16,
                    color: AppColor.white,
                  ),
                  buttonIconPosition: BUTTON_ICON_POSITION.left,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Container(
                width: 131,
                margin: const EdgeInsetsDirectional.only(top: 24, end: 16),
                child: CustomTextButtonWithIconWidget(
                  icon: Image.asset(
                    IconPath.vdAgianIcon,
                    height: 24,
                    width: 24,
                    color: AppColor.white2,
                  ),
                  btnText: ('take_photo_again').tr(),
                  btnTextSize: 17,
                  btnTextColor: AppColor.white2,
                  spaceBetweenTextAndIcon: 8,
                  btnPressed: () {
                    context.read<CameraBloc>().add(ReTakePhotoEvent());
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
