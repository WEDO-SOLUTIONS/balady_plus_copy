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
}
