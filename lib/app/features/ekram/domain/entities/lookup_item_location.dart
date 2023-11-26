import 'package:balady_plus/app/features/new_appointment/presentation/core/models/lookup_list_model.dart';

class LookUpItemLocation extends LookUpItem {
  String? laundryName;
  String? mosqueName;
  String? x;
  String? y;

  LookUpItemLocation(
      {super.id,
      super.name,
      this.laundryName,
      this.mosqueName,
      this.x,
      this.y});
}
