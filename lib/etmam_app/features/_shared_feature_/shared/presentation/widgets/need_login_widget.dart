import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show
        CustomPrimaryButton,
        CustomSvgIconWidget,
        CustomTextWidget,
        CustomVerticalSpace;
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../app/core/utils/enums/auth_status.dart';
import '../../../../../core/utils/utils_exports.dart';

class NeedLoginWidget extends StatefulWidget {
  final String? img;
  final String? title;
  final String? desc;
  final bool withMargin;
  final Function(bool isSuccess)? onSuccessLogin;

  const NeedLoginWidget({
    Key? key,
    this.desc,
    this.img,
    this.title,
    this.onSuccessLogin,
    this.withMargin = true,
  }) : super(key: key);

  @override
  _NeedLoginWidgetState createState() => _NeedLoginWidgetState();
}

class _NeedLoginWidgetState extends State<NeedLoginWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EntryPointCubit, EntryPointState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          if (widget.onSuccessLogin != null) {
            widget.onSuccessLogin!(true);
          }
        }
      },
      builder: (context, state) {
        return Container(
          margin: widget.withMargin
              ? const EdgeInsets.symmetric(horizontal: 16)
              : EdgeInsets.zero,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomSvgIconWidget(
                    widget.img ?? IconPath.needLoginLogo,
                    iconWidth: 124,
                    iconHeight: 136,
                  ),
                  const CustomVerticalSpace(height: 10),
                  CustomTextWidget(
                    widget.title ?? trans('etmam_log_in_first'),
                    fontSize: 20.0,
                    fontColor: AppColor.hunterGreen,
                    fontWeight: AppFontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(
                    widget.desc ?? trans('log_in_first_desc'),
                    fontSize: 13.0,
                    height: 1.6,
                    fontColor: AppColor.black400,
                    fontWeight: AppFontWeight.medium,
                    textAlign: TextAlign.center,
                  ),
                  const CustomVerticalSpace(height: 24),
                  CustomPrimaryButton(
                    btnWidth: 176,
                    onPressed: () {
                      context.read<EntryPointCubit>().onLogin(
                            isFromEtmam: true,
                            isMunicipality: true,
                          );
                    },
                    btnText: trans("signIn"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
