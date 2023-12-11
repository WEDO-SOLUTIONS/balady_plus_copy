import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/jobs/models/job_model.dart';
import 'package:mapness/features/jobs/providers/job_detail_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:share_plus/share_plus.dart';

class JobDetail extends ConsumerStatefulWidget {
  final String jobId;
  const JobDetail({
    super.key,
    required this.jobId,
  });

  @override
  ConsumerState<JobDetail> createState() => _JobDetailState();
}

class _JobDetailState extends ConsumerState<JobDetail> {
  @override
  Widget build(BuildContext context) {
    final job = ref.watch(jobDetailResponseProvider(
      id: widget.jobId,
    ));

    return Material(
      child: job.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          data: (data) {
            if (data == null) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16)
                      .copyWith(top: 16),
                  child: Column(
                    children: [
                      _decoratedCard(
                          context.l10n.jobDescription, data.description ?? ''),
                      _decoratedCard(context.l10n.skills, data.skills ?? ''),
                      _jobDetailCard(data),
                      const SizedBox(height: 16),
                      _jobContacts(data),
                      const SizedBox(height: 16),
                      _jobInfo(context.l10n.published,
                          _publishDate(data.publishDate ?? '')),
                      const SizedBox(height: 16),
                      _jobInfo(context.l10n.coordinates,
                          '${data.location?.latitude ?? ''}, ${data.location?.longitude ?? ''}'),
                      const SizedBox(height: 16),
                      _jobLicense(data),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                _buttonsRow(data),
                const SizedBox(height: 16),
              ],
            );
          }),
    );
  }

  Widget _buttonsRow(JobModel model) {
    return Container(
      padding: const EdgeInsets.only(top: 8, bottom: 24, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          _buildButton(
            context.l10n.call,
            'assets/icons/svg/ic_phone.svg',
            backgroundColor: const Color(0xff4CA5B4),
            textColor: Colors.white,
            onPressed: () => CommonFunctions.call(model.mobile ?? ''),
          ),
          const SizedBox(width: 12),
          _buildButton(
            '25 ${context.l10n.min}',
            'assets/icons/svg/ic_car.svg',
            backgroundColor: const Color(0xff1E2A36).withOpacity(0.05),
            textColor: const Color(0xff1E2A36).withOpacity(.5),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          _buildButton(
            context.l10n.share,
            'assets/icons/svg/ic_share.svg',
            backgroundColor: const Color(0xff1E2A36).withOpacity(0.05),
            textColor: const Color(0xff1E2A36).withOpacity(.5),
            onPressed: () => Share.share(
              'https://www.google.com/maps/dir/?api=1&destination=${model.location?.latitude},${model.location?.longitude}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _jobLicense(JobModel job) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16).copyWith(right: 0),
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
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textM
                        .apply(color: const Color(0xff1E2A36)),
                  ),
                  Text(
                    context.l10n.commercialLicenseNumber,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textS
                        .apply(color: const Color(0xff1E2A36).withOpacity(.5)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _jobInfo(String title, String data) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16).copyWith(right: 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textM
                  .apply(color: const Color(0xff1E2A36))),
          const SizedBox(height: 12),
          Text(data,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textS
                  .apply(color: const Color(0xff1E2A36).withOpacity(.5))),
        ]));
  }

  Widget _jobContacts(JobModel model) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16).copyWith(right: 0),
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
                colorFilter:
                    const ColorFilter.mode(Color(0xff4CA5B4), BlendMode.srcIn),
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
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textM
                        .apply(color: const Color(0xff1E2A36)),
                  ),
                ),
              ),
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Divider(
                color: const Color(0xff1E2A36).withOpacity(.15),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/icons/svg/ic_email.svg',
                width: 24,
                height: 24,
                package: 'mapness',
                colorFilter:
                    const ColorFilter.mode(Color(0xff4CA5B4), BlendMode.srcIn),
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
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .textM
                        .apply(color: const Color(0xff1E2A36)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String label, String asset,
      {Color? backgroundColor,
      Color? textColor,
      bool enabled = true,
      VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? const Color(0xff4CA5B4),
        disabledBackgroundColor: const Color(0xffDDDFE1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        padding: const EdgeInsets.all(10),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            asset,
            height: 18,
            width: 18,
            color: textColor ?? Colors.white,
            package: PackageConfig.packageName,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()
                ?.textM
                .copyWith(color: textColor ?? Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _jobDetailCard(JobModel model) {
    return Container(
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
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .accentL
                .apply(color: const Color(0xff1E2A36)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.l10n.workHours,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .apply(color: const Color(0xff1E2A36)),
                ),
              ),
              Expanded(
                child: Text(
                  model.workHours?.toStringAsFixed(0) ?? '',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textS
                      .apply(color: const Color(0xff1E2A36).withOpacity(0.5)),
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
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .apply(color: const Color(0xff1E2A36)),
                ),
              ),
              Expanded(
                child: Text(
                  model.contractType?.name ?? '',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textS
                      .apply(color: const Color(0xff1E2A36).withOpacity(0.5)),
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
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textM
                      .apply(color: const Color(0xff1E2A36)),
                ),
              ),
              Expanded(
                child: Text(
                  model.saudi == true ? 'Saudi' : 'Non-Saudi',
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .textS
                      .apply(color: const Color(0xff1E2A36).withOpacity(0.5)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _publishDate(String date) {
    final DateTime publishDate = DateTime.parse(date);
    final DateTime currentDate = DateTime.now();
    final Duration difference = currentDate.difference(publishDate);

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

  Widget _decoratedCard(String title, String data) {
    return ExpandableContainer(
      data: data,
      title: title,
    );
  }
}

class ExpandableContainer extends StatefulWidget {
  final String title;
  final String data;

  const ExpandableContainer({
    super.key,
    required this.title,
    required this.data,
  });

  @override
  ExpandableContainerState createState() => ExpandableContainerState();
}

class ExpandableContainerState extends State<ExpandableContainer> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) return const SizedBox.shrink();
    final dataSplits = widget.data.split('\n').where((e) => e.isNotEmpty).map(
          (e) => Text(
            '• $e\n',
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .textM
                .apply(color: const Color(0xff1E2A36)),
          ),
        );
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GestureDetector(
        onTap: () => setState(() {
          isExpanded = !isExpanded;
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .accentL
                      .apply(color: const Color(0xff1E2A36)),
                ),
                if (widget.data.split('\n').length > 5)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            if (isExpanded) ...dataSplits else ...dataSplits.take(5),
            if (!isExpanded && widget.data.split('\n').length > 5)
              Text(
                '...',
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .textM
                    .apply(color: const Color(0xff1E2A36)),
              ),
          ],
        ),
      ),
    );
  }
}
