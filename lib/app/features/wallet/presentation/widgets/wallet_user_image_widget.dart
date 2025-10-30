import 'package:balady_plus/app/features/wallet/core/blocs/wallet_details/wallet_details_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/common_functions.dart';

class WalletUserImage extends StatelessWidget {
  const WalletUserImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletDetailsBloc, WalletDetailsState>(
        builder: (context, state) {
      if (state.selectedItem?.imageUrl != null &&
          state.selectedItem!.imageUrl!.isNotEmpty)
        return Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                state.selectedItem!.imageUrl!,
                fit: BoxFit.fill,
                headers: {
                  "Authorization": "Bearer " + (CommonProperties.token ?? "")
                },
              ),
            ));

      return Container();
    });
  }
}
