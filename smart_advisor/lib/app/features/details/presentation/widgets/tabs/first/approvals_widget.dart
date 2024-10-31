import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';

import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../../core/utils/constants/app_style.dart';
import '../../../bloc/details_state.dart';

class ApprovalsWidget extends StatelessWidget {
  const ApprovalsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "الموافقات",
                style: AppStyle.heading2BoldStyle,
              ),
              const SizedBox(
                height: 8,
              ),
              MediaQuery.removePadding(
                removeTop: true,
                removeBottom: true,
                context: context,
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state
                            .entityActivityDetailsResponse?.approvals?.length ??
                        0,
                    itemBuilder: (ctx, index) {
                      return Container(
                        padding: const EdgeInsets.only(
                            right: 14, left: 14, top: 8, bottom: 8),
                        decoration: BoxDecoration(
                            color: AppColor.surfaceTertairyColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state
                                      .entityActivityDetailsResponse
                                      ?.approvals?[index]
                                      .supervisingAuthorityName ??
                                  "",
                              textAlign: TextAlign.start,
                              style: AppStyle.textRegularRomanStyle
                                  .copyWith(color: AppColor.textPrimaryColor),
                            ),
                            Text(
                              state.entityActivityDetailsResponse
                                      ?.approvals?[index].approvalType?.name ??
                                  "",
                              style: AppStyle.footNoteMediumStyle
                                  .copyWith(color: AppColor.textSecondaryColor),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        );
      },
    );
  }
}
