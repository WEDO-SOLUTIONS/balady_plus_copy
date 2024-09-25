import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/shimmer_effect_widget.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/data/models/tobacco_schedule.dart';
import 'package:balady_plus/app/commercial_model/features/tobacco_services/presentation/tobacco_details/mvvm/tobacco_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YearsCardsList extends StatelessWidget implements PreferredSizeWidget {
  const YearsCardsList({super.key});

  @override
  Widget build(BuildContext context) {
    TobaccoDetailsViewModel provider = context.watch<TobaccoDetailsViewModel>();
    return SizedBox(
      height: preferredSize.height,
      width: double.maxFinite,
      child: Selector<TobaccoDetailsViewModel, TobaccoSchedule?>(
        selector: (_, provider) => provider.tobaccoSchedule,
        builder: (context, tobaccoSchedule, child) {
          return tobaccoSchedule != null
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tobaccoSchedule.years
                        .map(
                          (year) => ValueListenableBuilder(
                            valueListenable: provider.year,
                            builder: (BuildContext context, int? value,
                                Widget? child) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                color: (value != null && value == year)
                                    ? AppColor.primary900Light
                                    : Colors.white,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      provider.setDisclosureSchedules(year);
                                    },
                                    child: Text(
                                      year.toString(),
                                      style:
                                          AppStyle.listTitleTextStyle.copyWith(
                                        color: (value != null && value == year)
                                            ? Colors.white
                                            : AppColor.primary900Light,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        .toList(),
                  ),
                )
              : ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, __) => Container(
                    height: 50,
                    width: 80,
                    margin: const EdgeInsets.only(top: 16),
                    child: const ShimmerEffectWidget(),
                  ),
                );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
