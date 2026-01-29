import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide IconButton;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/saudi_pass/offers_group.dart';
import 'package:mapness/features/saudi_pass/functions/create_amount_or_ratio_text_span.dart';
import 'package:mapness/features/saudi_pass/providers/offer_details_provider.dart';
import 'package:mapness/features/saudi_pass/providers/offer_favorites_provider.dart';
import 'package:mapness/features/saudi_pass/providers/offer_redeem_provider.dart';
import 'package:mapness/features/saudi_pass/providers/send_offer_feedback_provider.dart';
import 'package:mapness/features/saudi_pass/repo/offer_details_body.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_code_sheet.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_favorites_removing_sheet.dart';
import 'package:mapness/features/saudi_pass/widgets/offer_terms_sheet.dart';
import 'package:mapness/features/saudi_pass/widgets/saudi_pass_image.dart';
import 'package:mapness/l10n/generated/app_localizations.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/auth/auth_methods.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/error_widget/base_error_widget.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';

@RoutePage()
class OfferPage extends HookConsumerWidget {
  final String offerId;

  const OfferPage({required this.offerId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final offerProvider = ref.watch(offerDetailsProvider(offerId));

    return Material(
      color: colors.backgroundSurface4,
      child: SafeArea(
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.offer,
            textStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: colors.foregroundDefault),
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
          ),
          body: offerProvider.isLoading
              ? Center(child: Loading.large())
              : offerProvider.hasError
              ? const ErrorWidget()
              : _Content(offerId: offerId),
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Spacer(),
      BaseErrorWidget(
        errorTitle: context.l10n.offerNotAvailable,
        errorLabel: context.l10n.offerNotAvailableDescription,
        withRetryButton: false,
        onRetry: () {},
        backgroundColor: context.colors.backgroundSurface4,
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
            onTap: () => context.router.pop(),
          ),
        ),
      ),
    ],
  );
}

class _Content extends HookConsumerWidget {
  final String offerId;

