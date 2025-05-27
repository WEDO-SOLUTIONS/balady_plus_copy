import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class HajjInfoWidget extends ConsumerWidget {
  final PoiMarkerRcmc poiMarkerRcmc;

  const HajjInfoWidget({
    required this.poiMarkerRcmc,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // On phone card tap handler
    final void Function(String) onPhoneTap = (phone) {
      ref.read(poiCardActionsProvider.notifier).callPhone(phone);
    };

    final poiContentData = PoiContentData(
      fullAddress: PoiContentFullAddress(
        name: poiMarkerRcmc.title,
        address: poiMarkerRcmc.address ?? '',
        distance: '',
      ),
      about: poiMarkerRcmc.description != null
          ? PoiContentAbout(
              aboutTitle: context.l10n.about,
              text: poiMarkerRcmc.description ?? '',
              showMoreTitle: context.l10n.showMore,
              showLessTitle: context.l10n.showLess,
            )
          : null,
      contacts: poiMarkerRcmc.contactInfo != null
          ? PoiContentContacts(
              phone: poiMarkerRcmc.contactInfo,
              onPhoneTap: () => onPhoneTap(poiMarkerRcmc.contactInfo!),
            )
          : null,
    );

    return PoiContent(
      padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: Spacing.$3x),
      data: poiContentData,
    );
  }
}
