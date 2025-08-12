import 'package:balady_plus/app/core/errors/errors_exports.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/data/repositories/mini_apps_repository.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/mini_apps_engine_bloc.dart';
import 'package:balady_plus/mini_apps_engine/server/CustomInAppLocalhostServer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../app/core/utils/common_functions.dart';
import '../../../../super_app_js_bridge/model/access_token_model.dart';
import '../../../../super_app_js_bridge/model/base_response.dart';

part 'home_mini_apps_list_state.dart';

class HomeMiniAppsListCubit extends Cubit<HomeMiniAppsListState> {
  MiniAppsRepository homeServicesUseCases;

  // InAppLocalhostServer? localhostServer;
  // CustomInAppLocalhostServer? localhostServer;

  HomeMiniAppsListCubit({
    required this.homeServicesUseCases,
  }) : super(const HomeMiniAppsListLoadingState()) {
    loadMiniApps();
  }

  Future<void> loadMiniApps() async {
    emit(const HomeMiniAppsListLoadingState());
    homeServicesUseCases.getMiniAppsList().then(
      (value) {
        value.fold(
          (l) {
            emit(HomeMiniAppsListFiledState(errors: l.toString()));
          },
          (listMiniApps) async {
            // String basePathService = "${(await getApplicationDocumentsDirectory()).path}/www/";
            String pathService =
                "${(await getApplicationDocumentsDirectory()).path}/www/";
            CommonProperties.currentLocalServerDirectory = pathService;
            // localhostServer ??= CustomInAppLocalhostServer(
            //   PlatformInAppLocalhostServerCreationParams(
            //   documentRoot: pathService,
            //   port: 7734,
            //     shared: true,
            //   ),
            // );
            // localhostServer ??= InAppLocalhostServer(
            //   // PlatformInAppLocalhostServerCreationParams(
            //   documentRoot: pathService,
            //   port: 7734,
            //     shared: true,
            //   // ),
            // );

            ////////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////

            // bool isRunning = localhostServer!.isRunning();
            // if (!isRunning) {
            //   await localhostServer!.start();
            // }
            // String serverPath = "http://localhost:${localhostServer!.port}/";

            HomeMiniAppsListState state = HomeMiniAppsListSuccessState(
              miniAppsList: listMiniApps,
              // serverPath: serverPath,
            );

            for (var element in listMiniApps) {
              if (element.serviceKey == "municipalservice") {
                state = HomeMiniAppsListSuccessState(
                  miniAppsList: listMiniApps,
                  // municipalAppBloc: MiniAppsEngineBloc(
                  //   miniApp: element,
                  //   serverPath: serverPath,
                  // ),
                  // serverPath: serverPath,
                );
              }
            }
            emit(state);
          },
        );
      },
    );
  }

  Future<void> openMiniApp({required String serviceKey, String? path}) async {
    try {
      MiniAppModel miniApp = (state as HomeMiniAppsListSuccessState)
          .miniAppsList
          .firstWhere((service) => service.serviceKey == serviceKey)
          .copyWith();
      miniApp.path = path;
      NavigationService.pushNamed(
        routeName: RouteName.miniAppsMainScreen,
        args: miniApp,
      );
    } catch (_) {}
  }

  Future<BaseResponse?> getMiniAppAcessToken(String serviceKey) async {
    if (serviceKey != "municipalservice") {
      return BaseResponse(
        code: 200,
        message: "success",
        eventName: "getAccessToken",
        data: AccessTokenModel(
          accessToken: CommonProperties.token,
        ),
      );
    } else {
      int index = (state as HomeMiniAppsListSuccessState)
          .miniAppsList
          .indexWhere((it) => it.serviceKey == serviceKey);
      if (index != -1) {
        MiniAppModel model =
            (state as HomeMiniAppsListSuccessState).miniAppsList[index];

        try {
          final response =
              await homeServicesUseCases.getMiniAppAcessToken(model.id!);

          return response.fold(
            (error) {
              if (error is ServerFailure) {
                return BaseResponse(
                  code: 500,
                  message: error.errorMessage,
                  eventName: "getAccessToken",
                  data: null,
                );
              } else {
                return BaseResponse(
                  code: 500,
                  message: 'An unknown error occurred',
                  eventName: "getAccessToken",
                  data: null,
                );
              }
            },
            (res) {
              return BaseResponse(
                code: 200,
                message: "success",
                eventName: "getAccessToken",
                data: AccessTokenModel(
                  accessToken: res.toString(),
                ),
              );
            },
          );
        } catch (e) {
          return BaseResponse(
            code: 500,
            message: 'Failed to get access token: ${e.toString()}',
            eventName: "getAccessToken",
            data: null,
          );
        }
      }
    }
  }

// int index=(state as HomeMiniAppsListSuccessState).miniAppsList.indexWhere((it) => it.serviceKey == serviceKey);
// if(index !=-1) {
//
//   MiniAppModel model= (state as HomeMiniAppsListSuccessState).miniAppsList[index];
//   if(model.latestVersion?.nafathLogin== true) {
//     return CommonProperties.token;
//   }
//   else
//     {
//
//     }
}
