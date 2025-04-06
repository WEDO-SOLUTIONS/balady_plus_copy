import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/providers/offer_details_provider.dart';
import 'package:mapness/features/saudi_pass/providers/offer_favorites_provider.dart';
import 'package:mapness/features/saudi_pass/providers/offer_redeem_provider.dart';
import 'package:mapness/features/saudi_pass/providers/send_offer_feedback_provider.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_code_sheet.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_favorites_removing_sheet.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_terms_sheet.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_image.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';

@RoutePage()
class OfferPage extends HookConsumerWidget {
  final String offerId;

  const OfferPage({
    required this.offerId,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorsV3;
    final offerProvider = ref.watch(offerDetailsProvider(offerId));

    return Material(
      color: colors.backgroundSurface4,
      child: SafeArea(
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.offer,
            textStyle: context.textStyleV3.bodyLargeSemiBold.copyWith(
              color: colors.foregroundDefault,
            ),
            leading: ActionModel(
              onPressed: () => context.router.popForced(),
              icon: SystemIcons.arrowCornerLeftLarge,
            ),
          ),
          body: offerProvider.isLoading
              ? Center(child: Loading.large())
              : offerProvider.hasError
                  ? const _ErrorWidget()
                  : _Content(offerId: offerId),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const Spacer(),
          BaseErrorWidget(
            errorTitle: context.l10n.offerNotAvailable,
            errorLabel: context.l10n.offerNotAvailableDescription,
            withRetryButton: false,
            onRetry: () {},
            backgroundColor: context.colorsV3.backgroundSurface4,
          ),
          const Spacer(),
          const SizedBox(height: 96),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.$4x),
              child: AppButton(
                buttonColorScheme: ButtonColorScheme.primary,
                primaryLabel: context.l10n.goBack,
                onTap: () => context.router.popForced(),
              ),
            ),
          )
        ],
      );
}

class _Content extends HookConsumerWidget {
  final String offerId;

