import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/functions/create_amount_or_ratio_text_span.dart';
import 'package:mapness/features/saudi_pass/views/offers_screen_view.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_view_decoration_widget.dart';
import 'package:mapness/features/saudi_pass/widgets/offers_view_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class OfferViewWidget extends ConsumerWidget {
  final OfferView offerView;

  const OfferViewWidget(this.offerView, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorsV2;
    final textStyles = context.textStyleV3;
    final locale = Localizations.localeOf(context);
    final byDate = DateFormat('d MMMM', locale.languageCode).format(offerView.byDate);
    final byDateStyle = textStyles.captionMediumRegular.copyWith(
      color: offerView.isByDateRed ? colors.errorDefault : null,
    );

    final amountOrRatioTextSpan = createAmountOrRatioTextSpan(
      amount: offerView.amount,
      ratio: offerView.ratio,
      language: ref.watch(appLanguageProvider),
      locale: Localizations.localeOf(context),
      iconSize: 12,
    );

    const boxFit = BoxFit.cover;
    return InkWell(
      onTap: offerView.onTap,
      child: OfferViewDecorationWidget(
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.m)),
              child: SizedBox.square(
                dimension: Spacing.$12x,
                child: CachedNetworkImage(
                  imageUrl: offerView.logo.url,
                  httpHeaders: offerView.logo.headers,
                  fit: boxFit,
                  errorWidget: (context, url, error) => DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: offerView.offersGroup.color,
                        begin: context.isLTR ? Alignment.topLeft : Alignment.topRight,
                        end: context.isLTR ? Alignment.bottomRight : Alignment.bottomLeft,
                      ),
                    ),
                    child: Image.asset(
                      offerView.offersGroup.imagePath,
                      fit: boxFit,
                    ),
                  ),
                ),
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
                        TextSpan(text: offerView.title),
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
                    offerView.subTitle,
                    style: textStyles.captionMediumRegular,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    offerView.branchName,
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
            const SizedBox(width: Spacing.$3x),
            Align(
              alignment: Alignment.topRight,
              child: _HeartIconWidget(offerView),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeartIconWidget extends StatelessWidget {
  final OfferView offerView;

  const _HeartIconWidget(this.offerView);

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsV2;

    return ListenableBuilder(
      listenable: offerView,
      builder: (context, _) => InkWell(
        onTap: () {
          offerView.onHeartTap();
          context.findAncestorWidgetOfExactType<OffersViewWidget>()?.onChangeOffers?.call();
        },
        child: Icon(
          offerView.isHeartRedAndFilled ? GeneralIcons.filledHeart : GeneralIcons.heart,
          color: offerView.isHeartRedAndFilled ? colors.extra01Default : colors.neutralMuted,
        ),
      ),
    );
  }
}
