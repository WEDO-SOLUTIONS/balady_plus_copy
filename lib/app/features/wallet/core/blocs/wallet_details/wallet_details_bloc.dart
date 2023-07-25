import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../models/wallet_item.dart';
import '../../repository/wallet_repository.dart';

part 'wallet_details_event.dart';
part 'wallet_details_state.dart';

class WalletDetailsBloc extends Bloc<WalletDetailsEvent, WalletDetailsState> {
  final WalletRepository _repository = WalletRepository();

  WalletDetailsBloc(WalletItem? item)
      : super(WalletDetailsState(selectedItem: item)) {
    on<WalletDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<ShareWalletItem>(_printWalletItem);
  }

  Future<void> _printWalletItem(ShareWalletItem e, Emitter emitter) async {
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