  const _Content({required this.offerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colorsV3;
    final titleStyle = context.textStyleV3.captionSmallRegular.copyWith(color: context.colorsV3.foregroundSoft);
    final subtitleStyle = context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundDefault);
    final l10n = context.l10n;

    final offerProvider = ref.watch(offerDetailsProvider(offerId));
    final language = ref.watch(appLanguageProvider);

    if (!offerProvider.hasValue) {
      return const SizedBox.shrink();
    }

    final offer = offerProvider.requireValue;
    final redeemed = offer.redeemed;
    final code = offer.code;
    final offerImage = offer.images.firstOrNull;
    final showCode = useState(code != null && redeemed);
    final discount = _getDiscount(offer, language, context);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.xl)),
                    child: ColoredBox(
                      color: context.colorsV3.backgroundSurface1,
                      child: Column(
                        children: [
                          if (offerImage != null)
                            _OfferPreviewByBusiness(
                              imageId: offerImage,
                              description: offer.description,
                              discount: discount,
                            )
                          else
                            _OfferPreviewByGroup(
                              offersGroup: offer.offerGroup,
                              description: offer.description,
                              discount: discount,
                              companyLogoId: offer.provider.logo,
                            ),
                          Padding(
                            padding: const EdgeInsets.only(left: Spacing.$4x, top: Spacing.$4x, right: Spacing.$4x),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _OfferInfoRow(
                                  title: Text(l10n.brand, style: titleStyle),
                                  subtitle: Text(offer.provider.name, style: subtitleStyle),
                                ),
                                Spacing.$1_5x.heightBox,
                                _OfferInfoRow(
                                  title: Text(l10n.location, style: titleStyle),
                                  subtitle: Text(
                                    '${offer.branchName}, ${offer.city.name}',
                                    style: subtitleStyle,
                                  ),
                                ),
                                Spacing.$1_5x.heightBox,
                                _OfferInfoRow(
                                  title: Text(l10n.periodOfValidity, style: titleStyle),
                                  subtitle: Text(
                                    _getByDate(offer, context),
                                    style: offer.willExpiredSoon
                                        ? subtitleStyle.copyWith(color: colors.errorDefault)
                                        : subtitleStyle,
                                  ),
                                ),
                                Spacing.$3x.heightBox,
                                GestureDetector(
                                  onTap: () => _showTerms(context, offer.terms),
                                  child: Row(
                                    children: [
                                      Text(
                                        l10n.termAndConditions,
                                        style:
                                            context.textStyleV3.bodySmallMedium.copyWith(color: colors.accentDefault),
                                      ),
                                      AppIcons(
                                        iconData: SystemIcons.arrowCornerRightSmall,
                                        color: colors.accentDefault,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (showCode.value) _OfferCode(code: offer.code!),
                          Spacing.$4x.heightBox,
                        ],
                      ),
                    ),
                  ),
                  Spacing.$6x.heightBox,
                  _OfferFeedback(
                    offerId: offerId,
                    onRatingChanged: (rating) => _showFeedback(offerId: offerId, context: context, rating: rating),
                  ),
                  Spacing.$4x.heightBox,
                ],
              ),
            ),
          ),
        ),
        _ButtonContainer(
          child: !redeemed && code != null
              ? Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        buttonColorScheme: ButtonColorScheme.primary,
                        onTap: () => _useCode(context, ref, offer.id, code, showCode),
                        primaryIcon: SystemIcons.code,
                        primaryLabel: context.l10n.useCode,
                      ),
                    ),
                    Spacing.$2x.widthBox,
                    _FavoriteIconButton(
                      offer: offer,
                      changeFavorite: ({required favorite}) => changeFavorite(context, ref, favorite, offerId),
                    ),
                  ],
                )
              : _FavoriteButton(
                  offer: offer,
                  changeFavorite: ({required favorite}) => changeFavorite(context, ref, favorite, offerId),
                ),
        ),
      ],
    );
  }

  String _getByDate(OfferDetails offer, BuildContext context) {
    final value = offer.byDate(Localizations.localeOf(context).languageCode);
    return '${context.l10n.saudiPassOfferBy} $value';
  }

  // TODO: move to offer ext / utils
  String? _getDiscount(OfferDetails offer, Language language, BuildContext context) {
    final currencySymbol = switch (language) {
      Language.english => 'SAR',
      Language.arabic => 'ر.س',
    };
    final locale = Localizations.localeOf(context);

    final currencyFormatter = NumberFormat.currency(locale: 'ar_SA', symbol: currencySymbol, decimalDigits: 0);
    final percentFormatter = NumberFormat.decimalPercentPattern(locale: locale.languageCode);

    if (offer.typeDetails.amount != null) {
      return currencyFormatter.format(offer.typeDetails.amount);
    }

    final ratio = offer.typeDetails.ratio;
    if (ratio == null) {
      return null;
    }

    if (offer.typeDetails.ratio != null) {
      return percentFormatter.format(ratio / 100);
    }

    return null;
  }

  Future<void> _showTerms(BuildContext context, String terms) async {
    await showDialog(
      context: context,
      builder: (_) => OfferTermsSheet(
        terms: terms,
        title: context.l10n.termAndConditions,
        close: context.l10n.feedbackBreaksSheetClose,
      ),
    );
  }

  Future<void> _useCode(
    BuildContext context,
    WidgetRef ref,
    String offerId,
    String code,
    ValueNotifier showCode,
  ) async {
    await ref.read(authMethodsProvider.notifier).authOrOpen(
      context,
      callback: () async {
        final redeemProvider = ref.watch(offerRedeemProvider(offerId).notifier);
        unawaited(redeemProvider.send());

        final redeemed = await showDialog(
          context: context,
          builder: (_) => OfferCodeSheet(
            code: code,
            offerId: offerId,
            title: context.l10n.useCode,
            description: context.l10n.showCodeToSeller,
          ),
        );

        if (redeemed == true) {
          final rating = ref.read(sendOfferFeedbackProvider(offerId));
          if (rating == 0) {
            _showFeedback(rating: rating, offerId: offerId, context: context);
          }
          showCode.value = redeemed;
        }
      },
    );
  }

  void _showFeedback({
    required String offerId,
    required BuildContext context,
    required int rating,
  }) {
    context.router.push(AppFeedbackSheet(initialRating: rating, source: FeedbackSource.offer(offerId)));
  }
}

