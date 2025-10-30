import 'dart:convert';
import 'dart:typed_data';

import 'package:tuple/tuple.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/remote_services/api_constants.dart';
import '../../../../core/remote_services/pega_web_service.dart';
import '../../../../core/services/local/helpers.dart';
import '../models/wallet_response.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

class WalletRepository {
  final webServices = locator<PegaWebService>();

  Future<Tuple3<bool?, String?, WalletResponse?>> getWalletItems() async {
    Map<String, dynamic> queryParms = {};

    //  queryParms = {"": ""};

    String url = ApiConstants.wallet;

    final body =
        await webServices.getNewApigeeRequest(url, queryParams: queryParms);
    bool state = body['state'];
    dynamic data = body['data'];
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");
    WalletResponse? result;
    try {
      WalletResponse response = WalletResponse.fromJson(json.decode(data));
      result = response;
      if (state != true) {
        error = result.data?.responseMessage ?? error;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      try {
        Helpers.sendLog(url: url, data: data, errorMsg: error.toString());
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
    return Tuple3<bool?, String?, WalletResponse?>(state, error, result);
  }

  Future<Tuple4<bool?, String?, Uint8List?, String?>> downLoadLicense(
      String uuid) async {
    String query = "$uuid";

    final body = await webServices.getNewApigeeRequestWithoutUTF(
        ApiConstants.printWalletLicense,
        relativePath: query);
    bool state = body['state'];
    dynamic data = body['data'];
    Uint8List? result;
    String error =
        body['error'] ?? Helpers.translatingWord("errors_server_error_1");
    String? contentType = body['Content-Type'];

    try {
      if (state) result = data;

      if (!state) {
        //   error = result.data?.responseMessage ?? error;

        try {
          Helpers.sendLog(
              url: ApiConstants.printWalletLicense,
              data: data,
              errorMsg: body.toString() ?? "");
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
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
    return Tuple4<bool?, String?, Uint8List?, String?>(
        state, error, result, contentType);
  }
}
