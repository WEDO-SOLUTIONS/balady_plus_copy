import 'package:balady_uikit/core/extensions/build_context_ext.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/jobs/data/models/job_model.dart';
import 'package:mapness/features/jobs/providers/job_detail_provider.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/expandable_container.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/job_button.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/job_share_button.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/route_button.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/app_features.dart';

class JobDetail extends ConsumerStatefulWidget {
  const JobDetail({
    required this.jobId,
    super.key,
  });
  final String jobId;

  @override
  ConsumerState<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends ConsumerState<JobDetail> {
  @override
  Widget build(BuildContext context) {
    final job = ref.watch(
      jobDetailProvider(
        id: widget.jobId,
      ),
    );

    return Material(
      child: job.maybeWhen(
        orElse: () => const SizedBox.shrink(),
        data: (data) {
          if (data == null) {
            return const SizedBox.shrink();
          }

          final latitude = double.tryParse(data.location?.latitude ?? '');
          final longitude = double.tryParse(data.location?.longitude ?? '');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 16),
                child: Column(
                  children: [
                    ExpandableContainer(
                      title: context.l10n.jobDescription,
                      data: data.description ?? '',
                    ),
                    ExpandableContainer(
                      title: context.l10n.skills,
                      data: data.skills ?? '',
                    ),
                    _JobDetailCard(model: data),
                    const SizedBox(height: 16),
                    _JobContactsWidget(model: data),
                    const SizedBox(height: 16),
                    _JobInfoWidget(
                      title: context.l10n.published,
                      data: _publishDate(data.publishDate ?? ''),
                    ),
                    const SizedBox(height: 16),
                    _JobInfoWidget(
                      title: context.l10n.coordinates,
                      data: '${data.location?.latitude ?? ''}, ${data.location?.longitude ?? ''}',
                    ),
                    const SizedBox(height: 16),
                    _JobLicenseWidget(job: data),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsetsDirectional.only(
                  top: 8,
                  bottom: 16,
                  start: 16,
                  end: 16,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    JobButton(
                      label: context.l10n.call,
                      asset: 'assets/icons/svg/ic_phone.svg',
                      backgroundColor: context.color.strokeAccent,
                      textColor: Colors.white,
                      onPressed: () => CommonFunctions.call(data.mobile ?? ''),
                    ),
                    if (ref.read(appFeaturesProvider).naviEnabled && latitude != null && longitude != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: JobShareButton(
                          lat: latitude,
                          lon: longitude,
                        ),
                      ),
                    if (ref.read(appFeaturesProvider).naviEnabled && latitude != null && longitude != null)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(start: 16),
                        child: RouteButton(
                          latitude: latitude,
                          longitude: longitude,
                          label: data.name ?? '',
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
      ),
    );
  }

  String _publishDate(String date) {
    final publishDate = DateTime.parse(date);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(publishDate);

    String formattedDate;
    if (difference.inDays == 0) {
      formattedDate = context.l10n.today;
    } else if (difference.inDays == 1) {
      formattedDate = context.l10n.yesterday;
    } else if (difference.inDays < 7) {
      formattedDate = '${difference.inDays} ${context.l10n.daysAgo}';
    } else {
      formattedDate = date;
    }

    return formattedDate;
  }
}

class _JobDetailCard extends StatelessWidget {
  const _JobDetailCard({required this.model});
  final JobModel model;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.jobDetails,
              style: context.textStyle.heading2.apply(color: context.color.textAndIconsBasePrimary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.l10n.workHours,
                    style: context.textStyle.text.apply(color: context.color.textAndIconsBasePrimary),
                  ),
                ),
                Expanded(
                  child: Text(
                    model.workHours?.toStringAsFixed(0) ?? '',
                    textAlign: TextAlign.start,
                    style:
                        context.textStyle.footNote.apply(color: context.color.textAndIconsBasePrimary.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.l10n.employmentType,
                    style: context.textStyle.text.apply(color: context.color.textAndIconsBasePrimary),
                  ),
                ),
                Expanded(
                  child: Text(
                    model.contractType?.name ?? '',
                    textAlign: TextAlign.start,
                    style:
                        context.textStyle.footNote.apply(color: context.color.textAndIconsBasePrimary.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.l10n.nationality,
                    style: context.textStyle.text.apply(color: context.color.textAndIconsBasePrimary),
                  ),
                ),
                Expanded(
                  child: Text(
                    model.saudi == true ? 'Saudi' : 'Non-Saudi',
                    textAlign: TextAlign.start,
                    style:
                        context.textStyle.footNote.apply(color: context.color.textAndIconsBasePrimary.withOpacity(0.5)),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _JobContactsWidget extends StatelessWidget {
  const _JobContactsWidget({required this.model});
  final JobModel model;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/icons/svg/ic_phone.svg',
                  width: 18,
                  height: 18,
                  package: 'mapness',
                  colorFilter: ColorFilter.mode(
                    context.color.strokeAccent,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => CommonFunctions.call(model.mobile ?? ''),
                    child: Text(
                      model.mobile ?? '',
                      textAlign: TextAlign.start,
                      style: context.textStyle.text.apply(
                        color: context.color.textAndIconsBasePrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 36),
              child: Divider(
                color: context.color.textAndIconsBasePrimary.withOpacity(.15),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  'assets/icons/svg/ic_mail.svg',
                  width: 24,
                  height: 24,
                  package: 'mapness',
                  colorFilter: ColorFilter.mode(
                    context.color.strokeAccent,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => CommonFunctions.email(model.email ?? ''),
                    child: Text(
                      model.email ?? '',
                      textAlign: TextAlign.start,
                      style: context.textStyle.text.apply(
                        color: context.color.textAndIconsBasePrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _JobInfoWidget extends StatelessWidget {
  const _JobInfoWidget({
    required this.title,
    required this.data,
  });
  final String title;
  final String data;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textStyle.text.apply(
                color: context.color.textAndIconsBasePrimary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data,
              style: context.textStyle.footNote.apply(
                color: context.color.textAndIconsBasePrimary.withOpacity(.5),
              ),
            ),
          ],
        ),
      );
}

class _JobLicenseWidget extends StatelessWidget {
  const _JobLicenseWidget({required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 0, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/svg/ic_info_circle.svg',
                  package: PackageConfig.packageName,
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 8,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.commercialLicenseNumber?.toString() ?? '',
                      style: context.textStyle.text.apply(color: context.color.textAndIconsBasePrimary),
                    ),
                    Text(
                      context.l10n.commercialLicenseNumber,
                      style: context.textStyle.footNote.apply(
                        color: context.color.textAndIconsBasePrimary.withOpacity(.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
}
