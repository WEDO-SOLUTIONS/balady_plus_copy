import 'package:balady_plus/app/core/services/services_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart'
    hide PickerItem;
import 'package:balady_plus/app/features/calculator/core/calculator_location_view_model.dart';
import 'package:balady_plus/app/features/calculator/presentation/base.dart';
import 'package:balady_plus/app/features/calculator/presentation/pages/contract/ServiceCalculatorContract.dart';
import 'package:balady_plus/app/features/calculator/presentation/pages/drop_down_menu.dart';
import 'package:balady_plus/app/features/calculator/presentation/pages/presenter/ServiceCalculatorPresenter.dart';
import 'package:balady_plus/app/features/calculator/service_calculator_exports.dart'
    show
        BoardList,
        CalculateCost,
        CalculateCostResponse,
        CalculateCostV03,
        CalculateCostV03Response,
        CalculateDiggingCost,
        CalculateDiggingResponse,
        CalculateRenewDiggingCost,
        DetailedActivity,
        IsicActivity,
        Item,
        Municipality,
        Procedure,
        SearchItem,
        ServiceCalculatorResultScreen,
        SideWalkList,
        SubActivity;
import 'package:balady_plus/app/features/transaction_inquiry/presentation/pages/inquiry/transactions_inquiry/hijri_picker.dart'
    as HijriPicker hide PickerItem;
import 'package:collection/collection.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/dialog_names.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../../_shared_feature_/presentation/dialogs/incident_type_with_search_dialog.dart';
import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_tooltip_widget.dart';
import '../../../home_page/presentation/widgets/home_app_bar/circle_icon.dart';
import '../../../transaction_inquiry/presentation/core/models/gis_location_result.dart';
import '../../data/model/calculator_results_page_params.dart';
import 'add_board_screen.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';

enum ActivityIsicListDetailType { Normal, Current, New }

enum ActivityDetailType { Normal, Current, New }

class ServiceCalculatorScreen extends StatefulWidget {
  const ServiceCalculatorScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ServiceCalculatorScreenState createState() =>
      _ServiceCalculatorScreenState();
}

