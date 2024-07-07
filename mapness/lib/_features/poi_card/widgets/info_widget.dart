import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/widgets/about.dart';
import 'package:mapness/_features/poi_card/widgets/contacts_info.dart';
import 'package:mapness/_features/poi_card/widgets/favourites.dart';
import 'package:mapness/_features/poi_card/widgets/full_address.dart';
import 'package:mapness/_features/poi_card/widgets/opening_hours.dart';
import 'package:mapness/_features/poi_card/widgets/qr_license_info.dart';
import 'package:mapness/_features/poi_card/widgets/trade_license.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

import 'footer/footer_style.dart';

class InfoWidget extends ConsumerWidget {
  final PoiCardState? poiCardState;
  final VoidCallback callback;

  const InfoWidget({
    required this.poiCardState,
    required this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = poiCardState?.gisObjectIdMessage;
    final qrTradeLicense = poiCardState?.qrTradeLicense;
    final tradeLicense = data?.tradeLicense;

    final subTitle = data?.makeAddress() ?? '';

    final calculateEntrances = data?.entrances.fold(0, (prev, e) => prev + (e?.geometry?.entrancePoints.length ?? 0));

    final about = data?.about;
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Favourites(data),
          if (data != null)
            FullAddress(
              data: data,
              title: data.address?.buildingName ?? data.title,
              subtitle: subTitle,
              exits: calculateEntrances,
              onEntranceTap: callback,
            ),
          if (about != null && about.isNotEmpty == true)
            About(
              text: about,
            ),
          if (data?.openingHours != null)
            OpeningHours(
              data?.getOpeningHoursModel(
                context.l10n,
              ),
            ),
          if (data!.contactInfos.isNotEmpty)
            ContactsInfo(
              data: data.contactInfos,
            ),
          if (qrTradeLicense != null) QrLicenseInfo(qrTradeLicense),
          if (tradeLicense != null) TradeLicense(tradeLicense),
          const SafeArea(
            top: false,
            child: SizedBox(height: footerHeight),
          ),
        ],
      ),
    );
  }
}
