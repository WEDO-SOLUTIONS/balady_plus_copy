import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/saudi_pass/functions/create_amount_or_ratio_text_span.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:urbi_utils/urbi_utils.dart';

import 'saudi_pass_image.dart';

class OffersBottomSheetWidget extends StatelessWidget {
  const OffersBottomSheetWidget(this.offers, {super.key});

  final List<OfferDetails> offers;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface1,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: offers
              .map<Widget>((e) => _OfferViewWidgetDetails(e))
              .insertBetween(
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$3x),
                  child: Divider(
                    height: 1,
                    color: context.colors.borderDefault,
                  ),
                ),
              )
              .toList(),
        ),
      );
}

class _OfferViewWidgetDetails extends ConsumerWidget {
  final OfferDetails offerDetails;

  const _OfferViewWidgetDetails(this.offerDetails);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textStyles = context.textStyles;
    final locale = Localizations.localeOf(context);
    final byDate = DateFormat('d MMMM', locale.languageCode).format(offerDetails.publishEndDate);
    final byDateStyle = textStyles.captionMediumRegular.copyWith(
      color: offerDetails.willExpiredSoon ? colors.errorDefault : null,
    );

    final amountOrRatioTextSpan = createAmountOrRatioTextSpan(
      amount: offerDetails.typeDetails.amount,
      ratio: offerDetails.typeDetails.ratio,
      language: ref.watch(appLanguageProvider),
      locale: Localizations.localeOf(context),
      iconSize: 12,
    );
    final offerImage = offerDetails.images.firstOrNull;

    return InkWell(
      onTap: () => context.router.push(OfferRoute(offerId: offerDetails.id)),
      child: Padding(
        padding: const EdgeInsets.all(Spacing.$3x).copyWith(left: Spacing.$4x),
        child: Row(
          children: [
            if (offerImage != null)
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.m)),
              child: SizedBox.square(
                dimension: Spacing.$12x,
                child:  SaudiPassImage(imageId: offerDetails.provider.logo),
              ),
            ),
            const SizedBox(width: Spacing.$3x),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        if (amountOrRatioTextSpan != null) amountOrRatioTextSpan,
                        TextSpan(text: ' • ', style: TextStyle(color: colors.neutralMuted)),
                        TextSpan(text: offerDetails.name),
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: Spacing.$1x),
                            child: Icon(PlacesIcons.markets, size: 16, color: colors.neutralMuted),
                          ),
                        ),
                      ],
                      style: textStyles.bodySmallSemiBold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    offerDetails.description,
                    style: textStyles.captionMediumRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    offerDetails.branchName,
                    style: textStyles.captionMediumRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${context.l10n.saudiPassOfferBy} $byDate',
                    style: byDateStyle,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            SystemIcons.arrowCornerRightSmall.icon()
          ],
        ),
      ),
    );
  }
}
