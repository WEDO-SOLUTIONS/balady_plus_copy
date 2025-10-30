import 'package:tuple/tuple.dart';

import '../../../../../../core/base/base_view_model.dart';
import '../repository/appointment_repository.dart';
/*
class NewAppointmentServiceViewModel extends BaseViewModel {
  final _repository = locator<AppointmentRepository>();
  RatingInfoResponse? ratingResponse;
  NewAppointmentServiceViewModel() {
    // getNewServiceRating();
  }
  Future<bool> getNewServiceRating() async {
    // showLoading();

    Tuple3<bool?, String?, RatingInfoResponse?> response =
        await _repository.getRatingInfo("1301");
    // hideLoading();
    if (response.item1 != null &&
        response.item1! &&
        response.item3?.data?.result != null) {
      ratingResponse = response.item3;
      notifyListeners();
      return true;
    } else {
      //  showError(response.item2 ?? "");
    }
    notifyListeners();
    return false;
  }
}
*/
