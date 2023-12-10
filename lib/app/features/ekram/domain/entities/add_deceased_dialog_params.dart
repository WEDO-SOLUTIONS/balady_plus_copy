import 'package:balady_plus/app/features/ekram/data/model/apply_deceased/deceased_info_dto.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';

class AddDeceasedDialogParams {
  final List<LookUpItem>? nationalities;
  final List<LookUpItem>? cities;
  final DeceasedInfoDto data;
  final LookUpItem? deathCity;

  AddDeceasedDialogParams(
      {this.cities, required this.data, this.nationalities, this.deathCity});
}
