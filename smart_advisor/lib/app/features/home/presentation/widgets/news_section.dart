import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/home/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_shared_feature_/presentation/widgets/shimmer_card.dart';

class NewsSection extends StatelessWidget {
  const NewsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.newsStatus != current.newsStatus,
        builder: (context, state) {
          return Column(
            children: [
              if (state.newsStatus.isSuccess)
                SizedBox(
                  height: 254,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.newsResponse?.data?.dataList?.length ?? 0,
                    itemBuilder: (_, index) => NewsCard(
                      item: state.newsResponse?.data?.dataList![index],
                    ),
                  ),
                ),
              if (state.newsStatus.isLoading) const ShimmerHorizontalList(),
              if (state.newsStatus.isFailure)
                ReloadWidget(onTab: () {
                  context.read<HomeBloc>().add(const GetNews());
                })
            ],
          );
        });
  }
}