class _ServiceCalculatorScreenState extends BaseState<ServiceCalculatorScreen,
        IServviceCalculatorPresenter, IServiceCalculatorView>
    with SingleTickerProviderStateMixin
    implements IServiceCalculatorView {
  List<BoardList>? _boards = [];
  List<BoardList>? _newBoards = [];
  List<BoardList>? _currentBoards = [];
  List<Item> _serviceTypes = [];
  List<IsicActivity>? _isicActivites = [];
  List<Item> _detailedIsicActivites = [];
  List<Item> _detailedIsicActivitesCurrent = [];
  List<Item> _detailedIsicActivitesNew = [];
  List<Procedure> _procedures = [];
  List<Municipality> _zones = [];
  List<Municipality> _shownZones = [];
  List<SubActivity> _subActivities = [];
  List<Item> _accomodations = [];
  List<Item> _boardList = [];

  bool _isButtonDisabled = true;
  SubActivity? _serviceSubActivityController;

  Item? _serviceTypeController;
  Procedure? _serviceProcedureController;
  IsicActivity? _serviceIsicActivityController;
  IsicActivity? _serviceIsicActivityCurrentController;
  IsicActivity? _serviceIsicActivityNewController;

  Item? _serviceDetailedIsicActivityController;
  Item? _serviceDetailedIsicActivityCurrentController;
  Item? _serviceDetailedIsicActivityNewController;

  int _serviceCityIdController = 0;

  DetailedActivity? _serviceDetailedActivityController;
  DetailedActivity? _serviceDetailedActivityCurrentController;
  DetailedActivity? _serviceDetailedActivityNewController;

  Municipality? _serviceZoneController;
  Item? _serviceAccomodationController;

  Municipality? _serviceZoneCurrentController;

  Item? _serviceAccomodationCurrentController;
  Item? _serviceAccomodationNewController;

  bool _isValidServiceType = true;
  bool _isValidProcedure = true;
  bool _isValidIsicActivity = true;
  bool _isValidIsicActivityCurrent = true;
  bool _isValidIsicActivityNew = true;
  bool _isValidDetailedIsicActivity = true;
  bool _isValidDetailedIsicActivityCurrent = true;
  bool _isValidDetailedIsicActivityNew = true;

  String _serviceRegionErrMsg = "";
  String _serviceMunicipalitiesErrMsg = "";
  String _serviceTypeErrMsg = "";
  int _selectedServiceId = 0;
  int _selectedActionId = 0;
  bool _isValidZone = true;
  bool _isValidAccomodation = true;
  bool _isValidZoneCurrent = true;
  bool _isValidAccomodationCurrent = true;
  bool _isValidAccomodationNew = true;

  var _userLocation;
  var _userAddress;
  var _showManuciplility = false;

  GisLocationResult? _gisLocation;

  var scrollController = ScrollController();

  var _costOfPreviousLicenseController = TextEditingController();
  var _previousLicenseTermController = TextEditingController();
  var _lengthOfHoleController = TextEditingController();
  var _lengthOfPreviuosHoleController = TextEditingController();
  var _termOfNewLicenseController = TextEditingController();
  var _areaController = TextEditingController();
  var _paymentEndDateController = TextEditingController();
  var _currentSpaceController = TextEditingController();
  var _newSpaceController = TextEditingController();
  var _numberOfCertificatesController = TextEditingController();
  var _certificatesEndDateController = TextEditingController();
  var _numberOfDrillingDaysController = TextEditingController();
  var _numberOfWorkingDaysController = TextEditingController();

  var _distanceController = TextEditingController();
  var _numberOfDocumentsController = TextEditingController();

  var _portLicenseDays = TextEditingController();

  var _portRental = TextEditingController();

  var _costOfPreviousLicenseFocusNode = FocusNode();
  var _previousLicenseTermFocusNode = FocusNode();
  var _lengthOfHoleFocusNode = FocusNode();
  var _lengthOfPreviuosFocusNode = FocusNode();
  var _termOfNewLicenseFocusNode = FocusNode();
  var _areaFocusNode = FocusNode();
  var _currentSpaceFocusNode = FocusNode();
  var _newSpaceFocusNode = FocusNode();
  var _numberOfCertificatesFocusNode = FocusNode();
  var _certificatesEndDateFocusNode = FocusNode();
  var _numberOfDrillingDaysFocusNode = FocusNode();
  var _numberOfWorkingDaysFocusNode = FocusNode();

  var _distanceFocusNode = FocusNode();
  var _numberOfDocumentsFocusNode = FocusNode();

  var _portLicenseDaysFocusNode = FocusNode();

  var _portRentalFocusNode = FocusNode();

  GlobalKey _costOfPreviousLicenseControllerKey = GlobalKey();
  GlobalKey _previousLicenseTermControllerKey = GlobalKey();
  GlobalKey _lengthOfHoleControllerKey = GlobalKey();
  GlobalKey _lengthOfPreviuosControllerKey = GlobalKey();
  GlobalKey _termOfNewLicenseControllerKey = GlobalKey();

  bool isValidCostOfPreviousLicense = true;
  bool isValidPreviousLicenseTerm = true;
  bool isValidLengthOfHole = true;
  bool isValidPreviuosLengthOfHole = true;
  bool isValidTermOfNewLicense = true;
  bool isValidArea = true;
  bool isValidPaymentEndDate = true;
  bool isValidCurrentSpace = true;
  bool isValidCurrentPanelType = true;
  bool isValidCurrentPlateSpace = true;
  bool isValidNewSpace = true;
  bool isValidNumberOfCertificates = true;
  bool isValidNumberOfDrillingDays = true;
  bool isValidNumberOfWorkingDays = true;
  bool isValidDistance = true;
  bool isValidNumberOfDocuments = true;
  bool isValidCertificatesEndDate = true;
  bool isValidServiceActivity = true;

  bool isValidLicenseDays = true;
  bool isValidRental = true;

  String? _CostOfPreviousLicenseErrMsg = "";
  String? _PreviousLicenseTermErrMsg = "";
  String? _LengthOfHoleErrMsg = "";
  String? _LengthOPreviousfHoleErrMsg = "";

  String? _TermOfNewLicenseErrMsg = "";
  String? _AreaErrMsg = "";

  String? _PaymentEndDateErrMsg = "";
  String? _CurrentSpaceErrMsg = "";
  String? _NewSpaceErrMsg = "";
  String? _NumberOfCertificatesErrMsg = "";
  String? _NumberOfDrillingDaysErrMsg = "";
  String? _NumberOfWorkingDaysErrMsg = "";
  String? _DistanceErrMsg = "";
  String? _NumberOfDocumentsErrMsg = "";
  String? _CertificatesEndDateErrMsg = "";

  int _IsThereCleaningContractValue = 1;
  int _isThereCleaningContractCurrentValue = 1;
  int _isThereCleaningContractNewValue = 1;

  int? currentActivityId;
  int? currentactionId;

  final model = locator<CalculatorLocationViewModel>();
  @override
  void initState() {
    super.initState();
    // _getCurrentUserLocation();
    _gisLocation = model.gisLocation;
    /* presenter?.getServicesListlookup();
    presenter?.getIsicActivitieslookup();
    presenter?.getAccomodationlookup();
    presenter?.getZoneslookup();
    presenter?.getBoardListlookup();*/
    getServicesListlookupSuccess(model.serviceTypes);
    getIsicActivitieslookupSuccess(model.isicActivites);
    getAccomodationlookupSuccess(model.accomodations);
    getZoneslookupSuccess(model.zones);
    getBoardListlookupSuccess(model.boardList);
    _serviceCityIdController = model.cityId;

    //MM Helpers.sendEventToAnalytics(AppEvents.Calculator_details);

    CommonFunctions.sendEventToAnalytics(AppEvents.calculator);
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceFeesCalculator);
  }

  @override
  Widget buildScreen(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          elevation: 0,
          leadingWidth: 200,
          leading: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              NavigationService.navigatorKey.currentState?.pop();
            },
            child: Container(
              margin: const EdgeInsetsDirectional.only(start: 10),
              child: Row(
                children: [
                  CustomTextIconButtonWidget(
                    text: ('back').tr(),
                    icon: SvgPicture.asset(IconPath.vdAppBarBack),
                    iconTextTweenSpace: 5,
                    textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColor.blackModern700Light,
                        fontFamily: Constants.appFontType),
                    onPressed: () {
                      NavigationService.navigatorKey.currentState?.pop();
                    },
                  ),
                ],
              ),
            ),
          ),
          // leadingWidth: 32,
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: InkWell(
                onTap: () {
                  NavigationService.navigatorKey.currentState?.pop();
                },
                child: CircleIcon(
                  icon: Icons.close,
                  iconColor: AppColor.primary600Light,
                  backgroundColor: AppColor.geyser.withOpacity(0.4),
                  iconSize: 18,
                ),
              ),
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
            statusBarBrightness: Brightness.light,
          ),

          flexibleSpace: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 40, left: 16, right: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage(ImagePath.appBarBackground),
                    fit: BoxFit.fill,
                  ),
                  boxShadow: Constants.appBarBoxShadow,
                ),
                alignment: AlignmentDirectional.bottomCenter,
                child: LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width - 32,
                  addAutomaticKeepAlive: false,
                  lineHeight: 6.7,
                  isRTL: CommonFunctions.isAppAR ? true : false,
                  animationDuration: 0,
                  restartAnimation: false,
                  percent: 1 / (1),
                  barRadius: Radius.circular(33),
                  backgroundColor: AppColor.primary100Light,
                  linearGradient: LinearGradient(colors: [
                    AppColor.primary900Light,
                    Color(0xff159EBB),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
          onTap: hideKeybaord,
          child: SafeArea(
            child: Stack(children: [
              SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 85),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: CustomTextWidget(
                            ('lbl_activity_info').tr(),
                            fontColor: AppColor.blackModern600Light,
                            fontWeight: AppFontWeight.bold,
                            textAlign: TextAlign.start,
                          ),
                        ),
                        //  _locationInfoWidget(),
                        //if (_showManuciplility) _munucipilityInfoWidget(),
                        _serviceTypesWidget(),
                        _serviceProceduresWidget(),
                        _serviceContentWidget(),
                        const CustomVerticalSpace(height: 60),
                      ]),
                ),
              ),
              _sendDataButton()
              /* if (isLoading)
                Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      color: AppColor.baladyDarkGreen2,
                    ))*/
            ]),
          )),
    );
  }

  void hideKeybaord() {
    FocusScope.of(context).unfocus();
  }

  _addBoards(BoardList _board) {
    int itemIndex = _boards!.indexWhere((board) => board.id == _board.id);
    if (itemIndex >= 0) {
      _boards![itemIndex] = _board;
    } else {
      _boards!.add(_board);
    }
    changeBtnColor(currentActivityId, currentactionId);
  }

  _deleteBoard(BoardList _board) {
    int itemIndex = _boards!.indexWhere((board) => board.id == _board.id);
    if (itemIndex >= 0) {
      _boards!.removeAt(itemIndex);
      changeBtnColor(currentActivityId, currentactionId);
    }
  }

  _addNewBoards(BoardList _board) {
    int itemIndex = _newBoards!.indexWhere((board) => board.id == _board.id);
//item.width = _board.width;
    if (itemIndex >= 0) {
      _newBoards![itemIndex] = _board;
    } else {
      _newBoards!.add(_board);
    }
    changeBtnColor(currentActivityId, currentactionId);
  }

  _deleteNewBoard(BoardList _board) {
    int itemIndex = _newBoards!.indexWhere((board) => board.id == _board.id);
    if (itemIndex >= 0) {
      _newBoards!.removeAt(itemIndex);
      changeBtnColor(currentActivityId, currentactionId);
    }
  }

  _addCurrentBoards(BoardList _board) {
    int itemIndex =
        _currentBoards!.indexWhere((board) => board.id == _board.id);
//item.width = _board.width;
    if (itemIndex >= 0) {
      _currentBoards![itemIndex] = _board;
    } else {
      _currentBoards!.add(_board);
    }
    changeBtnColor(currentActivityId, currentactionId);
  }

  _deleteCurrentBoard(BoardList _board) {
    int itemIndex =
        _currentBoards!.indexWhere((board) => board.id == _board.id);
    if (itemIndex >= 0) {
      _currentBoards!.removeAt(itemIndex);
      changeBtnColor(currentActivityId, currentactionId);
    }
  }

  Widget _boardItem(int index) {
    int indexPanelType = _boardList
        .indexWhere((panel) => panel.id == _boards![index].boardTypeId);

    String boardName = "";
    if (indexPanelType >= 0) {
      boardName = _boardList[indexPanelType].name!;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            hideKeybaord();

            await BottomSheetDialog.showDraggableSheet(context,
                isFullHeight: true,
                dialogKeyName: DialogName.calculatorEditBoardDialog,
                currentRouteName: RouteName.calculatorRoute,
                child: BottomSheetWithActions(
                  title: "lbl_edit_board".tr(),
                  body: AddBoardScreen(
                      board: _boards![index],
                      editBoardList: _addBoards,
                      deleteBoard: _deleteBoard,
                      boardList: _boardList,
                      lastBoardId: _boards!.length,
                      title: "lbl_edit_board"),
                ));
          },
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              _deleteBoard(_boards![index]);
            },
            secondaryBackground: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: AlignmentDirectional.centerEnd,
              child: CustomTextWidget(
                Helpers.translatingWord('lbl_delete_for_activity'),
                textAlign: TextAlign.end,
              ),
              color: AppColor.redStarRating,
            ),
            direction: DismissDirection.endToStart,
            background: Container(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextWidget(
                  boardName,
                  fontColor: AppColor.black,
                  fontSize: 13,
                ),
                const CustomVerticalSpace(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      "${Helpers.translatingWord("lbl_area")}: ${_boards![index].width.toString()} ${Helpers.translatingWord("lbl_m2")}",
                      fontColor: AppColor.black300,
                      fontWeight: AppFontWeight.medium,
                      fontSize: 16,
                    ),
                    SvgPicture.asset(IconPath.arrowLeft, height: 16, width: 16)
                  ],
                ),
                const CustomVerticalSpace(height: 10),
                Divider(height: 1),
              ],
            ),
          ),
        ),
        const CustomVerticalSpace(height: 20),
      ],
    );
  }

  Widget _newBoardItem(int index) {
    int indexPanelType = _boardList
        .indexWhere((panel) => panel.id == _newBoards![index].boardTypeId);

    String boardName = "";
    if (indexPanelType >= 0) {
      boardName = _boardList[indexPanelType].name!;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            hideKeybaord();

            await BottomSheetDialog.showDraggableSheet(context,
                isFullHeight: true,
                dialogKeyName: DialogName.calculatorEditBoardDialog,
                currentRouteName: RouteName.calculatorRoute,
                child: BottomSheetWithActions(
                  title: "lbl_edit_board".tr(),
                  body: AddBoardScreen(
                      board: _newBoards![index],
                      editBoardList: _addNewBoards,
                      deleteBoard: _deleteNewBoard,
                      boardList: _boardList,
                      lastBoardId: _newBoards!.length,
                      title: "lbl_edit_board"),
                ));
          },
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              _deleteNewBoard(_newBoards![index]);
            },
            secondaryBackground: Container(
              padding: EdgeInsets.only(right: 12, left: 12),
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                Helpers.translatingWord("lbl_delete_for_activity"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.end,
                textScaleFactor: 1,
              ),
              color: Color(0xffcc3333),
            ),
            direction: DismissDirection.endToStart,
            background: Container(),
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    boardName,
                    style: const TextStyle(
                        color: AppColor.black,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 13.0),
                    textScaleFactor: 1,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextWidget(
                        "${Helpers.translatingWord("lbl_area")}: ${_newBoards![index].width.toString()} ${Helpers.translatingWord("lbl_m2")}",
                        fontColor: AppColor.black300,
                        fontWeight: AppFontWeight.medium,
                        fontSize: 16,
                      ),
                      SvgPicture.asset(IconPath.arrowLeft,
                          height: 16, width: 16)

                      /*Image.asset("assets/images/arrowLeftSLightCopy@3x.png",
                          height: 16, width: 16)*/
                    ],
                  ),
                  SizedBox(height: 10),
                  Divider(height: 1),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _currentBoardItem(int index) {
    int indexPanelType = _boardList
        .indexWhere((panel) => panel.id == _currentBoards![index].boardTypeId);

    String boardName = "";
    if (indexPanelType >= 0) {
      boardName = _boardList[indexPanelType].name!;
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            hideKeybaord();

            await BottomSheetDialog.showDraggableSheet(context,
                isFullHeight: true,
                dialogKeyName: DialogName.calculatorEditBoardDialog,
                currentRouteName: RouteName.calculatorRoute,
                child: BottomSheetWithActions(
                  title: "lbl_edit_board".tr(),
                  body: AddBoardScreen(
                      board: _currentBoards![index],
                      editBoardList: _addCurrentBoards,
                      deleteBoard: _deleteCurrentBoard,
                      boardList: _boardList,
                      lastBoardId: _currentBoards!.length,
                      title: "lbl_edit_board"),
                ));
          },
          child: Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              _deleteCurrentBoard(_currentBoards![index]);
            },
            secondaryBackground: Container(
              padding: EdgeInsets.only(right: 12, left: 12),
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                Helpers.translatingWord("lbl_delete_for_activity"),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.end,
                textScaleFactor: 1,
              ),
              color: Color(0xffcc3333),
            ),
            direction: DismissDirection.endToStart,
            background: Container(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boardName,
                  style: const TextStyle(
                      color: AppColor.black,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                  textScaleFactor: 1,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      "${Helpers.translatingWord("lbl_area")}: ${_currentBoards![index].width.toString()} ${Helpers.translatingWord("lbl_m2")}",
                      fontColor: AppColor.black300,
                      fontWeight: AppFontWeight.medium,
                      fontSize: 16,
                    ),
                    SvgPicture.asset(IconPath.arrowLeft, height: 16, width: 16)

                    /* Image.asset("assets/images/arrowLeftSLightCopy@3x.png",
                        height: 16, width: 16)*/
                  ],
                ),
                SizedBox(height: 10),
                Divider(height: 1),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _boardsTypes() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CustomTextWidget(
              ('lbl_panel_info').tr(),
              fontColor: AppColor.blackModern600Light,
              fontWeight: AppFontWeight.bold,
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            width: double.infinity,
            //  padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomTextWidget(
                    Helpers.translatingWord('lbl_boards_title'),
                    fontColor: AppColor.primary900Light,
                    fontWeight: AppFontWeight.bold,
                    textScaleFactor: 1,
                  ),
                  /*CustomTooltipWidget(
                    message:
                        Helpers.translatingWord('tool_tip_calculator_boards_1'),
                    child: Image.asset(Constants.imgPath + "moreInfo@3x.png",
                        height: 13, width: 13),
                  ),*/
                ]),
          ),
          SizedBox(
            height: 16,
          ),
          Flexible(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _boards!.length,
                itemBuilder: (ctx, index) {
                  return _boardItem(index);
                }),
          ),
          ElevatedButtonWidget.custom(
              onPressed: () async {
                hideKeybaord();

                await BottomSheetDialog.showDraggableSheet(context,
                    isFullHeight: true,
                    dialogKeyName: DialogName.calculatorAddBoardDialog,
                    currentRouteName: RouteName.calculatorRoute,
                    child: BottomSheetWithActions(
                      title: "lbl_add_new_board".tr(),
                      body: AddBoardScreen(
                          board: null,
                          editBoardList: _addBoards,
                          deleteBoard: null,
                          boardList: _boardList,
                          lastBoardId: _boards!.length,
                          title: "lbl_add_new_board"),
                    ));
              },
              text: Helpers.translatingWord("lbl_add_board")),
        ],
      ),
    );
  }

  Widget _newBoardsTypes() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CustomTextWidget(
              ('lbl_panel_new_info').tr(),
              fontColor: AppColor.blackModern600Light,
              fontWeight: AppFontWeight.bold,
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomTextWidget(
                    Helpers.translatingWord('lbl_boards_new_title'),
                    fontColor: AppColor.primary900Light,
                    fontSize: 18,
                    fontWeight: AppFontWeight.bold,
                    textScaleFactor: 1,
                  ),
                  /*CustomTooltipWidget(
                    message:
                        Helpers.translatingWord('tool_tip_calculator_boards_3'),
                    child: Image.asset(Constants.imgPath + "moreInfo@3x.png",
                        height: 13, width: 13),
                  ),*/
                ]),
          ),
          SizedBox(
            height: 16,
          ),
          Flexible(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _newBoards!.length,
                itemBuilder: (ctx, index) {
                  return _newBoardItem(index);
                }),
          ),
          ElevatedButtonWidget.custom(
              onPressed: () async {
                hideKeybaord();

                await BottomSheetDialog.showDraggableSheet(context,
                    isFullHeight: true,
                    dialogKeyName: DialogName.calculatorAddBoardDialog,
                    currentRouteName: RouteName.calculatorRoute,
                    child: BottomSheetWithActions(
                      title: "lbl_add_new_board".tr(),
                      body: AddBoardScreen(
                          board: null,
                          editBoardList: _addNewBoards,
                          deleteBoard: null,
                          boardList: _boardList,
                          lastBoardId: _newBoards!.length,
                          title: "lbl_add_new_board"),
                    ));
              },
              text: Helpers.translatingWord("lbl_add_board")),
        ],
      ),
    );
  }

  Widget _currentBoardsTypes() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CustomTextWidget(
              ('lbl_panel_current_info').tr(),
              fontColor: AppColor.blackModern600Light,
              fontWeight: AppFontWeight.bold,
              textAlign: TextAlign.start,
            ),
          ),
          Container(
            width: double.infinity,
            height: 35,
            // decoration: const BoxDecoration(color: Color(0xfff2f2f2)),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CustomTextWidget(
                    Helpers.translatingWord('lbl_boards_current_title'),
                    textScaleFactor: 1,
                    fontColor: AppColor.primary900Light,
                    fontSize: 18,
                    fontWeight: AppFontWeight.bold,
                  ),
                  /*CustomTooltipWidget(
                    message:
                        Helpers.translatingWord('tool_tip_calculator_boards_2'),
                    child: Image.asset(Constants.imgPath + "moreInfo@3x.png",
                        height: 13, width: 13),
                  ),*/
                ]),
          ),
          const CustomVerticalSpace(height: 16),
          Flexible(
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _currentBoards!.length,
                itemBuilder: (ctx, index) {
                  return _currentBoardItem(index);
                }),
          ),
          ElevatedButtonWidget.custom(
              onPressed: () async {
                hideKeybaord();

                await BottomSheetDialog.showDraggableSheet(context,
                    isFullHeight: true,
                    dialogKeyName: DialogName.calculatorEditBoardDialog,
                    currentRouteName: RouteName.calculatorRoute,
                    child: BottomSheetWithActions(
                      title: "lbl_edit_board".tr(),
                      body: AddBoardScreen(
                          board: null,
                          editBoardList: _addCurrentBoards,
                          deleteBoard: null,
                          boardList: _boardList,
                          lastBoardId: _currentBoards!.length,
                          title: "lbl_add_current_board"),
                    ));
              },
              text: Helpers.translatingWord("lbl_add_current_board")),
        ],
      ),
    );
  }

  Widget _serviceTypesWidget() {
    /* DropDownItem? dropItem;
    Item? item = _serviceTypes.firstWhereOrNull(
        (element) => element.id == _serviceTypeController?.id);
    if (item != null)
      dropItem = DropDownItem(id: item.id.toString(), name: item.name);
    return CustomTapWidgetForLongDialog(
      items: _serviceTypes
          .map((e) => DropDownItem(id: e.id.toString(), name: e.name))
          .toList(),
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        Item? item = _serviceTypes.firstWhereOrNull(
            (element) => int.tryParse(e?.id ?? "") == element.id);

        _selectServiceType(item);
      },
      label: Helpers.translatingWord("lbl_service_types_hint1"),
      hint: Helpers.translatingWord("lbl_service_types_hint1"),
      searchHint: Helpers.translatingWord("searchFor"),
    );
*/
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_service_types_hint1"),
      hintText: Helpers.translatingWord("lbl_service_types_hint1"),
      textValue: (_serviceTypeController != null)
          ? _serviceTypeController!.name
          : null,
      onTap: () {
        // to point to the same chosen index at picker view
        int? currentIndex;
        if (_serviceTypeController != null) {
          int index = _serviceTypes.indexWhere(
              (element) => element.id == _serviceTypeController!.id);
          if (index >= 0) currentIndex = index;
        }
        showBottomSheetItems([
          for (int i = 0; i < _serviceTypes.length; i++)
            SearchItem(text: _serviceTypes[i].name, value: _serviceTypes[i])
        ], _selectServiceType,
            Helpers.translatingWord("lbl_service_types_hint1"),
            selectedIndex: currentIndex, isSearchable: false);
      },
    );
  }

  _selectServiceType(Item? item) {
    if (item != null) {
      setState(() {
        _selectedServiceId = item.id!;
        _selectedActionId = 0;
        _serviceTypeController = item;
        _isValidServiceType = true;
        // _serviceTypeErrMsg = null;
        _serviceProcedureController = null;
        _procedures.clear();
        _isButtonDisabled = true;
        _detailedIsicActivites.clear();
        _serviceIsicActivityController = null;
        _serviceDetailedActivityController = null;
        _serviceDetailedIsicActivityController = null;
        _serviceSubActivityController = null;
        clearAllFields();
      });
      presenter?.getProceduresListlookup(item.id!);
    } else {
      setState(() {
        _isValidServiceType = false;
      });
    }
  }

  _serviceIsicActivityWidget() {
    /*DropDownItem? dropItem;
    IsicActivity? item = _isicActivites?.firstWhereOrNull((element) =>
        element.isicCode == _serviceIsicActivityController?.isicCode);
    if (item != null)
      dropItem =
          DropDownItem(id: item.isicCode.toString(), name: item.isicName);
    return CustomTapWidgetForLongDialog(
      items: _isicActivites != null
          ? _isicActivites!
              .map((e) =>
                  DropDownItem(id: e.isicCode.toString(), name: e.isicName))
              .toList()
          : [],
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        IsicActivity? item = _isicActivites
            ?.firstWhereOrNull((element) => e?.id == element.isicCode);

        _selectIsicActivity(item);
      },
      label: Helpers.translatingWord("lbl_isic_activity_hint1"),
      hint: Helpers.translatingWord("lbl_isic_activity_hint2"),
      searchHint: Helpers.translatingWord("searchFor"),
    );
*/
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_isic_activity_hint1"),
      hintText: Helpers.translatingWord("lbl_isic_activity_hint2"),
      textValue: (_serviceIsicActivityController != null)
          ? _serviceIsicActivityController!.isicName
          : null,
      onTap: () {
        // to point to the same chosen index at picker view
        int? currentIndex;
        if (_serviceIsicActivityController != null) {
          int index = _isicActivites!.indexWhere((element) =>
              element.isicCode == _serviceIsicActivityController!.isicCode);
          if (index >= 0) currentIndex = index;
        }
        showBottomSheetItems([
          for (int i = 0; i < _isicActivites!.length; i++)
            SearchItem(
                text: _isicActivites![i].isicName, value: _isicActivites![i])
        ], _selectIsicActivity,
            Helpers.translatingWord("lbl_isic_activity_hint1"),
            itemExtent: 60.0, selectedIndex: currentIndex);
      },
    );
  }

  _selectIsicActivity(IsicActivity? item) {
    if (item != null) {
      setState(() {
        //   _selectedActionId = newValue.isicCode;
        _isButtonDisabled = true;
        _serviceIsicActivityController = item;
        _isValidIsicActivity = true;
        _detailedIsicActivites.clear();
        _serviceDetailedActivityController = null;
        _serviceDetailedIsicActivityController = null;
      });
      clearAllFields();
      presenter?.getDetailedIsicActivityListlookup(
          int.parse(item.isicCode!), ActivityIsicListDetailType.Normal);
    } else {
      _isValidIsicActivity = false;
    }
  }

  _serviceDetailedIsicActivityWidget() {
    /*DropDownItem? dropItem;
    Item? item = _detailedIsicActivites.firstWhereOrNull(
        (element) => element.id == _serviceDetailedIsicActivityController?.id);
    if (item != null)
      dropItem = DropDownItem(id: item.id.toString(), name: item.name);
    return CustomTapWidgetForLongDialog(
      items: _detailedIsicActivites != null
          ? _detailedIsicActivites!
              .map((e) => DropDownItem(id: e.id.toString(), name: e.name))
              .toList()
          : [],
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        Item? item = _detailedIsicActivites
            .firstWhereOrNull((element) => e?.id == element.id.toString());

        _selectDetailedIsicActivity(item);
      },
      label: Helpers.translatingWord("lbl_detailed_isic_activity_hint1"),
      hint: Helpers.translatingWord("lbl_detailed_isic_activity_hint2"),
      searchHint: Helpers.translatingWord("searchFor"),
    );*/

    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_detailed_isic_activity_hint1"),
      hintText: Helpers.translatingWord("lbl_detailed_isic_activity_hint2"),
      textValue: (_serviceDetailedIsicActivityController != null)
          ? _serviceDetailedIsicActivityController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceDetailedIsicActivityController != null) {
          int index = _detailedIsicActivites.indexWhere((element) =>
              element.id == _serviceDetailedIsicActivityController!.id);
          if (index >= 0) currentIndex = index;
        }

        if (_serviceIsicActivityController != null) {
          showBottomSheetItems([
            for (int i = 0; i < _detailedIsicActivites.length; i++)
              SearchItem(
                  text: _detailedIsicActivites[i].name,
                  value: _detailedIsicActivites[i])
          ], _selectDetailedIsicActivity,
              Helpers.translatingWord("lbl_detailed_isic_activity_hint1"),
              itemExtent: 60.0, selectedIndex: currentIndex);
        }
      },
    );
  }

  _selectDetailedIsicActivity(Item? item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceDetailedIsicActivityController = item;
        _isValidDetailedIsicActivity = true;
      });

      presenter?.getDetailedActivitylookup(item.id!, ActivityDetailType.Normal);
    } else {
      setState(() {
        _isValidDetailedIsicActivity = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  _serviceIsicActivityCurrentWidget() {
    /* DropDownItem? dropItem;
    IsicActivity? item = _isicActivites?.firstWhereOrNull((element) =>
        element.isicCode == _serviceIsicActivityCurrentController?.isicCode);
    if (item != null)
      dropItem =
          DropDownItem(id: item.isicCode.toString(), name: item.isicName);
    return CustomTapWidgetForLongDialog(
      items: _isicActivites != null
          ? _isicActivites!
              .map((e) =>
                  DropDownItem(id: e.isicCode.toString(), name: e.isicName))
              .toList()
          : [],
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        IsicActivity? item = _isicActivites
            ?.firstWhereOrNull((element) => e?.id == element.isicCode);

        _selectIsicActivityCurrent(item);
      },
      label: Helpers.translatingWord("lbl_isic_activity_current_hint1"),
      hint: Helpers.translatingWord("lbl_isic_activity_current_hint2"),
      searchHint: Helpers.translatingWord("searchFor"),
    );
*/
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_isic_activity_current_hint1"),
      hintText: Helpers.translatingWord("lbl_isic_activity_current_hint2"),
      textValue: (_serviceIsicActivityCurrentController != null)
          ? _serviceIsicActivityCurrentController!.isicName
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceIsicActivityCurrentController != null) {
          int index = _isicActivites!.indexWhere((element) =>
              element.isicCode ==
              _serviceIsicActivityCurrentController!.isicCode);
          if (index >= 0) currentIndex = index;
        }
        showBottomSheetItems([
          for (int i = 0; i < _isicActivites!.length; i++)
            SearchItem(
                text: _isicActivites![i].isicName, value: _isicActivites![i])
        ], _selectIsicActivityCurrent,
            Helpers.translatingWord("lbl_isic_activity_current_hint1"),
            itemExtent: 60.0, selectedIndex: currentIndex);
      },
    );
  }

  _selectIsicActivityCurrent(IsicActivity? item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceIsicActivityCurrentController = item;
        _isValidIsicActivity = true;
        _detailedIsicActivitesCurrent.clear();
        _serviceDetailedActivityCurrentController = null;
        _serviceDetailedIsicActivityCurrentController = null;
        clearAllFields();
      });
      presenter?.getDetailedIsicActivityListlookup(
          int.parse(item.isicCode!), ActivityIsicListDetailType.Current);
    } else {
      setState(() {
        _isValidIsicActivityCurrent = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  _serviceIsicActivityNewWidget() {
    /* DropDownItem? dropItem;
    IsicActivity? item = _isicActivites?.firstWhereOrNull((element) =>
        element.isicCode == _serviceIsicActivityNewController?.isicCode);
    if (item != null)
      dropItem =
          DropDownItem(id: item.isicCode.toString(), name: item.isicName);
    return CustomTapWidgetForLongDialog(
      items: _isicActivites != null
          ? _isicActivites!
              .map((e) =>
                  DropDownItem(id: e.isicCode.toString(), name: e.isicName))
              .toList()
          : [],
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        IsicActivity? item = _isicActivites
            ?.firstWhereOrNull((element) => e?.id == element.isicCode);

        _selectIsicActivityNew(item);
      },
      label: Helpers.translatingWord("lbl_isic_activity_new_hint1"),
      hint: Helpers.translatingWord("lbl_isic_activity_new_hint2"),
      searchHint: Helpers.translatingWord("searchFor"),
    );
*/
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_isic_activity_new_hint1"),
      hintText: Helpers.translatingWord("lbl_isic_activity_new_hint2"),
      textValue: (_serviceIsicActivityNewController != null)
          ? _serviceIsicActivityNewController!.isicName
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceIsicActivityNewController != null) {
          int index = _isicActivites!.indexWhere((element) =>
              element.isicCode == _serviceIsicActivityNewController!.isicCode);
          if (index >= 0) currentIndex = index;
        }
        showBottomSheetItems([
          for (int i = 0; i < _isicActivites!.length; i++)
            SearchItem(
                text: _isicActivites![i].isicName, value: _isicActivites![i])
        ], _selectIsicActivityNew,
            Helpers.translatingWord("lbl_isic_activity_new_hint1"),
            itemExtent: 60.0, selectedIndex: currentIndex);
      },
    );
  }

  _selectIsicActivityNew(IsicActivity? item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceIsicActivityNewController = item;
        _isValidIsicActivityNew = true;
        _detailedIsicActivitesNew.clear();
        _serviceDetailedActivityNewController = null;
        _serviceDetailedIsicActivityNewController = null;
        clearAllFields();
      });

      presenter?.getDetailedIsicActivityListlookup(
          int.parse(item.isicCode!), ActivityIsicListDetailType.New);
    } else {
      setState(() {
        _isValidIsicActivityCurrent = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  _serviceDetailedIsicActivityCurrentWidget() {
    /*DropDownItem? dropItem;
    Item? item = _detailedIsicActivitesCurrent.firstWhereOrNull((element) =>
        element.id == _serviceDetailedIsicActivityCurrentController?.id);
    if (item != null)
      dropItem = DropDownItem(id: item.id.toString(), name: item.name);
    return CustomTapWidgetForLongDialog(
      items: _detailedIsicActivitesCurrent != null
          ? _detailedIsicActivitesCurrent!
              .map((e) => DropDownItem(id: e.id.toString(), name: e.name))
              .toList()
          : [],
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        Item? item = _detailedIsicActivitesCurrent
            ?.firstWhereOrNull((element) => e?.id == element.id.toString());

        _selectDetailedIsicActivityCurrent(item);
      },
      label:
          Helpers.translatingWord("lbl_detailed_isic_current_activity_hint1"),
      hint: Helpers.translatingWord("lbl_detailed_isic_current_activity_hint1"),
      searchHint: Helpers.translatingWord("searchFor"),
    );*/

    return CustomHeaderAndDescOnTapWidget(
      label:
          Helpers.translatingWord("lbl_detailed_isic_current_activity_hint1"),
      hintText:
          Helpers.translatingWord("lbl_detailed_isic_current_activity_hint1"),
      textValue: (_serviceDetailedIsicActivityCurrentController != null)
          ? _serviceDetailedIsicActivityCurrentController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceDetailedIsicActivityCurrentController != null) {
          int index = _detailedIsicActivitesCurrent.indexWhere((element) =>
              element.id == _serviceDetailedIsicActivityCurrentController!.id);
          if (index >= 0) currentIndex = index;
        }

        if (_serviceIsicActivityCurrentController != null) {
          showBottomSheetItems(
              [
                for (int i = 0; i < _detailedIsicActivitesCurrent.length; i++)
                  SearchItem(
                      text: _detailedIsicActivitesCurrent[i].name,
                      value: _detailedIsicActivitesCurrent[i])
              ],
              _selectDetailedIsicActivityCurrent,
              Helpers.translatingWord(
                  "lbl_detailed_isic_current_activity_hint1"),
              itemExtent: 60.0,
              selectedIndex: currentIndex);
        }
      },
    );
  }

  _selectDetailedIsicActivityCurrent(Item? item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceDetailedIsicActivityCurrentController = item;
        _isValidDetailedIsicActivityCurrent = true;
      });
      presenter?.getDetailedActivitylookup(
          item.id!, ActivityDetailType.Current);
    } else {
      setState(() {
        _isValidDetailedIsicActivityCurrent = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  _serviceDetailedIsicActivityNewWidget() {
    /*DropDownItem? dropItem;
    Item? item = _detailedIsicActivitesNew.firstWhereOrNull((element) =>
        element.id == _serviceDetailedIsicActivityNewController?.id);
    if (item != null)
      dropItem = DropDownItem(id: item.id.toString(), name: item.name);
    return CustomTapWidgetForLongDialog(
      items: _detailedIsicActivitesNew != null
          ? _detailedIsicActivitesNew!
              .map((e) => DropDownItem(id: e.id.toString(), name: e.name))
              .toList()
          : [],
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        Item? item = _detailedIsicActivitesNew
            ?.firstWhereOrNull((element) => e?.id == element.id.toString());

        _selectDetailedIsicActivityNew(item);
      },
      label: Helpers.translatingWord("lbl_detailed_isic_new_activity_hint1"),
      hint: Helpers.translatingWord("lbl_detailed_isic_new_activity_hint2"),
      searchHint: Helpers.translatingWord("searchFor"),
    );*/

    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_detailed_isic_new_activity_hint1"),
      hintText: Helpers.translatingWord("lbl_detailed_isic_new_activity_hint2"),
      textValue: (_serviceDetailedIsicActivityNewController != null)
          ? _serviceDetailedIsicActivityNewController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceDetailedIsicActivityNewController != null) {
          int index = _detailedIsicActivitesNew.indexWhere((element) =>
              element.id == _serviceDetailedIsicActivityNewController!.id);
          if (index >= 0) currentIndex = index;
        }

        if (_serviceIsicActivityNewController != null) {
          showBottomSheetItems([
            for (int i = 0; i < _detailedIsicActivitesNew.length; i++)
              SearchItem(
                  text: _detailedIsicActivitesNew[i].name,
                  value: _detailedIsicActivitesNew[i])
          ], _selectDetailedIsicActivityNew,
              Helpers.translatingWord("lbl_detailed_isic_new_activity_hint1"),
              itemExtent: 60.0, selectedIndex: currentIndex);
        }
      },
    );
  }

  _selectDetailedIsicActivityNew(Item? item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceDetailedIsicActivityNewController = item;
        _isValidDetailedIsicActivityNew = true;
      });
      presenter?.getDetailedActivitylookup(item.id!, ActivityDetailType.New);
    } else {
      setState(() {
        _isValidDetailedIsicActivityNew = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  _selectProcedure(Procedure? procedure) {
    if (procedure != null) {
      setState(() {
        _selectedActionId = procedure.id!;
        currentActivityId = procedure.id;
        _isButtonDisabled = true;
        _serviceProcedureController = procedure;
        _isValidProcedure = true;
        _detailedIsicActivites.clear();
        _serviceIsicActivityController = null;
        _serviceDetailedActivityController = null;
        _serviceDetailedIsicActivityController = null;
        _serviceSubActivityController = null;
        _serviceAccomodationController = null;
        clearAllFields();
      });
    } else {
      setState(() {
        _isValidProcedure = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);

    _checkIfRequiredSubActivityList();
  }

  bool? _checkIfRequiredSubActivityList() {
    if (_selectedServiceId != 1 && _selectedServiceId != 8) {
      setState(() {});
      presenter?.getSubActivitieslookup(_serviceProcedureController!.id!);
    }
  }

  _serviceProceduresWidget() {
    /*DropDownItem? dropItem;
    Procedure? item = _procedures.firstWhereOrNull(
        (element) => element.id == _serviceProcedureController?.id);
    if (item != null)
      dropItem = DropDownItem(id: item.id.toString(), name: item.name);
    return CustomTapWidgetForLongDialog(
      items: _procedures != null
          ? _procedures!
              .map((e) => DropDownItem(id: e.id.toString(), name: e.name))
              .toList()
          : [],
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        Procedure? item = _procedures
            ?.firstWhereOrNull((element) => e?.id == element.id.toString());

        _selectProcedure(item);
      },
      label: Helpers.translatingWord("lbl_needed_action_hint1"),
      hint: Helpers.translatingWord("lbl_needed_action_hint2"),
      searchHint: Helpers.translatingWord("searchFor"),
    );*/

    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_needed_action_hint1"),
      hintText: Helpers.translatingWord("lbl_needed_action_hint2"),
      textValue: (_serviceProcedureController != null)
          ? _serviceProcedureController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceProcedureController != null) {
          int index = _procedures.indexWhere(
              (element) => element.id == _serviceProcedureController!.id);
          if (index >= 0) currentIndex = index;
        }

        if (_serviceTypeController != null) {
          showBottomSheetItems([
            for (int i = 0; i < _procedures.length; i++)
              SearchItem(text: _procedures[i].name, value: _procedures[i])
          ], _selectProcedure,
              Helpers.translatingWord("lbl_needed_action_hint1"),
              selectedIndex: currentIndex, isSearchable: false);
        }
      },
    );
  }

  _serviceActivitiesWidget() {
    String title = currentActivityId == 2
        ? Helpers.translatingWord("lbl_building_type")
        : Helpers.translatingWord("lbl_service_activity_hint1");
    String hint = currentActivityId == 2
        ? Helpers.translatingWord("lbl_building_type_hint")
        : Helpers.translatingWord("lbl_service_activity_hint2");

    /* DropDownItem? dropItem;
    SubActivity? item = _subActivities.firstWhereOrNull(
        (element) => element.id == _serviceSubActivityController?.id);
    if (item != null)
      dropItem = DropDownItem(
          id: item.id.toString(),
          name: item.name_ar!.replaceAll("\n", "").trim());
    return CustomTapWidgetForLongDialog(
      items: _subActivities != null
          ? _subActivities!
              .map((e) => DropDownItem(
                  id: e.id.toString(),
                  name: e.name_ar!.replaceAll("\n", "").trim()))
              .toList()
          : [],
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        Procedure? item = _procedures
            ?.firstWhereOrNull((element) => e?.id == element.id.toString());

        _selectProcedure(item);
      },
      label: title,
      hint: hint,
      searchHint: Helpers.translatingWord("searchFor"),
    );*/

    return CustomHeaderAndDescOnTapWidget(
      label: title,
      hintText: hint,
      textValue: (_serviceSubActivityController != null)
          ? _serviceSubActivityController!.name_ar!.replaceAll("\n", "").trim()
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceSubActivityController != null) {
          int index = _subActivities.indexWhere(
              (element) => element.id == _serviceSubActivityController!.id);
          if (index >= 0) currentIndex = index;
        }
        if (_serviceProcedureController != null) {
          showBottomSheetItems([
            for (int i = 0; i < _subActivities.length; i++)
              SearchItem(
                  text: _subActivities[i].name_ar, value: _subActivities[i])
          ], _selectSubActivity, title, selectedIndex: currentIndex);
        }
      },
    );
  }

  _selectSubActivity(SubActivity item) {
    if (item != null) {
      setState(() {
        _serviceSubActivityController = item;
        isValidServiceActivity = true;
      });
      changeBtnColor(_selectedServiceId, _selectedActionId);
    }
  }

  showBottomSheetItems(var _items, Function _select, String title,
      {double itemExtent = 50.0,
      int? selectedIndex,
      bool isSearchable = true}) {
    // _showBottomPicker(_items, _select, title,
    //     itemExtent: itemExtent,
    //     selectedIndex: selectedIndex,
    //     isSearchable: isSearchable);
    showDropDownItems(_items, _select,
        itemExtent: itemExtent, selectedIndex: selectedIndex, title: title);
  }

  showDropDownItems(List<SearchItem> items, Function select,
      {double itemExtent = 50.0, int? selectedIndex, String? title}) async {
    // int selectedIndex = 0;
    List<DropDownItem> pickerItems = [];
    for (int i = 0; i < items.length; i++) {
      pickerItems.add(DropDownItem(
          id: i.toString(),
          name: items[i].text ?? "",
          calculatorValue: items[i].value));
    }

    FocusManager.instance.primaryFocus?.unfocus();
    await CustomPopUpsWidgets.showBottomSheet(
      NavigationService.navigatorKey.currentContext!,
      child: IncidentTypeWithSearchDialog(
        onSelect: (DropDownItem? e) {
          if (e!.calculatorValue != null && e.calculatorValue != null) {
            select(e.calculatorValue);
          }
        },
        items: pickerItems,
        selectedItem: selectedIndex != null ? pickerItems[selectedIndex] : null,
        title: title,
        searchHint: Helpers.translatingWord("searchFor"),
      ),
    );

    /*  DropDownMenu(
        items: pickerItems,
        selected: selectedIndex,
        title: title ?? "",
        isSearchable: true,
        height: 350,
        selectedTextStyle: const TextStyle(color: AppColor.baladyDarkGreen2),
        onConfirm: (PickerItem value, int index) {
          if (value != null && value.value != null) {
            select(value.value);
          }
          //    model.parkCategoryController = value.value;
        }).showModal(context);*/
  }

  void _showDropDown(List<SearchItem> items, Function select,
      {double itemExtent = 50.0}) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (builder) => Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).copyWith().size.height * 0.30,
        child: Stack(
          children: [
            CupertinoPicker.builder(
              itemExtent: itemExtent,
              diameterRatio: 1,
              useMagnifier: true,
              magnification: 1.1,
              childCount: items.length,
              onSelectedItemChanged: (index) {
                select(items[index]);
              },
              itemBuilder: (context, index) => Align(
                alignment: Alignment.center,
                child: CustomTextWidget(
                  items[index].text!,
                  fontColor: AppColor.black,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Container(
                margin: const EdgeInsetsDirectional.only(start: 15),
                child: CustomTextButtonWidget(
                  onPressed: () => Navigator.of(context).pop(),
                  text: Helpers.translatingWord(
                    "bookNewAppointmentCloseWindowWord",
                  ),
                  btnTextColor: AppColor.black400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _serviceZonesWidget() {
    /*DropDownItem? dropItem;
    Municipality? item = _shownZones.firstWhereOrNull(
        (element) => element.id == _serviceZoneController?.id);
    if (item != null) dropItem = DropDownItem(id: item.id, name: item.name);
    return CustomTapWidgetForLongDialog(
      items:
          _shownZones.map((e) => DropDownItem(id: e.id, name: e.name)).toList(),
      value: dropItem,
      onChangeType: (DropDownItem? e) {
        Municipality? item =
            _shownZones.firstWhereOrNull((element) => element.id == e?.id);

        _selectZone(item);
      },
      label: Helpers.translatingWord("lbl_zone_hint1"),
      hint: Helpers.translatingWord("lbl_zone_hint2"),
      searchHint: Helpers.translatingWord("lbl_zone_hint1"),
    );*/

    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_zone_hint1"),
      hintText: Helpers.translatingWord("lbl_zone_hint2"),
      textValue: (_serviceZoneController != null)
          ? _serviceZoneController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceZoneController != null) {
          int index = _shownZones.indexWhere(
              (element) => element.id == _serviceZoneController!.id);
          if (index >= 0) currentIndex = index;
        }
        showBottomSheetItems([
          for (int i = 0; i < _shownZones.length; i++)
            SearchItem(text: _shownZones[i].name, value: _shownZones[i])
        ], _selectZone, Helpers.translatingWord("lbl_zone_hint1"),
            isSearchable: false, selectedIndex: currentIndex);
      },
    );
  }

  _selectZone(Municipality? item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceZoneController = item;
        _isValidZone = true;
      });
    } else {
      setState(() {
        _isValidZone = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
    // _checkBtnStatus();
  }

/*
  _showBottomPicker(List<SearchItem> items, Function select, String title,
      {double itemExtent = 50.0,
      int selectedIndex = 0,
      bool isSearchable = true}) {
    if (items != null && items.length < 3) {
      isSearchable = false;
    } else {
      isSearchable = true;
    }
    hideKeybaord();
    Picker(
        adapter: PickerDataAdapter(data: [
          for (int i = 0; i < items.length; i++)
            PickerItem(text: Text(items[i].text ?? ""), value: items[i].value)
        ]),
        changeToFirst: true,
        confirmTextStyle: const TextStyle(
            fontFamily: 'packages/balady_uikit/Frutiger',
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            color: AppColor.baladyDarkGreen2),
        selectedTextStyle: TextStyle(color: AppColor.baladyDarkGreen2),
        headercolor: const Color(0xfffafaf8),
        cancel: Container(),
        isSearchable: isSearchable,
        itemExtent: itemExtent,
        selecteds: [selectedIndex],
        confirmText: Helpers.translatingWord("date_picker_confirm"),
        title: Text(title,
            style: const TextStyle(
                color: AppColor.black,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.normal,
                fontSize: 15.0),
            textAlign: TextAlign.right),
        hideHeader: false,
        // isSearchable: isSearchable,
        onConfirm: (Picker picker, List value) {
          if (picker.getSelectedValues() != null &&
              picker.getSelectedValues().length > 0 &&
              picker.getSelectedValues().length > 0) {
            if (picker.getSelectedValues()[0] != null)
              select(picker.getSelectedValues()[0]);
          }
        }).showModal(context);
  }*/

  _serviceZonesCurrentWidget() {
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_zone_current_hint1"),
      hintText: Helpers.translatingWord("lbl_zone_current_hint2"),
      textValue: (_serviceZoneCurrentController != null)
          ? _serviceZoneCurrentController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceZoneCurrentController != null) {
          int index = _shownZones.indexWhere(
              (element) => element.id == _serviceZoneCurrentController!.id);
          if (index >= 0) currentIndex = index;
        }

        showBottomSheetItems([
          for (int i = 0; i < _shownZones.length; i++)
            SearchItem(text: _shownZones[i].name, value: _shownZones[i])
        ], _selectZoneCurrent,
            Helpers.translatingWord("lbl_zone_current_hint1"),
            isSearchable: false, selectedIndex: currentIndex);
      },
    );
  }

  _selectZoneCurrent(Municipality item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceZoneCurrentController = item;
        _isValidZoneCurrent = true;
      });
    } else {
      setState(() {
        _isValidZoneCurrent = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  _serviceAccomodationsWidget() {
    String title = currentactionId == 22
        ? Helpers.translatingWord("lbl_accomodation_optional_hint1")
        : Helpers.translatingWord("lbl_accomodation_hint1");
    return CustomHeaderAndDescOnTapWidget(
      label: title,
      hintText: Helpers.translatingWord("lbl_accomodation_hint1"),
      textValue: (_serviceAccomodationController != null)
          ? _serviceAccomodationController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceAccomodationController != null) {
          int index = _accomodations.indexWhere(
              (element) => element.id == _serviceAccomodationController!.id);
          if (index >= 0) currentIndex = index;
        }

        showBottomSheetItems([
          for (int i = 0; i < _accomodations.length; i++)
            SearchItem(text: _accomodations[i].name, value: _accomodations[i])
        ], _selectAccomodations, title,
            selectedIndex: currentIndex, isSearchable: false);
      },
    );
  }

  _selectAccomodations(Item item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceAccomodationController = item;
        _isValidAccomodation = true;
      });
    } else {
      setState(() {
        _isValidAccomodation = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  _serviceAccomodationsCurrentWidget() {
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_accomodation_current_hint1"),
      hintText: Helpers.translatingWord("lbl_accomodation_current_hint2"),
      textValue: (_serviceAccomodationCurrentController != null)
          ? _serviceAccomodationCurrentController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceAccomodationCurrentController != null) {
          int index = _accomodations.indexWhere((element) =>
              element.id == _serviceAccomodationCurrentController!.id);
          if (index >= 0) currentIndex = index;
        }

        showBottomSheetItems([
          for (int i = 0; i < _accomodations.length; i++)
            SearchItem(text: _accomodations[i].name, value: _accomodations[i])
        ], _selectAccomodationsCurrent,
            Helpers.translatingWord("lbl_accomodation_current_hint1"),
            selectedIndex: currentIndex, isSearchable: false);
      },
    );
  }

  _selectAccomodationsCurrent(Item item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceAccomodationCurrentController = item;
        _isValidAccomodationCurrent = true;
      });
    } else {
      setState(() {
        _isValidAccomodationCurrent = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  _serviceAccomodationsNewWidget() {
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_accomodation_new_hint1"),
      hintText: Helpers.translatingWord("lbl_accomodation_new_hint2"),
      textValue: (_serviceAccomodationNewController != null)
          ? _serviceAccomodationNewController!.name
          : null,
      onTap: () {
        int? currentIndex;
        if (_serviceAccomodationNewController != null) {
          int index = _accomodations.indexWhere(
              (element) => element.id == _serviceAccomodationNewController!.id);
          if (index >= 0) currentIndex = index;
        }

        showBottomSheetItems([
          for (int i = 0; i < _accomodations.length; i++)
            SearchItem(text: _accomodations[i].name, value: _accomodations[i])
        ], _selectAccomodationsNew,
            Helpers.translatingWord("lbl_accomodation_new_hint1"),
            selectedIndex: currentIndex, isSearchable: false);
      },
    );
  }

  _selectAccomodationsNew(Item item) {
    if (item != null) {
      setState(() {
        _isButtonDisabled = true;
        _serviceAccomodationNewController = item;
        _isValidAccomodationNew = true;
      });
    } else {
      setState(() {
        _isValidAccomodationNew = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  Widget _serviceContentWidget() {
    if (_selectedActionId == 0) {
      return Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .30,
          ),
        ],
      );
    } else {
      return Container(
        child: DisplayCorrectScenario(_selectedServiceId, _selectedActionId),
      );
    }
  }

  _sendDataButton() {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          color: Colors.transparent,
          child: SafeArea(
            top: false,
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: EnhancedCustomElevatedButtonWidget(
                  btnColor: _isButtonDisabled
                      ? AppColor.black200
                      : AppColor.primary900Light,
                  btnTextColor:
                      _isButtonDisabled ? AppColor.black400 : AppColor.white,
                  btnPressed: _isButtonDisabled
                      ? null
                      : () {
                          if (CheckScenarioValidation(
                              _selectedServiceId, _selectedActionId)) {
                            SubmitData();
                          }
                        },
                  btnText: Helpers.translatingWord("lbl_calculate"),
                  btnTextSize: 16.0,
                  btnRadius: 8,
                  btnTextWeight: AppFontWeight.medium,
                  btnHeight: 56.0,
                )),
          ),
        ));
  }

  VoidCallback? _handleRadioValueChange1(int? value) {
    setState(() {
      _IsThereCleaningContractValue = value!;
      switch (_IsThereCleaningContractValue) {
        case 0:
          break;
        case 1:
          break;
      }
    });
  }

  Widget? DisplayCorrectScenario(int activityId, int actionId) {
    currentActivityId = activityId;
    currentactionId = actionId;
    if (activityId == 1) {
      if (actionId == 1) {
        return S1_1();
      } else if (actionId == 2) {
        return S1_2();
      } else if (actionId == 3) {
        return S1_3();
      } else if (actionId == 4) {
        return S1_4();
      } else if (actionId == 5) {
        return S1_5();
      } else if (actionId == 9) {
        return S1_6();
      } else if (actionId == 18) {
        return S1_7();
      } else if (actionId == 22) {
        return S1_8();
      } else if (actionId == 23) {
        return S1_9();
      } else if (actionId == 1028) {
        return S1_10();
      }
    } else if (activityId == 2) {
      if (actionId <= 4) {
        return S2_1_4();
      } else if (actionId == 5) {
        return S2_5();
      }
    } else if (activityId == 3) {
      return S3();
    } else if (activityId == 4) {
      if (actionId == 9) {
        return S4_1();
      } else if (actionId == 20) {
        return S4_2();
      }
    } else if (activityId == 5) {
      return S5();
    } else if (activityId == 6) {
      return S6();
    } else if (activityId == 7) {
      return S7();
    } else if (activityId == 8) {
      if (actionId == 1301) {
        return S8_1();
      } else if (actionId == 1302) {
        return S8_2();
      }
    } else if (activityId == 9) {
      return S9();
    } else if (activityId == 10 && (actionId == 1401 || actionId == 1402)) {
      return Column(
        children: [
          DistanceWidget(),
          PortLicenseDaysWidget(),
          PortRentalWidget()
        ],
      );
    }
  }

  bool CheckScenarioValidation(int activityId, int actionId) {
    if (activityId == 1) {
      if (actionId == 1) {
        if (validateAreaValue()) {
          return true;
        }
      } else if (actionId == 2 || actionId == 5) {
        if (validateAreaValue() && validatePaymentEndDateValue()) {
          return true;
        }
      } else if (actionId == 3) {
        if (validateAreaValue() && validatePaymentEndDateValue()) return true;
      } else if (actionId == 22 || actionId == 23) {
        return true;
      } else if (actionId == 4) {
        if (validateCurrentSpaceValue() && validateNewSpaceValue()) {
          return true;
        }
      } else if (actionId == 5) {
      } else if (actionId == 9) {
        if (validateAreaValue() && validateNumberOfWorkingDaysValue()) {
          return true;
        }
      } else if (actionId == 1028) {
        if (validateAreaValue()) {
          return true;
        }
      }
    } else if (activityId == 2) {
      if (actionId <= 4) {
        if (validateAreaValue()) return true;
      } else if (actionId == 5) {
        // if (validateNumberOfCertificatesValue())
        return true;
      }
    } else if (activityId == 3) {
      if (validateAreaValue()) return true;
    } else if (activityId == 4) {
      if (actionId == 9) {
        if (validateNumberOfDrillingDaysValue() /*&& validateDistanceValue()*/) {
          return true;
        }
      } else if (actionId == 20) {
        if (validateCostOfPreviousLicenseValue() &&
            validatePreviousLicenseTermValue() &&
            validateLengthOfHoleValue() &&
            validatePreviuosLengthOfHoleValue() &&
            validateTermOfNewLicenseValue()) return true;
      }
    } else if (activityId == 5) {
      return true;
    } else if (activityId == 6) {
      return true;
    } else if (activityId == 7) {
      if (validateAreaValue()) return true;
    } else if (activityId == 8) {
      if (actionId == 1301) {
        // if (validateCertificatesEndDateValue())
        return true;
      } else if (actionId == 1302) {
        // if (validateCertificatesEndDateValue())
        return true;
      }
    } else if (activityId == 9) {
      return true;
    } else if (activityId == 10 && (actionId == 1401 || actionId == 1402)) {
      if (validateDistanceValue() && validatePortLicenseDaysValue())
        return true;
    } else if (activityId == 10 && (actionId == 1403)) {
      return true;
    }
    return false;
  }

  bool changeBtnColor(int? activityId, int? actionId) {
    if (activityId == null && actionId == null) return false;
    if (activityId == 1) {
      if (actionId == 1) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateIsicActivity();
        bool a7 = validateDetailedIsicActivity();
        bool a8 = validateDetailedActivity();
        bool a9 = validateArea();
        bool a10 = validatePanelType();
        bool a11 = validateIsAccomodation();
        bool a12 = validateIsTobacoo();
        if (a1 && a4 && a5 && a6 && a7 && a8 && a9 && a10 && a11 && a12) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 2) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateIsicActivity();
        bool a7 = validateDetailedIsicActivity();
        bool a8 = validateDetailedActivity();
        bool a9 = validateArea();
        bool a11 = validateIsAccomodation();
        bool a12 = validateIsTobacoo();
        bool a13 = validateIsEmptyPaymentEndDateValue();

        if (a1 && a4 && a5 && a6 && a7 && a8 && a9 && a11 && a12 && a13) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 3) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateIsicActivity();
        bool a7 = validateDetailedIsicActivity();
        bool a8 = validateDetailedActivity();
        bool a9 = validateArea();
        bool a11 = validateIsAccomodation();
        bool a12 = validateIsTobacoo();
        bool a13 = validateIsEmptyPaymentEndDateValue();

        if (a1 && a4 && a5 && a6 && a7 && a8 && a9 && a11 && a12 && a13) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 23) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();

        if (a1 && a4 && a5) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 4) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateIsicActivityCurrent();
        bool a7 = validateDetailedIsicActivityCurrent();
        bool a8 = validateIsicActivityNew();
        bool a9 = validateDetailedIsicActivityNew();

        bool a10 = validateDetailedActivityCurrent();
        bool a11 = validateDetailedActivityNew();

        bool a12 = validateIsEmptyCurrentSpaceValue();
        bool a13 = validateIsEmptyNewSpaceValue();

        bool a14 = validatePanelTypeCurrent();
        bool a15 = validatePanelTypeNew();
        bool a16 = validateIsAccomodationCurrent();
        bool a17 = validateIsTobacooNew();
        bool a18 = validateIsAccomodationNew();
        if (a1 &&
            a4 &&
            a5 &&
            a6 &&
            a7 &&
            a8 &&
            a9 &&
            a10 &&
            a11 &&
            a12 &&
            a13 &&
            a14 &&
            a15 &&
            a16 &&
            a17 &&
            a18) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 5) {
        bool a1 = _gisLocation != null;

        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateIsicActivity();
        bool a7 = validateDetailedIsicActivity();
        bool a8 = validateDetailedActivity();
        bool a9 = validateArea();
        bool a11 = validateIsAccomodation();
        bool a12 = validateIsTobacoo();
        bool a13 = validateIsEmptyPaymentEndDateValue();

        if (a1 && a4 && a5 && a6 && a7 && a8 && a9 && a11 && a12 && a13) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 9) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateArea();
        bool a7 = validateNumberOfWorkingDays();
        if (a1 && a4 && a5 && a6 && a7) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 1028) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateIsicActivity();
        bool a7 = validateDetailedIsicActivity();
        bool a8 = validateDetailedActivity();
        bool a9 = validateArea();
        bool a10 = validateIsAccomodation();
        bool a11 = validateIsTobacoo();
        if (a1 && a4 && a5 && a6 && a7 && a8 && a9 && a10 && a11) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 22) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateIsTobacoo();
        if (a1 && a4 && a5 && a6) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 10) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    } else if (activityId == 2) {
      if (actionId! <= 4) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateArea();
        bool a7 = validateSubActivities();

        if (a1 && a4 && a5 && a6 && a7) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 5) {
        bool a1 = _gisLocation != null;
        bool a4 = validateServiceType();
        bool a5 = validateProcedures();
        bool a6 = validateSubActivities();
        if (a1 && a4 && a5 && a6) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      }
    } else if (activityId == 3) {
      bool a1 = _gisLocation != null;
      bool a4 = validateServiceType();
      bool a5 = validateProcedures();
      bool a6 = validateArea();
      bool a7 = validateSubActivities();
      if (a1 && a4 && a5 && a6 && a7) {
        setState(() {
          _isButtonDisabled = false;
        });
      } else {
        setState(() {
          _isButtonDisabled = true;
        });
      }
    } else if (activityId == 4) {
      if (actionId == 9) {
        bool a1 = validateIsEmptyNumberOfDrillingDaysValue();
        //  bool a2 = validateIsEmptyDistanceValue();
        bool a3 = validateSubActivities();
        bool a4 = _gisLocation != null;
        if (a1 && /*a2 &&*/ a3 && a4) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 20) {
        bool a1 = validateIsEmptyCostOfPreviousLicenseValue();
        bool a2 = validateIsEmptyPreviousLicenseTermValue();
        bool a3 = validateIsEmptyLengthOfHoleValue();
        bool a5 = validateIsEmptyPreviousLengthOfHoleValue();
        bool a4 = validateIsEmptyTermOfNewLicenseValue();
        bool a6 = validateSubActivities();
        bool a7 = _gisLocation != null;
        if (a1 && a2 && a3 && a4 && a5 && a6 && a7) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      }
    } else if (activityId == 5) {
      bool a1 = _gisLocation != null;
      if (a1 && validateSubActivities()) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    } else if (activityId == 6) {
      bool a1 = _gisLocation != null;

      if (a1 && validateSubActivities()) {
        setState(() {
          _isButtonDisabled = false;
        });
      }
    } else if (activityId == 7) {
      bool a1 = validateArea();
      bool a2 = validateSubActivities();
      bool a3 = _gisLocation != null;
      if (a1 && a2 && a3) {
        setState(() {
          _isButtonDisabled = false;
        });
      } else {
        setState(() {
          _isButtonDisabled = true;
        });
      }
    } else if (activityId == 8) {
      if (actionId == 1301) {
        bool a1 = _gisLocation != null;
        if (a1) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      } else if (actionId == 1302) {
        bool a1 = _gisLocation != null;
        if (a1) {
          setState(() {
            _isButtonDisabled = false;
          });
        } else {
          setState(() {
            _isButtonDisabled = true;
          });
        }
      }
    } else if (activityId == 9) {
      bool a1 = _gisLocation != null;
      bool a2 = validateSubActivities();
      if (a2 && a1) {
        setState(() {
          _isButtonDisabled = false;
        });
      } else {
        setState(() {
          _isButtonDisabled = true;
        });
      }
    } else if (activityId == 10 && (actionId == 1401 || actionId == 1402)) {
      bool a1 = _gisLocation != null;
      bool a2 = validateDistanceValue();
      bool a3 = validatePortLicenseDaysValue();

      if (a1 && a2 && a3) {
        setState(() {
          _isButtonDisabled = false;
        });
      } else {
        setState(() {
          _isButtonDisabled = true;
        });
      }
    } else if (activityId == 10 && (actionId == 1403)) {
      bool a1 = _gisLocation != null;

      if (a1) {
        setState(() {
          _isButtonDisabled = false;
        });
      } else {
        setState(() {
          _isButtonDisabled = true;
        });
      }
    }

    return true;
  }

  Widget S1_1() {
    return Column(
      children: <Widget>[
        _serviceIsicActivityWidget(),
        _serviceDetailedIsicActivityWidget(),
        if (_serviceDetailedActivityController != null) ...S1_1_details()
      ],
    );
  }

  List<Widget> S1_1_details() {
    List<Widget> children = [
      if (_serviceDetailedActivityController!.unit != "license") AreaWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.isTabacco == 1)
        _serviceZonesWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.unit == "unit")
        _serviceAccomodationsWidget(),
      IsThereCleaningContractWidget(),
      _boardsTypes(),
    ];
    return children;
  }

  Widget S1_2() {
    return Column(
      children: <Widget>[
        _serviceIsicActivityWidget(),
        _serviceDetailedIsicActivityWidget(),
        if (_serviceDetailedActivityController != null) ...S1_2_details()
      ],
    );
  }

  List<Widget> S1_2_details() {
    List<Widget> children = [
      if (_serviceDetailedActivityController!.unit != "license") AreaWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.isTabacco == 1)
        _serviceZonesWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.unit == "unit")
        _serviceAccomodationsWidget(),
      IsThereCleaningContractWidget(),
      PaymentEndDateWidget(),
      _boardsTypes()
    ];

    return children;
  }

  Widget S1_3() {
    return Column(
      children: <Widget>[
        _serviceIsicActivityWidget(),
        _serviceDetailedIsicActivityWidget(),
        if (_serviceDetailedActivityController != null) ...S1_3_details()
      ],
    );
  }

  List<Widget> S1_3_details() {
    List<Widget> children = [
      if (_serviceDetailedActivityController!.unit != "license") AreaWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.isTabacco == 1)
        _serviceZonesWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.unit == "unit")
        _serviceAccomodationsWidget(),
      PaymentEndDateWidget(),
      _boardsTypes(),
    ];

    return children;
  }

  Widget S1_4() {
    return Column(
      children: <Widget>[
        _serviceIsicActivityCurrentWidget(),
        _serviceDetailedIsicActivityCurrentWidget(),
        // if (_serviceDetailedActivityCurrentController!= null && _serviceDetailedActivityCurrentController.isTabacco == 1)
        // _serviceZonesCurrentWidget(),
        if (_serviceDetailedActivityCurrentController != null &&
            _serviceDetailedActivityCurrentController!.unit == "unit")
          _serviceAccomodationsCurrentWidget(),

        _serviceIsicActivityNewWidget(),
        _serviceDetailedIsicActivityNewWidget(),
        if (_serviceDetailedActivityNewController != null &&
            _serviceDetailedActivityNewController!.isTabacco == 1)
          _serviceZonesWidget(),
        if (_serviceDetailedActivityNewController != null &&
            _serviceDetailedActivityNewController!.unit == "unit")
          _serviceAccomodationsNewWidget(),

        if (_serviceDetailedActivityCurrentController != null &&
            _serviceDetailedActivityNewController != null)
          ...S1_4_details()
      ],
    );
  }

  List<Widget> S1_4_details() {
    List<Widget> children = [
      if (_serviceDetailedActivityCurrentController!.unit != "license")
        CurrentSpaceWidget(),
      if (_serviceDetailedActivityNewController!.unit != "license")
        newSpaceWidget(),
      IsThereCleaningContractCurrentWidget(),
      IsThereCleaningContractNewWidget(),
      _currentBoardsTypes(),
      _newBoardsTypes(),
    ];
    return children;
  }

  Widget S1_5() {
    return Column(
      children: <Widget>[
        _serviceIsicActivityWidget(),
        _serviceDetailedIsicActivityWidget(),
        if (_serviceDetailedActivityController != null) ...S1_5_details()
      ],
    );
  }

  List<Widget> S1_5_details() {
    List<Widget> children = [
      if (_serviceDetailedActivityController!.unit != "license") AreaWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.isTabacco == 1)
        _serviceZonesWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.unit == "unit")
        _serviceAccomodationsWidget(),
      IsThereCleaningContractWidget(),
      PaymentEndDateWidget(),
      _boardsTypes()
    ];

    return children;
  }

  Widget S1_6() {
    return Column(
      children: <Widget>[AreaWidget(), NumberOfWorkingDaysWidget()],
    );
  }

  Widget S1_7() {
    return Column(
      children: <Widget>[
        Container(
          child: Text(
            "releaseText".tr(),
            textScaleFactor: 1,
          ),
        )
      ],
    );
  }

  Widget S1_8() {
    return Column(children: <Widget>[
      // _serviceIsicActivityWidget(),
      //  _serviceDetailedIsicActivityWidget(),
      _serviceZonesWidget(),
      _serviceAccomodationsWidget(),
    ]);
  }

  Widget S1_9() {
    return Column(
      children: <Widget>[
        // AreaWidget(),
      ],
    );
  }

  Widget S1_10() {
    return Column(
      children: <Widget>[
        _serviceIsicActivityWidget(),
        _serviceDetailedIsicActivityWidget(),
        if (_serviceDetailedActivityController != null) ...S1_10_details()
      ],
    );
  }

  List<Widget> S1_10_details() {
    List<Widget> children = [
      if (_serviceDetailedActivityController!.unit != "license") AreaWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.isTabacco == 1)
        _serviceZonesWidget(),
      if (_serviceDetailedActivityController != null &&
          _serviceDetailedActivityController!.unit == "unit")
        _serviceAccomodationsWidget(),
    ];
    return children;
  }

  Widget S2_1_4() {
    return Column(
      children: <Widget>[_serviceActivitiesWidget(), AreaWidget()],
    );
  }

  Widget S2_5() {
    return Column(
      children: <Widget>[
        _serviceActivitiesWidget(),
        //  NumberOfCertificatesWidget()
      ],
    );
  }

  Widget S3() {
    return Column(
      children: <Widget>[_serviceActivitiesWidget(), AreaWidget()],
    );
  }

  Widget S4_1() {
    return Column(
      children: <Widget>[
        _serviceActivitiesWidget(),
        NumberOfDrillingDaysWidget(),
        // DistanceWidget()
      ],
    );
  }

  Widget S4_2() {
    return Column(
      children: <Widget>[
        _serviceActivitiesWidget(),
        CostOfPreviousLicenseWidget(),
        PreviousLicenseTermWidget(),
        LengthOfHolePreviousWidget(),
        LengthOfHoleWidget(),
        TermOfNewLicenseWidget()
      ],
    );
  }

  Widget S5() {
    return Column(
      children: <Widget>[
        _serviceActivitiesWidget(),
      ],
    );
  }

  Widget S6() {
    return Column(
      children: <Widget>[
        _serviceActivitiesWidget(),
      ],
    );
  }

  Widget S7() {
    return Column(
      children: <Widget>[_serviceActivitiesWidget(), AreaWidget()],
    );
  }

  Widget S8_1() {
    return Column(
      children: <Widget>[
        //  NumberOfCertificatesWidget()
        //  CertificateEndDateWidget()
      ],
    );
  }

  Widget S8_2() {
    return Column(
      children: <Widget>[
        //   CertificateEndDateWidget()
      ],
    );
  }

  Widget S9() {
    return Column(
      children: <Widget>[
        _serviceActivitiesWidget(),
        // NumberOfDocumentsWidget()
      ],
    );
  }

  // Create Cost Of Previous License Widget
  Widget CostOfPreviousLicenseWidget() {
    return CustomTextFieldWidget(
      key: _costOfPreviousLicenseControllerKey,
      label: Helpers.translatingWord("lbl_cost_of_previous_license"),
      controller: _costOfPreviousLicenseController,
      focusNode: _costOfPreviousLicenseFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        //if (!isValidCostOfPreviousLicense) return _CostOfPreviousLicenseErrMsg;
        // return null;
      },
      suffixIcon: labelUnit("lbl_SAR"),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_previousLicenseTermFocusNode);
      },
      spacerSize: 20,
    );
  }

  // Create Previous License Term Widget Widget
  Widget PreviousLicenseTermWidget() {
    return CustomTextFieldWidget(
      key: _previousLicenseTermControllerKey,
      label: Helpers.translatingWord("lbl_previous_license_term"),
      controller: _previousLicenseTermController,
      focusNode: _previousLicenseTermFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        //return _PreviousLicenseTermErrMsg;
      },
      suffixIcon: labelUnit("lbl_day"),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_lengthOfPreviuosFocusNode);
      },
      spacerSize: 20,
    );
  }

  // Create Length Of Hole Widget
  Widget LengthOfHoleWidget() {
    return CustomTextFieldWidget(
      key: _lengthOfHoleControllerKey,
      label: Helpers.translatingWord("lbl_length_of_hole"),
      controller: _lengthOfHoleController,
      focusNode: _lengthOfHoleFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _LengthOfHoleErrMsg;
      },
      suffixIcon: labelUnit("lbl_meter"),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_termOfNewLicenseFocusNode);
      },
      spacerSize: 20,
    );
  }

  // Create Length Of Hole Previous Widget
  Widget LengthOfHolePreviousWidget() {
    return CustomTextFieldWidget(
      key: _lengthOfPreviuosControllerKey,
      label: Helpers.translatingWord("lbl_length_previuos_of_hole"),
      controller: _lengthOfPreviuosHoleController,
      focusNode: _lengthOfPreviuosFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _LengthOPreviousfHoleErrMsg;
      },
      suffixIcon: labelUnit("lbl_meter"),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_lengthOfHoleFocusNode);
      },
      spacerSize: 20,
    );
  }

  // Create Term Of  License Widget
  Widget TermOfNewLicenseWidget() {
    return CustomTextFieldWidget(
      key: _termOfNewLicenseControllerKey,
      label: Helpers.translatingWord("lbl_term_of_new_license"),
      controller: _termOfNewLicenseController,
      focusNode: _termOfNewLicenseFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _TermOfNewLicenseErrMsg;
      },
      suffixIcon: labelUnit("lbl_day"),
      textInputAction: TextInputAction.done,
      spacerSize: 20,
    );
  }

  Widget IsThereCleaningContractWidget() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            CustomTextWidget(
              Helpers.translatingWord("lbl_is_there_cleaning_contract"),
              fontColor: AppColor.baladyDarkGreen2,
              fontSize: 13,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Column(
          children: <Widget>[
            Row(
              children: [
                Radio(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: AppColor.primary900Light,
                  value: 1,
                  groupValue: _IsThereCleaningContractValue,
                  onChanged: _handleRadioValueChange1,
                ),
                Text(
                  Helpers.translatingWord("Yes"),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  activeColor: AppColor.primary900Light,
                  value: 0,
                  groupValue: _IsThereCleaningContractValue,
                  onChanged: _handleRadioValueChange1,
                ),
                Text(
                  Helpers.translatingWord("No"),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textScaleFactor: 1,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget IsThereCleaningContractCurrentWidget() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            CustomTextWidget(
              Helpers.translatingWord("lbl_is_there_cleaning_current_contract"),
              fontColor: AppColor.baladyDarkGreen2,
              fontSize: 13,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Column(
          children: <Widget>[
            Row(
              children: [
                Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: AppColor.primary900Light,
                    value: 1,
                    groupValue: _isThereCleaningContractCurrentValue,
                    onChanged: (value) {
                      setState(() {
                        _isThereCleaningContractCurrentValue =
                            int.parse(value.toString());
                      });
                    }),
                Text(
                  Helpers.translatingWord("Yes"),
                  style: TextStyle(fontSize: 16.0),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: AppColor.primary900Light,
                    value: 0,
                    groupValue: _isThereCleaningContractCurrentValue,
                    onChanged: (value) {
                      setState(() {
                        _isThereCleaningContractCurrentValue =
                            int.parse(value.toString());
                      });
                    }),
                Text(
                  Helpers.translatingWord("No"),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  textScaleFactor: 1,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget IsThereCleaningContractNewWidget() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            CustomTextWidget(
              Helpers.translatingWord("lbl_is_there_cleaning_new_contract"),
              fontColor: AppColor.baladyDarkGreen2,
              fontSize: 13,
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Column(
          children: <Widget>[
            Row(
              children: [
                Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: AppColor.primary900Light,
                    value: 1,
                    groupValue: _isThereCleaningContractNewValue,
                    onChanged: (value) {
                      setState(() {
                        _isThereCleaningContractNewValue =
                            int.parse(value.toString());
                      });
                    }),
                Text(
                  Helpers.translatingWord("Yes"),
                  style: TextStyle(fontSize: 16.0),
                  textScaleFactor: 1,
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    activeColor: AppColor.primary900Light,
                    value: 0,
                    groupValue: _isThereCleaningContractNewValue,
                    onChanged: (value) {
                      setState(() {
                        _isThereCleaningContractNewValue =
                            int.parse(value.toString());
                      });
                    }),
                Text(
                  Helpers.translatingWord("No"),
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                  textScaleFactor: 1,
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  final _dateController = TextEditingController();

  HijriCalendar selectedDateHijri = HijriCalendar.now();

  var hijriDate;

  void _presentHijriDatePicker() async {
    hideKeybaord();
    HijriPicker.Picker(
        textScaleFactor: 1,
        confirmTextStyle: const TextStyle(
            fontFamily: Constants.appFontType,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            color: AppColor.baladyDarkGreen2),
        headercolor: const Color(0xfffafaf8),
        cancel: Container(),
        confirmText: Helpers.translatingWord("date_picker_confirm"),
        title: Text(
          Helpers.translatingWord("date_picker_header"),
          style: const TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 15.0),
          textAlign: TextAlign.right,
          textScaleFactor: 1,
        ),
        hideHeader: false,
        adapter: HijriPicker.DateTimePickerAdapter(
            customColumnType: [0, 1, 2], value: hijriDate),
        selectedTextStyle: TextStyle(color: AppColor.baladyDarkGreen2),
        onConfirm: (HijriPicker.Picker picker, List value) {
          var date =
              (picker.adapter as HijriPicker.DateTimePickerAdapter).value;
          selectedDateHijri = date!;
          hijriDate = date;
          if (currentActivityId == 1)
            _paymentEndDateController.text =
                CommonFunctions.replaceArabicNumberWithEnglish(
                    date.toFormat("dd/mm/yyyy"));
          else if (currentActivityId == 8)
            _certificatesEndDateController.text =
                CommonFunctions.replaceArabicNumberWithEnglish(
                    date.toFormat("dd/mm/yyyy"));

          changeBtnColor(_selectedServiceId, _selectedActionId);
        }).showModal(context);
  }

  Widget PaymentEndDateWidget() {
    return DropDownWithTitle(
        title: Helpers.translatingWord("lbl_payment_end_date"),
        selectedValue: _paymentEndDateController.text.isNotEmpty
            ? _paymentEndDateController.text
            : "dd/mm/yyyy",
        onTap: () {
          _presentHijriDatePicker();
        });
  }

  // Create Current Space Widget
  Widget CurrentSpaceWidget() {
    String title = (_serviceDetailedActivityCurrentController != null &&
            _serviceDetailedActivityCurrentController!.unit == "unit")
        ? Helpers.translatingWord("lbl_unit_current")
        : Helpers.translatingWord("lbl_current_space");

    Widget suffixText = _serviceDetailedActivityCurrentController != null
        ? labelUnitText(_serviceDetailedActivityCurrentController!.unitDesc)
        : labelUnit("lbl_m2");

    return CustomTextFieldWidget(
      label: title,
      controller: _currentSpaceController,
      focusNode: _currentSpaceFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _CurrentSpaceErrMsg;
      },
      suffixIcon: suffixText,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_newSpaceFocusNode);
      },
      spacerSize: 20,
    );
  }

  Widget labelUnit(String text) {
    return SizedBox(
      width: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Helpers.translatingWord(text),
          style: const TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 13.0),
          textAlign: TextAlign.center,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  Widget labelUnitText(String? text) {
    return SizedBox(
      width: 50,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text!,
          style: const TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 13.0),
          textAlign: TextAlign.center,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  // Create  Space Widget
  Widget newSpaceWidget() {
    String title = (_serviceDetailedActivityNewController != null &&
            _serviceDetailedActivityNewController!.unit == "unit")
        ? Helpers.translatingWord("lbl_unit_new")
        : Helpers.translatingWord("lbl_new_space");

    Widget suffixText = _serviceDetailedActivityNewController != null
        ? labelUnitText(_serviceDetailedActivityNewController!.unitDesc)
        : labelUnit("lbl_m2");

    return CustomTextFieldWidget(
      label: title,
      controller: _newSpaceController,
      focusNode: _newSpaceFocusNode,
      keyboardType: TextInputType.number,
      fillColor: Colors.transparent,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        //  return _NewSpaceErrMsg;
      },
      suffixIcon: suffixText,
      textInputAction: TextInputAction.done,
      spacerSize: 20,
    );
  }

  // Create Number Of Certificates Widget
  Widget NumberOfCertificatesWidget() {
    return CustomTextFieldWidget(
      label: Helpers.translatingWord("lbl_number_of_certificates"),
      controller: _numberOfCertificatesController,
      focusNode: _numberOfCertificatesFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _NumberOfCertificatesErrMsg;
      },
      suffixIcon: labelUnit("lbl_Certificate"),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_lengthOfHoleFocusNode);
      },
      spacerSize: 20,
    );
  }

  // Create Number Of Working Days Widget
  Widget NumberOfWorkingDaysWidget() {
    return CustomTextFieldWidget(
      label: Helpers.translatingWord("lbl_number_of_working_days"),
      controller: _numberOfWorkingDaysController,
      focusNode: _numberOfWorkingDaysFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _NumberOfWorkingDaysErrMsg;
      },
      suffixIcon: labelUnit("lbl_day"),
      textInputAction: TextInputAction.done,
      spacerSize: 20,
    );
  }

  // Create Number Of Drilling Days Widget
  Widget NumberOfDrillingDaysWidget() {
    return CustomTextFieldWidget(
      label: Helpers.translatingWord("lbl_number_of_drilling_days"),
      controller: _numberOfDrillingDaysController,
      focusNode: _numberOfDrillingDaysFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _NumberOfDrillingDaysErrMsg;
      },
      suffixIcon: labelUnit("lbl_day"),
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        FocusScope.of(context).requestFocus(_distanceFocusNode);
      },
      spacerSize: 20,
    );
  }

  // Create Distance Widget
  Widget DistanceWidget() {
    return CustomTextFieldWidget(
      label: Helpers.translatingWord("space_square"),
      controller: _distanceController,
      focusNode: _distanceFocusNode,
      keyboardType: TextInputType.number,
      fillColor: Colors.transparent,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _DistanceErrMsg;
      },
      spacerSize: 20,
      textInputAction: TextInputAction.done,
    );
  }

  Widget PortLicenseDaysWidget() {
    return CustomTextFieldWidget(
      label: Helpers.translatingWord("approve_days"),
      controller: _portLicenseDays,
      focusNode: _portLicenseDaysFocusNode,
      keyboardType: TextInputType.number,
      fillColor: Colors.transparent,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _DistanceErrMsg;
      },
      spacerSize: 20,
      textInputAction: TextInputAction.done,
    );
  }

  Widget PortRentalWidget() {
    return CustomTextFieldWidget(
      label: Helpers.translatingWord("daily_rent"),
      controller: _portRental,
      focusNode: _portRentalFocusNode,
      keyboardType: TextInputType.number,
      fillColor: Colors.transparent,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _DistanceErrMsg;
      },
      spacerSize: 20,
      textInputAction: TextInputAction.done,
    );
  }

  // Create Number of Documents Widget
  Widget NumberOfDocumentsWidget() {
    return CustomTextFieldWidget(
      label: Helpers.translatingWord("lbl_number_of_documents"),
      controller: _numberOfDocumentsController,
      focusNode: _numberOfDocumentsFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // return _NumberOfDocumentsErrMsg;
      },
      spacerSize: 20,
      suffixIcon: labelUnit("lbl_Document"),
      textInputAction: TextInputAction.done,
    );
  }

  Widget CertificateEndDateWidget() {
    return DropDownWithTitle(
        title: Helpers.translatingWord("lbl_certificate_end_date"),
        selectedValue: _certificatesEndDateController.text.isNotEmpty
            ? _certificatesEndDateController.text
            : "dd/mm/yyyy",
        /* descColor: _certificatesEndDateController.text.isNotEmpty
            ? AppColor.black
            : AppColor.black300,
        descSize: _certificatesEndDateController.text.isNotEmpty ? 16 : 13,*/
        onTap: () {
          _presentHijriDatePicker();
        });
  }

// Create Area Widget
  Widget AreaWidget() {
    String title = (_serviceDetailedActivityController != null &&
            _serviceDetailedActivityController!.unit == "unit")
        ? Helpers.translatingWord("lbl_unit")
        : (currentactionId == 9
            ? Helpers.translatingWord("lbl_area")
            : Helpers.translatingWord("lbl_area"));
    Widget suffixText = _serviceDetailedActivityController != null
        ? labelUnitText(_serviceDetailedActivityController!.unitDesc)
        : labelUnit("lbl_m2");

    if (currentActivityId == 2 &&
        currentactionId! <= 4 &&
        _serviceDetailedActivityController == null &&
        _serviceSubActivityController != null) {
      if (_serviceSubActivityController!.name_ar == "الأسوار") {
        title = Helpers.translatingWord("lbl_length");
        suffixText = labelUnit("lbl_meter");
      }
    }

    return CustomTextFieldWidget(
      label: title,
      controller: _areaController,
      focusNode: _areaFocusNode,
      fillColor: Colors.transparent,
      keyboardType: TextInputType.number,
      onChanged: (txt) {
        changeBtnColor(_selectedServiceId, _selectedActionId);
      },
      onValidate: (text) {
        // if (!isValidArea) return _AreaErrMsg;
        // return null;
      },
      spacerSize: 20,
      suffixIcon: suffixText,
      textInputAction: TextInputAction.done,
    );
  }

  bool validateCostOfPreviousLicenseValue() {
    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _costOfPreviousLicenseController.text.trim());

    if (_costOfPreviousLicenseController.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidCostOfPreviousLicense = true;
        _CostOfPreviousLicenseErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidCostOfPreviousLicense = false;
        _CostOfPreviousLicenseErrMsg =
            Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validatePreviousLicenseTermValue() {
    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _previousLicenseTermController.text.trim());

    if (_previousLicenseTermController.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidPreviousLicenseTerm = true;
        _PreviousLicenseTermErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidPreviousLicenseTerm = false;
        _PreviousLicenseTermErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateLengthOfHoleValue() {
    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _lengthOfHoleController.text.trim());

    if (_lengthOfHoleController.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidLengthOfHole = true;
        _LengthOfHoleErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidLengthOfHole = false;
        _LengthOfHoleErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validatePreviuosLengthOfHoleValue() {
    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _lengthOfPreviuosHoleController.text.trim());

    if (_lengthOfPreviuosHoleController.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidPreviuosLengthOfHole = true;
        _LengthOPreviousfHoleErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidPreviuosLengthOfHole = false;
        _LengthOPreviousfHoleErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateTermOfNewLicenseValue() {
    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _termOfNewLicenseController.text.trim());

    if (_termOfNewLicenseController.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidTermOfNewLicense = true;
        _TermOfNewLicenseErrMsg = null;
      });

      return true;
    } else {
      setState(() {
        isValidTermOfNewLicense = false;
        _TermOfNewLicenseErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateAreaValue() {
    if (_serviceDetailedActivityController != null &&
        _serviceDetailedActivityController!.unit == "license") return true;

    if (_areaController.text.isNotEmpty &&
        double.tryParse(CommonFunctions.replaceArabicNumberWithEnglish(
                _areaController.text.trim())) !=
            null &&
        double.parse(CommonFunctions.replaceArabicNumberWithEnglish(
                _areaController.text.trim())) >
            0) {
      setState(() {
        isValidArea = true;
        _AreaErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidArea = false;
        _AreaErrMsg = Helpers.translatingWord("lbl_test_error");
      });
      return false;
    }
  }

  bool validateNumberOfWorkingDaysValue() {
    if (_numberOfWorkingDaysController.text.isNotEmpty &&
        int.tryParse(CommonFunctions.replaceArabicNumberWithEnglish(
                _numberOfWorkingDaysController.text.trim())) !=
            null &&
        int.parse(CommonFunctions.replaceArabicNumberWithEnglish(
                _numberOfWorkingDaysController.text.trim())) >
            0) {
      setState(() {
        isValidNumberOfWorkingDays = true;
        _NumberOfWorkingDaysErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidNumberOfWorkingDays = false;
        _NumberOfWorkingDaysErrMsg = Helpers.translatingWord("lbl_test_error");
      });
      return false;
    }
  }

  bool validatePaymentEndDateValue() {
    if (_paymentEndDateController.text.isEmpty) {
      setState(() {
        isValidPaymentEndDate = false;
        _PaymentEndDateErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    } else {
      setState(() {
        isValidPaymentEndDate = true;
        _PaymentEndDateErrMsg = null;
      });
      return true;
    }
  }

  bool validatePaymentEndDateNotExpiredValue() {
    if (_paymentEndDateController.text.isEmpty) {
      setState(() {
        isValidPaymentEndDate = false;
        _PaymentEndDateErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    } else {
      // if (selectedDateHijri.isAfter(ummAlquraCalendar.now().hYear,
      //     ummAlquraCalendar.now().hMonth, ummAlquraCalendar.now().hDay)) {
      //   setState(() {
      //     isValidPaymentEndDate = true;
      //     _PaymentEndDateErrMsg = null;
      //   });
      //   return true;
      // } else {
      //   setState(() {
      //     isValidPaymentEndDate = false;
      //     _PaymentEndDateErrMsg =
      //         Helpers.translatingWord("lbl_test_error_valid_date");
      //   });

      return false;
    }
  }

  bool validateCurrentSpaceValue() {
    if (_serviceDetailedActivityCurrentController!.unit != null &&
        _serviceDetailedActivityCurrentController!.unit == "license")
      return true;

    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _currentSpaceController.text.trim());

    if (_currentSpaceController.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidCurrentSpace = true;
        _CurrentSpaceErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidCurrentSpace = false;
        _CurrentSpaceErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateNewSpaceValue() {
    if (_serviceDetailedActivityNewController != null &&
        _serviceDetailedActivityNewController!.unit == "license") return true;

    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _newSpaceController.text.trim());

    if (_newSpaceController.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidNewSpace = true;
        _NewSpaceErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidNewSpace = false;
        _NewSpaceErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateNumberOfCertificatesValue() {
    if (_numberOfCertificatesController.text.isNotEmpty &&
        double.tryParse(_numberOfCertificatesController.text) != null &&
        double.parse(_numberOfCertificatesController.text) > 0) {
      setState(() {
        isValidNumberOfCertificates = true;
        _NumberOfCertificatesErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidNumberOfCertificates = false;
        _NumberOfCertificatesErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateCertificatesEndDateValue() {
    if (_certificatesEndDateController.text.isEmpty) {
      setState(() {
        isValidCertificatesEndDate = false;
        _CertificatesEndDateErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    } else {
      setState(() {
        isValidCertificatesEndDate = true;
        _CertificatesEndDateErrMsg = null;
      });
      return true;
    }
  }

  bool validateNumberOfDrillingDaysValue() {
    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _numberOfDrillingDaysController.text.trim());

    if (_numberOfDrillingDaysController.text.isNotEmpty &&
        int.tryParse(value) != null &&
        int.parse(value) > 0) {
      setState(() {
        isValidNumberOfDrillingDays = true;
        _NumberOfDrillingDaysErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidNumberOfDrillingDays = false;
        _NumberOfDrillingDaysErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateDistanceValue() {
    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _distanceController.text.trim());

    if (_distanceController.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidDistance = true;
      });
      return true;
    } else {
      setState(() {
        isValidDistance = false;
        _DistanceErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validatePortLicenseDaysValue() {
    String value = CommonFunctions.replaceArabicNumberWithEnglish(
        _portLicenseDays.text.trim());

    if (_portLicenseDays.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidLicenseDays = true;
      });
      return true;
    } else {
      setState(() {
        isValidLicenseDays = false;
      });

      return false;
    }
  }

  bool validateRentalDaysValue() {
    String value =
        CommonFunctions.replaceArabicNumberWithEnglish(_portRental.text.trim());

    if (_portRental.text.isNotEmpty &&
        double.tryParse(value) != null &&
        double.parse(value) > 0) {
      setState(() {
        isValidRental = true;
      });
      return true;
    } else {
      setState(() {
        isValidRental = false;
      });

      return false;
    }
  }

  bool validateNumberOfDocumentsValue() {
    if (_numberOfDocumentsController.text.isNotEmpty &&
        double.tryParse(_numberOfDocumentsController.text) != null &&
        double.parse(_numberOfDocumentsController.text) > 0) {
      setState(() {
        isValidNumberOfDocuments = true;
        _NumberOfDocumentsErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidNumberOfDocuments = false;
        _NumberOfDocumentsErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateIsEmptyCostOfPreviousLicenseValue() {
    if (_costOfPreviousLicenseController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyPreviousLicenseTermValue() {
    if (_previousLicenseTermController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyLengthOfHoleValue() {
    if (_lengthOfHoleController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyPreviousLengthOfHoleValue() {
    if (_lengthOfPreviuosHoleController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyTermOfNewLicenseValue() {
    if (_termOfNewLicenseController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyPaymentEndDateValue() {
    if (_paymentEndDateController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyCurrentSpaceValue() {
    if (_serviceDetailedActivityCurrentController != null &&
        _serviceDetailedActivityCurrentController!.unit == "license") {
      return true;
    }

    if (_currentSpaceController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyNewSpaceValue() {
    if (_serviceDetailedActivityNewController != null &&
        _serviceDetailedActivityNewController!.unit == "license") return true;

    if (_newSpaceController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyNumberOfCertificatesValue() {
    if (_numberOfCertificatesController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyCertificatesEndDateValue() {
    if (_certificatesEndDateController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyNumberOfDrillingDaysValue() {
    if (_numberOfDrillingDaysController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyDistanceValue() {
    if (_distanceController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateIsEmptyNumberOfDocumentsValue() {
    if (_numberOfDocumentsController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  bool validateServiceType() {
    if (_serviceTypeController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateProcedures() {
    if (_serviceProcedureController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateSubActivities() {
    if (_serviceSubActivityController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateIsicActivity() {
    if (_serviceIsicActivityController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateIsicActivityCurrent() {
    if (_serviceIsicActivityCurrentController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateIsicActivityNew() {
    if (_serviceIsicActivityNewController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateDetailedIsicActivity() {
    if (_serviceDetailedIsicActivityController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateDetailedIsicActivityCurrent() {
    if (_serviceDetailedIsicActivityCurrentController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateDetailedIsicActivityNew() {
    if (_serviceDetailedIsicActivityCurrentController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateDetailedActivity() {
    if (_serviceDetailedActivityController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateDetailedActivityCurrent() {
    if (_serviceDetailedActivityCurrentController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateDetailedActivityNew() {
    if (_serviceDetailedActivityNewController != null) {
      return true;
    } else {
      return false;
    }
  }

  bool validateArea() {
    if (_serviceDetailedActivityController != null &&
        _serviceDetailedActivityController!.unit == "license") return true;
    if (_areaController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool validateNumberOfWorkingDays() {
    if (_numberOfWorkingDaysController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  bool validatePanelType() {
    bool valid = false;
    if (currentActivityId == 1) {
      if (currentactionId == 1 ||
          currentactionId == 2 ||
          currentactionId == 5 ||
          currentactionId == 3) {
        if (_boards!.isNotEmpty) valid = true;
      }
    }
    return valid;
  }

  bool validatePanelTypeCurrent() {
    bool valid = false;

    if (currentActivityId == 1) {
      if (currentactionId == 4) {
        if (_currentBoards!.isNotEmpty) valid = true;
      }
    }
    return valid;
  }

  bool validatePanelTypeNew() {
    bool valid = false;

    if (currentActivityId == 1) {
      if (currentactionId == 4) {
        if (_newBoards!.isNotEmpty) valid = true;
      }
    }
    return valid;
  }

  bool validateIsAccomodation() {
    if (_serviceDetailedActivityController != null) {
      if (_serviceDetailedActivityController!.unit == "unit") {
        if (_serviceAccomodationController == null) {
          return false;
        } else {
          return true;
        }
      }
    }
    return true;
  }

  bool validateIsAccomodationCurrent() {
    if (_serviceDetailedActivityCurrentController != null) {
      if (_serviceDetailedActivityCurrentController!.unit == "unit") {
        if (_serviceAccomodationCurrentController == null) {
          return false;
        } else {
          return true;
        }
      }
    }
    return true;
  }

  bool validateIsAccomodationNew() {
    if (_serviceDetailedActivityNewController != null) {
      if (_serviceDetailedActivityNewController!.unit == "unit") {
        if (_serviceAccomodationNewController == null) {
          return false;
        } else {
          return true;
        }
      }
    }
    return true;
  }

  bool validateIsTobacoo() {
    if ((_serviceDetailedActivityController != null &&
            _serviceDetailedActivityController!.isTabacco == 1) ||
        _selectedActionId == 22) {
      if (_serviceZoneController == null) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  bool validateIsTobacooCurrent() {
    if (_serviceDetailedActivityController != null &&
        _serviceDetailedActivityCurrentController!.isTabacco == 1) {
      if (_serviceZoneCurrentController == null) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  bool validateIsTobacooNew() {
    if (_serviceDetailedActivityController != null &&
        _serviceDetailedActivityNewController!.isTabacco == 1) {
      if (_serviceZoneController == null) {
        return false;
      } else {
        return true;
      }
    }
    return true;
  }

  CalculateCostV03 createCalculateV03Request() {
    CalculateCostV03 request = CalculateCostV03();
    request.paymentYearsCount = 1;
    request.serviceTypeId = _serviceProcedureController!.id;

    if (_serviceDetailedActivityController! != null)
      request.isicDetailedActivityId = _serviceDetailedActivityController!.id;

    request.isVisit = true;
    request.subMunicipalityId = _gisLocation!.sub_Municipalityguid;

    if (_serviceDetailedActivityController!.unit == "unit")
      request.accommodationTypeId = _serviceAccomodationController!.id;
    if (_serviceDetailedActivityController!.unit == "license") {
      request.area = 1;
    } else {
      if (_areaController.text.isNotEmpty) {
        String formattedNumber = CommonFunctions.replaceArabicNumberWithEnglish(
            _areaController.text.trim());
        request.area = double.parse(formattedNumber);
      }
    }

    if (_serviceDetailedActivityController!.isTabacco == 1) {
      request.isTobacco = true;
      request.zone = _serviceZoneController!.id;
    } else {
      request.isTobacco = false;
    }

    request.activity24Type =
        _serviceDetailedActivityController!.twentyFourHourStatus;
    return request;
  }

  CalculateCostV03 getServiceOneInitRequest() {
    CalculateCostV03 request = CalculateCostV03();
    request.paymentYearsCount = 1;
    request.serviceTypeId = _serviceProcedureController!.id;
    request.isicDetailedActivityId = _serviceDetailedActivityController!.id;
    request.isVisit = true;
    request.subMunicipalityId = _gisLocation!.sub_Municipalityguid;

    if (_serviceDetailedActivityController!.unit == "unit")
      request.accommodationTypeId = _serviceAccomodationController!.id;
    if (_serviceDetailedActivityController!.unit == "license") {
      request.area = 1;
    } else {
      String formattedNumber = CommonFunctions.replaceArabicNumberWithEnglish(
          _areaController.text.trim());

      request.area = double.parse(formattedNumber);
    }

    if (_serviceDetailedActivityController!.isTabacco == 1) {
      request.isTobacco = true;
      request.zone = _serviceZoneController!.id;
    } else {
      request.isTobacco = false;
    }

    request.activity24Type =
        _serviceDetailedActivityController!.twentyFourHourStatus;
    return request;
  }

  CalculateCostV03 getServiceIssueTobaccoRequest() {
    CalculateCostV03 request = CalculateCostV03();
    request.paymentYearsCount = 1;
    request.serviceTypeId = _serviceProcedureController!.id;
    request.isVisit = true;
    request.subMunicipalityId = _gisLocation!.sub_Municipalityguid;

    if (_serviceAccomodationController != null)
      request.accommodationTypeId = _serviceAccomodationController!.id;

    request.isTobacco = true;
    request.zone = _serviceZoneController!.id;

    return request;
  }

  CalculateCostV03 createProcedureOneRequest() {
    CalculateCostV03 request = getServiceOneInitRequest();
    request.boardList = _boards;
    request.isCitizenPledgedToClean =
        _IsThereCleaningContractValue > 0 ? true : false;

    return request;
  }

  CalculateCostV03 createProcedureTwoRequest() {
    CalculateCostV03 request = getServiceOneInitRequest();
    request.boardList = _boards;
    request.isCitizenPledgedToClean =
        _IsThereCleaningContractValue > 0 ? true : false;
    request.expiryDate = _paymentEndDateController.text.trim();
    return request;
  }

  CalculateCostV03 createProcedureThreeRequest() {
    CalculateCostV03 request = getServiceOneInitRequest();
    request.boardList = _boards;
    request.expiryDate = _paymentEndDateController.text.trim();
    return request;
  }

  CalculateCostV03 createProcedureEditActivityRequest() {
    CalculateCostV03 request = CalculateCostV03();
    request.paymentYearsCount = 1;
    request.serviceTypeId = _serviceProcedureController!.id;
    request.isicDetailedActivityId = _serviceDetailedActivityNewController!.id;
    request.activity24Type =
        _serviceDetailedActivityNewController!.twentyFourHourStatus;

    request.oldIsicDetailedActivityId =
        _serviceDetailedActivityCurrentController!.id;
    request.isCitizenPledgedToClean =
        _isThereCleaningContractNewValue > 0 ? true : false;
    request.oldIsCitizenPledgedToClean =
        _isThereCleaningContractCurrentValue > 0 ? true : false;

    request.isVisit = true;
    request.subMunicipalityId = _gisLocation!.sub_Municipalityguid;

    if (_serviceDetailedActivityCurrentController!.unit == "unit") {
      request.oldAccommodationTypeId =
          _serviceAccomodationCurrentController!.id;
    }
    if (_serviceDetailedActivityCurrentController!.unit == "license") {
      request.oldArea = 1;
    } else {
      String formattedNumber = CommonFunctions.replaceArabicNumberWithEnglish(
          _currentSpaceController.text.trim());

      request.oldArea = double.parse(formattedNumber);
    }

    if (_serviceDetailedActivityNewController!.unit == "unit")
      request.accommodationTypeId = _serviceAccomodationNewController!.id;
    if (_serviceDetailedActivityNewController!.unit == "license") {
      request.area = 1;
    } else {
      String formattedNumber = CommonFunctions.replaceArabicNumberWithEnglish(
          _newSpaceController.text.trim());

      request.area = double.parse(formattedNumber);
    }

    request.boardList = _newBoards;
    request.oldBoardList = _currentBoards;

    request.isTobacco = false;
    request.oldIsTobacco = false;
    if (_serviceDetailedActivityNewController!.isTabacco == 1) {
      request.isTobacco = true;
      request.zone = _serviceZoneController!.id;
    }

    if (_serviceDetailedActivityCurrentController!.isTabacco == 1) {
      request.oldIsTobacco = true;
      //request.zone = _serviceZoneController.id;
    }

    return request;
  }

  CalculateCostV03 createProcedureSideWalkRequest() {
    CalculateCostV03 request = CalculateCostV03();

    request.paymentYearsCount = 1;
    request.serviceTypeId = _serviceProcedureController!.id;
    request.isVisit = true;
    request.subMunicipalityId = _gisLocation!.sub_Municipalityguid;
    request.subActivityId = 118;

    List<SideWalkList> sidewalkList = [];
    SideWalkList sideWalk = SideWalkList();
    sideWalk.area = double.parse(CommonFunctions.replaceArabicNumberWithEnglish(
        _areaController.text.trim()));
    sideWalk.days = int.parse(CommonFunctions.replaceArabicNumberWithEnglish(
        _numberOfWorkingDaysController.text.trim()));
    sidewalkList.add(sideWalk);
    request.sideWalkList = sidewalkList;
    return request;
  }

  CalculateCost createCalculateCostRequest() {
    CalculateCost request = CalculateCost();
    request.cityId = _serviceCityIdController;
    request.subactivityId = _serviceSubActivityController!.getId();
    if (double.tryParse(CommonFunctions.replaceArabicNumberWithEnglish(
            _areaController.text.trim())) !=
        null) {
      request.value = double.parse(
          CommonFunctions.replaceArabicNumberWithEnglish(
              _areaController.text.trim()));
    }
    request.isVisit = true;
    request.period = _serviceSubActivityController!.period.toString();
    request.unit = _serviceSubActivityController!.unit;
    request.isAccommodation = _serviceSubActivityController!.is_accommodation;
    request.isDividedArea = _serviceSubActivityController!.is_divided_area;

    if (_serviceSubActivityController!.unit == "license") request.value = 1;

    return request;
  }

  CalculateDiggingCost createCalculateDiggingCostRequest() {
    CalculateDiggingCost request = CalculateDiggingCost();
    request.cityId = _serviceCityIdController;
    request.subServiceId = _serviceSubActivityController!.getId();
    request.diggingPeriod = int.parse(
        CommonFunctions.replaceArabicNumberWithEnglish(
            _numberOfDrillingDaysController.text.trim()));
    request.diggingDistance = 1;
    /*request.diggingDistance = double.parse(
        CommonFunctions.replaceArabicNumberWithEnglish(
            _distanceController.text.trim()));*/
    return request;
  }

  CalculateRenewDiggingCost createCalculateRenewDiggingCostRequest() {
    CalculateRenewDiggingCost request = CalculateRenewDiggingCost();
    request.cityId = _serviceCityIdController;
    request.subServiceId = _serviceSubActivityController!.getId();
    request.lastDiggingLicenseCost = double.parse(
        CommonFunctions.replaceArabicNumberWithEnglish(
            _costOfPreviousLicenseController.text.trim()));
    request.lastDiggingLicensePeriod = double.parse(
        CommonFunctions.replaceArabicNumberWithEnglish(
            _previousLicenseTermController.text.trim()));
    request.lastDiggingLicenseDistance = double.parse(
        CommonFunctions.replaceArabicNumberWithEnglish(
            _lengthOfPreviuosHoleController.text.trim()));
    request.diggingRemainingDistance = double.parse(
        CommonFunctions.replaceArabicNumberWithEnglish(
            _lengthOfHoleController.text.trim()));
    request.renewDiggingLicensePeriod = double.parse(
        CommonFunctions.replaceArabicNumberWithEnglish(
            _termOfNewLicenseController.text.trim()));

    return request;
  }

  void SubmitData() {
    hideKeybaord();
    if (currentActivityId == 1) {
      if (currentactionId == 1) {
        presenter?.calculateV03(createProcedureOneRequest());
      } else if (currentactionId == 2) {
        presenter?.calculateV03(createProcedureTwoRequest());
      } else if (currentactionId == 3) {
        presenter?.calculateV03(createProcedureThreeRequest());
      } else if (currentactionId == 4) {
        presenter?.calculateV03(createProcedureEditActivityRequest());
      } else if (currentactionId == 5) {
        presenter?.calculateV03(createProcedureTwoRequest());
      } else if (currentactionId == 9) {
        presenter?.calculateV03(createProcedureSideWalkRequest());
      } else if (currentactionId == 22) {
        presenter?.calculateV03(getServiceIssueTobaccoRequest());
      } else if (currentactionId == 1028) {
        presenter?.calculateV03(getServiceOneInitRequest());
      } else if (currentactionId == 23) {
        CalculateCostV03 request = CalculateCostV03();
        request.paymentYearsCount = 1;
        request.isVisit = true;
        request.serviceTypeId = _serviceProcedureController!.id;
        presenter?.calculateV03(request);
      }
    } else if (currentActivityId == 2) {
      if (currentactionId! <= 4) {
        presenter?.calculateCost(createCalculateCostRequest());
      } else if (currentactionId == 5) {
        presenter?.calculateCost(createCalculateCostRequest());
      }
    } else if (currentActivityId == 3) {
      presenter?.calculateCost(createCalculateCostRequest());
    } else if (currentActivityId == 4) {
      if (currentactionId == 9) {
        presenter?.calculateDiggingCost(createCalculateDiggingCostRequest());
      } else if (currentactionId == 20) {
        presenter?.calculatRenewDiggingCost(
            createCalculateRenewDiggingCostRequest());
      }
    } else if (currentActivityId == 5) {
      presenter?.calculateCost(createCalculateCostRequest());
    } else if (currentActivityId == 6) {
      presenter?.calculateCost(createCalculateCostRequest());
    } else if (currentActivityId == 7) {
      presenter?.calculateCost(createCalculateCostRequest());
    } else if (currentActivityId == 8) {
      if (currentactionId == 1301) {
        CalculateCostV03 request = CalculateCostV03();
        request.paymentYearsCount = 1;
        request.isVisit = true;
        request.serviceTypeId = _serviceProcedureController!.id;
        request.subMunicipalityId = _gisLocation!.sub_Municipalityguid;
        if (_certificatesEndDateController.text.isNotEmpty) {
          request.expiryDate = _certificatesEndDateController.text.trim();
        }
        presenter?.calculateV03(request);
      } else if (currentactionId == 1302) {
        CalculateCostV03 request = CalculateCostV03();
        request.paymentYearsCount = 1;
        request.isVisit = true;
        request.serviceTypeId = _serviceProcedureController!.id;
        request.subMunicipalityId = _gisLocation!.sub_Municipalityguid;
        if (_certificatesEndDateController.text.isNotEmpty) {
          request.expiryDate = _certificatesEndDateController.text.trim();
        }
        presenter?.calculateV03(request);
      }
    } else if (currentActivityId == 9) {
      presenter?.calculateCost(createCalculateCostRequest());
    } else if (currentActivityId == 10 &&
        (currentactionId == 1401 || currentactionId == 1402)) {
      CalculateCostV03 request = CalculateCostV03();
      request.isVisit = true;
      request.serviceTypeId = _serviceProcedureController!.id;
      request.subMunicipalityId = _gisLocation!.sub_Municipalityguid;
      request.paymentYearsCount = int.tryParse(_portLicenseDays.text.trim());
      request.area = double.tryParse(_distanceController.text.trim());
      request.DailyRentCost = int.tryParse(_portRental.text.trim());
      presenter?.calculateV03(request);
    } else if (currentActivityId == 10 && (currentactionId == 1403)) {
      showError("لا يوجد رسوم");
    }
  }

  void selectIsicActivity(IsicActivity isicActivity) {
    setState(() {
      _isButtonDisabled = true;
      _serviceIsicActivityController = isicActivity;
      _isValidIsicActivity = true;
      _detailedIsicActivites.clear();
      _serviceDetailedActivityController = null;
      _serviceDetailedIsicActivityController = null;
    });

    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  void clearAllFields() {
    _costOfPreviousLicenseController.clear();
    _previousLicenseTermController.clear();
    _lengthOfHoleController.clear();
    _termOfNewLicenseController.clear();
    _areaController.clear();

    _paymentEndDateController.clear();
    _currentSpaceController.clear();

    _newSpaceController.clear();

    _numberOfCertificatesController.clear();
    _certificatesEndDateController.clear();
    _numberOfDrillingDaysController.clear();
    _distanceController.clear();
    _portLicenseDays.clear();
    _portRental.clear();
    _numberOfDocumentsController.clear();

    // _boards =  List();
    // _newBoards =  List();
    // _currentBoards = List();
  }

  _munucipilityInfoWidget() {
    String municipilityName = (_gisLocation != null &&
            _gisLocation!.subMunicipalityName != null &&
            _gisLocation!.subMunicipalityName!.contains("بلدية"))
        ? "${_gisLocation!.subMunicipalityName}، ${_gisLocation!.municipalityName}"
        : "بلدية ${_gisLocation!.subMunicipalityName}، ${_gisLocation!.municipalityName}";
    return Column(
      children: <Widget>[
        Container(
          //height: 38,
          padding: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(color: const Color(0xfff2f2f2)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment:  MainAxisAlignment.spaceAround,
            children: <Widget>[
              //providerIcn
              SizedBox(width: 12),
              Image.asset(
                'assets/images/providerIcn@3x.png',
                width: 14,
                height: 14,
              ),
              SizedBox(width: 4),
              Text(
                Helpers.translatingWord("lbl_provider"),
                style: const TextStyle(
                    color: AppColor.black500,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.normal,
                    fontSize: 13.0),
                textAlign: TextAlign.right,
                textScaleFactor: 1,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  municipilityName,
                  style: const TextStyle(
                      color: AppColor.black500,
                      height: 1.3,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 13.0),
                  textAlign: TextAlign.right,
                  textScaleFactor: 1,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10)
      ],
    );
  }

  _locationInfoWidget() {
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_activity_address"),
      hintText: Helpers.translatingWord("lbl_activity_address_hint"),
      materialIconDirection: Helpers.isArabic(context)
          ? MATERIAL_ICON_DIRECTION.left
          : MATERIAL_ICON_DIRECTION.right,
      textValue: _userAddress,
      onTap: () {
        //  _selectOnMap();
      },
      icon: const Icon(Icons.location_on, color: AppColor.greenLight),
    );
  }

  void _getCurrentUserLocation() async {
    try {
      geolocator.Geolocator.getLastKnownPosition().then((locationData) {
        if (locationData != null) {
          _userLocation = locationData;
        }
      });
    } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
  }

  // _getCurrentAddress(LatLng locationData) async {
  //   placemarkFromCoordinates(locationData.latitude, locationData.longitude,
  //           localeIdentifier: 'ar')
  //       .then((placeMark) {
  //     var address = "";
  //     if (placeMark[0].name.isNotEmpty) address += placeMark[0].name + "، ";
  //     if (placeMark[0].subAdministrativeArea.isNotEmpty)
  //       address += placeMark[0].subAdministrativeArea + "، ";
  //     if (placeMark[0].administrativeArea.isNotEmpty)
  //       address += placeMark[0].administrativeArea + "، ";
  //
  //     if (placeMark[0].country.isNotEmpty) address += placeMark[0].country;
  //
  //     setState(() {
  //       _userAddress = address;
  //     });
  //   }).catchError((onError) {
  //     // print("Error retrive Address " + onError.toString());
  //   });
  // }

  // PlaceLocation placeLocation;
  //
  // Future<void> _selectOnMap() async {
  //   if (_userLocation != null) {
  //     placeLocation = PlaceLocation(
  //         latitude: _userLocation.latitude,
  //         longtitude: _userLocation.longitude,
  //         address: _userAddress);
  //   }
  //   final PlaceLocation selectedLocation = await Navigator.of(context)
  //       .push<PlaceLocation>(MaterialPageRoute(builder: (ctx) {
  //     if (placeLocation != null) {
  //       return MapScreen(initialLocation: placeLocation);
  //     } else
  //       return MapScreen();
  //   }));
  //   if (selectedLocation == null) {
  //     return;
  //   }
  //
  //   setState(() {
  //     _userLocation =
  //         LatLng(selectedLocation.latitude, selectedLocation.longtitude);
  //     // _userAddress = selectedLocation.address;
  //     placeLocation = PlaceLocation(
  //         latitude: _userLocation.latitude,
  //         longtitude: _userLocation.longitude,
  //         address: _userAddress);
  //
  //     presenter.getGpsLocation(
  //         LatLng(_userLocation.latitude, _userLocation.longitude));
  //   });
  // }

  removeFocusesNodesListners() {
    _costOfPreviousLicenseFocusNode.dispose();
    _previousLicenseTermFocusNode.dispose();
    _lengthOfHoleFocusNode.dispose();
    _lengthOfPreviuosFocusNode.dispose();
    _termOfNewLicenseFocusNode.dispose();
    _areaFocusNode.dispose();
    _currentSpaceFocusNode.dispose();
    _newSpaceFocusNode.dispose();
    _numberOfCertificatesFocusNode.dispose();
    _numberOfDrillingDaysFocusNode.dispose();
    _numberOfWorkingDaysFocusNode.dispose();
    _distanceFocusNode.dispose();
    _portLicenseDaysFocusNode.dispose();
    _portRentalFocusNode.dispose();
    _numberOfDocumentsFocusNode.dispose();
  }

  bool hideNotes() {
    return currentActivityId == 10 || currentActivityId == 8;
  }

  @override
  void dispose() {
    super.dispose();
    removeFocusesNodesListners();
    scrollController.dispose();
    _costOfPreviousLicenseController.dispose();
    _previousLicenseTermController.dispose();
    _lengthOfHoleController.dispose();
    _lengthOfPreviuosHoleController.dispose();
    _termOfNewLicenseController.dispose();
    _areaController.dispose();
    _paymentEndDateController.dispose();
    _currentSpaceController.dispose();
    _newSpaceController.dispose();
    _numberOfCertificatesController.dispose();
    _certificatesEndDateController.dispose();
    _numberOfDrillingDaysController.dispose();
    _numberOfWorkingDaysController.dispose();
    _distanceController.dispose();
    _numberOfDocumentsController.dispose();
  }

  @override
  void calculatRenewDiggingCostSuccess(CalculateDiggingResponse? result) {
    Navigator.pushNamed(context, RouteName.calculatorResultsScreen,
        arguments: CalculatorResultsPageParams(
            calculateDiggingResponse: result, hideNote: hideNotes()));
  }

  @override
  void calculateCostSuccess(CalculateCostResponse? result) {
    Navigator.pushNamed(context, RouteName.calculatorResultsScreen,
        arguments: CalculatorResultsPageParams(
            calculateCostResponse: result, hideNote: hideNotes()));
  }

  @override
  void calculateDiggingCostSuccess(CalculateDiggingResponse? result) {
    Navigator.pushNamed(context, RouteName.calculatorResultsScreen,
        arguments: CalculatorResultsPageParams(
            calculateDiggingResponse: result, hideNote: hideNotes()));
  }

  @override
  void calculateV03Success(CalculateCostV03Response? result) {
    CalculateCostV03Response? response = result;
    Navigator.pushNamed(context, RouteName.calculatorResultsScreen,
        arguments: CalculatorResultsPageParams(
            calculateCostV03Response: response, hideNote: hideNotes()));
  }

  @override
  void getAccomodationlookupSuccess(List<Item>? result) {
    setState(() {
      List<Item>? lookup = result;
      _accomodations.clear();
      _accomodations.addAll(lookup ?? []);
    });
  }

  @override
  void getBoardListlookupSuccess(List<Item>? result) {
    setState(() {
      List<Item>? lookup = result;
      _boardList.clear();
      _boardList.addAll(lookup ?? []);
    });
  }

  @override
  void getCityIdlookupSuccess(int? result) {
    int? lookup = result;
    _serviceCityIdController = lookup ?? 0;
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  @override
  void getDetailedActivitylookupSuccess(
      DetailedActivity? result, ActivityDetailType? type) {
    if (type == ActivityDetailType.Normal) {
      DetailedActivity? lookup = result;
      _serviceDetailedActivityController = lookup;
    }
    if (type == ActivityDetailType.New) {
      DetailedActivity? lookup = result;
      _serviceDetailedActivityNewController = lookup;
    }
    if (type == ActivityDetailType.Current) {
      DetailedActivity? lookup = result;
      _serviceDetailedActivityCurrentController = lookup;
    }

    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  @override
  void getDetailedIsicActivityListlookupSuccess(
      List<Item>? result, ActivityIsicListDetailType? type) {
    if (type == ActivityIsicListDetailType.Normal) {
      List<Item>? lookup = result;

      _detailedIsicActivites.clear();
      _detailedIsicActivites.addAll(lookup ?? []);
    }

    if (type == ActivityIsicListDetailType.New) {
      List<Item>? lookup = result;
      _detailedIsicActivitesNew.clear();
      _detailedIsicActivitesNew.addAll(lookup ?? []);
    }

    if (type == ActivityIsicListDetailType.Current) {
      List<Item>? lookup = result;
      _detailedIsicActivitesCurrent.clear();
      _detailedIsicActivitesCurrent.addAll(lookup ?? []);
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  @override
  void getGpsLocationSuccess(GisLocationResult? result) {
    setState(() {
      _gisLocation = result;
      //_gisLocation.sub_Municipalityguid= "976e1e5d-02a5-4a1d-bb18-8b68c40705bc";
    });
    if (_gisLocation != null &&
        _gisLocation!.sub_Municipalityguid != null &&
        _gisLocation!.sub_Municipalityguid!.isNotEmpty) {
      presenter?.getCityIdlookup(_gisLocation!.sub_Municipalityguid!);
      setState(() {
        _showManuciplility = true;
      });
      try {
        _userAddress = setAddress(_gisLocation!);
        setState(() {});
      } catch (error, stackTrace) {
    LogsViewModel().sendEventFromModel(
      event: ErrorExceptionModel(
        nameEvent: EventsName.handledException,
        message: error.toString(),
        stackTrace: stackTrace.toString(),
      ),
    );
  }
    } else {
      showError(Helpers.translatingWord("gis_error_1"));

      setState(() {
        _showManuciplility = false;
      });
    }
    changeBtnColor(_selectedServiceId, _selectedActionId);
  }

  String setAddress(GisLocationResult gisLocationResult) {
    var streetName = gisLocationResult.streetName;
    var districtName = gisLocationResult.districtName;
    var subMunicipalityName = gisLocationResult.subMunicipalityName;
    var adminMunicipalityName = gisLocationResult.adminMunicipalityName;
    var address = "";
    if (streetName != null &&
        streetName.toLowerCase() != "null" &&
        streetName.isNotEmpty) address += streetName + ", ";

    if (districtName != null &&
        districtName.toLowerCase() != "null" &&
        districtName.isNotEmpty) address += districtName + ", ";

    if (subMunicipalityName != null &&
        subMunicipalityName.toLowerCase() != "null" &&
        subMunicipalityName.isNotEmpty) address += subMunicipalityName + ", ";

    if (adminMunicipalityName != null && adminMunicipalityName.isNotEmpty)
      address += adminMunicipalityName;
    return address;
  }

  @override
  void getIsicActivitieslookupSuccess(List<IsicActivity>? result) {
    setState(() {
      List<IsicActivity>? lookup = result;
      _isicActivites!.clear();
      _isicActivites!.addAll(lookup ?? []);
    });
  }

  @override
  void getProceduresListlookupSuccess(List<Procedure>? result) {
    setState(() {
      List<Procedure>? lookup = result;
      _procedures.clear();
      _procedures.addAll(lookup ?? []);
    });
  }

  @override
  void getServicesListlookupSuccess(List<Item>? result) {
    setState(() {
      List<Item>? lookup = result;
      _serviceTypes.clear();
      _serviceTypes.addAll(lookup ?? []);
    });
  }

  @override
  void getSubActivitieslookupSuccess(List<SubActivity>? result) {
    List<SubActivity>? lookup = result;
    _subActivities.clear();
    _subActivities.addAll(lookup ?? []);

    changeBtnColor(currentActivityId, currentactionId);
  }

  @override
  void getZoneslookupSuccess(List<Municipality>? result) {
    List<Municipality>? lookup = result;
    _zones.clear();
    _shownZones.clear();
    _zones.addAll(lookup ?? []);
    _shownZones.addAll(lookup ?? []);
    changeBtnColor(currentActivityId, currentactionId);
  }

  @override
  IServviceCalculatorPresenter initPresenter() {
    return ServiceCalculatorPresenter();
  }

  @override
  void calculatRenewDiggingCostFailed() {
    // TODO: implement calculatRenewDiggingCostFailed
  }

  @override
  void calculateCostFailed() {
    // TODO: implement calculateCostFailed
  }

  @override
  void calculateDiggingCostFailed() {
    // TODO: implement calculateDiggingCostFailed
  }

  @override
  void calculateV03Failed() {
    // TODO: implement calculateV03Failed
  }

  @override
  void getAccomodationlookupFailed() {
    // TODO: implement getAccomodationlookupFailed
  }

  @override
  void getBoardListlookupFailed() {
    // TODO: implement getBoardListlookupFailed
  }

  @override
  void getCityIdlookupFailed() {
    // TODO: implement getCityIdlookupFailed
  }

  @override
  void getDetailedActivitylookupFailed() {
    // TODO: implement getDetailedActivitylookupFailed
  }

  @override
  void getDetailedIsicActivityListlookupFailed() {
    // TODO: implement getDetailedIsicActivityListlookupFailed
  }

  @override
  void getGpsLocationFailed() {
    // TODO: implement getGpsLocationFailed
  }

  @override
  void getIsicActivitieslookupFailed() {
    // TODO: implement getIsicActivitieslookupFailed
  }

  @override
  void getProceduresListlookupFailed() {
    // TODO: implement getProceduresListlookupFailed
  }

  @override
  void getServicesListlookupFailed() {
    // TODO: implement getServicesListlookupFailed
  }

  @override
  void getSubActivitieslookupFailed() {
    // TODO: implement getSubActivitieslookupFailed
  }

  @override
  void getZoneslookupFailed() {
    // TODO: implement getZoneslookupFailed
  }

  @override
  void sessionEnded() {
    // TODO: implement sessionEnded
  }
}
