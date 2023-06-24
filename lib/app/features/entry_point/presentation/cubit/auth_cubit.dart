//import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
//   show showUpdateAppPopUpWidget;
import 'package:balady_plus/app/features/entry_point/domain/use_cases/get_test_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:webview_flutter/webview_flutter.dart' as c;

import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/services/services_exports.dart';
import '../../../../core/utils/utils_exports.dart';
import '../../../profile_features/delegators/delegators_exports.dart';
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
  })  : _getToken = getToken,
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
        _getForceVersion = forceVersion,
        _getTestData = GetTestData(repository: sl()),
        super(const EntryPointState()) {}

  Future<void> onLoadingApp() async {
    //setTheme();
    print("onLoadingApp");
    // print(state.token?.refreshToken);
    emit(state.copyWith(status: AuthStatus.loading));
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
      });
      //MM sl<EtmamEntryPointCubit>().onLoadingApp();

      if (token.refreshToken != null) await refreshToken(token.refreshToken!);
      refreshSSOProfile();
    });
  }

  Future<bool> onLogin({bool isFromEtmam = false}) async {
    EasyLoading.show();
    emit(state.copyWith(
      status: AuthStatus.loading,
    ));
    final failureOrSuccessForToken = await _getToken(NoParams());

    await failureOrSuccessForToken.fold((failure) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: (failure as ServerFailure).errorMessage,
      ));
    }, (success) async {
      SSOToken token = SSOToken(
          token: success.accessToken,
          refreshToken: success.refreshToken,
          idToken: success.idToken,
          expirationTime: success.accessTokenExpirationDateTime.toString());
      final failureOrSuccess = await _saveAuth(token);
      if (failureOrSuccess.isRight()) {
        emit(state.copyWith(
          status: AuthStatus.loading,
          token: token,
          errorMessage: "",
        ));

        final failureOrSuccessForSSOProfile = await _getProfile(NoParams());

        await failureOrSuccessForSSOProfile.fold((failure) async {
          clearAuth();
          emit(EntryPointState(
              status: AuthStatus.failure,
              errorMessage: ("errors_server_error_1").tr()));
        }, (success) async {
          final failureOrSuccess = await _saveSSOProfile(success);
          if (failureOrSuccess.isRight()) {
            emit(state.copyWith(
              status: AuthStatus.notAuthenticated,
              token: token,
              userInfo: success,
              errorMessage: "",
            ));
          }
        });

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
          //MM    sl<EtmamEntryPointCubit>().onLogin();
        }
        if (state.status == AuthStatus.notAuthenticated) {
          //MM  locator<CustomerSoundViewModel>().getUserRequests(showLoad: false);
          //MM  PCPViewModel.checkIfSameLoggedInUser();

          return false;
        }
      }
    });
    EasyLoading.dismiss();
    //MM   sl<VDCategoryBloc>().add(RefreshCategoriesEvent());
    //MM return isLoggedIn;
    return CommonProperties.isLoggedIn;
  }

  Future<void> refreshToken(String refreshToken) async {
    final failureOrSuccess = await _refreshToken(refreshToken);

    return await failureOrSuccess.fold((failure) {}, (success) async {
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
        return true;
      });
    });
  }

  Future<bool> refreshAPIGeeToken() async {
    // print("refreshAPIGeeToken");
    // print(state.apigeeToken);
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
    _clearAuth(NoParams());

    sharedPrefs.setSSOToken(null);
    //MM sharedPrefs.setUserProfile(null);
    clearSSOInfo();
    emit(const EntryPointState(
      status: AuthStatus.notAuthenticated,
    ));
  }

  Future<void> autoLogout() async {
    sharedPrefs.setSSOToken(null);
    //MM sharedPrefs.setUserProfile(null);
    sharedPrefs.setSSOUserProfile(null);
    clearSSOInfo();
    emit(const EntryPointState(
      status: AuthStatus.notAuthenticated,
    ));
    _logout(NoParams());
    //MM  sl<VDCategoryBloc>().add(RefreshCategoriesEvent());

    //MM  Helpers.backToHome();
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
          _saveSSOProfile(success);
        }
      });
    } catch (ex) {}
  }

  Future<void> checkVersion() async {
    await Future.delayed(const Duration(seconds: 7));
    final failureOrSuccessForProfile = await _getForceVersion(NoParams());
    await failureOrSuccessForProfile.fold((failure) async {}, (success) async {
      //s print("SUCCCCCCCCESSSSSS ${success}");
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
    await c.CookieManager().clearCookies();
    try {
      dynamic controller;
      const c.WebView().onWebViewCreated!(controller);
      controller.clearCache();
    } catch (ex) {
      //  print("EXXX $ex");
    }
  }

  testData() async {
    final failureOrSuccess = await _getTestData(NoParams());
    failureOrSuccess.fold((l) {
      //  print(l);
    }, (r) {
      // print(r);
    });
  }

  void selectDelegator(DelegatorEntity? delegator) {
    emit(state.copyWith(selectedDelegator: Nullable(delegator)));
  }
}
