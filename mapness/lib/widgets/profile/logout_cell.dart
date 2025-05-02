import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class LogoutCell extends ConsumerWidget {
  const LogoutCell({
    super.key,
    this.onTap,
  });
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                top: 12,
                bottom: 14,
                right: 16,
              ),
              child: Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      context.l10n.logOut,
                      style: context.textStyle.text.copyWith(color: context.color.textAndIconsBasePrimary),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SvgPicture.asset(
                    Assets.icons.svg.icProfileLogout.keyName,
                    height: 24,
                    width: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
