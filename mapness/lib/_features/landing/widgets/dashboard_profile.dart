import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class DashboardProfile extends ConsumerWidget {
  const DashboardProfile({Key? key}) : super(key: key);

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: userData.maybeWhen(
          orElse: () => Text(
                _greeting(context),
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .accentL
                    .apply(color: const Color(0xff4CA5B4)),
                textAlign: TextAlign.end,
              ),
          data: (userInfo) {
            if (userInfo == null) {
              return Text(
                _greeting(context),
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .accentL
                    .apply(color: const Color(0xff4CA5B4)),
                textAlign: TextAlign.end,
              );
            }

            return Text(
              '${_greeting(context)}, ${userInfo.getFirstName()}',
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .accentL
                  .apply(color: const Color(0xff4CA5B4)),
              textAlign: TextAlign.end,
            );
          }),
    );
  }
}
