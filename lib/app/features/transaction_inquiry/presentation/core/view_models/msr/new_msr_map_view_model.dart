/*import 'package:balady_new_app/app/core/base/base_view_model.dart';

import 'package:balady_new_app/app/core/core_exports.dart' show locator;
import 'package:balady_new_app/app/features/customer_voice/customer_voice_exports.dart'
    show
        CustomerVoiceRepository,
        GisLocationResult,
        NewMSRViewModel,
        SelectedLocation,
        CustomerVoiceReportTypeModel;

class NewMSRMapViewModel extends BaseViewModel {
  final _repositry = locator<CustomerVoiceRepository>();
  final dataModel = locator<NewMSRViewModel>();

  set gisLocation(GisLocationResult? data) => dataModel.gisLocation = data;
  GisLocationResult? get gisLocation => dataModel.gisLocation;

  set selectedLocation(SelectedLocation data) =>
      dataModel.selectedLocation = data;
  SelectedLocation get selectedLocation => dataModel.selectedLocation;

  set type(CustomerVoiceReportTypeModel data) => dataModel.type = data;

  void refresh() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    dataModel.resetAll();
  }

  void reset() {
    dataModel.resetAll();
  }
}
*/