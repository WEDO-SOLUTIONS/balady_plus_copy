import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/utils/utils_exports.dart';
import '../../../_shared_feature_/shared_feature_exports.dart';
import '../bloc/weather_bloc.dart';
import 'alerts_modalsheet_contents.dart';

class WeatherAppbar extends StatelessWidget {
  const WeatherAppbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryPointCubit, EntryPointState>(
      builder: (context, entryState) {
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
                      ),
              ],
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: CustomTextWidget(
                entryState.userLocationGIS?.cityName ?? "",
                fontSize: 20,
                fontWeight: AppFontWeight.bold,
              ),
            );
          },
        );
      },
    );
  }
}
