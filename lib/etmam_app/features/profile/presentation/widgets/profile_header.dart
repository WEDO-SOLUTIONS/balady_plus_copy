import 'package:balady_plus/etmam_app/core/utils/themes/app_color_theme.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EtmamEntryPointCubit, EtmamEntryPointState>(
      builder: (context, state) {
        return Container(
          height: 80,
          alignment: Alignment.center,
          padding: const EdgeInsetsDirectional.only(start: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColor.white,
            boxShadow: const [
              BoxShadow(
                  color: Color(0x14d1d5db),
                  offset: Offset(-2, 4),
                  blurRadius: 8,
                  spreadRadius: 0)
            ],
          ),
          child: Row(children: [
            ProfileAvatar(
              gender: state.profile?.getGenderType(),
            ),
            const CustomHorizontalSpace(width: 14),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(state.profile?.nameAr ?? ""),
                  const CustomVerticalSpace(height: 8),
                  CustomTextWidget(state.profile?.nationalId ?? ""),
                ])
          ]),
        );
      },
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  final GenderType? gender;

  const ProfileAvatar({super.key, this.gender});

  @override
  Widget build(BuildContext context) {
    return gender != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
                width: 48,
                height: 48,
                color: AppColorsTheme.primary700,
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CustomSvgIconWidget(
                    gender!.icon,
                    iconSize: 40,
                    iconFit: BoxFit.fill,
                  ),
                )),
          )
        : CustomImageIconWidget(
            ImagePath.userProfileHeader,
            iconFit: BoxFit.fill,
            iconSize: 40,
          );
  }
}
