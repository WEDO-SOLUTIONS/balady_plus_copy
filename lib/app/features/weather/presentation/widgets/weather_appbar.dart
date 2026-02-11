import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/presentation/buttons/circular_container_icon_button.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../bloc/weather_bloc.dart';
import 'alerts_modalsheet_contents.dart';

class WeatherAppbar extends StatelessWidget {
  const WeatherAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherBloc, WeatherState>(
      builder: (context, state) {
        return AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.close,
            ),
          ),
          actions: [
            state.allWeatherInfo?.alerts?.alert?.isEmpty ?? true
                ? const SizedBox()
                : InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                            // <-- SEE HERE
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(32.0),
                            ),
                          ),
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => BlocProvider.value(
                                value: context.read<WeatherBloc>(),
                                child: const AlertsModalSheetContent(),
                              ));
                    },
                    child: const CircularContainerForIcons(
                      iconPath: IconPath.danger,
                      width: 48,
                      height: 48,
                    ),
                  ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: CustomTextWidget(
            state.gisResponse?.cityName ?? "",
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
          ),
        );
      },
    );
  }
}