  const _Content({required this.offerId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final textStyle = context.textStyles;
    final titleStyle = textStyle.captionSmallRegular.copyWith(color: colors.foregroundSoft);
    final subtitleStyle = textStyle.bodySmallRegular.copyWith(color: colors.foregroundDefault);
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
    final duration = offer.briefDurationTo;

    final durationString = switch (duration) {
      null => '',
      final n when n < 1 => '${(duration * 1000).toInt()} ${l10n.meter}',
      final n => '${n.toInt()} ${l10n.km}',
    };

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
                      color: colors.backgroundSurface1,
                      child: Column(
                        children: [
                          if (offerImage != null)
                            _OfferPreviewByBusiness(
                              imageId: offerImage,
                              title: offer.name,
                              discount: discount,
                              offer: offer,
                            ),
                          // todo[amr] they use the image form not logo no I left this because if they decided to return back again
                          // else
                          // _OfferPreviewByGroup(
                          //   offersGroup: offer.offerGroup,
                          //   title: offer.name,
                          //   discount: discount,
                          //   companyLogoId: offer.provider.logo,
                          // ),
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
                                  subtitle: Text('${offer.branchName}, ${offer.city.name}', style: subtitleStyle),
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
                                Spacing.$1_5x.heightBox,
                                _OfferInfoRow(
                                  title: Text(l10n.offerDescription, style: titleStyle),
                                  subtitle: Text(
                                    offer.description.length > 500
                                        ? '${offer.description.substring(0, 500)}...'
                                        : offer.description,
                                    style: subtitleStyle,
                                  ),
                                ),
                                Spacing.$3x.heightBox,
                                GestureDetector(
                                  onTap: () => _showTerms(context, offer.terms),
                                  child: Row(
                                    children: [
                                      Text(
                                        l10n.termAndConditions,
                                        style: textStyle.bodySmallMedium.copyWith(color: colors.accentDefault),
                                      ),
                                      AppIcons(
                                        iconData: SystemIcons.arrowCornerRightSmall,
                                        color: colors.accentDefault,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (showCode.value) _OfferCode(code: offer.code!),
                          Spacing.$3x.heightBox,
                          if (offer.location.longitude != '0.0' && offer.location.latitude != '0.0')
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      primaryIcon: TransportIcons.locationDirectionNavigator,
                                      iconColor: colors.accentSecondaryOnContainer,
                                      primaryLabel: '${l10n.poiCardDirections} $durationString',
                                      color: colors.accentSecondaryContainerDefault,
                                      textColor: colors.accentSecondaryOnContainer,
                                      buttonColorScheme: ButtonColorScheme.accent,
                                      onTap: () => _openNavigationPage(context, l10n, offer),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Spacing.$3x.heightBox,
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
                        buttonColorScheme: ButtonColorScheme.accentSecondary,
                        onTap: () => _useCode(context, ref, offer.id, code, showCode),
                        primaryIcon: SystemIcons.code,
                        primaryLabel: l10n.useCode,
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

  void _openNavigationPage(BuildContext context, AppLocalizations l10n, OfferDetails offer) {
    context.router.push(
      RoutingRoutesRoute(
        points: [
          RouteParamsPointWithLabel(value: null, label: l10n.myLocation),
          RouteParamsPointWithLabel(
            value: RouteParamsPoint(
              latitude: double.parse(offer.location.latitude),
              longitude: double.parse(offer.location.longitude),
            ),
            label: offer.name,
          ),
        ],
      ),
    );
  }

  String _getByDate(OfferDetails offer, BuildContext context) {
    final value = offer.byDate(Localizations.localeOf(context).languageCode);
    return '${context.l10n.saudiPassOfferBy} $value';
  }

  TextSpan? _getDiscount(OfferDetails offer, Language language, BuildContext context) {
    final locale = Localizations.localeOf(context);

    return createAmountOrRatioTextSpan(
      language: language,
      locale: locale,
      amount: offer.typeDetails?.amount,
      ratio: offer.typeDetails?.ratio,
      iconSize: 22,
    );
  }

  Future<void> _showTerms(BuildContext context, String terms) async {
    await showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => OfferTermsSheet(
        terms: terms,
        title: context.l10n.termAndConditions,
        close: context.l10n.saudiPassTermAndConditionsClose,
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
    await ref
        .read(authMethodsProvider.notifier)
        .authOrOpen(
          context,
          callback: () async {
            final redeemProvider = ref.watch(offerRedeemProvider(offerId).notifier);
            unawaited(redeemProvider.send());

            final redeemed = await showDialog(
              context: context,
              useSafeArea: false,
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

  void _showFeedback({required String offerId, required BuildContext context, required int rating}) {
    context.router.push(AppFeedbackSheet(initialRating: rating, source: FeedbackSource.offer(offerId)));
  }
}

void changeFavorite(BuildContext context, WidgetRef ref, bool favorite, String offerId) {
  ref
      .read(authMethodsProvider.notifier)
      .authOrOpen(
        context,
        callback: () {
          favorite
              ? ref.read(offerFavoritesProvider(offerId).notifier).addToFavorites()
              : _showFavoritesRemovingDialog(context, ref, offerId);
        },
      );
}

Future<void> _showFavoritesRemovingDialog(BuildContext context, WidgetRef ref, String offerId) async {
  await showDialog(
    context: context,
    useSafeArea: false,
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
  final String title;
  final TextSpan? discount;
  final String? companyLogoId;

  const _OfferPreviewByGroup({required this.offersGroup, required this.title, this.discount, this.companyLogoId});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = discount != null;
    return SizedBox(
      width: double.infinity,
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
                  child: Image.asset(offersGroup.imagePath, fit: BoxFit.contain),
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
                        Text(
                          title.length > 250 ? '${title.substring(0, 250)}...' : title,
                          style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.staticWhite),
                        ),
                        if (hasDiscount)
                          Padding(
                            padding: const EdgeInsets.only(top: Spacing.$3x),
                            child: Text.rich(
                              discount!,
                              maxLines: 1,
                              style: context.textStyles.h1SemiBold.copyWith(color: context.colors.staticWhite),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  if (companyLogoId != null)
                    Expanded(
                      child: SizedBox(
                        height: 100,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.m)),
                          child: SaudiPassImage(imageId: companyLogoId!),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 78),
                ],
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
  final String title;
  final TextSpan? discount;
  final OfferDetails offer;

  const _OfferPreviewByBusiness({required this.imageId, required this.title, required this.offer, this.discount});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = discount != null;
    String? path;
    List<Color>? gradientColors;
    try {
      path = offer.offerGroup.imagePath;
      gradientColors = offer.offerGroup.color;
    } catch (ex) {}

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? OffersGroup.others.color,
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
        ),
        image: path != null
            ? DecorationImage(
                alignment: AlignmentDirectional.centerEnd,
                matchTextDirection: true,
                image: AssetImage(offer.offerGroup.imagePath),
                fit: BoxFit.contain,
              )
            : null,
      ),
      padding: const EdgeInsets.all(Spacing.$4x),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.length > 250 ? '${title.substring(0, 250)}...' : title,
                  style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.staticWhite),
                ),
                if (hasDiscount)
                  Padding(
                    padding: const EdgeInsets.only(top: Spacing.$3x),
                    child: Text.rich(
                      discount!,
                      maxLines: 1,
                      style: context.textStyleV3.h1SemiBold.copyWith(color: context.colorsV3.staticWhite),
                    ),
                  ),
              ],
            ),
          ),
          Spacing.$3x.widthBox,
          Expanded(
            child: SizedBox(
              height: 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.m)),
                child: imageId != null ? SaudiPassImage(imageId: imageId!) : const SizedBox.shrink(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCode extends StatelessWidget {
  final String code;

  const _OfferCode({required this.code, Key? key}) : super(key: key);

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
          Text(code, style: context.textStyleV3.h3SemiBold.copyWith(color: context.colorsV3.neutralOnContainer)),
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
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, Spacing.$0_5x.heightBox, subtitle]);
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
            ref.read(authMethodsProvider.notifier).authOrOpen(context, callback: () => onRatingChanged(rating));
          },
        ),
        Spacing.$1_5x.heightBox,
        Text(
          context.l10n.doYouLikeOffer,
          textAlign: TextAlign.center,
          style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV2.foregroundSoft),
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
          buttonColorScheme: ButtonColorScheme.neutral,
          buttonType: ButtonType.secondary,
          onTap: () => changeFavorite(favorite: true),
          primaryIcon: GeneralIcons.heart,
        )
      : AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          buttonType: ButtonType.secondary,
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
    decoration: BoxDecoration(color: context.colors.backgroundSurface4),
    padding: const EdgeInsets.only(left: Spacing.$4x, top: Spacing.$3x, right: Spacing.$4x, bottom: Spacing.$4x),
    child: child,
  );
}
