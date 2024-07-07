import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/app/routes/jobs_map.dart';
import 'package:mapness/features/jobs/providers/jobs_statistic_provider.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class JobsAroundCard extends ConsumerWidget {
  const JobsAroundCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobStatistic = ref.watch(jobStatisticProvider);
    final authState = ref.watch(authProvider);

    // Update card when user auth state changes
    return authState.maybeWhen(
      orElse: () => const SizedBox.shrink(),
      data: (_) => GestureDetector(
        onTap: () => _openJobs(context, ref),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n.jobsAraundYou, style: context.textStyle.heading2),
              const SizedBox(height: 12),
              Stack(
                children: [
                  Image.asset(
                    'assets/images/job_card_img.png',
                    fit: BoxFit.fitWidth,
                    package: PackageConfig.packageName,
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: jobStatistic.maybeWhen(
                      orElse: () => Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          LabeledElevatedButton(
                            label: context.l10n.findJob,
                            onPressed: () => _openJobs(context, ref),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 42,
                              vertical: 10,
                            ),
                          ),
                          const SizedBox(
                            width: 38,
                          ),
                        ],
                      ),
                      data: (jobs) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jobs?.jobsCount?.toString() ?? '',
                                style: context.textStyle.heading2.apply(color: Colors.white),
                              ),
                              Text(
                                context.l10n.jobVacancy,
                                style: context.textStyle.footNote.apply(color: Colors.white),
                              ),
                            ],
                          ),
                          LabeledElevatedButton(
                            label: context.l10n.findJob,
                            onPressed: () => _openJobs(context, ref),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 42,
                              vertical: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openJobs(BuildContext context, WidgetRef ref) {
    if (!context.mounted) {
      return;
    }

    //Hide all quick-filters
    ref.read(searchByRubricsQueryProvider.notifier).update(null);

    CommonFunctions.authOrOpen(
      context,
      callback: () {
        if (!context.mounted) {
          return;
        }
        const JobsMapRoute().push(context);
      },
    );
  }
}
