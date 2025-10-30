import 'package:balady_plus/etmam_app/features/dynamic_form/domain/entities/bidding_form_params.dart';
import 'package:balady_plus/etmam_app/features/dynamic_form/presentation/blocs/bidding_type/bidding_type_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../app/core/dependency_injection/injection_container.dart';
import '../../../../../app/core/services/local/navigation_services.dart';
import '../../../../../app/core/utils/constants/route_names.dart';

class BiddingTypePage extends StatefulWidget {
  const BiddingTypePage({super.key});

  @override
  State<BiddingTypePage> createState() => _BiddingTypePageState();
}

class _BiddingTypePageState extends State<BiddingTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => BiddingTypeBloc(findByRequestType: sl()),
        child: BlocBuilder<BiddingTypeBloc, BiddingTypeState>(
          builder: (context, state) {
            return Container(
              child: Center(
                child: ListView.builder(
                    itemCount: state.releationResponse?.length ?? 0,
                    itemBuilder: (ctx, index) {
                      return GestureDetector(
                        onTap: () {
                          NavigationService.pushNamed(
                              routeName: EtmamRoutesNames.biddingForm,
                              args: BiddingFormParams(
                                  relation: state.releationResponse![index]));
                        },
                        child: Column(
                          children: [
                            Container(
                                child: Text(
                                    state.releationResponse?[index].name ??
                                        "")),
                          ],
                        ),
                      );
                    }),
              ),
            );
          },
        ),
      ),
    );
  }
}
