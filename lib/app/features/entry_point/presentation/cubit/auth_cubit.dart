//import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
//   show showUpdateAppPopUpWidget;
import 'package:balady_plus/app/features/entry_point/domain/use_cases/get_test_data.dart';
import 'package:balady_plus/app/features/profile_features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../etmam_app/features/etmam_entry_point/presentation/cubit/etmam_entry_point_cubit.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/services/services_exports.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../profile_features/delegators/delegators_exports.dart';
import '../../data/models/get_permission_params_model.dart';
import '../../domain/use_cases/get_ekram_permission.dart';
import '../../entry_point_exports.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

import 'package:balady_authorization/src/authentication/models/login_data_model.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_authorization/src/utils/injection/injection_container.dart';

part 'auth_state.dart';

class EntryPointCubit extends Cubit<EntryPointState> {
  final GetToken _getToken;
  final SaveAuth _saveAuth;
  final CheckAuth _checkAuth;
  final RefreshToken _refreshToken;
  final GetProfile _getProfile;
  final SaveSSOProfile _saveSSOProfile;
  final CheckSSOProfile _checkSSOProfile;
  final GetCookie _getCookie;
  final GetAPIgeeToken _getAPIgeeToken;

  // final ClearAuth _clearAuth;
  final Logout _logout;
  final GetForceVersion _getForceVersion;
  final GetTestData _getTestData;
  final GetGISData _getGisData;
  final GetEkramPermission _getEkramPermission;
  final GetPaymentUrl _getPaymentUrl;

  EntryPointCubit(
      {required GetToken getToken,
      required SaveAuth saveAuth,
      required CheckAuth checkAuth,
      required RefreshToken refreshToken,
      required GetProfile getProfile,
      required SaveSSOProfile saveSSOProfile,
      required CheckSSOProfile checkSSOProfile,
      required GetCookie getCookie,
      // required ClearAuth clearAuth,
      required Logout logout,
      required GetAPIgeeToken getAPIgeeToken,
      required GetForceVersion forceVersion,
      required GetGISData getGisData})
      : _getToken = getToken,
        _saveAuth = saveAuth,
        _checkAuth = checkAuth,
        _refreshToken = refreshToken,
        _getProfile = getProfile,
        _saveSSOProfile = saveSSOProfile,
        _checkSSOProfile = checkSSOProfile,
        _getCookie = getCookie,
        _getAPIgeeToken = getAPIgeeToken,
        // _clearAuth = clearAuth,
        _logout = logout,
        _getPaymentUrl = GetPaymentUrl(repository: sl()),
        _getForceVersion = forceVersion,
        _getTestData = GetTestData(repository: sl()),
        _getEkramPermission = GetEkramPermission(repository: sl()),
        _getGisData = getGisData,
        super(const EntryPointState());

  void hideSplash() {
    emit(
      state.copyWith(showSplash: false),
    );
  }

  Future<void> onLoadingApp() async {
    emit(state.copyWith(status: AuthStatus.loading));
    sl<LocationCubit>().getLocationInit();
    final failureOrSuccess = await _checkAuth(NoParams());
    await failureOrSuccess.fold((failure) {
      emit(state.copyWith(
        status: AuthStatus.failure,
      ));
    }, (token) async {
      final failureOrSuccess = await _checkSSOProfile(NoParams());
      failureOrSuccess.fold((failure) {}, (profile) {
        emit(state.copyWith(
          status: AuthStatus.notAuthenticated,
          token: token,
          userInfo: profile,
          errorMessage: "",
        ));
        FlutterUxcam.setUserIdentity(profile.idNo);
        FlutterUxcam.setUserProperty("name", profile.arName ?? "");
      });
      //MM sl<EtmamEntryPointCubit>().onLoadingApp();

      //  if (token.refreshToken != null) await refreshToken(token.refreshToken!);
      if (sharedPrefs.getFirstDateTime() == null) {
        sharedPrefs.setFirstDateTime();
      }
      refreshSSOProfile();
      getEkramPermissions();
    });
    refreshAPIGeeToken();
  }

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<bool> onLogin({
    bool isFromEtmam = false,
  }) async {
    try {
      slAuthentication<AuthenticationBloc>().add(GoLoginScreenAuthentication());
    } catch (e) {
      print("object");
    }
    return false;
  }

