import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tuple/tuple.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../health_certificate/presentation/core/models/check_update_photo_client.dart';
import '../../../../health_certificate/presentation/core/services/repository/health_license_repository.dart';
import '../../../../health_certificate/presentation/dialogs/update_photo_dialog.dart';
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

  /* Future<bool?>? checkNeedToUpdatePhoto() async {
    emit(state.copyWith(photoStatus: BlocStatus.loading));

    Tuple3<bool?, String?, CheckUpdateClientPhoto?> result =
        await locator<HealthLicenseRepository>()
            .checkUpdatedPhoto(state.selectedItem!.requestId!);

    if (result.item3?.data?.result == true) {
      emit(state.copyWith(photoStatus: BlocStatus.success));
    } else if (result.item3?.data?.result == false) {
      emit(state.copyWith(photoStatus: BlocStatus.success));
    } else {
      emit(state.copyWith(photoStatus: BlocStatus.failure));
    }

    return result.item3?.data?.result;
  }*/

  void checkPhoto() async {
    print("HEREE ${state.selectedItem!.requestId}");
    emit(state.copyWith(status: BlocStatus.download));

    Tuple3<bool?, String?, CheckUpdateClientPhoto?> result =
        await locator<HealthLicenseRepository>()
            .checkUpdatedPhoto(state.selectedItem!.requestId!);
    print(result);
    emit(state.copyWith(status: BlocStatus.success));

    if (result.item3?.data?.result == true) {
      add(ShareWalletItem(selectedIetm: state.selectedItem));
    } else if (result.item3 != null) {
      if (result.item3?.data?.responseCode == "2") {
        bool? isUpdated = await BottomSheetDialog.showDraggableSheet(
            NavigationService.navigatorKey.currentContext!,
            dialogKeyName: DialogName.healthCertificateUpdatePhotoActionsDialog,
            currentRouteName: RouteName.businessLicensePage,
            child: UpdateHealthCerificatePhotoDialog(
              onUpdated: () {},
              requestId: state.selectedItem!.requestId ?? 0,
              certificateUUID: state.selectedItem!.uuid!,
            ));

        if (isUpdated == true)
          add(ShareWalletItem(selectedIetm: state.selectedItem));
      }
    } else {
      CommonFunctions.showError(result.item2 ?? "");
    }
  }
}
