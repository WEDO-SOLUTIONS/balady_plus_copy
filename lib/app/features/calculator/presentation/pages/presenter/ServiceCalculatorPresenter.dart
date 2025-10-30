import 'package:balady_plus/app/features/calculator/data/model/request/CalculateCost.dart';
import 'package:balady_plus/app/features/calculator/data/model/request/CalculateCostV03.dart';
import 'package:balady_plus/app/features/calculator/data/model/request/CalculateDiggingCost.dart';
import 'package:balady_plus/app/features/calculator/data/model/request/CalculateRenewDiggingCost.dart';
import 'package:balady_plus/app/features/calculator/presentation/pages/repository/ServiceCalculatorRepository.dart';
import 'package:balady_plus/app/features/calculator/presentation/pages/service_calculator_screen.dart';
import 'package:dgis_map/library.dart';

import '../../../../../core/services/local/helpers.dart';
import '../contract/ServiceCalculatorContract.dart';

class ServiceCalculatorPresenter extends IServviceCalculatorPresenter {
  ServiceCalculatorRepository _serviceCalculatorRepository =
      ServiceCalculatorRepository();

  ServiceCalculatorPresenter() {
    //  this._serviceCalculatorRepository = ServiceCalculatorRepository();
  }

  @override
  void getServicesListlookup() {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.

    print(getView());
    if (isViewAttached) getView()?.showLoading();
    this._serviceCalculatorRepository.getServicesListlookup().then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();

        if (value != null) {
          getView()?.getServicesListlookupSuccess(value);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getServicesListlookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");
      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getServicesListlookupFailed();
      }
    });
  }

  @override
  void getProceduresListlookup(int serviceId) {
    if (isViewAttached) getView()?.showLoading();
    this
        ._serviceCalculatorRepository
        .getProceduresListlookup(serviceId)
        .then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getProceduresListlookupSuccess(value);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getServicesListlookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getProceduresListlookupFailed();
      }
    });
  }

  @override
  void getDetailedIsicActivityListlookup(
      int isicActivityId, ActivityIsicListDetailType type) {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.

    if (isViewAttached) getView()?.showLoading();
    this
        ._serviceCalculatorRepository
        .getDetialedIsicActivitieslookup(isicActivityId)
        .then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getDetailedIsicActivityListlookupSuccess(value, type);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getServicesListlookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getDetailedIsicActivityListlookupFailed();
      }
    });
  }

  @override
  void getDetailedActivitylookup(int activityId, ActivityDetailType type) {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.

    if (isViewAttached) getView()?.showLoading();
    this
        ._serviceCalculatorRepository
        .getDetialedActivitiylookup(activityId)
        .then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getDetailedActivitylookupSuccess(value, type);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getServicesListlookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getDetailedActivitylookupFailed();
      }
    });
  }

  @override
  void getZoneslookup() {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.

    if (isViewAttached) getView()?.showLoading();
    this._serviceCalculatorRepository.getZoneslookup().then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getZoneslookupSuccess(value);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getZoneslookupFailed();
        }
      }
    }).catchError((error) {
      print(error);
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getZoneslookupFailed();
      }
    });
  }

  @override
  void getBoardListlookup() {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.

    if (isViewAttached) getView()?.showLoading();
    this._serviceCalculatorRepository.getBoardList().then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getBoardListlookupSuccess(value);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getBoardListlookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getBoardListlookupFailed();
      }
    });
  }

  @override
  void getAccomodationlookup() {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.
    if (isViewAttached) getView()?.showLoading();
    this._serviceCalculatorRepository.getAccommodationTypes().then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getAccomodationlookupSuccess(value);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getAccomodationlookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getAccomodationlookupFailed();
      }
    });
  }

  @override
  void getIsicActivitieslookup() {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.
    if (isViewAttached) getView()?.showLoading();
    this._serviceCalculatorRepository.getIsicActivitieslookup().then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getIsicActivitieslookupSuccess(value);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getIsicActivitieslookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getIsicActivitieslookupFailed();
      }
    });
  }

  @override
  void getSubActivitieslookup(int procedureid) {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.
    if (isViewAttached) getView()?.showLoading();
    this
        ._serviceCalculatorRepository
        .getSubActivitiesList(procedureid)
        .then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getSubActivitieslookupSuccess(value);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getSubActivitieslookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getSubActivitieslookupFailed();
      }
    });
  }

  @override
  void getCityIdlookup(String subMunicipalityId) {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.
    if (isViewAttached) getView()?.showLoading();
    this
        ._serviceCalculatorRepository
        .getCityId(subMunicipalityId)
        .then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null) {
          getView()?.getCityIdlookupSuccess(value);
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getCityIdlookupFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getCityIdlookupFailed();
      }
    });
  }

  @override
  void calculateV03(CalculateCostV03 request) {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.
    if (isViewAttached) getView()?.showLoading();
    this._serviceCalculatorRepository.calculateCostV03(request).then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value.statusCode == 200 && value != null) {
          getView()?.calculateV03Success(value);
        } else {
          String error = " ";

          if (value.errorList != null && value.errorList!.isNotEmpty)
            error = value.errorList![0];
          else if (value.statusName != null && (value.statusName!.isNotEmpty))
            error = value.statusName!;

          getView()?.showError(error);
          getView()?.calculateV03Failed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.calculateV03Failed();
      }
    });
  }

  @override
  void calculateCost(CalculateCost request) {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.

    if (isViewAttached) getView()?.showLoading();
    this._serviceCalculatorRepository.calculteCost(request).then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();

        if (value.statusCode == 200 && value != null) {
          getView()?.calculateCostSuccess(value);
        } else {
          String error = " ";
          if (value.errorList != null && value.errorList!.isNotEmpty)
            error = value.errorList![0];
          else if (value.errorDetails != null &&
              (value.errorDetails!.isNotEmpty)) error = value.errorDetails!;

          getView()?.showError(error);
          getView()?.calculateCostFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.calculateCostFailed();
      }
    });
  }

  @override
  void calculateDiggingCost(CalculateDiggingCost request) {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.

    if (isViewAttached) getView()?.showLoading();
    this
        ._serviceCalculatorRepository
        .calculteDiggingCost(request)
        .then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value.statusCode == 200 && value != null) {
          getView()?.calculateDiggingCostSuccess(value);
        } else {
          String error = " ";
          if (value.errorList != null && value.errorList!.isNotEmpty)
            error = value.errorList![0];
          else if (value.errorDetails != null &&
              (value.errorDetails!.isNotEmpty)) error = value.errorDetails!;

          getView()?.showError(error);
          getView()?.calculateDiggingCostFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.calculateDiggingCostFailed();
      }
    });
  }

  @override
  void calculatRenewDiggingCost(CalculateRenewDiggingCost request) {
    // Here I load the data to the view who implements the contract.
    // You Must Explicitly call this function from the view to load data.
    if (isViewAttached) getView()?.showLoading();
    this
        ._serviceCalculatorRepository
        .calculteRenewDiggingCost(request)
        .then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value.statusCode == 200 && value != null) {
          getView()?.calculatRenewDiggingCostSuccess(value);
        } else {
          String error = " ";
          if (value.errorList != null && value.errorList!.isNotEmpty)
            error = value.errorList?[0] ?? "";
          else if (value.errorDetails != null &&
              (value.errorDetails?.isNotEmpty ?? false))
            error = value.errorDetails ?? "";
          getView()?.showError(error);
          getView()?.calculatRenewDiggingCostFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.calculatRenewDiggingCostFailed();
      }
    });
  }

  @override
  void getGpsLocation(LatLng latLng) {
    if (isViewAttached) getView()?.showLoading();
    this._serviceCalculatorRepository.getGpsLocation(latLng).then((value) {
      if (isViewAttached) {
        getView()?.hideLoading();
        if (value != null && (value.isSuccessfull ?? false)) {
          getView()?.getGpsLocationSuccess(value);
          if (value.sub_Municipalityguid == null) {
            getView()?.showError(Helpers.translatingWord("gis_error_1"));
          }
        } else {
          String error = Helpers.translatingWord("server_error_1");
          getView()?.showError(error);
          getView()?.getGpsLocationFailed();
        }
      }
    }).catchError((error) {
      String msg = Helpers.translatingWord("server_error_1");

      if (error is APIException) {
        msg = Helpers.translatingWord("errors_server_error_2");
      }

      if (isViewAttached) {
        getView()?.hideLoading();
        getView()?.showError(msg);
        getView()?.getGpsLocationFailed();
      }
    });
  }
}

class APIException implements Exception {
  dynamic exception;
  String? apiPath;
  String? fullPath;

  APIException({this.apiPath, this.exception, this.fullPath});
}
