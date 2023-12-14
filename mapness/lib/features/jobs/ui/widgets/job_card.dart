import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/app/routes/jobs_map.dart';
import 'package:mapness/features/jobs/models/job_model.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';

class JobCard extends ConsumerWidget {
  final JobModel jobModel;

  const JobCard({
    Key? key,
    required this.jobModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final briefInfo = ref.watch(briefRouteInfoProvider(
      finishPoint: null,
      navType: RouteSearchOptionsMessage.car,
    ));
    print(briefInfo.toString());
    return Material(
      child: GestureDetector(
        onTap: () {
          if (jobModel.id == null) return;
          JobsMapDetail(jobId: jobModel.id!).push(context);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jobModel.name ?? '',
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .accentM
                      .apply(color: const Color(0xff1E2A36))),
              Text(jobModel.provider?.name ?? '',
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textS
                      .apply(color: const Color(0xff1E2A36).withOpacity(.5))),
              const SizedBox(height: 4),
              Text(jobModel.description ?? '',
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textS
                      .apply(color: const Color(0xff1E2A36))),
              const SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/svg/ic_car.svg',
                    width: 24,
                    height: 24,
                    package: 'mapness',
                    colorFilter: ColorFilter.mode(
                        const Color(0xff1E2A36).withOpacity(.5),
                        BlendMode.srcIn),
                  ),
                  const SizedBox(width: 4),

                  // if (jobModel.location?.latitude != null &&
                  //     jobModel.location?.longitude != null)
                  //   BriefRouteInfo(
                  //     finishPoint: RouteSearchPointMessage(
                  //       coordinates: GeoPointMessage(
                  //           latitude:
                  //               double.tryParse(jobModel.location!.latitude!) ??
                  //                   0,
                  //           longitude:
                  //               double.tryParse(jobModel.location!.latitude!) ??
                  //                   0),
                  //       objectId: DgisObjectIdMessage(
                  //         objectId: 0,
                  //         entranceId: 0,
                  //       ),
                  //     ),
                  //     routeType: RouteSearchOptionsMessage.car,
                  //   ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
