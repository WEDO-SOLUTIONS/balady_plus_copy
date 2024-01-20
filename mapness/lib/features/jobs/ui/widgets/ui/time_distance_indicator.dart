import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/jobs/providers/job_distance_provider.dart';
import 'package:mapness/features/path_nav/lib/number_formatters.dart';
import 'package:mapness/shared/config/package_config.dart';

class TimeDistanceIndicator extends ConsumerWidget {
  final double latitude;
  final double longitude;
  const TimeDistanceIndicator({
    required this.latitude,
    required this.longitude,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDistance = ref.watch(jobDistanceProvider(latitude, longitude));

    return jobDistance.maybeWhen(
      data: (data) {
        if (data == null ||
            data.briefMessages == null ||
            data.briefMessages?.isEmpty == true) {
          return const SizedBox.shrink();
        }

        final duration = data.briefMessages?.first.duration ?? 0;

        final fmtDuration = duration.floor().formatDuration();

        return Row(
          children: [
            SvgPicture.asset(
              'assets/icons/svg/ic_car.svg',
              colorFilter: ColorFilter.mode(
                const Color(0xff1E2A36).withOpacity(.5),
                BlendMode.srcIn,
              ),
              package: PackageConfig.packageName,
            ),
            const SizedBox(width: 8),
            Text(
              fmtDuration,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textS
                  .copyWith(
                    color: const Color(0xff1E2A36).withOpacity(.5),
                  ),
            ),
          ],
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
