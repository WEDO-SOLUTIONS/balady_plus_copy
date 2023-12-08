import 'package:balady_plus/etmam_app/features/home/home_exports.dart'
    show SubServiceResponse;

class SubServicePageArgs {
  SubServicePageArgs({
    this.mainServiceName,
    required this.subServiceResponse,
  });

  String? mainServiceName;
  SubServiceResponse subServiceResponse;
}
