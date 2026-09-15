import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../app/core/utils/common_functions.dart';
import '../../../app/core/utils/constants/app_colors.dart';
import '../../../app/core/utils/constants/paths/icon_paths.dart';
import '../../../app/core/utils/enums/bloc_status.dart' show BlocStatus;
import '../../../app/core/utils/enums/enums.dart';
import '../../../app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../camera_bloc/camera_bloc.dart';

class PhotoPreviewWidgetNew extends StatelessWidget {
  const PhotoPreviewWidgetNew({super.key});

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
                  ? Image.memory(
                      state.files!.encodeImage!,
                      // Image.file(
                      //   File(state.files?.first.filePath ?? ""),
                      fit: BoxFit.cover,
                    )
                  : Container(),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 30, end: 16, start: 16),
                      child: EnhancedCustomElevatedButtonWidget(
                        btnText: ("take_photo_again").tr(),
                        btnHeight: 48,
                        btnRadius: 8,
                        btnColor: AppColor.white,
                        btnTextColor: AppColor.primary900Light,
                        btnPressed: () {
                          context.read<CameraBloc>().add(ReTakePhotoEvent());
                        },
                      ),
                    ),
                  ),
                  const Expanded(flex: 1, child: SizedBox(height: 1)),
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: const EdgeInsetsDirectional.only(bottom: 30, end: 16),
                      child: EnhancedCustomElevatedButtonWidget(
                        btnPressed: () {
                          // CreateVDParamsPage

                          /// TODO: Back With the data of the photo
                          Navigator.of(context).pop(context.read<CameraBloc>().state.files);
                          // context.read<CameraBloc>().add(
                          //       GetUserLocationEvent(),
                          //     );
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
                          child: Image.asset(IconPath.vdarrowLeftIcon, height: 16, width: 16, color: AppColor.white),
                        ),
                        buttonIconPosition: ButtonIconPosition.left,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 16, right: 16),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  iconSize: 36,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            if (state.status == BlocStatus.loading)
              const Align(alignment: Alignment.center, child: CustomCircularLoadingWidget()),
          ],
        );
      },
    );
  }
}
