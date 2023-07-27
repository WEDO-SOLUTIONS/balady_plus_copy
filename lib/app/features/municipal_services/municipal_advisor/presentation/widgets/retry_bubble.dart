import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/retry_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/utils_exports.dart';
import '../../municipal_advisor_exports.dart';

class RetryBubble extends StatelessWidget {
  const RetryBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.bottomEnd,
      child: Container(
        padding: const EdgeInsets.all(12),
        width: 200,
        margin: const EdgeInsetsDirectional.only(
          end: 8,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: AppColor.primary100Light,
          borderRadius: const BorderRadiusDirectional.only(
            topEnd: Radius.circular(10),
            topStart: Radius.circular(10),
            bottomStart: Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.black.withOpacity(0.03),
              blurRadius: 18,
              offset: const Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: RetryWidget(
          height: 20,
          onRetry: () {
            context.read<MunicipalAdvisorBloc>().add(
                  MunicipalAdvisorRetryEvent(),
                );
          },
        ),
      ),
    );
  }
}
