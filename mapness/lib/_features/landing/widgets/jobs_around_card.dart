import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/jobs_map.dart';
import 'package:mapness/features/jobs/providers/jobs_statistic_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class JobsAroundCard extends ConsumerWidget {
  const JobsAroundCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobStatistic = ref.watch(jobStatisticResponseProvider);

    return GestureDetector(
      onTap: () => _openJobs(context, ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.jobsAraundYou,
                style: Theme.of(context).extension<ThemeTextStyles>()!.accentL),
            const SizedBox(height: 12),
            Stack(
              children: [
                Image.asset(
                  'assets/images/job_card_img.png',
                  fit: BoxFit.fitWidth,
                  package: 'mapness',
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: jobStatistic.maybeWhen(
                    orElse: () => const SizedBox.shrink(),
                    data: (jobs) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jobs?.jobsCount?.toString() ?? '',
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()!
                                    .accentL
                                    .apply(
                                      color: Colors.white,
                                    ),
                              ),
                              Text(
                                context.l10n.jobVacancy,
                                style: Theme.of(context)
                                    .extension<ThemeTextStyles>()!
                                    .textS
                                    .apply(
                                      color: Colors.white,
                                    ),
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
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openJobs(BuildContext context, WidgetRef ref) async {
    CommonFunctions.authOrOpen(ref, context, callback: () {
      const JobsMapRoute().push(context);
    });
  }
}
