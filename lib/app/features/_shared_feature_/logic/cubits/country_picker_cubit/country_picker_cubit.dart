import 'package:flutter_bloc/flutter_bloc.dart' show Cubit;
import 'package:country_picker/country_picker.dart' show Country;

class CountryPickerCubit extends Cubit<Country?> {
  final Country? initialValue;
  CountryPickerCubit({required this.initialValue}) : super(initialValue);

  void onChangeValue(Country? selectedItem) => emit(selectedItem);
}
