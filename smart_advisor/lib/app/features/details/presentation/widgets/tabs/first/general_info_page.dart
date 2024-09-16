import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/details/presentation/bloc/details_bloc.dart';
import '/app/features/details/presentation/bloc/details_event.dart';
import '/app/features/details/presentation/bloc/details_state.dart';
import '/app/features/details/presentation/widgets/permits_widget.dart';
import '/app/features/details/presentation/widgets/tabs/first/details_item_widget.dart';
import '/app/features/details/presentation/widgets/tabs/first/details_user_guide.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/features/_shared_feature_/presentation/models/addtionalInfoModel.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/activity.dart';

class GeneralInfoPage extends StatelessWidget {
  GeneralInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        if (state.entityActivityDetailsStatus == BlocStatus.loading)
          return const ShimmerVerticalList(
            height: 50,
          );

        /*if (state.entityActivityDetailsStatus == BlocStatus.failure)
          return ReloadWidget(
            onTab: () {
              context.read<DetailsBloc>().add(GetEntityActivityDetailsEvent());
            },
          );

        if (state.entityActivityDetailsStatus == BlocStatus.success)*/
        return Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Text(
                ("general_info").tr(),
                style: GoogleFonts.cairo(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              DetailsItemWidget(),
              const SizedBox(
                height: 30,
              ),
              Text(("license_guide").tr(),
                  style: AppStyle.heading2BoldStyle
                      .copyWith(color: AppColor.textPrimaryColor)),
              const SizedBox(
                height: 15,
              ),
              const DetailsUserGuide(),
              const SizedBox(
                height: 20,
              ),

              //add permits HERE
              //permitsView

              const PermitsWidget(),
              const SizedBox(
                height: 26,
              ),

              const Activity()
            ],
          ),
        );
      },
    );
  }
}
