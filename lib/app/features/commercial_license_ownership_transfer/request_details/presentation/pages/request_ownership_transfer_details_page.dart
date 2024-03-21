import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/data/data_sources/remote_data_source.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/data/repositories/repository_implementation.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/domain/use_cases/get_request_ownership_transfer_details.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/bloc/request_ownership_transfer_details_cubit.dart';
import 'package:balady_plus/app/features/commercial_license_ownership_transfer/request_details/presentation/widgets/request_ownership_transfer_details_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class RequestOwnershipTransferDetailsPage extends StatefulWidget {
  const RequestOwnershipTransferDetailsPage({super.key});

  @override
  State<RequestOwnershipTransferDetailsPage> createState() =>
      _RequestOwnershipTransferDetailsPageState();
}

class _RequestOwnershipTransferDetailsPageState
    extends State<RequestOwnershipTransferDetailsPage> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.openLicensesDetails);
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context)!.settings.arguments as Map;
   String requestNumber = data['requestNumber'];
    return BlocProvider(
      create: (context) =>
          RequestOwnershipTransferDetailsCubit(
            GetRequestOwnershipTransferDetails(
            repository: RequestOwnershipTransferRepositoryImplementation(
              remoteDataSource: RequestOwnershipTransferRemoteDataSourceImplementation(
                webService: sl(),
              ),
            ),
          ),
            requestNumber,
        ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.scaffoldBackground,
          elevation: 0,
          shadowColor: AppColor.primary100Light,
          centerTitle: false,
          // leadingWidth: showBack == true ? null : 8,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomTextWidget(
                "requests".tr(),
                fontSize: 20,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: AppFontWeight.bold,
                fontColor: AppColor.blackModern700Light,
              ),
              CustomTextWidget(
                "#$requestNumber",
                fontSize: 14,
                maxLines: 1,
                textOverflow: TextOverflow.ellipsis,
                fontWeight: AppFontWeight.medium,
                fontColor: AppColor.blackModern700Light,
              ),
            ],
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColor.blackModern900Light,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(16),
          child: RequestOwnershipTransferDetailsBody(),
        ),
      ),
    );
  }
}