  ////////////////////////////////////////////////////////////////////////
  Future<bool> onLoginV2({
    required LoginDataModel? data,
    bool isFromEtmam = false,
  }) async {
    EasyLoading.show();
    emit(state.copyWith(
      status: AuthStatus.loading,
    ));
    late SSOToken token;

    if (data != null) {
      token = SSOToken(
        token: data.accessToken,
        refreshToken: data.refreshToken,
        idToken: "",
        expirationTime: data.expiresIn.toString(),
      );
    } else {
      final failureOrSuccessForToken = await _getToken(NoParams());
      await failureOrSuccessForToken.fold((failure) {
        emit(state.copyWith(
          status: AuthStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ));
      }, (success) async {
        token = SSOToken(
          token: success.accessToken,
          refreshToken: success.refreshToken,
          idToken: success.idToken,
          expirationTime: success.accessTokenExpirationDateTime.toString(),
        );
      });
    }

    _saveDataLogin(token: token, isFromEtmam: isFromEtmam);

    if (CommonProperties.fcmToken != null &&
        CommonProperties.fcmToken!.isNotEmpty) {
      CommonFunctions.updateNotificationSettings(CommonProperties.fcmToken!);
    }

    EasyLoading.dismiss();
    return CommonProperties.isLoggedIn;
  }

  ////////////////////////////////////////////////////////////////////////
  Future<void> onLoginNfaaz({
    bool isFromEtmam = false,
  }) async {
    EasyLoading.show();
    emit(state.copyWith(
      status: AuthStatus.loading,
    ));
    final failureOrSuccessForToken = await _getToken(NoParams());
    await failureOrSuccessForToken.fold((failure) {
      emit(
        state.copyWith(
          status: AuthStatus.failure,
          errorMessage: (failure as ServerFailure).errorMessage,
        ),
      );
      EasyLoading.dismiss();
      return;
    }, (success) async {
      try {
        EasyLoading.dismiss();
        sl<AuthenticationBloc>().add(
          LoginWithNafazAuthentication(
            dataLogin: {
              "access_token": success.accessToken,
              "expires_in": success.accessTokenExpirationDateTime != null
                  ? DateTime.now()
                      .difference(success.accessTokenExpirationDateTime!)
                      .inSeconds
                  : 3500000,
              "token_type": success.tokenType,
              "refresh_token": success.refreshToken,
              "scope": success.scopes ?? "",
            },
          ),
        );
      } catch (e) {
        EasyLoading.dismiss();
        print("object");
      }
    });
    return;
  }

  ////////////////////////////////////////////////////////////////////////

  Future<void> refreshToken(String refreshToken) async {
    SSOToken? token = state.token;

    if (token != null && token.token != null && token.token!.isNotEmpty) {
      final failureOrSuccess = await _refreshToken(refreshToken);

      return await failureOrSuccess.fold((failure) async {
        await autoLogout();
      }, (success) async {
        SSOToken token = SSOToken(
            token: success.accessToken,
            refreshToken: success.refreshToken,
            idToken: success.idToken,
            expirationTime: success.accessTokenExpirationDateTime.toString());
        final failureOrSuccess = await _saveAuth(token);
        failureOrSuccess.fold((f) {
          emit(state.copyWith(
            status: AuthStatus.notAuthenticated,
            errorMessage: ("errors_server_error_1".tr()),
          ));
          return false;
        }, (s) {
          emit(state.copyWith(
            status: AuthStatus.notAuthenticated,
            token: token,
            errorMessage: "",
          ));

          if (CommonProperties.fcmToken != null &&
              CommonProperties.fcmToken!.isNotEmpty) {
            CommonFunctions.updateNotificationSettings(
                CommonProperties.fcmToken!);
          }
          return true;
        });
      });
    } else {
      await autoLogout();
    }
  }

  Future<bool> refreshAPIGeeToken() async {
    DateTime? expireTime =
        DateTime.tryParse(state.apigeeToken?.expirationTime ?? "");

    if (expireTime == null ||
        (expireTime.difference(DateTime.now()).inHours <= 2)) {
      final failureOrSuccess = await _getAPIgeeToken(NoParams());
      return await failureOrSuccess.fold((failure) {
        return false;
      }, (success) async {
        success.expirationTime = success.getExpireTime().toString();
        emit(state.copyWith(apigeeToken: success));
        return true;
      });
    }
    return true;
  }

  Future<void> checkifTokenExpired() async {
    if (state.status == AuthStatus.notAuthenticated) {
      DateTime? expireTime =
          DateTime.tryParse(state.token?.expirationTime ?? "");

      if (expireTime != null) {
        if (!DateTime.now()
            .add(const Duration(minutes: 15))
            .isBefore(expireTime)) {
          if (state.token?.refreshToken != null) {
            return await refreshToken(state.token!.refreshToken!);
          }
        }
      }
    }

    return Future.value(false);
  }

