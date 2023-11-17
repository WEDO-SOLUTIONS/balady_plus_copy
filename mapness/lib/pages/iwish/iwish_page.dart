import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IwishPage extends ConsumerWidget {
  const IwishPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final markers = ref.watch(iwishMarkersProvider);

    return const Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // const IwishCarousel(),
        // IwishPlaceCard(iwishId: markers.first.id),
        // IwishFeedback(iwishId: markers.first.id),
        // IwishFeedbackComment(
        //   onClose: () {},
        //   onSubmit: (String? comment) {},
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     IwishCardRoute(iwishId: markers.first.id).push(context);
        //   },
        //   child: Text('card'),
        // ),
        // ElevatedButton(
        //   onPressed: () {
        //     IwishFeedbackRoute(iwishId: markers.first.id).push(context);
        //   },
        //   child: Text('feedback'),
        // ),
      ],
    );
  }
}
