/*
class CompassCalibration extends StatefulWidget {
  const CompassCalibration({super.key});

  @override
  State<CompassCalibration> createState() => _CompassCalibrationState();
}

class _CompassCalibrationState extends State<CompassCalibration> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container( 
      height: 400,
      decoration: BoxDecoration(color: AppColor.white),
      child: Column(
        children: [
          CustomTextWidget(
            "ضبط البوصلة",
            fontColor: AppColor.blackModern500Light,
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
          ),
          CustomVerticalSpace(height: 16),
          CustomTextWidget(
            "حرك جوالك ثلاث مرات كما في الصورة",
            fontColor: AppColor.blackModern500Light,
            fontSize: 20,
            fontWeight: AppFontWeight.bold,
          ),
          CustomVerticalSpace(height: 16),
          Builder(builder: (context) {
            return StreamBuilder<CompassEvent>(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error reading heading: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                double? direction = snapshot.data!.heading;
                double? accuracy = snapshot.data!.accuracy;

                // if direction is null, then device does not support this sensor
                // show error message
                if (direction == null)
                  return Center(
                    child: Text("Device does not have sensors !"),
                  );

                return Row(
                  children: [
                    CustomTextWidget(
                      "دقة البوصة: ",
                      fontColor: AppColor.blackModern500Light,
                      fontSize: 20,
                      fontWeight: AppFontWeight.bold,
                    ),
                    CustomTextWidget(
                      "$accuracy",
                      fontColor: AppColor.blackModern500Light,
                      fontSize: 20,
                      fontWeight: AppFontWeight.bold,
                    ),
                  ],
                );
              },
            );
          })
        ],
      ),
    );
  }
}

enum compassCalibration { low, medium, high }
*/
