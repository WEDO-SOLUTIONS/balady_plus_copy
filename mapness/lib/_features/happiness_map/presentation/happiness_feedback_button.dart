import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/_features/happiness_map/domain/happiness_feedback.dart';

class HappinesFeedbackButton extends StatelessWidget {
  final HappinessFeedback type;
  final HappinessFeedback? state;
  final void Function(HappinessFeedback) onPressed;

  const HappinesFeedbackButton({
    super.key,
    required this.type,
    required this.state,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final splashColor = switch (type) {
      HappinessFeedback.like => const Color(0xff1DB93C),
      HappinessFeedback.dislike => const Color(0xffff4d4d),
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
      _ => const Color(0xFF4CA5B4),
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
