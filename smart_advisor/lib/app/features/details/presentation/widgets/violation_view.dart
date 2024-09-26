// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card%20copy.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_event.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';

import '../../../../core/utils/enums/bloc_status.dart';
import '../../data/models/entity_violation_activity_model.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ViolatonView extends StatefulWidget {
  const ViolatonView({super.key});

  @override
  State<ViolatonView> createState() => _ViolatonViewState();
}

class _ViolatonViewState extends State<ViolatonView> {
  bool isWarning = false;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        return Container(
          color: Colors.transparent,
          child: Column(
            children: [
              MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                    itemCount: state.vdViolationList?.length ?? 0,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context
                              .read<DetailsBloc>()
                              .add(GetViolationDetailsEvent(
                                  item: EntityViolationActivityModel(
                                linkId: state.vdViolationList?[index].linkId,
                              )));
                        },
                        child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /* Text(
                                        'المخالفة',
                                        style: AppStyle.textRegularRomanStyle
                                            .copyWith(
                                                color: AppColor.textPrimaryColor),
                                      ),*/
                                      Text(
                                        state.vdViolationList?[index]
                                                .description ??
                                            "",
                                        style: AppStyle.footNoteMediumStyle
                                            .copyWith(
                                                color:
                                                    AppColor.textPrimaryColor),
                                      ),
                                    ],
                                  ),
                                ),
                                SvgPicture.asset(IconPath.arrowR),
                              ],
                            )),
                      );
                    }),
              ),
              if (state.vdViolationStatus == BlocStatus.loading)
                Shimmer2VerticalList()
            ],
          ),
        );
      },
    );
  }
}
