import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/dashboard/domain/entities/volunteering_statistics_entity.dart';
import 'package:balady_plus/app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class VolunteerDashboardCard extends StatefulWidget {
  const VolunteerDashboardCard({super.key});

  @override
  State<VolunteerDashboardCard> createState() => _VolunteerDashboardCardState();
}

class _VolunteerDashboardCardState extends State<VolunteerDashboardCard> {
  final DashboardBloc _dashboardBloc = GetIt.instance<DashboardBloc>();

  @override
  void initState() {
    super.initState();
    _dashboardBloc.add(DashboardLoadVolunteeringStatistics());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration:  BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const DrawIconBasedTypeWidget(icon: IconPath.volunteerIcon),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'volunteer_municipal_housing'.tr(),
                  maxLines: 2,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<DashboardBloc, DashboardState>(
            bloc: _dashboardBloc,
            builder: (context, state) {
              if (state is SuccessVolunteeringStatisticsState) {
                final statistics = state.volunteeringStatistics;
                return statistics == null ? const NoDataComponent() : VolunteeringCardStatistics(statistics);
              }
              return const Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
    );
  }
}

class VolunteeringCardStatistics extends StatelessWidget {
  const VolunteeringCardStatistics(this.statistics, {super.key});

  final VolunteeringStatisticsEntity statistics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        color: Theme.of(context).cardColor,
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildItem(
                label: 'volunteering_hours'.tr(),
                value: statistics.volunteeringHours,
                color: Theme.of(context).primaryColor,
                context: context),
            _buildItem(
                label: 'volunteers_in_progress'.tr(),
                value: statistics.volunteersInProgress,
                color: Theme.of(context).primaryColor,
                context: context),
            _buildItem(
                label: 'completed_volunteers'.tr(),
                value: statistics.completedVolunteers,
                color: Theme.of(context).primaryColor,
                context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(
      {required String label, required String value, required Color color, required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color:  Theme.of(context).scaffoldBackgroundColor,

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            value,
            textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
          ),
          const SizedBox(height: 8),
          CustomTextWidget(
            label,
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }


}
