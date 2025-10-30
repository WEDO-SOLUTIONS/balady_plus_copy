import 'package:flutter/material.dart';
import '/app/features/map/presentation/widgets/address.dart';
import '/app/features/map/presentation/widgets/allowed_tag.dart';
import '/app/features/map/presentation/widgets/notallowed.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';

class DetermineLocation extends StatelessWidget {
  const DetermineLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: "تحديد موقع العمل ؟"),
        body: Container(
          child: Stack(
            children: [
              Image.asset(
                "packages/smart_advisor/smart_advisor_assets/images/map.png",
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              ),
              const Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Textfield(),
              ),
              const Positioned(
                top: 470,
                left: 10,
                child: Column(
                  children: [
                    const Notallowed(),
                    SizedBox(
                      height: 5,
                    ),
                    const AllowedTag(),
                  ],
                ),
              ),
              const Align(alignment: Alignment.bottomCenter, child: Address())
            ],
          ),
        ),
      ),
    );
  }
}
