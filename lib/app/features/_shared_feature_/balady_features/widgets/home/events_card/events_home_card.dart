import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../events/domain/entities/search_events/search_events_item.dart';
import '../../../../../events/presentation/bloc/events_bloc.dart';
import '../../../../../events/presentation/bloc/events_event.dart';
import '../../../../../events/presentation/bloc/events_state.dart';
import '../../../../presentation/widgets/custom_shimmer_list_widget.dart';
import 'events_item_card.dart';

class EventsHomeCard extends StatelessWidget {
  const EventsHomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<EventsBloc>(),
      child: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state.status == BlocStatus.loading) {
            return const CustomShimmerWidget(
              childHeight: 201,
            );
          }
          if (state.status == BlocStatus.failure) {
            return RetryWidget(
              onRetry: () {
                context.read<EventsBloc>().add(const GetSearchEvent());
              },
            );
          }

          SearchEventsItem? item = state.searchItems.firstOrNull;
          if (item == null) return Container();

          return Column(
            //   mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'events'.tr(),
                      style: Theme.of(context)
                          .extension<ThemeTextStyles>()
                          ?.accentL
                          .copyWith(color: const Color(0xFF1E2A36)),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigatorKey.currentState!
                            .pushNamed(RouteName.eventsMainPage);
                      },
                      child: Text(
                        "show_all".tr(),
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()
                            ?.accentS
                            .copyWith(
                              color: const Color(0xFF1E2A36).withOpacity(0.5),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: ((state.searchItems.length) > 4)
                      ? 4
                      : state.searchItems.length,
                  padding: const EdgeInsets.only(
                    left: 16,
                  ),
                  itemBuilder: (context, index) {
                    return EventItemCard(
                      width: MediaQuery.of(context).size.width - 60,
                      padding: const EdgeInsets.only(right: 16),
                      item: state.searchItems[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