  Future<void> clearAuth() async {
    try {
      sl<AuthenticationBloc>().add(LogoutAuthentication());
    } catch (e) {
      print("object");
    }
    await _logout(NoParams());
    sl<DelegatorsCubit>().clearDelegators();
    // final failureOrSuccess = await _clearAuth(NoParams());

    // await failureOrSuccess.fold((l) {
      sharedPrefs.setSSOToken(null);
      clearSSOInfo();
      emit(const EntryPointState(
        status: AuthStatus.notAuthenticated,
        showSplash: false,
      ));
    // }, (r) {
    //   sharedPrefs.setSSOToken(null);
    //   //MM sharedPrefs.setUserProfile(null);
    //   clearSSOInfo();
    //   emit(const EntryPointState(
    //     status: AuthStatus.notAuthenticated,
    //     showSplash: false,
    //   ));
    // });

    if (CommonProperties.fcmToken != null &&
        CommonProperties.fcmToken!.isNotEmpty) {
      CommonFunctions.updateNotificationSettings(CommonProperties.fcmToken!);
    }
  }

  Future<void> autoLogout() async {
    sharedPrefs.setSSOToken(null);
    sl<DelegatorsCubit>().clearDelegators();
    try {
      sl<AuthenticationBloc>().add(LogoutAuthentication());
    } catch (e) {
      print("object");
    }
    //MM sharedPrefs.setUserProfile(null);
    sharedPrefs.setSSOUserProfile(null);
    clearSSOInfo();
    emit(const EntryPointState(
      status: AuthStatus.notAuthenticated,
    ));

    _logout(NoParams());
    //MM  sl<VDCategoryBloc>().add(RefreshCategoriesEvent());

    // Fix White screen on startup
    // Helpers.backToHome();

    if (CommonProperties.fcmToken != null &&
        CommonProperties.fcmToken!.isNotEmpty) {
      CommonFunctions.updateNotificationSettings(CommonProperties.fcmToken!);
    }
    CommonFunctions.showError("session_ended_error".tr());
  }

