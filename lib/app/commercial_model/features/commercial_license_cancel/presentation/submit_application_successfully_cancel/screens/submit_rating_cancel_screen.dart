import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/mvvm/submit_rating_view_model.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/widgets/submit_rating_sheet.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_cancel/presentation/submit_application_successfully_cancel/widgets/successfully_submit_rating_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitRatingCancelScreen extends StatelessWidget {
  const SubmitRatingCancelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SubmitRatingViewModel submitRatingViewModel =
        ModalRoute.of(context)!.settings.arguments as SubmitRatingViewModel;
    return ChangeNotifierProvider(
      create: (BuildContext context) => submitRatingViewModel,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: double.maxFinite),
                Image.asset(IconPath.like, width: 250, height: 250),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.zero,
                    color: Colors.grey.withOpacity(0.7),
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.zero,
                      color: Colors.grey.withOpacity(0.7),
                      width: double.maxFinite,
                      height: 100,
                    ),
                    Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(40)),
                      ),
                      margin: EdgeInsets.zero,
                      child: Selector<SubmitRatingViewModel, int?>(
                        selector: (_, provider) => provider.responseRating,
                        builder: (context, responseRating, child) {
                          return responseRating != null
                              ? const SuccessfullySubmitRatingSheet()
                              : const SubmitRatingSheet();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
