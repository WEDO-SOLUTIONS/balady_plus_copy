import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/jobs_map.dart';
import 'package:mapness/features/jobs/data/models/job_model.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/time_distance_indicator.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';

class JobCard extends ConsumerWidget {
  const JobCard({
    required this.jobModel,
    super.key,
  });
  final JobModel jobModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final longitude = double.tryParse(jobModel.location?.longitude ?? '');
    final latitude = double.tryParse(jobModel.location?.latitude ?? '');

    return Material(
      child: GestureDetector(
        onTap: () {
          if (jobModel.id == null) {
            return;
          }
          ref.read(cameraPositionProvider.notifier).animateTo(
                CameraPositionMessage(
                  zoom: 15,
                  bearing: 0,
                  point: GeoPointMessage(
                    longitude: double.parse(jobModel.location!.longitude!),
                    latitude: double.parse(jobModel.location!.latitude!),
                  ),
                  tilt: 0,
                ),
              );
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
              Text(
                jobModel.name ?? '',
                style: context.textStyle.callout.copyWith(
                  color: context.color.textAndIconsBasePrimary,
                ),
              ),
              Text(
                jobModel.provider?.name ?? '',
                style: context.textStyle.footNote.copyWith(
                  color: context.color.textAndIconsBasePrimary.withOpacity(.5),
                ),
              ),
              if (jobModel.description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    jobModel.description ?? '',
                    style: context.textStyle.footNote.copyWith(
                      color: context.color.textAndIconsBasePrimary,
                    ),
                  ),
                ),
              if (longitude != null && latitude != null)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: TimeDistanceIndicator(
                    latitude: latitude,
                    longitude: longitude,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
