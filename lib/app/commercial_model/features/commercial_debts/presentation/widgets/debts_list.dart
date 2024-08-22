import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/widgets/debts_list_item.dart';
import 'package:flutter/material.dart';

class DebtsList extends StatefulWidget {
  const DebtsList({super.key});

  @override
  State<DebtsList> createState() => _DebtsListState();
}

class _DebtsListState extends State<DebtsList> {
    final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
           return ListView.builder(
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: 3,
            itemBuilder: (context, index) {
  
              return DebtsListItem(
              );
            },
          );;
  }
}