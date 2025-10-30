import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/my_orders/domain/entities/request_offers_page_params.dart';
import 'package:flutter/material.dart';

import '../../../_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';

class DeleteOrdersPage extends StatelessWidget {
  const DeleteOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: trans("delete_services"), withCloseImg: true),
    );
  }
}
