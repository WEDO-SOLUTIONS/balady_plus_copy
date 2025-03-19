import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../../../../shared_features/widgets/custom_button.dart';

class NewOwnerData extends StatefulWidget {
  const NewOwnerData({super.key});

  @override
  State<NewOwnerData> createState() => _NewOwnerDataState();
}

class _NewOwnerDataState extends State<NewOwnerData> {
  TextEditingController idController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();

    idController.text =
        context.read<ManageMainFlowBloc>().state.newCRNumber ?? "";
  }

  // Function to show the date picker and update the selected date
  Future<void> _pickBirthday() async {
    DateTime initialDate = DateTime.now()
        .subtract(const Duration(days: 365 * 18)); // Default to 18 years ago
    DateTime firstDate = DateTime(1900); // Earliest date allowed
    DateTime lastDate = DateTime.now().subtract(
        const Duration(days: 365 * 15)); // Latest date allowed (current date)

    DateTime? selectedDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: firstDate,
        lastDate: lastDate,
        builder: (BuildContext context, Widget? child) {
          // Customizing the DatePicker appearance using ThemeData
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppColor.primary,
              buttonTheme: const ButtonThemeData(
                textTheme: ButtonTextTheme.primary,
              ),
              colorScheme: ColorScheme.light(primary: AppColor.primary),
              dialogBackgroundColor: AppColor.primary,
            ),
            child: child!,
          );
        });

    if (selectedDate != null && selectedDate != _selectedDate) {
      setState(() {
        _selectedDate = selectedDate; // Update the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
        builder: (context, state) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F6FB),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ما هي بيانات المالك الجديد ؟",
                  textAlign: TextAlign.center,
                  style: AppStyle.somarSemiBold
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  "ادخل بيانات المالك الجديد للرخصة",
                  textAlign: TextAlign.center,
                  style: AppStyle.textRegularStyle
                      .copyWith(color: AppColor.textSecondaryColor),
                ),
                const SizedBox(
                  height: 25,
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "رقم السجل التجاري",
                    style: AppStyle.textRegularStyle,
                  ),
                ),

                // TextField
                Stack(
                  children: [
                    TextField(
                        controller: idController,
                        onChanged: (String t) {
                          context
                              .read<ManageMainFlowBloc>()
                              .add(ChangeValueEvent(cr: t));
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.white,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 12.0),
                          hintText: 'ادخل رقم السجل التجاري',
                        )),
                    /* Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CustomButton(
                          onPress: () {


                          },
                          text: "تحقق",
                          btnWidth: 100,
                          btnHeight: 45,
                        ),
                      ),
                    )*/
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),
                /*  Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'تاريخ الميلاد',
                    style: AppStyle.textRegularStyle,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _pickBirthday();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Row(
                          children: [
                            Text(_selectedDate != null
                                ? " ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}"
                                : "2023/03/01"),
                            const SizedBox(
                              width: 30,
                            ),
                            Image.asset(IconPath.dateIcon),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 90,
                          height: 60,
                          child: Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.black),
                                  overlayColor: WidgetStateProperty.all<Color>(
                                      Colors.grey.withOpacity(0.2)),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "ميلادي",
                                  style: AppStyle.textRegularStyle
                                      .copyWith(fontSize: 16),
                                )),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          width: 90,
                          height: 60,
                          child: Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.white),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.black),
                                  overlayColor: WidgetStateProperty.all<Color>(
                                      Colors.grey.withOpacity(0.2)),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "هجري",
                                  style: AppStyle.textRegularStyle,
                                )),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'رقم الجوال',
                    style: AppStyle.textRegularStyle,
                  ),
                ),

                // TextField
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColor.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColor.textPrimaryColor,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: AppColor.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 12.0),
                    hintText: '05449922011',
                  ),
                  controller: phoneController,
                ),
            
            */
              ],
            ),
          ),
        ),
      );
    });
  }
}
