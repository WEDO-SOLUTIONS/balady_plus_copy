import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/Commercial_license_transfer/domain/use_cases/get_validate_license.dart';
import 'package:balady_plus/app/features/Commercial_license_transfer/persentation/license_premits/request_sequence_pledges.dart';
import 'package:balady_plus/app/features/Commercial_license_transfer/persentation/license_premits/request_sequence_premits.dart';
import 'package:balady_plus/app/features/Commercial_license_transfer/persentation/license_premits/sucessfull_page.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../Commercial_license_transfer/persentation/interface/step_interface.dart';
import '../../../../Commercial_license_transfer/persentation/license_premits/request_sequence_new_owner.dart';
import '../blocs/request_approval_sequence_cubit.dart';
import 'approval_sequence_permits_screen.dart';
import 'approval_sequence_shop_info_screen.dart';
import 'approval_sequence_shop-location.dart';

class ApprovalSequenceMainScreen extends StatefulWidget {
  const ApprovalSequenceMainScreen({Key? key}) : super(key: key);

  @override
  State<ApprovalSequenceMainScreen> createState() =>
      _ApprovalSequenceMainScreenState();
}

class _ApprovalSequenceMainScreenState extends State<ApprovalSequenceMainScreen>
    implements StepInterface {
  PageController controller = PageController();
  int currentPageValue = 0;

  RequestApprovalSequenceCubit? bloc;
  String? requestNumber;

  late List<Widget>? pagesList = [
    
    ApprovalSequencePermitsScreen(stepInterface: this),
    ApprovalSequenceShopInfoScreen(stepInterface: this),
    ApprovalSequenceShopLocationScreen(stepInterface: this),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.microtask(() {
      setState(() {
        requestNumber = ModalRoute.of(context)!.settings.arguments as String;
      });
      bloc?.requestNumber = int.parse(requestNumber!);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      child: BlocProvider(
        create: (_) {
          bloc = RequestApprovalSequenceCubit(
              requestApprovalSequenceRepository: sl(), isChecked: false);

          return bloc!;
        },
        child: GestureDetector(
          onTap: () => hideKeyboard(),
          child: Scaffold(
            appBar: DetailsAppBarTwo(
              pageLength: pagesList!.length,
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
              requestNum: bloc?.requestNumber,
            ),
            body: PageView.builder(
              itemCount: pagesList!.length,
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              itemBuilder: (context, position) {
                return AnimatedContainer(
                  curve: Curves.easeIn,
                  duration: const Duration(milliseconds: 300),
                  child: pagesList![position],
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

  @override
  void nextPage() {
    setState(() {
      currentPageValue++;
    });

    goToNewPage();
  }
}
