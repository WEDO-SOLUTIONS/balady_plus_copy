import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../_shared_feature_/shared_feature_exports.dart' show ElevatedButtonWidget;
import '../../bloc/events_bloc.dart';

class EventsFilterActions extends StatelessWidget {
  final EventsBloc requestsBloc;

  const EventsFilterActions({
    super.key,
    required this.requestsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: requestsBloc,
      child: Builder(builder: (context) {
        return Column(
          children: [
            ElevatedButtonWidget.apply(
              onPressed: () {
                /*  context.read<ViolationsBloc>().add(
                      ApplyViolationsFiltersEvent(),
                    );*/
                Navigator.pop(context, true);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.deletaAll(
              onPressed: () {
                /* context.read<ViolationsBloc>().add(
                      ClearViolationsFiltersEvent(),
                    );*/
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      }),
    );
  }
}