void changeFavorite(BuildContext context, WidgetRef ref, bool favorite, String offerId) {
  ref.read(authMethodsProvider.notifier).authOrOpen(context, callback: () {
    favorite
        ? ref.read(offerFavoritesProvider(offerId).notifier).addToFavorites()
        : _showFavoritesRemovingDialog(context, ref, offerId);
  });
}

Future<void> _showFavoritesRemovingDialog(BuildContext context, WidgetRef ref, String offerId) async {
  await showDialog(
    context: context,
    builder: (_) => OfferFavoritesRemovingSheet(
      title: context.l10n.removeFromFavorites,
      description: context.l10n.removeFromFavoritesDescription,
      cancel: context.l10n.cancel,
      remove: context.l10n.remove,
      onRemove: () {
        ref.read(offerFavoritesProvider(offerId).notifier).removeFromFavorites();
      },
    ),
  );
}

class _OfferPreviewByGroup extends StatelessWidget {
  final OffersGroup offersGroup;
  final String description;
  final String? discount;
  final String? companyLogoId;

  const _OfferPreviewByGroup({
    required this.offersGroup,
    required this.description,
    this.discount,
    this.companyLogoId,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = discount != null;
    return SizedBox(
      width: double.infinity,
      height: 141,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: offersGroup.color,
            begin: context.isLTR ? Alignment.topLeft : Alignment.topRight,
            end: context.isLTR ? Alignment.bottomRight : Alignment.bottomLeft,
          ),
        ),
        child: Stack(
          children: [
            Positioned.directional(
              textDirection: Directionality.of(context),
              bottom: 0,
              end: 0,
              child: SizedBox(
                height: 141,
                child: Transform(
                  alignment: Alignment.center,
                  transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                  child: Image.asset(
                    offersGroup.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.$4x),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: hasDiscount ? 4 : 6,
                            style:
                                context.textStyleV3.captionLargeRegular.copyWith(color: context.colorsV3.staticWhite),
                          ),
                        ),
                        if (hasDiscount)
                          Padding(
                            padding: const EdgeInsets.only(top: Spacing.$3x),
                            child: Text(
                              discount!,
                              maxLines: 1,
                              style: context.textStyleV3.h1SemiBold.copyWith(color: context.colorsV3.staticWhite),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 98),
                ],
              ),
            ),
            if (companyLogoId != null)
              Positioned.directional(
                textDirection: Directionality.of(context),
                top: Spacing.$4x,
                end: Spacing.$4x,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.m)),
                  child: SizedBox(
                    width: 48,
                    height: 48,
                    child: SaudiPassImage(imageId: companyLogoId!),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _OfferPreviewByBusiness extends StatelessWidget {
  final String? imageId;
  final String description;
  final String? discount;

  const _OfferPreviewByBusiness({
    required this.imageId,
    required this.description,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = discount != null;
    return Container(
      height: 141,
      color: context.colorsV3.staticDarkblue,
      padding: const EdgeInsets.all(Spacing.$4x),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: hasDiscount ? 4 : 6,
                    style: context.textStyleV3.captionLargeRegular.copyWith(color: context.colorsV3.staticWhite),
                  ),
                ),
                if (hasDiscount)
                  Padding(
                    padding: const EdgeInsets.only(top: Spacing.$3x),
                    child: Text(
                      discount!,
                      maxLines: 1,
                      style: context.textStyleV3.h1SemiBold.copyWith(color: context.colorsV3.staticWhite),
                    ),
                  ),
              ],
            ),
          ),
          Spacing.$3x.widthBox,
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.l)),
            child: SizedBox(
              width: 103,
              height: 109,
              child: imageId != null ? SaudiPassImage(imageId: imageId!) : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCode extends StatelessWidget {
  final String code;

  const _OfferCode({
    required this.code,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: Spacing.$4x, top: Spacing.$4x, right: Spacing.$4x),
        child: Container(
          decoration: BoxDecoration(
            color: context.colorsV3.neutralContainerDefault,
            borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.l)),
          ),
          height: 69,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                code,
                style: context.textStyleV3.h3SemiBold.copyWith(color: context.colorsV3.neutralOnContainer),
              ),
              Spacing.$0_5x.heightBox,
              Text(
                context.l10n.codeWasUsed,
                style: context.textStyleV3.captionSmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
              ),
            ],
          ),
        ),
      );
}

