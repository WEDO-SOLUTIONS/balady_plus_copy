import 'dart:typed_data';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/wallet/core/models/wallet_type.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:tuple/tuple.dart';
import 'package:collection/collection.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../models/wallet_item.dart';
import '../../models/wallet_response.dart';
import '../../repository/wallet_repository.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _repository = WalletRepository();

  WalletBloc() : super(WalletState()) {
    on<WalletEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<GetWalletDataEvent>(_getWalletData);
    on<ChangeWalletItem>(_changeWalletItem);
    on<ShareWalletItemEvent>(_printWalletItem);
    on<ChangeViewAllEvent>(_changeViewAllHandler);
    on<ChangeTypeEvent>(_selectTypeHandler);
    if (CommonProperties.isLoggedInMunicipality) add(GetWalletDataEvent());
  }

  Future<void> _changeViewAllHandler(
      ChangeViewAllEvent e, Emitter emitter) async {
    emitter(state.copyWith(showAll: true));
  }

  Future<void> _selectTypeHandler(ChangeTypeEvent e, Emitter emitter) async {
    emitter(state.copyWith(selectedTypeIndex: e.index));
  }

  Future<void> _changeWalletItem(ChangeWalletItem e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    emitter(state.copyWith(
        status: BlocStatus.success, selectedItem: e.selectedIetm));
  }

  Future<void> _getWalletData(GetWalletDataEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.loading));

    Tuple3<bool?, String?, WalletResponse?> response =
        await _repository.getWalletItems();
    emitter(state.copyWith(status: BlocStatus.loaded));
    if (response.item1 != null && response.item1!) {
      emitter(state.copyWith(
          status: BlocStatus.success,
          items: response.item3?.data?.result ?? [],
          selectedItem: response.item3?.data?.result?.firstOrNull));
    } else {
      if (response.item3?.data?.responseCode == "2") {
        emitter(state.copyWith(
            status: BlocStatus.success, items: [], errorMessage: ""));
      } else {
        emitter(state.copyWith(
            status: BlocStatus.retry,
            items: [],
            errorMessage: response.item2 ??
                Helpers.translatingWord("errors_server_error_1")));
      }
    }
  }

  Future<void> _printWalletItem(ShareWalletItemEvent e, Emitter emitter) async {
    emitter(state.copyWith(status: BlocStatus.download));
    Tuple4<bool?, String?, Uint8List?, String?> response =
        await _repository.downLoadLicense(e.selectedIetm?.uuid ?? "");
    emitter(state.copyWith(status: BlocStatus.loaded));
    if (response.item3 != null && response.item1 != null && response.item1!) {
      emitter(state.copyWith(
        status: BlocStatus.success,
      ));
      if (response.item3 != null)
        Helpers.openFile(response.item3!, contentType: response.item4);
    } else {
      emitter(state.copyWith(
          status: BlocStatus.failure,
          errorMessage: response.item2 ??
              Helpers.translatingWord("errors_server_error_1")));
    }
  }
}
