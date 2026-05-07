import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_services_enabled_provider.g.dart';

/// Whether the OS currently exposes a usable location signal to the app.
///
/// Returns `false` when either:
///   - location permission is not granted (denied / restricted), or
///   - the device location service is disabled.
///
/// Returns `true` when location permission is granted AND the OS location
/// service is enabled. A `true` result does NOT guarantee a fresh GPS fix;
/// callers that need an actual position must still handle the case of
/// `locationProvider` returning `null`.
///
/// Used by the By Preference / All Offers city resolvers to distinguish
/// "location services disabled" (BRD AC-03) from "permission granted but no
/// fix yet". Source: BRD "Offers Lists Enhancements" (Confluence page
/// 511246338) / Jira BALADY-188.
@riverpod
Future<bool> locationServicesEnabled(Ref ref) async {
  final permissionStatus = await Permission.location.status;
  if (!permissionStatus.isGranted) {
    return false;
  }
  final serviceStatus = await Permission.location.serviceStatus;
  return serviceStatus == ServiceStatus.enabled;
}
