import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/app_feedback/v2/rating_bar.dart';

@RoutePage()
class ContributePage extends StatefulWidget {
  const ContributePage({super.key});

  @override
  State<ContributePage> createState() => _ContributePageState();
}

class _ContributePageState extends State<ContributePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.colors.backgroundSurface4,
    appBar: BaladyTopBar(
      onLeadingPressed: () => context.router.pop(),
      leading: Semantics(
        label: context.l10n.a11yBack,
        button: true,
        child: ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: Spacing.$4x),
              Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.foregroundDefault),
              const SizedBox(width: Spacing.$4x),
            ],
          ),
        ),
      ),
      title: context.l10n.contributePageTitle,
    ),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
      child: Column(
        children: [
          ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: [
              Padding(
                padding: const EdgeInsets.all(Spacing.$4x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.addPlaceToMap,
                      style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                    ),
                    const SizedBox(height: Spacing.$1_5x),
                    Text(
                      context.l10n.addPlaceToMapDescription,
                      style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                    ),
                    const SizedBox(height: Spacing.$4x),
                    Material(
                      borderRadius: BorderRadius.circular(RadiusBorder.m),
                      color: context.colors.backgroundSurface4,
                      child: Container(
                        height: 70,
                        padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: _FeatureItem(
                                  text: context.l10n.name,
                                  icon: Icon(GeneralIcons.buildings, color: context.colors.foregroundSoft, size: 24),
                                ),
                              ),
                              const VerticalDivider(),
                              Expanded(
                                child: _FeatureItem(
                                  text: context.l10n.address,
                                  icon: Icon(GeneralIcons.location, color: context.colors.foregroundSoft, size: 24),
                                ),
                              ),
                              const VerticalDivider(),
                              Expanded(
                                child: _FeatureItem(
                                  text: context.l10n.photo,
                                  icon: Icon(GeneralIcons.photo, color: context.colors.foregroundSoft, size: 24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.$6x),
                    SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        primaryLabel: context.l10n.addPlaceV2,
                        buttonColorScheme: ButtonColorScheme.accentSecondary,
                        onTap: () {
                          context.router.push(QuickFeedbackRoute());
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.$4x),
          ContentWrapper(
            color: context.colors.backgroundSurface1,
            children: [
              const SizedBox(width: double.infinity),
              Padding(
                padding: const EdgeInsets.all(Spacing.$4x),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.shareFeedback,
                        style: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                      ),
                      const SizedBox(height: Spacing.$1_5x),
                      Text(
                        context.l10n.yourOpinionHelpUsImproveUserExperience,
                        style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                      ),
                      const SizedBox(height: Spacing.$4x),
                      RatingBar(
                        onRatingChanged: (value) {
                          context.router.push(AppFeedbackSheetV2(rating: value));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _FeatureItem extends StatelessWidget {
  final String text;
  final Widget icon;

  const _FeatureItem({required this.text, required this.icon});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(height: Spacing.$0_5x),
        Text(text, style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault)),
      ],
    ),
  );
}