  Future<void> refreshSSOProfile() async {
    try {
      final failureOrSuccessForProfile = await _getProfile(NoParams());
      await failureOrSuccessForProfile.fold((failure) async {},
          (success) async {
        final failureOrSuccess = await _saveSSOProfile(success);
        if (failureOrSuccess.isRight()) {
          emit(state.copyWith(
            userInfo: success,
          ));
        }
      });
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
  }

  Future<void> checkVersion() async {
    await Future.delayed(const Duration(seconds: 7));
    final failureOrSuccessForProfile = await _getForceVersion(NoParams());
    await failureOrSuccessForProfile.fold((failure) async {}, (success) async {
      //  if (success)
      //   showUpdateAppPopUpWidget(
      //      NavigationService.navigatorKey.currentContext!);
    });
  }

  void clearSSOInfo() async {
    //MM sharedPrefs.storeINCReportsNumbers(null);
    sharedPrefs.setAppCookie(null);
    sharedPrefs.setLicenseClientImage(null);
    sharedPrefs.storeGuestInfo(null, null, null);
    sharedPrefs.setIsUserCOAuthorized(null);

//MM    locator<MyAppointmentsViewModel>().reset();
    //MM  locator<VisitMainViewModel>().reset();
    //MM  locator<CustomerSoundViewModel>().reset();
    await CookieManager.instance().deleteAllCookies();
    sl<DelegatorsCubit>().clearDelegators();
  }

  testData() async {
    final failureOrSuccess = await _getTestData(NoParams());
    failureOrSuccess.fold((l) {}, (r) {});
  }

  void updateCurrentLocation(GISResponse response, GISParams params) {
    emit(state.copyWith(userLocationGIS: response, userLocation: params));
  }

  void selectDelegator(DelegatorEntity? delegator) {
    emit(state.copyWith(
        selectedDelegator: Nullable(delegator), selectedAgent: Nullable(null)));
  }

  void selectAgent(AgentEntity? agent) {
    emit(state.copyWith(
        selectedDelegator: Nullable(null), selectedAgent: Nullable(agent)));
  }

  Future<(GISParams, GISResponse)?> getUserLocationData() async {
    emit(state.copyWith(gisStatus: BlocStatus.loading));
    var latlng = await Helpers.getMapLocation();

    if (latlng == null) {
    } else {
      emit(state.copyWith(
          userLocation: GISParams(x: latlng.longitude, y: latlng.latitude)));

      GetGISData getgis = GetGISData(repository: sl());

      var result =
          await getgis(GISParams(x: latlng.longitude, y: latlng.latitude));
      result.fold((l) {
        emit(state.copyWith(gisStatus: BlocStatus.failure));
      }, (r) {
        emit(state.copyWith(userLocationGIS: r, gisStatus: BlocStatus.success));

        return (state.userLocation, state.userLocationGIS);
      });
    }
    return null;
  }

  Future<String?> getPaymentURL(PaymentRequest request) async {
    var result = await _getPaymentUrl(request);
    result.fold((l) {
      CommonFunctions.showError((l as ServerFailure).errorMessage);
    }, (r) async {
      return r;
    });

    return result.getRight;
  }

  Future<void> getEkramPermissions({bool allowTracking = false}) async {
    try {
      if (state.userInfo?.sub == null || state.userInfo?.tnm == null) return;
      final failureOrSuccessForProfile =
          await _getEkramPermission(GetPermissionParamsModel(claims: [
        Claim(type: "sub", value: state.userInfo!.sub!),
        Claim(type: "tenant", value: state.userInfo!.tnm!)
      ]));
      await failureOrSuccessForProfile.fold((failure) async {
        print("permission failure$failure");
      }, (success) async {
        print("permission success$success");
        if ((success.permissions?.contains("تسجيل رحلة نقل وتجهيز الموتى") ??
                false) &&
            (success.permissions?.contains("تسجيل رحلة نقل وتجهيز الموتى") ??
                false)) {
          CommonProperties.showEkramDriver = true;
          sharedPrefs.setIsEkramDriver(true);
        } else {
          CommonProperties.showEkramDriver = false;
        }
      });
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
    }
    CommonProperties.showEkramDriver =
        sharedPrefs.isEkramDriver() ?? CommonProperties.showEkramDriver;
    if (allowTracking) {
      if (CommonProperties.showEkramDriver) {
        //  sl<EkramLocationService>().startTracking = true;
        //  sl<EkramLocationService>().startTimer();
      }
    }
  }

  void refreshApp() {
    emit(state.copyWith(blocStatus: BlocStatus.loading));

    emit(state.copyWith(blocStatus: BlocStatus.success));
  }

  void _saveDataLogin({
    required SSOToken token,
    required bool isFromEtmam,
  }) async {
    final failureOrSuccess = await _saveAuth(token);
    if (failureOrSuccess.isRight()) {
      emit(state.copyWith(
        status: AuthStatus.loading,
        token: token,
        errorMessage: "",
      ));

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token.token ?? "");
      SsoUserInfo user = SsoUserInfoModel.fromJson(decodedToken);
      final failureOrSuccess =
          await _saveSSOProfile(SsoUserInfoModel.fromJson(decodedToken));
      if (failureOrSuccess.isRight()) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          token: token,
          userInfo: user,
          errorMessage: "",
        ));
        FlutterUxcam.setUserIdentity(user.idNo);
        FlutterUxcam.setUserProperty("name", user.arName ?? "");
      }

      final failureOrSuccessForCookie = await _getCookie(NoParams());

      await failureOrSuccessForCookie.fold((l) async {
        final failureOrSuccessForCookie = await _getCookie(NoParams());
        await failureOrSuccessForCookie.fold((failure) {
          emit(state.copyWith(
            status: AuthStatus.failure,
            errorMessage: (failure as ServerFailure).errorMessage,
          ));
        }, (r) async {
          SSOToken? token = state.token;
          token?.appCookie = r;
          if (token != null) {
            await _saveAuth(token);
            emit(state.copyWith(token: token));
          }
        });
      }, (r) async {
        SSOToken? token = state.token;
        token?.appCookie = r;
        if (token != null) {
          await _saveAuth(token);
          emit(state.copyWith(token: token));
        }
      });
      EasyLoading.dismiss();
      if (isFromEtmam) {
        sl<EtmamEntryPointCubit>().onLogin();
      }
      if (state.status == AuthStatus.notAuthenticated) {
        //MM  locator<CustomerSoundViewModel>().getUserRequests(showLoad: false);
        //MM  PCPViewModel.checkIfSameLoggedInUser();
        return;
      }
      getEkramPermissions();
      try {
        BlocProvider.of<DashboardBloc>(
                NavigationService.navigatorKey.currentContext!)
            .add(DashboardEventInitial());
      } catch (error, stackTrace) {
        LogsViewModel().sendEventFromModel(
          event: ErrorExceptionModel(
            nameEvent: EventsName.handledException,
            message: error.toString(),
            stackTrace: stackTrace.toString(),
          ),
        );
      }
    }
  }
}
