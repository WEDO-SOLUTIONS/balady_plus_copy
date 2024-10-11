import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/features/activities/bloc/activite_event.dart';
import '/app/features/activities/bloc/activite_state.dart';
import '/app/features/_shared_feature_/presentation/models/activite_model.dart';

class ActiviteBolc extends Bloc<ActiviteEvent, ActiviteState> {
  ActiviteBolc()
      : super(ActiviteState(popularList: [], normalList: [], activiteList: [
          ActiviteModel(
              id: "1",
              name: "محطات الوقود ومراكز الخدمة فئة أ 1",
              noOfActiveLicense: 13),
          ActiviteModel(
              id: "2",
              name: "محطات الوقود ومراكز الخدمة فئة أ 2 ",
              noOfActiveLicense: 14),
          ActiviteModel(
              id: "3",
              name: "محطة وقود داخل المدينة فئة د",
              noOfActiveLicense: 15),
          ActiviteModel(
            id: "4",
            name:
                " البيع بالتجزئة لوقود السيارات والدراجات النارية محطات الوقود  ",
            noOfActiveLicense: 12,
          ),
          ActiviteModel(
              id: "5", name: "محطة وقود صغيرة ج", noOfActiveLicense: 15),
        ])) {
    on<GetActiviteList>(_getAcitivites);
    add(GetActiviteList(id: "1"));
  }

  void _getAcitivites(GetActiviteList event, Emitter emit) {
    List<ActiviteModel> activiteList = state.activiteList;

    activiteList.sort((a, b) =>
        b.noOfActiveLicense?.compareTo(a.noOfActiveLicense ?? 0) ?? 0);

    List<ActiviteModel> firstList = activiteList.take(3).toList();
    List<ActiviteModel> secondList = activiteList.skip(3).toList();

    emit(state.copyWith(normalList: secondList, popularList: firstList));
  }
}
