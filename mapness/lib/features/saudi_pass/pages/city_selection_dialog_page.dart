import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/saudi_pass/views/city_selection_dialog.dart';
import 'package:mapness/features/saudi_pass/widgets/city_selection_dialog_widget.dart';

@RoutePage()
class CitySelectionDialogPage extends StatelessWidget {
  const CitySelectionDialogPage({required this.citySelectionDialog, super.key});

  final CitySelectionDialog citySelectionDialog;

  @override
  Widget build(BuildContext context) => CitySelectionDialogWidget(citySelectionDialog);
}
