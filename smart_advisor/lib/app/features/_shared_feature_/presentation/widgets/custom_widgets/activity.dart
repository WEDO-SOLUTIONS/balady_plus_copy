import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';

import '../../../../details/presentation/bloc/details_bloc.dart';
import '../../../../select_activity/domain/entities/addetional_activites_response.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/features/home/presentation/pages/home_page.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import '/app/features/shared_features/widgets/custom_icon_text.dart';
import 'package:flutter/material.dart';
import '/app/core/utils/constants/language.dart';

class Activity extends StatelessWidget {
  const Activity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        List<AddetionalActivityItem>? addetionalActivites =
            context.read<DetailsBloc>().args.addetionalActivites;
        return addetionalActivites?.isEmpty == false
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ("extra_activities").tr(),
                    style: AppStyle.heading2BoldStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  /*  Text(
                    'أنشطة إضافية يمكنك اضافتها الى رخصتك',
                    style: AppStyle.heading2BoldStyle
                        .copyWith(color: AppColor.primary),
                  ),*/
                  const SizedBox(
                    height: 10,
                  ),
                  MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: addetionalActivites?.length ?? 0,
                        itemBuilder: (ctx, index) {
                          return CustomIconText(
                              text: addetionalActivites?[index].activityName ??
                                  "");
                        }),
                  )

                  /* CustomButton(
              btnColor: AppColor.surfaceAccentSecondaryColor,
              textColor: AppColor.statusAccentColor,
              onPress: () {
                showModalBottomSheet(
                  backgroundColor: const Color(0xff000000),
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) => const NewHomePage(),
                );
              },
              //activities
              text: ("all_activities").tr(),
            ),*/
                ],
              )
            : Container();
      },
    );
  }
}
