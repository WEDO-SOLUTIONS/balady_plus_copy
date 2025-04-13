import 'package:app_popup_menu/app_popup_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../blocs/choose_muncipality_bloc.dart';
import '../../widget/choose_muncipality_widget.dart';

class ChooseMunicipalityScreen extends StatefulWidget {
  const ChooseMunicipalityScreen({Key? key}) : super(key: key);

  @override
  State<ChooseMunicipalityScreen> createState() => _ChooseMunicipalityScreenState();
}

class _ChooseMunicipalityScreenState extends State<ChooseMunicipalityScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChooseMuncipalityBloc, CertifiedObserverState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is ChooseMuncipalityState) {
          return Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ChooseMuncipalityWidget(),
                state.status == BlocRequestStatus.submissionGetLoading
                    ? const Center(child: CustomCircularLoadingWidget())
                    : Container()
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
