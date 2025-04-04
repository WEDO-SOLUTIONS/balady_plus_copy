import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class OffersBadge extends StatelessWidget {
  const OffersBadge({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaladyBadge.secondary(
      context.l10n.offers,
      badgeType: BadgeType.warning,
      iconPosition: BadgeIconPosition.start,
      icon: GeneralIcons.home,
    );
}
