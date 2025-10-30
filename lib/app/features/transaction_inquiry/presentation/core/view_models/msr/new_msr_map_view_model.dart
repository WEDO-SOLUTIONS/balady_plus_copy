import '../../../../../../core/base/base_view_model.dart';
import '../../../../data/general_inquiry_data.dart';
import '../../models/gis_location_result.dart';
import '../../models/selected_location.dart';
import '../../services/customer_voice_repository.dart';
import 'new_msr_view_model.dart';

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
