import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/pages/freelance_certificate_state_screen.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/pages/wait_for_approval_screen.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import '../blocs/choose_muncipality_bloc.dart';

class RegisterObserverHome extends StatefulWidget {
  const RegisterObserverHome({super.key});

  @override
  State<RegisterObserverHome> createState() => _RegisterObserverHomeState();
}

class _RegisterObserverHomeState extends State<RegisterObserverHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChooseMuncipalityBloc(),
      child: BlocConsumer<ChooseMuncipalityBloc, CertifiedObserverState>(
        listener: (context, state) {
          if (state is ChooseMuncipalityState) {
            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          }

          if (state is FreelanceCertificateState) {
            if (state.errorMessage?.isNotEmpty ?? false) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          }
        },
        builder: (context, state) {
          if (state is LoadingApprovalState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FailureApprovalState) {
            return Scaffold(
              body: Center(
                child: ReloadWidget(
                  onTab: () {
                    context.read<ChooseMuncipalityBloc>().add(
                          GetObserverStatusEvent(
                            // identityNumber: "1006966525",
                            identityNumber:
                                CommonProperties.userInfo?.idNo ?? "",
                          ),
                        );
                  },
                ),
              ),
            );
          }
          if (state is WaitingApprovalState) {
            return const WaitForApprovalScreen();
          }
          //////////////////////////////////////////////////////////////////////////////

          if (state is FreelanceCertificateState) {
            return FreelanceCertificateStateScreen(state: state);
          }

          //////////////////////////////////////////////////////////////////////////////
          if (state is ChooseMuncipalityState) {
            return WillPopScope(
              onWillPop: () {
                context
                    .read<ChooseMuncipalityBloc>()
                    .add(const GoToPreviousPageEvent());
                return Future<bool>.value(false);
              },
              child: GestureDetector(
                onTap: () {
                  context.read<ChooseMuncipalityBloc>().hideKeyboard();
                },
                child: Scaffold(
                  appBar: DetailsAppBarTwo(
                    currentStep: state.pagesList!.isNotEmpty
                        ? (state.currentPageValue + 1)
                        : 0,
                    pageLength: state.pagesList?.length ?? 0,
                    backOnPress: () => context
                        .read<ChooseMuncipalityBloc>()
                        .add(const GoToPreviousPageEvent()),
                    onTapCloseAction: () async {
                      bool back = await showDialog(
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
                                  SvgPicture.asset(IconPath.logoutIcon),
                                  const SizedBox(height: 16),
                                  CustomAutoSizeTextWidget(
                                    'exit_order'.tr(),
                                    textStyle: AppStyle.appBarTitleTextStyle,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomAutoSizeTextWidget(
                                    'exit_message'.tr(),
                                    textStyle:
                                        AppStyle.profileSectionTitleTextStyle,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButtonWidget.primaryCustom(
                                    text: "exit".tr(),
                                    onPressed: () {
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
                      if (back) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  body: Stack(
                    children: [
                      PageView.builder(
                        itemCount: state.pagesList?.length ?? 0,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        controller:
                            context.read<ChooseMuncipalityBloc>().controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                            child: state.pagesList![position],
                          );
                        },
                      ),
                      if (state.status == BlocStatus.loading &&
                          state.currentPageValue != 1)
                        const CustomCircularLoadingWidget(),
                    ],
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
