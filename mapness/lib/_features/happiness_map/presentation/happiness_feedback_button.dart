import 'package:balady_uikit/core/colors/non_theme_colors.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';
import 'package:mapness/shared/config/package_config.dart';

class HappinesFeedbackButton extends StatelessWidget {
  const HappinesFeedbackButton({
    required this.type,
    required this.state,
    required this.onPressed,
    super.key,
  });
  final HappinessFeedback type;
  final HappinessFeedback? state;
  final void Function(HappinessFeedback) onPressed;

  @override
  Widget build(BuildContext context) {
    final splashColor = switch (type) {
      HappinessFeedback.like => NonThemeColor.color35,
      HappinessFeedback.dislike => NonThemeColor.color36,
    };
    final bgColor = Color(
      switch ((state, type)) {
        (HappinessFeedback.like, HappinessFeedback.like) => 0xFF52B374,
        (HappinessFeedback.dislike, HappinessFeedback.dislike) => 0xFFD14733,
        _ => 0xFFECF6F7,
      },
    );
    final iconAsset = switch (type) {
      HappinessFeedback.like => 'assets/icons/svg/ic_like.svg',
      HappinessFeedback.dislike => 'assets/icons/svg/ic_dislike.svg',
    };

    final iconColor = switch ((state, type)) {
      /// match
      (HappinessFeedback.like, HappinessFeedback.like) ||
      (HappinessFeedback.dislike, HappinessFeedback.dislike) =>
        Colors.white,

      /// not match
      _ => context.color.strokeAccent,
    };

    return Ink(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: bgColor,
      ),
      child: InkWell(
        splashColor: splashColor,
        onTap: () => onPressed(type),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 10),
          child: Center(
            child: SvgPicture.asset(
              iconAsset,
              height: 20,
              width: 20,
              package: PackageConfig.packageName,
              colorFilter: ColorFilter.mode(
                iconColor,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
