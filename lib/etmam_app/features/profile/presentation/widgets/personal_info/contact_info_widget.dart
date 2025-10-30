import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, SectionTitleWidget;
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/etmam_app/features/submit_request/presentation/widgets/order_info/order_info_card_widget.dart';
import 'package:balady_plus/etmam_app/features/submit_request/presentation/widgets/order_info/order_title_and_desc_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactInfoSection extends StatelessWidget {
  const ContactInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EtmamEntryPointCubit, EtmamEntryPointState>(
        builder: (context, state) {
      return WhiteCardWidget(
        child: Column(
          children: [
            SectionTitleWidget(
              title: trans('personal_contact_info'),
              primaryIcon: PrimaryIcons.callSectionIcon,
            ),
            if (state.profile?.mobile != null) ...[
              OrderTitleAndDescWidget(
                title: trans('personal_mobile'),
                desc: state.profile?.mobile ?? "",
              ),
              const CustomVerticalSpace(height: 16),
            ],
            if (state.profile?.email != null)
              OrderTitleAndDescWidget(
                title: trans('personal_email'),
                desc: state.profile?.email ?? "",
              ),
          ],
        ),
      );
    });
  }
}
