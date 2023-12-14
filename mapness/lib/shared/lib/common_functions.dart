import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/routes/signin.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonFunctions {
  static externalLaunch(String url) async {
    final Uri convertUrl = Uri.parse(url);
    if (!await launchUrl(convertUrl, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $convertUrl';
    }
  }

  static launch(String url) async {
    final Uri convertUrl = Uri.parse(url);
    if (!await launchUrl(convertUrl)) throw 'Could not launch $convertUrl';
  }

  static void call(String? number) async {
    if (number != null && number.isNotEmpty) {
      await CommonFunctions.launch("tel://$number");
    }
  }

  static void email(String? mail) async {
    if (mail != null && mail.isNotEmpty) {
      await CommonFunctions.launch("mailto://$mail");
    }
  }

  static void authOrOpen(WidgetRef ref, BuildContext context,
      {VoidCallback? callback}) async {
    bool isAuth = await _isAuth(ref);
    if (!isAuth) {
      // ignore: use_build_context_synchronously
      await const SignInRoute().push(context);
      isAuth = await _isAuth(ref);
    }

    if (isAuth) {
      callback?.call();
    }
  }

  static Future<bool> _isAuth(WidgetRef ref) async {
    final sso = await ref.read(authProvider.future);
    return sso != null;
  }
}
