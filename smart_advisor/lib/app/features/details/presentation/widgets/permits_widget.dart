import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../select_activity/domain/entities/permits_activites_response.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/features/shared_features/widgets/text_component.dart';
import 'package:flutter/material.dart';
import '/app/core/utils/constants/language.dart';

class PermitsWidget extends StatelessWidget {
  const PermitsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        List<PermitItem>? permits = context.read<DetailsBloc>().args.permits;
        return permits?.isEmpty == false
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ("permits").tr(),
                    style: AppStyle.heading2BoldStyle
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  MediaQuery.removePadding(
                      removeTop: true,
                      context: context,
                      child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: permits?.length ?? 0,
                          itemBuilder: (context, index) {
                            return TextComponent(
                              title: permits?[index].name ?? "",
                              Subtitle: permits?[index].isFreeOfCharge != true
                                  ? "برسوم"
                                  : "بدون رسوم",
                            );
                          })),
                  /*CustomButton(
              btnColor: AppColor.surfaceAccentSecondaryColor,
              textColor: AppColor.statusAccentColor,
              onPress: () {
                showModalBottomSheet(
                  backgroundColor: const Color(0xff000000),
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) => HomePage(),
                );
              },
              text: ("all_permits").tr(),
            ),*/
                ],
              )
            : Container();
      },
    );
  }
}
