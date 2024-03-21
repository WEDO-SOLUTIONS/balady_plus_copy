import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/commercial_license_cancel/presentation/commercial_license_cancel/mvvm/request_attachments_view_model.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/approval_sequence/presentation/screens/approval_sequence_attachments_screen.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/approval_sequence/presentation/screens/approval_sequence_permits_screen.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/approval_sequence/presentation/screens/approval_sequence_shop_info_screen.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class ApprovalSequenceMainScreen extends StatefulWidget {
  const ApprovalSequenceMainScreen({Key? key}) : super(key: key);

  @override
  State<ApprovalSequenceMainScreen> createState() =>
      _ApprovalSequenceMainScreenState();
}

class _ApprovalSequenceMainScreenState
    extends State<ApprovalSequenceMainScreen> {
  PageController controller = PageController();
  int currentPageValue = 0;

  List<Widget> pagesList = [];

  @override
  void initState() {
    super.initState();
    pagesList = [
      ApprovalSequencePermitsScreen(goToNewPage: goToNewPage),
      ApprovalSequenceShopInfoScreen(goToNewPage: goToNewPage),
      ApprovalSequenceAttachmentsScreen(goToNewPage: goToNewPage),
    ];
    CommonFunctions.sendUXCamEvent(
      UXCamEvents.CancelCommercialLicense_Open_Create_Details_Event,
    );
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
    return WillPopScope(
      onWillPop: () async {
        if (currentPageValue < 0) {
          setState(() {
            currentPageValue == 0;
          });
          goToNewPage();
          return Future<bool>.value(false);
        } else {
          return (await showBackDialog());
        }
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) {
              return RequestAttachmentsViewModel(
                webService: sl(),
                requestId: 4312197298,
              );
            },
          ),
        ],
        child: GestureDetector(
          onTap: () => hideKeyboard(),
          child: Scaffold(
            appBar: DetailsAppBarTwo(
              pageLength: pagesList.length,
              currentStep: currentPageValue + 1,
              backOnPress: () {
                if (currentPageValue > 0) {
                  setState(() {
                    currentPageValue--;
                  });
                  goToNewPage();
                } else {
                  showBackDialog();
                }
              },
              onTapCloseAction: () => showBackDialog(),
              requestNum: data['requestId'],
            ),
            body: PageView.builder(
              itemCount: pagesList.length,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              itemBuilder: (context, position) {
                return AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300),
                  child: pagesList[position],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void goToNewPage() {
    controller.animateToPage(
      currentPageValue,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeIn,
    );
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
                  'cancellation_license_message'.tr(),
                  textStyle: AppStyle.profileSectionTitleTextStyle,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                ElevatedButtonWidget.primaryCustom(
                  text: "save_exit".tr(),
                  onPressed: () {
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
