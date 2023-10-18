import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils_exports.dart' show AppColor, IconPath;
import '../../../home_page/home_exports.dart' show HomeTag;
import '../../services_exports.dart'
    show ServiceCardEntity, ServiceCardsCubit, ServiceCardsState;

class ServiceCardsList extends StatelessWidget implements PreferredSizeWidget {
  final List<ServiceCardEntity> cards;

  const ServiceCardsList({
    super.key,
    required this.cards,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height,
      child: BlocBuilder<ServiceCardsCubit, ServiceCardsState>(
        builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: InkWell(
                  onTap: () =>
                      context.read<ServiceCardsCubit>().selectCard(card),
                  child: HomeTag(
                    title: card.title,
                    icon: IconPath.requests, //card.iconName,
                    color: AppColor.primary900Light,
                    selected: state.selectedCard == card,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
