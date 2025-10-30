import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../../app/core/utils/constants/app_colors.dart';
import '../../../../../../app/core/utils/constants/constants.dart';
import '../../../../../../app/core/utils/enums/app_font_weights.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../../../../app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../../core/utils/constants/app_config.dart';
import '../../../../_shared_feature_/shared/presentation/widgets/custom_buttons_widgets.dart';
import '../../../../dynamic_form/presentation/dialogs/bidding_types_dialog.dart';
import '../../blocs/home_bloc/home_bloc.dart';

class EtmamBiddingWidget extends StatelessWidget {
  const EtmamBiddingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<EntryPointCubit, EntryPointState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.read<HomeBloc>().add(FindByRequestTypeEvent());
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomTextWidget(
                  "bidding_test_launch".tr(),
                  fontSize: 18,
                  fontWeight: AppFontWeight.bold,
                  fontColor: AppColor.black700,
                ),
              ),
              Container(
                height: 250,
                padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                decoration: new BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(8),
                  /* boxShadow: [
                    BoxShadow(
                        color: Color(0x14000000),
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0)
                  ],*/
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset("assets/etmam_app/images/bidding_icon.png",
                          width: 92, height: 92),
                      CustomVerticalSpace(height: 14),
                      CustomTextWidget(trans("biddng_home_title"),
                          fontColor: AppColor.black,
                          fontSize: 17,
                          fontWeight: AppFontWeight.bold),
                      CustomVerticalSpace(height: 10),
                      CustomTextWidget(trans("bidding_home_desc"),
                          fontColor: AppColor.kGray115,
                          fontSize: 13,
                          fontWeight: AppFontWeight.medium),
                      CustomVerticalSpace(height: 16),
                      ElevatedButtonWidget.primaryCustom(
                          onPressed: () {
                            if (CommonProperties.isLoggedInMunicipality) {
                              context
                                  .read<HomeBloc>()
                                  .add(FindByRequestTypeEvent());
                            } else {
                              sl<EntryPointCubit>().onLogin(
                                isFromEtmam: true,
                                isMunicipality: true,
                              );
                            }
                          },
                          text: "bidding_home_publish".tr())
                    ]),
              ),
            ],
          );
        },
      ),
    );
  }
}
