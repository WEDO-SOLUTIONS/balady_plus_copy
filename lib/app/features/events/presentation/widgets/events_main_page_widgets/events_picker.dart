import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/draggable_sheet_component.dart';
import 'package:flutter/material.dart';

class EventsPickerWidget extends StatelessWidget {
  const EventsPickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableSheetComponent(
      title: '',
      height: 0.85,
    
      body: Column(children: [
        Text('first'),
        Text('Second'),
      ]),
    );
  }
}
