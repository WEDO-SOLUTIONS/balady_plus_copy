//import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
//   show showUpdateAppPopUpWidget;
import 'dart:async';

import 'package:balady_authorization/src/authentication/bloc/action_login_cubit/action_login_cubit.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_authorization/src/authentication/models/login_data_model.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:balady_plus/app/features/entry_point/domain/use_cases/get_test_data.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_params.dart';
import 'package:balady_plus/app/features/location/domain/entities/gis/gis_response.dart';
import 'package:balady_plus/app/features/location/domain/use_cases/get_gis_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart' show WidgetsBinding;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mapness/features/balady_analytics/balady_analytics.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/services/services_exports.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../domain/use_cases/get_ekram_permission.dart';
import '../../entry_point_exports.dart';

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

  final ClearAuth _clearAuth;
  final Logout _logout;
  final GetForceVersion _getForceVersion;
  final GetTestData _getTestData;

  // final GetGISData _getGisData;
  final GetEkramPermission _getEkramPermission;
  final GetPaymentUrl _getPaymentUrl;

  EntryPointCubit({
    required GetToken getToken,
    required SaveAuth saveAuth,
    required CheckAuth checkAuth,
    required RefreshToken refreshToken,
    required GetProfile getProfile,
    required SaveSSOProfile saveSSOProfile,
    required CheckSSOProfile checkSSOProfile,
    required GetCookie getCookie,
    required ClearAuth clearAuth,
    required Logout logout,
    required GetAPIgeeToken getAPIgeeToken,
    required GetForceVersion forceVersion,
    // required GetGISData getGisData,
  }) : _getToken = getToken,
       _saveAuth = saveAuth,
       _checkAuth = checkAuth,
       _refreshToken = refreshToken,
       _getProfile = getProfile,
       _saveSSOProfile = saveSSOProfile,
       _checkSSOProfile = checkSSOProfile,
       _getCookie = getCookie,
       _getAPIgeeToken = getAPIgeeToken,
       _clearAuth = clearAuth,
       _logout = logout,
       _getPaymentUrl = GetPaymentUrl(repository: sl()),
       _getForceVersion = forceVersion,
       _getTestData = GetTestData(repository: sl()),
       _getEkramPermission = GetEkramPermission(repository: sl()),
       // _getGisData = getGisData,
       super(const EntryPointState()) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<LocationCubit>().getLocationInit();
      // Unawaited: a PlatformException here (no Activity yet) must not become
      // an unhandled zone error reported to telemetry.
      Permission.notification
          .request()
          .catchError((_) => PermissionStatus.denied);
    });
    refreshAPIGeeToken();
    // Restore authentication state on app startup (non-blocking)
    // unawaited(_restoreAuthState());
  }

  /// Restore authentication state from storage when app starts

  void hideSplash() {
    emit(state.copyWith(showSplash: false));
  }

  String? mainPage;

  ////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////
  Future<bool> onLogin({
    bool isFromEtmam = false,
    // When Use This Function and you want to login with municipality send isMunicipality = true
    required bool isMunicipality,
    String? mainPage,
  }) async {
    try {
      sl<ActionLoginCubit>().openLoginScreen(state: sl<AuthenticationBloc>().state, isMunicipality: isMunicipality);
      this.mainPage = mainPage;
    } catch (e) {
      print("object");
    }
    return false;
  }

  ////////////////////////////////////////////////////////////////////////
  Future<bool> onLoginV2({required LoginDataModel? data, bool isFromEtmam = false}) async {
    EasyLoading.show();
    emit(state.copyWith(status: AuthStatus.loading));
    late SSOToken token;

    if (data != null) {
      token = SSOToken(
        token: data.accessToken,
        refreshToken: data.refreshToken,
        idToken: data.idToken,
        expirationTime: data.expiresIn.toString(),
      );
    } else {
      final failureOrSuccessForToken = await _getToken(NoParams());
      await failureOrSuccessForToken.fold(
        (failure) {
          emit(state.copyWith(status: AuthStatus.failure, errorMessage: (failure as ServerFailure).errorMessage));
        },
        (success) async {
          token = SSOToken(
            token: success.accessToken,
            refreshToken: success.refreshToken,
            idToken: success.idToken,
            expirationTime: success.accessTokenExpirationDateTime.toString(),
          );
        },
      );
    }
    AuthenticatedState authState = sl<AuthenticationBloc>().state as AuthenticatedState;
    if (authState is AuthenticatedMunicipalityState) {
      _saveDataLogin(token: token, isFromEtmam: isFromEtmam, authState: authState);
    } else {
      final profileData = authState.profileData;
      // `complete_profile` comes from the OTP login API (`MobileLoginVerifyOtp`).
      // - true  → user signed up via OTP only → personal data is editable.
      // - false → user already has an SSO/Nafath account → profile is read-only.
      final bool completeProfile = authState.loginData.completeProfile;
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          token: token,
          userInfo: SsoUserInfo(
            name: profileData.firstNameArabic,
            sname: profileData.lastNameArabic,
            enName: profileData.enName,
            arName: profileData.arName,
            idNo: profileData.sub,
            // `sub` is the SSO subject id and the ONE identifier that means the
            // same thing across phone (OTP) and national-id (SSO) login. On this
            // OTP path `profileData.sub` is a required non-null String, so set it
            // explicitly (previously only `idNo` carried it, leaving
            // `userInfo.sub` null on phone login).
            sub: profileData.sub,
            mail: profileData.email,
            phone: profileData.phoneNumber,
            loginType: SsoLoginType.otp,
            completeProfile: completeProfile,
          ),
          errorMessage: "",
        ),
      );
      Sentry.configureScope((scope) {
        scope.setUser(
          SentryUser(id: profileData.sub.toString(), username: profileData.enName, email: profileData.email),
        );
      });
    }

    if (CommonProperties.fcmToken != null && CommonProperties.fcmToken!.isNotEmpty) {
      CommonFunctions.updateNotificationSettings(CommonProperties.fcmToken!);
    }

    EasyLoading.dismiss();
    return CommonProperties.isLoggedInMunicipality;
  }

  ////////////////////////////////////////////////////////////////////////
  Future<void> onLoginNfaaz({bool isFromEtmam = false}) async {
    EasyLoading.show();
    emit(state.copyWith(status: AuthStatus.loading));
    final failureOrSuccessForToken = await _getToken(NoParams());
    await failureOrSuccessForToken.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.failure, errorMessage: (failure as ServerFailure).errorMessage));
        EasyLoading.dismiss();
        return;
      },
      (success) async {
        try {
          EasyLoading.dismiss();
          sl<AuthenticationBloc>().add(
            LoginWithNafazAuthentication(
              dataLogin: {
                "access_token": success.accessToken,
                "idToken": success.idToken,
                "expires_in": success.accessTokenExpirationDateTime != null
                    ? DateTime.now().difference(success.accessTokenExpirationDateTime!).inSeconds
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
      },
    );
    return;
  }

  ////////////////////////////////////////////////////////////////////////

  Future<void> refreshToken(String refreshToken) async {
    // SSOToken? token = state.token;
    //
    // if (token != null && token.token != null && token.token!.isNotEmpty) {
    //   final failureOrSuccess = await _refreshToken(refreshToken);
    //
    //   return await failureOrSuccess.fold((failure) async {
    //     //await autoLogout();
    //   },
    //           (success) async {
    //     SSOToken token = SSOToken(
    //         token: success.accessToken,
    //         refreshToken: success.refreshToken,
    //         idToken: success.idToken,
    //         expirationTime: success.accessTokenExpirationDateTime.toString());
    //
    //     final failureOrSuccess = await _saveAuth(token);
    //     failureOrSuccess.fold((f) {
    //       emit(state.copyWith(
    //         status: AuthStatus.notAuthenticated,
    //         errorMessage: ("errors_server_error_1".tr()),
    //       ));
    //       return false;
    //     }, (s) {
    //       emit(state.copyWith(
    //         status: AuthStatus.authenticated,
    //         token: token,
    //         errorMessage: "",
    //       ));
    //       if (CommonProperties.fcmToken != null &&
    //           CommonProperties.fcmToken!.isNotEmpty) {
    //         CommonFunctions.updateNotificationSettings(
    //             CommonProperties.fcmToken!);
    //       }
    //       return true;
    //     });
    //   });
    // } else {
    //   // await autoLogout();
    // }
  }

  Future<bool> refreshAPIGeeToken() async {
    DateTime? expireTime = DateTime.tryParse(state.apigeeToken?.expirationTime ?? "");

    if (expireTime == null || (expireTime.difference(DateTime.now()).inHours <= 2)) {
      final failureOrSuccess = await _getAPIgeeToken(NoParams());
      return await failureOrSuccess.fold(
        (failure) {
          return false;
        },
        (success) async {
          success.expirationTime = success.getExpireTime().toString();
          emit(state.copyWith(apigeeToken: success));
          return true;
        },
      );
    }
    return true;
  }

  Future<void> checkifTokenExpired() async {
    if (state.status == AuthStatus.notAuthenticated) {
      DateTime? expireTime = DateTime.tryParse(state.token?.expirationTime ?? "");

      if (expireTime != null) {
        if (!DateTime.now().add(const Duration(minutes: 15)).isBefore(expireTime)) {
          if (state.token?.refreshToken != null) {
            return await refreshToken(state.token!.refreshToken!);
          }
        }
      }
    }

    return Future.value(false);
  }

  Future<void> clearAuth({LoginDataModel? loginData}) async {
    try {
      if (loginData == null) {
        sl<AuthenticationBloc>().add(LogoutAuthentication());
        // return;
      }

      // if (state.status == AuthStatus.notAuthenticated) {
      //   return;
      // }
      emit(const EntryPointState(status: AuthStatus.notAuthenticated, showSplash: false));

      if (loginData?.deviceIdToken != null) {
        try {
          await _logout(NoParams());
        } catch (e) {
          EasyLoading.dismiss();
        }
        // sl<DelegatorsCubit>().clearDelegators();
        await _clearAuth(NoParams());
        clearSSOInfo();
      }

      if (CommonProperties.fcmToken != null && CommonProperties.fcmToken!.isNotEmpty) {
        CommonFunctions.updateNotificationSettings(CommonProperties.fcmToken!);
      }
      EasyLoading.dismiss();
    } catch (e) {
      print("object");
      EasyLoading.dismiss();
    }
  }

  Future<void> autoLogout() async {
    if (state.status == AuthStatus.notAuthenticated) {
      return;
    }
    try {
      emit(const EntryPointState(status: AuthStatus.notAuthenticated));
      sl<AuthenticationBloc>().add(LogoutAuthentication());
    } catch (e) {
      print("object");
      EasyLoading.dismiss();
    }
    if (sl<AuthenticationBloc>().state is AuthenticatedMunicipalityState) {
      await _clearAuth(NoParams());
      // sl<DelegatorsCubit>().clearDelegators();
      clearSSOInfo();
      try {
        await _logout(NoParams());
      } catch (e) {
        EasyLoading.dismiss();
      }
    }
    if (CommonProperties.fcmToken != null && CommonProperties.fcmToken!.isNotEmpty) {
      CommonFunctions.updateNotificationSettings(CommonProperties.fcmToken!);
    }
    CommonFunctions.showError("session_ended_error".tr());
    EasyLoading.dismiss();
  }

  /// Persists and broadcasts profile edits (e.g. OTP user name changes from mapness).
  Future<void> applyUserInfo(SsoUserInfo userInfo) async {
    final failureOrSuccess = await _saveSSOProfile(userInfo);
    if (failureOrSuccess.isRight()) {
      emit(state.copyWith(userInfo: userInfo));
    }
  }

  Future<void> refreshSSOProfile() async {
    try {
      AuthenticatedState authState = sl<AuthenticationBloc>().state as AuthenticatedState;
      if (authState is AuthenticatedMunicipalityState) {
        final failureOrSuccessForProfile = await _getProfile(NoParams());
        await failureOrSuccessForProfile.fold((failure) async {}, (success) async {
          // `/connect/userinfo` does not return `complete_profile`,
          // `loginType`, etc. Preserve them from the value captured at login
          // (`MobileLoginVerifyOtp` / `_saveDataLogin`) so editing rules stay
          // consistent across profile refreshes.
          final previous = state.userInfo;
          final merged = success.copyWith(
            loginType: previous?.loginType ?? success.loginType,
            completeProfile: previous?.completeProfile ?? success.completeProfile,
            isEmailVerified: previous?.isEmailVerified ?? success.isEmailVerified,
            isEmailEditable: previous?.isEmailEditable ?? success.isEmailEditable,
            isSSOLocked: previous?.isSSOLocked ?? success.isSSOLocked,
          );
          final failureOrSuccess = await _saveSSOProfile(merged);
          if (failureOrSuccess.isRight()) {
            emit(state.copyWith(userInfo: merged));
          }
        });
      }
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
    // sharedPrefs.setAppCookie(null);
    // sharedPrefs.setLicenseClientImage(null);
    // sharedPrefs.setIsUserCOAuthorized(null);

    sharedPrefs.storeGuestInfo(null, null, null);
    await CookieManager.instance().deleteAllCookies();
    // sl<DelegatorsCubit>().clearDelegators();
  }

  Future<void> testData() async {
    final failureOrSuccess = await _getTestData(NoParams());
    failureOrSuccess.fold((l) {}, (r) {});
  }

  void updateCurrentLocation(GISResponse response, GISParams params) {
    emit(state.copyWith(userLocationGIS: response, userLocation: params));
  }

  // void selectDelegator(DelegatorEntity? delegator) {
  //   emit(state.copyWith(selectedDelegator: Nullable(delegator), selectedAgent: Nullable(null)));
  // }

  // void selectAgent(AgentEntity? agent) {
  //   emit(state.copyWith(selectedDelegator: Nullable(null), selectedAgent: Nullable(agent)));
  // }

  Future<(GISParams, GISResponse)?> getUserLocationData() async {
    emit(state.copyWith(gisStatus: BlocStatus.loading));
    var latlng = await Helpers.getMapLocation();

    if (latlng == null) {
    } else {
      emit(
        state.copyWith(
          userLocation: GISParams(x: latlng.longitude, y: latlng.latitude),
        ),
      );

      GetGISData getgis = GetGISData(repository: sl());

      var result = await getgis(GISParams(x: latlng.longitude, y: latlng.latitude));
      result.fold(
        (l) {
          emit(state.copyWith(gisStatus: BlocStatus.failure));
        },
        (r) {
          emit(state.copyWith(userLocationGIS: r, gisStatus: BlocStatus.success));

          return (state.userLocation, state.userLocationGIS);
        },
      );
    }
    return null;
  }

  Future<String?> getPaymentURL(PaymentRequest request) async {
    var result = await _getPaymentUrl(request);
    result.fold(
      (l) {
        CommonFunctions.showError((l as ServerFailure).errorMessage);
      },
      (r) async {
        return r;
      },
    );

    return result.getRight;
  }

  void refreshApp() {
    emit(state.copyWith(blocStatus: BlocStatus.loading));

    emit(state.copyWith(blocStatus: BlocStatus.success));
  }

  void _saveDataLogin({
    required SSOToken token,
    required bool isFromEtmam,
    required AuthenticatedMunicipalityState authState,
  }) async {
    print(" ");
    print(" ");
    print(" ");
    print(" ");
    final failureOrSuccess = await _saveAuth(token);
    failureOrSuccess.fold(
      (failure) {
        print("object");
      },
      (success) async {
        emit(state.copyWith(status: AuthStatus.loading, token: token, errorMessage: ""));

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token.token ?? "");
        SsoUserInfo user = SsoUserInfoModel.fromJson(decodedToken);
        // TEMP verification: confirm the SSO JWT actually carries a `sub` claim so
        // `userInfo.sub` is reliable on national-id login (it is guaranteed on the
        // phone/OTP path). Remove once confirmed on a real SSO login.
        // ignore: avoid_print
        assert(() {
          print('[AUTH][SSO] jwt has sub=${decodedToken.containsKey('sub')} value=${decodedToken['sub']}');
          return true;
        }());
        final failureOrSuccess = await _saveSSOProfile(SsoUserInfoModel.fromJson(decodedToken));
        if (failureOrSuccess.isRight()) {
          emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              token: token,
              userInfo: user.copyWith(
                name: authState.profileData.firstNameArabic,
                sname: authState.profileData.lastNameArabic,
                enName: authState.profileData.enName,
                arName: authState.profileData.arName,
                mail: authState.profileData.email,
                phone: authState.profileData.phoneNumber,
                loginType: SsoLoginType.nationalId,
                completeProfile: authState.loginData.completeProfile,
              ),
              errorMessage: "",
            ),
          );
          BaladyAnalytics.instance.identify(
            userId: user.idNo,
            traits: {
              "sub": user.sub ?? "",
              "name": user.arName ?? "",
              "en_name": user.enName ?? "",
              "login_type": user.loginType.name ?? "",
              "sex": user.sex == "1"
                  ? "male"
                  : user.sex == "2"
                  ? "female"
                  : "N/A",
              "nationality": user.nationality ?? "N/A",
              "birthday": user.dob ?? "N/A",
            },
          );
          // Sentry.configureScope((scope) {
          //   scope.setUser(
          //     SentryUser(
          //       id: user.idNo,
          //       username: user.enName,
          //       email: user.mail,
          //     ),
          //   );
          // });
        }

        final failureOrSuccessForCookie = await _getCookie(true);

        await failureOrSuccessForCookie.fold(
          (l) async {
            final failureOrSuccessForCookie = await _getCookie(true);
            await failureOrSuccessForCookie.fold(
              (failure) {
                emit(state.copyWith(status: AuthStatus.failure, errorMessage: (failure as ServerFailure).errorMessage));
              },
              (r) async {
                SSOToken? token = state.token;
                token?.appCookie = r;
                if (token != null) {
                  await _saveAuth(token);
                  emit(state.copyWith(token: token));
                }
              },
            );
          },
          (r) async {
            SSOToken? token = state.token;
            token?.appCookie = r;
            if (token != null) {
              await _saveAuth(token);
              emit(state.copyWith(token: token));
            }
          },
        );

        EasyLoading.dismiss();
        if (state.status == AuthStatus.notAuthenticated) {
          //MM  locator<CustomerSoundViewModel>().getUserRequests(showLoad: false);
          //MM  PCPViewModel.checkIfSameLoggedInUser();
          return;
        }
      },
    );
  }
}
