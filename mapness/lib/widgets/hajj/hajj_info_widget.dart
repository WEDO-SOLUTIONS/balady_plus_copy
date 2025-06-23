import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/hajj/poi_marker_rcmc.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_about_card.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_contacts_card.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_full_address_card.dart';
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

    final contactInfo = poiMarkerRcmc.contactInfo;
    const itemPadding = EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x);

    return Padding(
      padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: Spacing.$3x),
      child: Column(
        children: [
          Padding(
            padding: itemPadding,
            child: PoiContentFullAddressCard(
              data: PoiContentFullAddressModel(title: poiMarkerRcmc.title, fullAddress: poiMarkerRcmc.address ?? ''),
            ),
          ),
          if (poiMarkerRcmc.description != null)
            Padding(
              padding: itemPadding,
              child: PoiContentAboutCard(
                data: PoiContentAboutModel(
                  aboutTitle: context.l10n.about,
                  text: poiMarkerRcmc.description ?? '',
                  showMoreTitle: context.l10n.showMore,
                  showLessTitle: context.l10n.showLess,
                ),
              ),
            ),
          if (contactInfo != null)
            Padding(
              padding: itemPadding,
              child: PoiContentContactsCard(
                data: PoiContentContactsModel(
                  onPhoneTap: onPhoneTap,
                  onEmailTap: (_) {},
                  onSocialMediaTap: (_) {},
                  phones: [contactInfo],
                ),
              ),
            )
        ],
      ),
    );
  }
}
