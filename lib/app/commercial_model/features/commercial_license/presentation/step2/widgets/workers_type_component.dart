import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';

class WorkerTypeComponent extends StatelessWidget {
  const WorkerTypeComponent({
    super.key,
    required this.selectedWorkerType,
    required this.onSelectedType,
  });

  final WorkersTypes? selectedWorkerType;
  final Function(WorkersTypes type) onSelectedType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "step2WorkerType".tr(),
          style: AppStyle.mainTextSecondaryStyle.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColor.blackModern700Light),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            WorkerTypeItem(
              onTap: onSelectedType,
              workersType: WorkersTypes.men,
              selectedWorkersType: selectedWorkerType,
            ),
            const SizedBox(width: 8),
            WorkerTypeItem(
              onTap: onSelectedType,
              workersType: WorkersTypes.women,
              selectedWorkersType: selectedWorkerType,
            ),
            const SizedBox(width: 8),
            WorkerTypeItem(
              onTap: onSelectedType,
              workersType: WorkersTypes.menWomen,
              selectedWorkersType: selectedWorkerType,
            ),
          ],
        ),
      ],
    );
  }
}

class WorkerTypeItem extends StatelessWidget {
  const WorkerTypeItem({
    super.key,
    required this.onTap,
    required this.workersType,
    required this.selectedWorkersType,
  });

  final Function(WorkersTypes type) onTap;
  final WorkersTypes workersType;
  final WorkersTypes? selectedWorkersType;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(workersType),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: workersType == selectedWorkersType
                ? AppColor.primary900Light
                : AppColor.white,
          ),
          child: CustomTextWidget(
            workersType.name.tr(),
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            fontColor: workersType == selectedWorkersType
                ? AppColor.blackModern50Light
                : AppColor.blackModern600Light,
            fontSize: 14,
            textAlign: TextAlign.center,
            fontWeight: AppFontWeight.bold,
          ),
        ),
      ),
    );
  }
}
