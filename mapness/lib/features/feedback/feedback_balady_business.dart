import 'package:mapness/shared/providers/dgis_environment.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'feedback_balady_business.g.dart';

@riverpod
class FeedbackBaladyBusiness extends _$FeedbackBaladyBusiness {
  @override
  Future<String> build() async {
    final env = await ref.read(dgisEnvironmentProvider.future);

    return env.baladyBusinessUrl;
  }

  Future<void> openBaladyBusiness() async {
    final url = state.valueOrNull;
    if (url != null) {
      final uri = Uri.parse(url);
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      } catch (e, stackTrace) {
        logger.log('Failed to open Balady Business ${e.toString()}, ${stackTrace.toString()}');
      }
    }
  }
}
