import 'package:flutter/material.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/pdf/core/image_path.dart';

import '../../../home/custom_app_bar.dart';
import '../../../home/text_item.dart';

class ScopeofApp extends StatelessWidget {
  const ScopeofApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        icon: ImagePath.arrowright,
        name: 'نطاق التطبيق',
        listicon: ImagePath.frame,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextItem(
                name: 'نطاق التطبيق',
                size: 17,
                desc:
                    'يتم تطبيق إصدار شهادة امتثال المباني على جميع المباني الواقعة على الشوارع التجارية المحددة في المستكشف الجغرافي لشهادة امتثال المباني في منصة بلدي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
