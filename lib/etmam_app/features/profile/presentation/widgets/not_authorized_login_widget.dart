import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotAuthorizedLoginWidget extends StatelessWidget {
  const NotAuthorizedLoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColorsTheme.primary700,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(start: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextWidget(
                        trans('etmam_log_in_first'),
                        fontSize: 20.0,
                        fontColor: AppColor.white,
                        fontWeight: AppFontWeight.w600,
                        textAlign: TextAlign.start,
                      ),
                      const CustomVerticalSpace(height: 8),
                      CustomTextWidget(
                        trans('log_in_first_desc'),
                        fontSize: 12.0,
                        height: 1.6,
                        fontColor: AppColorsTheme.primary200,
                        fontWeight: AppFontWeight.medium,
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                ),
              ),
              const CustomSvgIconWidget(
                IconPath.needLoginMoreLogo,
                iconHeight: 110,
                iconWidth: 88,
              )
            ],
          ),
          const CustomVerticalSpace(height: 24),
          Padding(
            padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
            child: CustomPrimaryButton(
              onPressed: () {
                context.read<EntryPointCubit>().onLogin(
                      isFromEtmam: true,
                      isMunicipality: true,
                    );
              },
              btnText: trans("signIn"),
              btnColor: AppColor.white,
              textColor: AppColorsTheme.primary700,
            ),
          ),
        ],
      ),
    );
  }
}
