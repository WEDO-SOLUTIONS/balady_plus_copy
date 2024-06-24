import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';

class DashboardProfile extends ConsumerWidget {
  const DashboardProfile({super.key});

  String _greeting(BuildContext context) {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return context.l10n.goodMorning;
    } else if (hour < 18) {
      return context.l10n.goodAfternoon;
    } else {
      return context.l10n.goodEvening;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authProvider);
    final lang = ref.watch(appLanguageProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: userData.maybeWhen(
        orElse: () => Text(
          _greeting(context),
          style: context.textStyle.heading1.copyWith(color: context.color.textAndIconsStatusAccent),
          textAlign: TextAlign.end,
        ),
        data: (userInfo) {
          String? name;
          if (userInfo != null) {
            final localizedName = switch (lang) {
              Language.arabic => userInfo.arName,
              _ => userInfo.enName,
            }
                ?.split(' ')
                .first;
            if (localizedName != null && localizedName.isNotEmpty) {
              name = '${_greeting(context)}, $localizedName';
            }
          }
          return Text(
            name ?? _greeting(context),
            style: context.textStyle.heading1.copyWith(color: context.color.textAndIconsStatusAccent),
            textAlign: TextAlign.end,
          );
        },
      ),
    );
  }
}
