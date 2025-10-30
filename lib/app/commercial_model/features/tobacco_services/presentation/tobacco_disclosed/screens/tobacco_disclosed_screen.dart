import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/mvvm/tobacco_disclosed_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_disclosed/screens/tobacco_disclosed_info_screen.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';


class TobaccoDisclosedScreen extends StatefulWidget {
  const TobaccoDisclosedScreen({Key? key}) : super(key: key);

  @override
  State<TobaccoDisclosedScreen> createState() => _TobaccoDisclosedScreenState();
}

class _TobaccoDisclosedScreenState extends State<TobaccoDisclosedScreen> {
  @override
  void initState() {
    super.initState();
    CommonFunctions.sendUXCamEvent(
      UXCamEvents.openConfirmTobaccoDisclosedScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    TobaccoDisclosedViewModel provider =
        ModalRoute.of(context)!.settings.arguments as TobaccoDisclosedViewModel;
    return ChangeNotifierProvider(
      create: (BuildContext context) => provider,
      child: WillPopScope(
        onWillPop: () async {
          return (await showBackDialog());
        },
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => hideKeyboard(),
                child: Scaffold(
                  appBar: DetailsAppBarTwo(
                    pageLength: 1,
                    currentStep: 1,
                    backOnPress: () {
                      showBackDialog();
                    },
                    onTapCloseAction: () => showBackDialog(),
                  ),
                  body: const TobaccoDisclosedInfoScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  Future<bool> showBackDialog() async {
    return await showDialog(
      barrierColor: Colors.black.withOpacity(0.6),
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  IconPath.logoutIcon,
                ),
                const SizedBox(height: 16),
                CustomAutoSizeTextWidget(
                  'exit_order'.tr(),
                  textStyle: AppStyle.appBarTitleTextStyle,
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                CustomAutoSizeTextWidget(
                  'exit_message'.tr(),
                  textStyle: AppStyle.profileSectionTitleTextStyle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButtonWidget.primaryCustom(
                  text: "exit".tr(),
                  onPressed: () {
                    CommonFunctions.sendUXCamEvent(
                      UXCamEvents.closeServiceTobaccoDisclosed,
                    );
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop(true);
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButtonWidget.primaryCustomBorder(
                  text: 'back_order'.tr(),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
