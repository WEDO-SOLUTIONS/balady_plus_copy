import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/old_owner_transfer/persentation/license_premits/request_sequence_pledges.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_ownership_transfer/old_owner_transfer/persentation/license_premits/request_sequence_premits.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../domain/use_cases/get_license_permits_data.dart';
import '../../domain/use_cases/get_validate_license.dart';
import '../../domain/use_cases/get_validate_new_owner.dart';
import '../../domain/use_cases/post_to_new_owner.dart';
import '../bloc/license_tranfer_cubit.dart';
import '../interface/step_interface.dart';

import 'request_sequence_new_owner.dart';

class RequestSequenceHomeScreen extends StatefulWidget {
  const RequestSequenceHomeScreen({Key? key}) : super(key: key);

  @override
  State<RequestSequenceHomeScreen> createState() =>
      _RequestSequenceHomeScreenState();
}

class _RequestSequenceHomeScreenState extends State<RequestSequenceHomeScreen>
    implements StepInterface {
  PageController controller = PageController();
  int currentPageValue = 0;

  LicenseTransferCubit? bloc;
  String? licenseNumber;

  late List<Widget>? pagesList = [
    ReuestSequencePremitsScreen(stepInterface: this),
    RquestSequenceNewOwnerInfoScreen(stepInterface: this),
    RequestSequencePledgesScreen(stepInterface: this),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      setState(() {
        licenseNumber = ModalRoute.of(context)!.settings.arguments as String;
      });
      bloc?.licenseNumber = licenseNumber;
    });
  }


  @override
  Widget build(BuildContext context) {
    licenseNumber = ModalRoute.of(context)!.settings.arguments as String;
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
          bloc = LicenseTransferCubit(
            GetLicensePermitsData(repository: sl()),
            GetValidateNewOwner(repository: sl()),
            GetValidateLicense(repository: sl()),
            PostToNewOwner(repository: sl()),
          );

          bloc!.licenseNumber = licenseNumber;
          // bloc =
          // ModalRoute.of(context)!.settings.arguments as LicensePermitsCubit;
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
              requestNum: null,
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
                  '',
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
