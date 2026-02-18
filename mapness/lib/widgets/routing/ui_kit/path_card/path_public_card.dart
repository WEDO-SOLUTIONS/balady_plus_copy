import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/pages/routing/route_details_sheet.dart';
import 'package:mapness/pages/routing/ui/models/routing_details_ui_model.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';
import 'package:mapness/widgets/path_nav/lib/utils.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_localization.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/models/path_card_status.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_card_wrapper.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/path_status.dart';
import 'package:mapness/widgets/routing/ui_kit/path_card/tools/public_transport_colors.dart';
import 'package:urbi_utils/urbi_utils.dart';

class PathPublicCard extends ConsumerWidget {
  final BriefPublicTransportModel route;
  final PathCardLocalization localizations;
  final Function()? onStartNavigation;
  final RouteParamsPointWithLabel? destination;
  final RouteParamsPointWithLabel? startPoint;
  final PathCardStatus? additionalInfo;
  final List<BriefPublicTransportModel>? publicTransportRoutes;
  final int activeIndex;
  final ValueChanged<int>? onActiveChanged;
  const PathPublicCard({
    required this.route,
    required this.localizations,
    required this.activeIndex,
    this.onStartNavigation,
    this.destination,
    this.startPoint,
    this.additionalInfo,
    this.publicTransportRoutes,
    this.onActiveChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = route.duration.formatDurationShort(context.l10n);
    final transfers = ArPlurals.transfers(route.transferCount, context.l10n);

    return PathCardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      duration,
                      style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                    ),
                    const SizedBox(height: Spacing.$1x),
                    Row(
                      children: <Widget>[
                        Text(
                          transfers,
                          style: context.textStyles.captionMediumRegular.copyWith(
                            color: context.colors.foregroundDefault,
                          ),
                        ),
                        if (additionalInfo != null) ...[
                          Text(
                            '·',
                            style: context.textStyles.captionMediumRegular.copyWith(
                              color: context.colors.foregroundDefault,
                            ),
                          ),
                          PathBadge(additionalInfo!),
                        ],
                      ].insertBetween(Spacing.$1x.widthBox).toList(),
                    ),
                  ],
                ),
              ),
              AppButton(
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                onTap: onStartNavigation,
                primaryLabel: localizations.go.toUpperCase(),
                innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$5x),
              ),
            ],
          ),
          Spacing.$4x.heightBox,
          if (route.transports.length > 1) ...[
            TransportIconsRow(transports: route.transports, pubs: route.publicTransportTransferRouteLongEntry),
            Spacing.$4x.heightBox,
          ],
          AppButton(
            buttonColorScheme: ButtonColorScheme.accentSecondary,
            buttonType: SaudiNationalDay.isNow() ? ButtonType.primary : ButtonType.secondary,
            innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$5x),
            onTap: () {
              context.router.push(
                RouteDetailsRoute(
                  type: RouteDetailsSheetType.about,
                  destination: destination,
                  startPoint: startPoint,
                  onPressed: () async => onStartNavigation?.call(),
                  onClose: () async => context.router.pop(),
                  buttonLabel: context.l10n.go.toUpperCase(),
                  publicTransportRoutes: publicTransportRoutes ?? [],
                  initialIndex: activeIndex,
                  onActiveChanged: onActiveChanged,
                ),
              );
            },
            primaryLabel: context.l10n.aboutRoute,
          ),
        ],
      ),
    );
  }

  IconData getStepIcon(BuildContext context) {
    if (Directionality.of(context) == TextDirection.ltr) {
      return TransportIcons.pedestrianLTR;
    } else {
      return TransportIcons.pedestrianRTL;
    }
  }
}

class TransportIconsRow extends StatelessWidget {
  final List<Transport> transports;
  final List<PublicTransportTransferRouteLongEntryMessage> pubs;
  final bool isLarge;
  final MainAxisAlignment mainAxisAlignment;

  const TransportIconsRow({
    required this.transports,
    required this.pubs,
    this.isLarge = false,
    this.mainAxisAlignment = MainAxisAlignment.start,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final transportsWithoutTransfers = transports.whereIndexed((index, e) => !isTransfer(pubs, index));
    if (!isLarge && transportsWithoutTransfers.length > 5) {
      return Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          ...transportsWithoutTransfers
              .take(2)
              .map((e) => TransportIconWidget(name: e.names.join(', '), isLarge: isLarge)),
          Row(
            children: [
              Text(
                '...',
                style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.neutralOnContainer),
              ),
              Spacing.$1x.widthBox,
              Icon(SystemIcons.arrowCornerRightSmall, size: 16, color: context.colors.foregroundMuted),
            ],
          ),
          ...transportsWithoutTransfers
              .skip(transportsWithoutTransfers.length - 2)
              .map(
                (e) => TransportIconWidget(
                  name: e.names.join(', '),
                  isLast: e == transportsWithoutTransfers.last,
                  isLarge: isLarge,
                ),
              ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: transports
          .mapIndexed((index, e) {
            final pub = pubs[index];
            final isPedestrian = pub.value.routeParts.isEmpty;
            return TransportIconWidget(
              name: e.names.join(', '),
              time: isPedestrian ? durationByFoot(pub.length.millimeters) : null,
              isLast: e == transports.last,
              isLarge: isLarge,
            );
          })
          .whereIndexed((index, e) => !isTransfer(pubs, index))
          .toList(),
    );
  }
}

class TransportIconWidget extends StatelessWidget {
  final String name;
  final int? time;
  final bool isLast;
  final bool isLarge;

  const TransportIconWidget({required this.name, this.time, this.isLast = false, this.isLarge = false, super.key});

  @override
  Widget build(BuildContext context) {
    final isLTR = Directionality.of(context) == TextDirection.ltr;
    final icon = name.isEmpty
        ? (isLTR ? TransportIcons.pedestrianLTR : TransportIcons.pedestrianRTL)
        : TransportIcons.metroStation;
    return Row(
      children: [
        Icon(icon, size: isLarge ? 24 : 16, color: getMetroLineColor(name, context)),
        if (time != null)
          Text('$time', style: context.textStyles.bodyLargeRegular.copyWith(color: context.colors.neutralOnContainer)),
        if (!isLast)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isLarge ? Spacing.$1_5x : Spacing.$1x),
            child: Icon(SystemIcons.arrowCornerRightSmall, size: 16, color: context.colors.foregroundMuted),
          ),
      ],
    );
  }
}
