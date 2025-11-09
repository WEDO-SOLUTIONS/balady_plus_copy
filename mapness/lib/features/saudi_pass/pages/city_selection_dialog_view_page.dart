import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/views/city_selection_dialog_view.dart';
import 'package:mapness/features/saudi_pass/widgets/city_selection_dialog_view_widget.dart';

@RoutePage()
class CitySelectionDialogViewPage extends StatelessWidget {
  const CitySelectionDialogViewPage({required this.citySelectionDialogView, super.key});

  final CitySelectionDialogView citySelectionDialogView;

  @override
  Widget build(BuildContext context) => CitySelectionDialogViewWidget(citySelectionDialogView);
}
