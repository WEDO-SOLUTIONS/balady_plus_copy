import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

/// Opens the Balady+ host login screen (same flow as the app's Profile tab).
///
/// TIFO doesn't own authentication — the host shell does (`EntryPointCubit`
/// via GetIt, exactly how `token_provider` reads the SSO token). Once the
/// user signs in, `tokenProvider` picks the new token up automatically and
/// the next TIFO request runs as the signed-in user.
Future<void> openHostLogin() async {
  try {
    await sl<EntryPointCubit>().onLogin(isMunicipality: false);
  } catch (e) {
    logger.log('[tifo] openHostLogin failed: $e');
  }
}
