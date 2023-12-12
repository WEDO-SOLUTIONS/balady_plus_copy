import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/app/routes/happines_map.dart';
import 'package:mapness/app/routes/signin.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class HappinesControl extends ConsumerWidget {
  const HappinesControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MapButton(
      onTap: () => _openHappiness(context, ref),
      child: SvgPicture.asset(
        "assets/icons/svg/ic_like.svg",
        package: PackageConfig.packageName,
        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
      ),
    );
  }

  Future<bool> _isAuth(WidgetRef ref) async {
    final sso = await ref.read(authProvider.future);
    return sso != null;
  }

  Future<void> _openHappiness(BuildContext context, WidgetRef ref) async {
    if (!await _isAuth(ref)) {
      await const SignInRoute().push(context);
    }

    if (await _isAuth(ref)) {
      const HappinessMapRoute(bottomSheetOpened: false).push(context);
    }
  }
}
