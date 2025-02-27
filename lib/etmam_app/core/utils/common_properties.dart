import 'package:balady_plus/app/core/utils/enums/auth_status.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show ApiHeaders;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CityItem;
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:dgis_map/library.dart';


import '../../features/on_boarding_cities/presentation/blocs/city_bloc.dart';
import 'package:uuid/uuid.dart';

class CommonProperties {
  static final Map<String, String> defaultHeaders = {"lang": "ar"};

  static LatLng defaultLocation =
      const LatLng(latitude:24.76836756001484, longitude:46.720988751704304);

  static String? get token => sl<EntryPointCubit>().state.token?.token;
  static String? get profileId => sl<EtmamEntryPointCubit>().state.profile?.id;
  static AuthStatus get authStatus => sl<EntryPointCubit>().state.status;
  static bool get isUserLogged => sl<EntryPointCubit>().state.token != null;
  static String get cityId => sl<CityBloc>().state.selectedItem?.id ?? "";
  static CityItem? get cityItem => sl<CityBloc>().state.selectedItem;

  static String appName = "Balady";
  static String? clientIP;
  static String? appVersion;
  static String? deviceId;
  static String? deviceName;
  static String? deviceOs;
  static String? sessionId;
  static String? fcmToken;

  static Uuid uuidInstance = Uuid();
}