class _OfferInfoRow extends StatelessWidget {
  final Widget title;
  final Widget subtitle;

  const _OfferInfoRow({required this.title, required this.subtitle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          Spacing.$0_5x.heightBox,
          subtitle,
        ],
      );
}

class _OfferFeedback extends ConsumerWidget {
  final String offerId;
  final ValueChanged<int> onRatingChanged;

  const _OfferFeedback({required this.offerId, required this.onRatingChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offerFeedback = ref.watch(sendOfferFeedbackProvider(offerId));

    return Column(
      children: [
        RatingBar(
          rating: offerFeedback,
          onRatingChanged: (rating) {
            ref.read(authMethodsProvider.notifier).authOrOpen(
                  context,
                  callback: () => onRatingChanged(rating),
                );
          },
        ),
        Spacing.$1_5x.heightBox,
        Text(
          context.l10n.doYouLikeOffer,
          textAlign: TextAlign.center,
          style: context.textStyleV3.bodySmallRegular.copyWith(
            color: context.colorsV2.foregroundSoft,
          ),
        ),
      ],
    );
  }
}

class _FavoriteIconButton extends StatelessWidget {
  final OfferDetails offer;
  final void Function({required bool favorite}) changeFavorite;

  const _FavoriteIconButton({required this.offer, required this.changeFavorite});

  @override
  Widget build(BuildContext context) => !offer.favorite
      ? AppButton(
          buttonColorScheme: ButtonColorScheme.secondary,
          onTap: () => changeFavorite(favorite: true),
          primaryIcon: GeneralIcons.heart,
        )
      : AppButton(
          buttonColorScheme: ButtonColorScheme.secondary,
          onTap: () => changeFavorite(favorite: false),
          primaryIcon: GeneralIcons.filledHeart,
        );
}

class _FavoriteButton extends StatelessWidget {
  final OfferDetails offer;
  final void Function({required bool favorite}) changeFavorite;

  const _FavoriteButton({required this.offer, required this.changeFavorite});

  @override
  Widget build(BuildContext context) => !offer.favorite
      ? AppButton(
          buttonColorScheme: ButtonColorScheme.primary,
          onTap: () => changeFavorite(favorite: true),
          primaryIcon: GeneralIcons.heart,
          primaryLabel: context.l10n.addToFavorites,
        )
      : AppButton(
          buttonColorScheme: ButtonColorScheme.secondary,
          onTap: () => changeFavorite(favorite: false),
          primaryLabel: context.l10n.removeFromFavorites,
        );
}

class _ButtonContainer extends StatelessWidget {
  final Widget child;

  const _ButtonContainer({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        decoration: BoxDecoration(color: context.colorsV3.backgroundSurface4),
        padding: const EdgeInsets.only(left: Spacing.$4x, top: Spacing.$3x, right: Spacing.$4x, bottom: Spacing.$4x),
        child: child,
      );
}
