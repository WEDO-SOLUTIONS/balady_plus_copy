import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/functions/create_amount_or_ratio_text_span.dart';
import 'package:mapness/features/saudi_pass/repo/promotions_body.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

/// The [_PoiContentOffersWidget] widget is used to display a offers in the POI content.
class PoiContentOffersCard extends StatelessWidget {
  static const offerCardHeight = 115.0;
  static const offerCardWidth = 296.0;
  final List<Offer> offers;
  final EdgeInsets contentPadding;

  const PoiContentOffersCard({
    required this.offers,
    required this.contentPadding,
    super.key,
  });

  @override
  Widget build(BuildContext context) => offers.length == 1
      ? Padding(
          padding: contentPadding,
          child: _OfferCard(
            offer: offers.first,
            height: offerCardHeight,
            width: double.infinity,
          ),
        )
      : SizedBox(
          height: offerCardHeight,
          child: ScrollConfiguration(
            behavior: NoGlowingScrollBehavior(),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: contentPadding,
              itemCount: offers.length,
              itemBuilder: (context, i) {
                final offer = offers[i];
                return _OfferCard(
                  offer: offer,
                  height: offerCardHeight,
                  width: offerCardWidth,
                );
              },
              separatorBuilder: (context, index) => Spacing.$2x.widthBox,
            ),
          ),
        );
}

class _OfferCard extends HookConsumerWidget {
  final Offer offer;
  final double height;
  final double width;

  const _OfferCard({
    required this.offer,
    required this.height,
    required this.width,
  });

  TextSpan? _getDiscount(Offer offer, Language language, BuildContext context) {
    final locale = Localizations.localeOf(context);

    return createAmountOrRatioTextSpan(
      language: language,
      locale: locale,
      amount: offer.typeDetails?.amount,
      ratio: offer.typeDetails?.ratio,
      iconSize: 22,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasDiscount = offer.discount != null;

    final language = ref.watch(appLanguageProvider);
    final discount = _getDiscount(offer, language, context);

    return GestureDetector(
      onTap: () => context.router.push(OfferRoute(offerId: offer.id)),
      child: SizedBox(
        height: height,
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(RadiusBorder.xl),
            ),
            color: context.colorsV3.backgroundSurface1,
          ),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.$1_5x),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: Spacing.$2x,
                      top: Spacing.$2x,
                      bottom: Spacing.$2x,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            offer.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: hasDiscount ? 2 : 5,
                            style: context.textStyleV3.captionLargeRegular
                                .copyWith(
                              color: context.colorsV3.foregroundDefault,
                            ),
                          ),
                        ),
                        if (offer.discount != null)
                          Text.rich(
                            discount!,
                            maxLines: 1,
                            style: context.textStyleV3.h1SemiBold.copyWith(
                              color: context.colorsV3.foregroundDefault,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.$4x),
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(RadiusBorder.l),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: offer.offerGroup.color,
                        begin: context.isLTR
                            ? Alignment.topLeft
                            : Alignment.topRight,
                        end: context.isLTR
                            ? Alignment.bottomRight
                            : Alignment.bottomLeft,
                      ),
                    ),
                    child: SizedBox(
                      height: 103,
                      child: Transform(
                        alignment: Alignment.center,
                        transform: context.isLTR
                            ? Matrix4.identity()
                            : Matrix4.rotationY(pi),
                        child: Image.asset(
                          offer.offerGroup.imagePath,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FallbackImage extends StatelessWidget {
  final PoiContentOfferFallbackImage image;

  const _FallbackImage({required this.image, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLTR = Directionality.of(context) == TextDirection.ltr;
    return Transform(
      alignment: Alignment.center,
      transform: isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: image.colors,
          ),
        ),
        child: Padding(
          padding: image.padding,
          child: Image.asset(
            image.path,
            fit: BoxFit.cover,
            package: image.package,
          ),
        ),
      ),
    );
  }
}

class PoiContentOfferFallbackImage {
  final String path;
  final List<Color> colors;
  final EdgeInsetsDirectional padding;
  final String? package;

  const PoiContentOfferFallbackImage({
    required this.path,
    required this.colors,
    required this.padding,
    this.package,
  });
}
