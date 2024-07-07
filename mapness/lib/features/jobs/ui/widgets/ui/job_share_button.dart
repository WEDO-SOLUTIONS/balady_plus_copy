import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/jobs/providers/job_distance_provider.dart';
import 'package:mapness/features/jobs/ui/widgets/ui/job_button.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:share_plus/share_plus.dart';

class JobShareButton extends ConsumerWidget {
  const JobShareButton({required this.lat, required this.lon, super.key});
  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobDistance = ref.watch(
      jobDistanceProvider(lat, lon),
    );

    if (jobDistance.hasValue && jobDistance.valueOrNull == null) {
      return const SizedBox.shrink();
    }
    return jobDistance.maybeWhen(
      data: (data) => JobButton(
        label: context.l10n.share,
        asset: 'assets/icons/svg/ic_share.svg',
        backgroundColor: context.color.textAndIconsBasePrimary.withOpacity(0.05),
        textColor: context.color.textAndIconsBasePrimary.withOpacity(.5),
        onPressed: () {
          final object = data?.id?.objectId;
          if (object == null) {
            return;
          }
          Share.share('balady://poi-map?dgis-object-id=$object');
        },
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
