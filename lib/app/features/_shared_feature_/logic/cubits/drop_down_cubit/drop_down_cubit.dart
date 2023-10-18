import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;

import '../../../shared_feature_exports.dart' show DropDownItem;

class DropDownCubit extends Cubit<DropDownItem?> {
  final DropDownItem? initialValue;
  DropDownCubit({required this.initialValue}) : super(initialValue);

  void onChangeValue(DropDownItem? selectedItem) => emit(selectedItem);
}
