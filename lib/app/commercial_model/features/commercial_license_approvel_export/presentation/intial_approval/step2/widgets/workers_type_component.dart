import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../data/models/initialApproval/sub_activity_details_data.dart';


class WorkerTypeComponent extends StatelessWidget {
  const WorkerTypeComponent({
    super.key,
     this.selectedWorkerType,
    required this.onSelectedType,
    this.lstWorkerTypes,
  });

  final WorkerTypes? selectedWorkerType;
  final Function(WorkerTypes type) onSelectedType;
  final List<WorkerTypes>? lstWorkerTypes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "step2WorkerType_quest".tr(),
          style: AppStyle.mainTextSecondaryStyle.copyWith(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: AppColor.blackModern700Light),
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 40,
          child: ListView.builder(
            itemCount: lstWorkerTypes?.length??0,
             scrollDirection :Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {


              return WorkerTypeItem(
                onTap: onSelectedType,
                workersType: lstWorkerTypes![index],
                selectedWorkersType: selectedWorkerType,
              );
            },
          ),
        )

        // Row(
        //   children: [
        //     WorkerTypeItem(
        //       onTap: onSelectedType,
        //       workersType: WorkersTypes.men,
        //       selectedWorkersType: selectedWorkerType,
        //     ),
        //     const SizedBox(width: 8),
        //     WorkerTypeItem(
        //       onTap: onSelectedType,
        //       workersType: WorkersTypes.women,
        //       selectedWorkersType: selectedWorkerType,
        //     ),
        //     const SizedBox(width: 8),
        //     WorkerTypeItem(
        //       onTap: onSelectedType,
        //       workersType: WorkersTypes.menWomen,
        //       selectedWorkersType: selectedWorkerType,
        //     ),
        //   ],
        // ),
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

  final Function(WorkerTypes type) onTap;
  final WorkerTypes workersType;
  final WorkerTypes? selectedWorkersType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(workersType),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        //padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: workersType.id == selectedWorkersType?.id
              ? AppColor.primary900Light
              : AppColor.white,
        ),

        child: Center(
          child: CustomTextWidget(
            workersType.name??"",
            maxLines: 3,
            textOverflow: TextOverflow.ellipsis,
            fontColor: workersType.id == selectedWorkersType?.id
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
