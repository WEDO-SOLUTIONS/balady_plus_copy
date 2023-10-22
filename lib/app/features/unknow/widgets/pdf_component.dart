import 'package:balady_plus/app/features/unknow/presentation/details_bloc/investment_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/utils_exports.dart';
import '../../_shared_feature_/shared_feature_exports.dart';
import '../../map_page/data/model/investment_details_response.dart';

class PDFComponent extends StatelessWidget {
  PDFComponent({
    super.key,
    this.pdfs,
  });

  List<ContractTemplate>? pdfs;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvestmentDetailsBloc, InvestmentDetailsState>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: AppColor.white,
          ),
          child: ListView.separated(
            itemCount: pdfs?.length ?? 0,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) => Container(
              width: MediaQuery.sizeOf(context).width,
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AppColor.primary50Light50,
              ),
              child: GestureDetector(
                onTap: () {
                  context.read<InvestmentDetailsBloc>().add(DownloadFileEvent(
                      fileKey: pdfs?[index].pxLinkedRefTo ?? ""));
                },
                child: Row(
                  children: [
                    const CustomSvgIconWidget(IconPath.pdf, iconSize: 24),
                    const SizedBox(width: 8),
                    CustomTextWidget(
                      pdfs?[index].pyMemo ?? "",
                      fontSize: 14,
                      fontWeight: AppFontWeight.bold,
                      fontColor: AppColor.blackModern500Light,
                    ),
                    const Spacer(),
                    const CustomSvgIconWidget(IconPath.download, iconSize: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
