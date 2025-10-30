import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, SectionTitleWidget;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/etmam_app/features/submit_request/presentation/widgets/order_info/order_info_card_widget.dart';
import 'package:balady_plus/etmam_app/features/submit_request/presentation/widgets/order_info/order_title_and_desc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PersonalMainInfoSection extends StatelessWidget {
  const PersonalMainInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EtmamEntryPointCubit, EtmamEntryPointState>(
        builder: (context, state) {
      return WhiteCardWidget(
        child: Column(
          children: [
            SectionTitleWidget(
              title: trans('personal_main_info'),
              primaryIcon: PrimaryIcons.personalInfoSectionIcon,
            ),
            if (state.profile?.nameAr != null) ...[
              OrderTitleAndDescWidget(
                title: trans('personal_full_name'),
                desc: state.profile?.nameAr ?? "",
              ),
              const CustomVerticalSpace(height: 16),
            ],
            if (state.profile?.nationalId != null) ...[
              OrderTitleAndDescWidget(
                title: trans('personal_id'),
                desc: state.profile?.nationalId ?? "",
              ),
              const CustomVerticalSpace(height: 16),
            ],
            if (state.profile?.birthDate != null) ...[
              OrderTitleAndDescWidget(
                title: trans('personal_date_of_birth'),
                desc: state.profile?.birthDate ?? "",
              ),
              const CustomVerticalSpace(height: 16),
            ],
            if (state.profile?.nationality != null) ...[
              OrderTitleAndDescWidget(
                  title: trans('personal_nationality'),
                  desc: state.profile?.nationality ??
                      "" //getNationality(state.profile?.nationalId ?? ""),
                  ),
              const CustomVerticalSpace(height: 16),
            ],
            if (state.profile?.getGenderType() != null)
              OrderTitleAndDescWidget(
                title: trans('personal_gender'),
                desc: trans(state.profile?.getGenderType()?.type ?? ""),
              )
          ],
        ),
      );
    });
  }

  String getNationality(String id) {
    if (id.startsWith("1"))
      return trans('personal_saudi');
    else
      return trans('personal_non_saudi');
  }
}
