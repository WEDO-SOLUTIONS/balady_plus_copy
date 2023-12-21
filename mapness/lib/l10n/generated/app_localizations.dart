import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @aboutApp.
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get aboutApp;

  /// No description provided for @aboutBalady.
  ///
  /// In ar, this message translates to:
  /// **'عن بلدي'**
  String get aboutBalady;

  /// No description provided for @aboutPark.
  ///
  /// In ar, this message translates to:
  /// **'عن الحديقة'**
  String get aboutPark;

  /// No description provided for @accessibility.
  ///
  /// In ar, this message translates to:
  /// **'إمكانية الوصول'**
  String get accessibility;

  /// No description provided for @addAddress.
  ///
  /// In ar, this message translates to:
  /// **'إضافة عنوان'**
  String get addAddress;

  /// No description provided for @additionalServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات إضافية'**
  String get additionalServices;

  /// No description provided for @am.
  ///
  /// In ar, this message translates to:
  /// **'صباحًا'**
  String get am;

  /// No description provided for @arabicFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل باللغة العربية'**
  String get arabicFullName;

  /// No description provided for @areYouSureYouWantToDeleteAllFavorites.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد حذف كافة المفضلة؟'**
  String get areYouSureYouWantToDeleteAllFavorites;

  /// No description provided for @areYouSureYouWantToLogOutOfYourAccount.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد أنك تريد تسجيل الخروج من حسابك؟'**
  String get areYouSureYouWantToLogOutOfYourAccount;

  /// No description provided for @arrival.
  ///
  /// In ar, this message translates to:
  /// **'الوصول'**
  String get arrival;

  /// No description provided for @baladyWebsite.
  ///
  /// In ar, this message translates to:
  /// **'موقع بلدي'**
  String get baladyWebsite;

  /// No description provided for @beaches.
  ///
  /// In ar, this message translates to:
  /// **'الشواطئ'**
  String get beaches;

  /// No description provided for @beautyCenters.
  ///
  /// In ar, this message translates to:
  /// **'مراكز التجميل'**
  String get beautyCenters;

  /// No description provided for @best.
  ///
  /// In ar, this message translates to:
  /// **'أفضل'**
  String get best;

  /// No description provided for @bicycleParking.
  ///
  /// In ar, this message translates to:
  /// **'موقف الدراجات الهوائية'**
  String get bicycleParking;

  /// No description provided for @branches.
  ///
  /// In ar, this message translates to:
  /// **'الفروع'**
  String get branches;

  /// No description provided for @buildings.
  ///
  /// In ar, this message translates to:
  /// **'المباني'**
  String get buildings;

  /// No description provided for @business.
  ///
  /// In ar, this message translates to:
  /// **'عمل'**
  String get business;

  /// No description provided for @call.
  ///
  /// In ar, this message translates to:
  /// **'اتصال'**
  String get call;

  /// No description provided for @calories.
  ///
  /// In ar, this message translates to:
  /// **'السعرات الحرارية'**
  String get calories;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @carServices.
  ///
  /// In ar, this message translates to:
  /// **'خدمات السيارات'**
  String get carServices;

  /// No description provided for @challenge.
  ///
  /// In ar, this message translates to:
  /// **'تحدي'**
  String get challenge;

  /// No description provided for @changeTheColorSchemeOfAnApp.
  ///
  /// In ar, this message translates to:
  /// **'تغيير نظام ألوان التطبيق من الفاتح إلى الداكن'**
  String get changeTheColorSchemeOfAnApp;

  /// No description provided for @chooseTheLanguageOfAll.
  ///
  /// In ar, this message translates to:
  /// **'اختر لغة كل الواجهة في تطبيق بلدي'**
  String get chooseTheLanguageOfAll;

  /// No description provided for @clean.
  ///
  /// In ar, this message translates to:
  /// **'تنظيف'**
  String get clean;

  /// No description provided for @closedUntill.
  ///
  /// In ar, this message translates to:
  /// **'مغلق حتى'**
  String get closedUntill;

  /// No description provided for @closesIn.
  ///
  /// In ar, this message translates to:
  /// **'يغلق في '**
  String get closesIn;

  /// No description provided for @comfort.
  ///
  /// In ar, this message translates to:
  /// **'راحة'**
  String get comfort;

  /// No description provided for @commercialLicenseNumber.
  ///
  /// In ar, this message translates to:
  /// **' رقم الرخصة التجارية'**
  String get commercialLicenseNumber;

  /// No description provided for @compilanceBuildings.
  ///
  /// In ar, this message translates to:
  /// **'مباني الامتثال'**
  String get compilanceBuildings;

  /// No description provided for @complete.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get complete;

  /// No description provided for @completeTheTrip.
  ///
  /// In ar, this message translates to:
  /// **'أكمل الرحلة'**
  String get completeTheTrip;

  /// No description provided for @completed.
  ///
  /// In ar, this message translates to:
  /// **'مكتمل'**
  String get completed;

  /// No description provided for @complianceCardDescription.
  ///
  /// In ar, this message translates to:
  /// **'تعرف على الطرق المستهدفة لتطبيق شهادة الامتثال من خلال الخريطة '**
  String get complianceCardDescription;

  /// No description provided for @complianceCardTitle.
  ///
  /// In ar, this message translates to:
  /// **'خريطة شهادة الإمتثال'**
  String get complianceCardTitle;

  /// No description provided for @complianceFAQ.
  ///
  /// In ar, this message translates to:
  /// **'الاسئلة الشائعة'**
  String get complianceFAQ;

  /// No description provided for @complianceOr.
  ///
  /// In ar, this message translates to:
  /// **'أو'**
  String get complianceOr;

  /// No description provided for @complianceRequirements.
  ///
  /// In ar, this message translates to:
  /// **'الاشتراطات'**
  String get complianceRequirements;

  /// No description provided for @complianceToKnow.
  ///
  /// In ar, this message translates to:
  /// **'لمعرفه المزيد اطلع على'**
  String get complianceToKnow;

  /// No description provided for @connectToMomrah.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get connectToMomrah;

  /// No description provided for @connectionLost.
  ///
  /// In ar, this message translates to:
  /// **'فقد الاتصال'**
  String get connectionLost;

  /// No description provided for @contactInformation.
  ///
  /// In ar, this message translates to:
  /// **'معلومات التواصل'**
  String get contactInformation;

  /// No description provided for @continueRide.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الرحلة'**
  String get continueRide;

  /// No description provided for @continueTrip.
  ///
  /// In ar, this message translates to:
  /// **'متابعة الرحلة'**
  String get continueTrip;

  /// No description provided for @contributedToImproving.
  ///
  /// In ar, this message translates to:
  /// **'ساهم في تحسين المشهد الحضري'**
  String get contributedToImproving;

  /// No description provided for @coordinates.
  ///
  /// In ar, this message translates to:
  /// **'الإحداثيات'**
  String get coordinates;

  /// No description provided for @createCompliance.
  ///
  /// In ar, this message translates to:
  /// **'أصدر الشهادة'**
  String get createCompliance;

  /// No description provided for @daily.
  ///
  /// In ar, this message translates to:
  /// **'يوميًا'**
  String get daily;

  /// No description provided for @darkMap.
  ///
  /// In ar, this message translates to:
  /// **'خريطة داكنة'**
  String get darkMap;

  /// No description provided for @darkMode.
  ///
  /// In ar, this message translates to:
  /// **'الوضع الداكن'**
  String get darkMode;

  /// No description provided for @dateOfBirth.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الميلاد'**
  String get dateOfBirth;

  /// No description provided for @daysAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ %d يوم'**
  String get daysAgo;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @deleteAll.
  ///
  /// In ar, this message translates to:
  /// **'حذف الكل'**
  String get deleteAll;

  /// No description provided for @deleteHistory.
  ///
  /// In ar, this message translates to:
  /// **'حذف السجلّ'**
  String get deleteHistory;

  /// No description provided for @deliveryAvailable.
  ///
  /// In ar, this message translates to:
  /// **'التسليم متاح'**
  String get deliveryAvailable;

  /// No description provided for @dentalCenters.
  ///
  /// In ar, this message translates to:
  /// **'مراكز طب الأسنان'**
  String get dentalCenters;

  /// No description provided for @describeInMoreDetails.
  ///
  /// In ar, this message translates to:
  /// **'وصف بمزيد من التفاصيل'**
  String get describeInMoreDetails;

  /// No description provided for @didNotMatchAnyResults.
  ///
  /// In ar, this message translates to:
  /// **'لم يتطابق مع أية نتائج.'**
  String get didNotMatchAnyResults;

  /// No description provided for @done.
  ///
  /// In ar, this message translates to:
  /// **'تم'**
  String get done;

  /// No description provided for @droneView.
  ///
  /// In ar, this message translates to:
  /// **'عرض طائرة بدون طيار'**
  String get droneView;

  /// No description provided for @edit.
  ///
  /// In ar, this message translates to:
  /// **'تعديل'**
  String get edit;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @employmentType.
  ///
  /// In ar, this message translates to:
  /// **'نوع الوظيفة'**
  String get employmentType;

  /// No description provided for @endTrip.
  ///
  /// In ar, this message translates to:
  /// **'إنهاء الرحلة'**
  String get endTrip;

  /// No description provided for @englishFullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الكامل باللغة الانجليزية'**
  String get englishFullName;

  /// No description provided for @events.
  ///
  /// In ar, this message translates to:
  /// **'الفعاليات'**
  String get events;

  /// No description provided for @exits.
  ///
  /// In ar, this message translates to:
  /// **'مخارج'**
  String get exits;

  /// No description provided for @explore.
  ///
  /// In ar, this message translates to:
  /// **'استكشف'**
  String get explore;

  /// No description provided for @favorites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get favorites;

  /// No description provided for @favourites.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get favourites;

  /// No description provided for @fencingVacantLands.
  ///
  /// In ar, this message translates to:
  /// **'تسوير الأراضي الشاغرة'**
  String get fencingVacantLands;

  /// No description provided for @findAJob.
  ///
  /// In ar, this message translates to:
  /// **'العثور على وظيفة'**
  String get findAJob;

  /// No description provided for @findInFavorites.
  ///
  /// In ar, this message translates to:
  /// **'البحث في المفضلة'**
  String get findInFavorites;

  /// No description provided for @findJob.
  ///
  /// In ar, this message translates to:
  /// **'العثور على وظيفة'**
  String get findJob;

  /// No description provided for @firstName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم الاول'**
  String get firstName;

  /// No description provided for @floor.
  ///
  /// In ar, this message translates to:
  /// **'الطابق'**
  String get floor;

  /// No description provided for @focusOnTheRoad.
  ///
  /// In ar, this message translates to:
  /// **'ركِّز في الطريق'**
  String get focusOnTheRoad;

  /// No description provided for @friday.
  ///
  /// In ar, this message translates to:
  /// **'جمعة'**
  String get friday;

  /// No description provided for @from.
  ///
  /// In ar, this message translates to:
  /// **'من'**
  String get from;

  /// No description provided for @gasStations.
  ///
  /// In ar, this message translates to:
  /// **'محطات الوقود'**
  String get gasStations;

  /// No description provided for @gates.
  ///
  /// In ar, this message translates to:
  /// **'بوابات'**
  String get gates;

  /// No description provided for @go.
  ///
  /// In ar, this message translates to:
  /// **'ذهاب'**
  String get go;

  /// No description provided for @goodAfternoon.
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In ar, this message translates to:
  /// **'مساء الخير'**
  String get goodEvening;

  /// No description provided for @goodMorning.
  ///
  /// In ar, this message translates to:
  /// **'صباح الخير'**
  String get goodMorning;

  /// No description provided for @helpCenter.
  ///
  /// In ar, this message translates to:
  /// **'مركز المساعدة'**
  String get helpCenter;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'المنزل'**
  String get home;

  /// No description provided for @horseRacing.
  ///
  /// In ar, this message translates to:
  /// **'سباق الخيل'**
  String get horseRacing;

  /// No description provided for @hospitals.
  ///
  /// In ar, this message translates to:
  /// **'المستشفيات'**
  String get hospitals;

  /// No description provided for @hotels.
  ///
  /// In ar, this message translates to:
  /// **'الفنادق'**
  String get hotels;

  /// No description provided for @hrs.
  ///
  /// In ar, this message translates to:
  /// **'ساعة'**
  String get hrs;

  /// No description provided for @importantEvents.
  ///
  /// In ar, this message translates to:
  /// **'أحداث مهمة'**
  String get importantEvents;

  /// No description provided for @inNovember.
  ///
  /// In ar, this message translates to:
  /// **'في نوفمبر'**
  String get inNovember;

  /// No description provided for @includingTrafficJams.
  ///
  /// In ar, this message translates to:
  /// **'بما في ذلك زحمة السير'**
  String get includingTrafficJams;

  /// No description provided for @infantRoom.
  ///
  /// In ar, this message translates to:
  /// **'غرفة الرضع'**
  String get infantRoom;

  /// No description provided for @info.
  ///
  /// In ar, this message translates to:
  /// **'معلومات'**
  String get info;

  /// No description provided for @interestingForYou.
  ///
  /// In ar, this message translates to:
  /// **'مثيرة للاهتمام بالنسبة لك'**
  String get interestingForYou;

  /// No description provided for @invalid.
  ///
  /// In ar, this message translates to:
  /// **'غير صالح'**
  String get invalid;

  /// No description provided for @investmentOpportunities.
  ///
  /// In ar, this message translates to:
  /// **'فرص الاستثمار'**
  String get investmentOpportunities;

  /// No description provided for @iwish.
  ///
  /// In ar, this message translates to:
  /// **'أتمنى'**
  String get iwish;

  /// No description provided for @jobDescription.
  ///
  /// In ar, this message translates to:
  /// **'وصف الوظيفة'**
  String get jobDescription;

  /// No description provided for @jobDetails.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الوظيفة'**
  String get jobDetails;

  /// No description provided for @jobVacancy.
  ///
  /// In ar, this message translates to:
  /// **'وظيفة شاغرة'**
  String get jobVacancy;

  /// No description provided for @jobs.
  ///
  /// In ar, this message translates to:
  /// **'وظائف'**
  String get jobs;

  /// No description provided for @jobsAraundYou.
  ///
  /// In ar, this message translates to:
  /// **'وظائف حولك'**
  String get jobsAraundYou;

  /// No description provided for @joyParks.
  ///
  /// In ar, this message translates to:
  /// **'حدائق بهجة'**
  String get joyParks;

  /// No description provided for @km.
  ///
  /// In ar, this message translates to:
  /// **'كم'**
  String get km;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @languageTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإنجليزية'**
  String get languageTitle;

  /// No description provided for @lastName.
  ///
  /// In ar, this message translates to:
  /// **'رقم التواصل'**
  String get lastName;

  /// No description provided for @layersOnTheMap.
  ///
  /// In ar, this message translates to:
  /// **'الطبقات على الخريطة'**
  String get layersOnTheMap;

  /// No description provided for @lightning.
  ///
  /// In ar, this message translates to:
  /// **'برق'**
  String get lightning;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جارٍ التحميل…'**
  String get loading;

  /// No description provided for @logOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logOut;

  /// No description provided for @loginToAccess.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول للوصول الى'**
  String get loginToAccess;

  /// No description provided for @lookForUsefulPlacesCafesMallsForExampleMallNearby.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن الأماكن والمقاهي ومراكز التسوق المفيدة على سبيل المثال: مول قريب'**
  String get lookForUsefulPlacesCafesMallsForExampleMallNearby;

  /// No description provided for @mallNearby.
  ///
  /// In ar, this message translates to:
  /// **'مركز تجاري قريب'**
  String get mallNearby;

  /// No description provided for @maneuvers.
  ///
  /// In ar, this message translates to:
  /// **'مناورات'**
  String get maneuvers;

  /// No description provided for @maneuversAreOff.
  ///
  /// In ar, this message translates to:
  /// **'المناورات متوقفة'**
  String get maneuversAreOff;

  /// No description provided for @maneuversIncluded.
  ///
  /// In ar, this message translates to:
  /// **'المناورات شاملة'**
  String get maneuversIncluded;

  /// No description provided for @mapLayerCar.
  ///
  /// In ar, this message translates to:
  /// **'سيارة'**
  String get mapLayerCar;

  /// No description provided for @mapLayerMetro.
  ///
  /// In ar, this message translates to:
  /// **'مترو'**
  String get mapLayerMetro;

  /// No description provided for @mapLayerMonorail.
  ///
  /// In ar, this message translates to:
  /// **'السكة المفردة'**
  String get mapLayerMonorail;

  /// No description provided for @mapLayerParking.
  ///
  /// In ar, this message translates to:
  /// **'موقف'**
  String get mapLayerParking;

  /// No description provided for @mapLayerTransport.
  ///
  /// In ar, this message translates to:
  /// **'المواصلات'**
  String get mapLayerTransport;

  /// No description provided for @markets.
  ///
  /// In ar, this message translates to:
  /// **'الأسواق'**
  String get markets;

  /// No description provided for @maybeLater.
  ///
  /// In ar, this message translates to:
  /// **'ربما في وقت لاحق'**
  String get maybeLater;

  /// No description provided for @menu.
  ///
  /// In ar, this message translates to:
  /// **'قائمة'**
  String get menu;

  /// No description provided for @meter.
  ///
  /// In ar, this message translates to:
  /// **'م'**
  String get meter;

  /// No description provided for @meters.
  ///
  /// In ar, this message translates to:
  /// **'متر'**
  String get meters;

  /// No description provided for @min.
  ///
  /// In ar, this message translates to:
  /// **'دقيقة'**
  String get min;

  /// No description provided for @minutes.
  ///
  /// In ar, this message translates to:
  /// **'دقائق'**
  String get minutes;

  /// No description provided for @monday.
  ///
  /// In ar, this message translates to:
  /// **'الإثنين'**
  String get monday;

  /// No description provided for @mosques.
  ///
  /// In ar, this message translates to:
  /// **'المساجد'**
  String get mosques;

  /// No description provided for @motorVisual.
  ///
  /// In ar, this message translates to:
  /// **'الموتور، بصري'**
  String get motorVisual;

  /// No description provided for @myChallenge.
  ///
  /// In ar, this message translates to:
  /// **'التحدي الخاص بي'**
  String get myChallenge;

  /// No description provided for @myLocation.
  ///
  /// In ar, this message translates to:
  /// **'موقعي'**
  String get myLocation;

  /// No description provided for @nationality.
  ///
  /// In ar, this message translates to:
  /// **'الجنسية'**
  String get nationality;

  /// No description provided for @nav_general.
  ///
  /// In ar, this message translates to:
  /// **'استكشف'**
  String get nav_general;

  /// No description provided for @nav_landing.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get nav_landing;

  /// No description provided for @nav_profile.
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي '**
  String get nav_profile;

  /// No description provided for @nav_route.
  ///
  /// In ar, this message translates to:
  /// **'طريق'**
  String get nav_route;

  /// No description provided for @next.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get next;

  /// No description provided for @noThanks.
  ///
  /// In ar, this message translates to:
  /// **'لا، شكرًا'**
  String get noThanks;

  /// No description provided for @open24Hours.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح على مدار 24 ساعة'**
  String get open24Hours;

  /// No description provided for @openIn.
  ///
  /// In ar, this message translates to:
  /// **'يفتح في '**
  String get openIn;

  /// No description provided for @openUntil.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح حتى'**
  String get openUntil;

  /// No description provided for @openUntill.
  ///
  /// In ar, this message translates to:
  /// **'مفتوح حتى'**
  String get openUntill;

  /// No description provided for @parkAmanah.
  ///
  /// In ar, this message translates to:
  /// **'Amanah'**
  String get parkAmanah;

  /// No description provided for @parkAreaSize.
  ///
  /// In ar, this message translates to:
  /// **'Area size'**
  String get parkAreaSize;

  /// No description provided for @parkOpeningDate.
  ///
  /// In ar, this message translates to:
  /// **'Opening date'**
  String get parkOpeningDate;

  /// No description provided for @parkSizeBig.
  ///
  /// In ar, this message translates to:
  /// **'Big size park'**
  String get parkSizeBig;

  /// No description provided for @parkSizeMedium.
  ///
  /// In ar, this message translates to:
  /// **'Medium size park'**
  String get parkSizeMedium;

  /// No description provided for @parkSizeSmall.
  ///
  /// In ar, this message translates to:
  /// **'Small size park'**
  String get parkSizeSmall;

  /// No description provided for @parkSizeUnknown.
  ///
  /// In ar, this message translates to:
  /// **'Unknown size park'**
  String get parkSizeUnknown;

  /// No description provided for @parkType.
  ///
  /// In ar, this message translates to:
  /// **'Type'**
  String get parkType;

  /// No description provided for @parking.
  ///
  /// In ar, this message translates to:
  /// **'موقف'**
  String get parking;

  /// No description provided for @parkingSpaces.
  ///
  /// In ar, this message translates to:
  /// **'أماكن وقوف السيارات'**
  String get parkingSpaces;

  /// No description provided for @parks.
  ///
  /// In ar, this message translates to:
  /// **'الحدائق'**
  String get parks;

  /// No description provided for @personalData.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الشخصية'**
  String get personalData;

  /// No description provided for @pharmacies.
  ///
  /// In ar, this message translates to:
  /// **'الصيدليات'**
  String get pharmacies;

  /// No description provided for @photoAndVideo.
  ///
  /// In ar, this message translates to:
  /// **'صور وارسل'**
  String get photoAndVideo;

  /// No description provided for @photos.
  ///
  /// In ar, this message translates to:
  /// **'الصور'**
  String get photos;

  /// No description provided for @placesToShop.
  ///
  /// In ar, this message translates to:
  /// **'أماكن للتسوق'**
  String get placesToShop;

  /// No description provided for @placesToVisit.
  ///
  /// In ar, this message translates to:
  /// **'أماكن للزيارة'**
  String get placesToVisit;

  /// No description provided for @planned.
  ///
  /// In ar, this message translates to:
  /// **'مخطط'**
  String get planned;

  /// No description provided for @playground.
  ///
  /// In ar, this message translates to:
  /// **'ملعب'**
  String get playground;

  /// No description provided for @pleaseRestartApplicationForTheNewSettingsToTakeEffect.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إعادة تشغيل التطبيق حتى تصبح الإعدادات الجديدة سارية المفعول.'**
  String get pleaseRestartApplicationForTheNewSettingsToTakeEffect;

  /// No description provided for @pleaseTryAgainLater.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء معاودة المحاولة في وقت لاحق'**
  String get pleaseTryAgainLater;

  /// No description provided for @pm.
  ///
  /// In ar, this message translates to:
  /// **'مساء'**
  String get pm;

  /// No description provided for @poi_boulevard_riyadh_city.
  ///
  /// In ar, this message translates to:
  /// **'بوليفارد مدينة الرياض'**
  String get poi_boulevard_riyadh_city;

  /// No description provided for @poi_edge_of_the_world.
  ///
  /// In ar, this message translates to:
  /// **'حافة العالم'**
  String get poi_edge_of_the_world;

  /// No description provided for @poi_faisaliya_tower.
  ///
  /// In ar, this message translates to:
  /// **' برج الفيصلية'**
  String get poi_faisaliya_tower;

  /// No description provided for @poi_kingdom_center.
  ///
  /// In ar, this message translates to:
  /// **'مركز المملكة'**
  String get poi_kingdom_center;

  /// No description provided for @poi_masmak_fortress.
  ///
  /// In ar, this message translates to:
  /// **'قصر المصمك'**
  String get poi_masmak_fortress;

  /// No description provided for @prayerTime.
  ///
  /// In ar, this message translates to:
  /// **'وقت الصلاة'**
  String get prayerTime;

  /// No description provided for @presentTime.
  ///
  /// In ar, this message translates to:
  /// **'الوقت الحالي'**
  String get presentTime;

  /// No description provided for @profile.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get profile;

  /// No description provided for @profileSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الحساب'**
  String get profileSettings;

  /// No description provided for @published.
  ///
  /// In ar, this message translates to:
  /// **'تم النشر'**
  String get published;

  /// No description provided for @rate.
  ///
  /// In ar, this message translates to:
  /// **'تقييم'**
  String get rate;

  /// No description provided for @rateBaladyApp.
  ///
  /// In ar, this message translates to:
  /// **'قيّم تطبيق بلدي'**
  String get rateBaladyApp;

  /// No description provided for @rateMessage.
  ///
  /// In ar, this message translates to:
  /// **'إذا أعجبك هذا التطبيق، نرجو تخصيص بعض من وقتك لتقييمنا!  لن يستغرق الأمر أكثر من دقيقة واحدة.'**
  String get rateMessage;

  /// No description provided for @rateThisApp.
  ///
  /// In ar, this message translates to:
  /// **'قيم هذا التطبيق'**
  String get rateThisApp;

  /// No description provided for @ratingBuilding.
  ///
  /// In ar, this message translates to:
  /// **'أو قيم مبناك'**
  String get ratingBuilding;

  /// No description provided for @ready.
  ///
  /// In ar, this message translates to:
  /// **'مستعد'**
  String get ready;

  /// No description provided for @recreationalCenters.
  ///
  /// In ar, this message translates to:
  /// **'مراكز الترفيه'**
  String get recreationalCenters;

  /// No description provided for @refresh.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تحميل'**
  String get refresh;

  /// No description provided for @registerForOpportunities.
  ///
  /// In ar, this message translates to:
  /// **'سجل للحصول على الفرص'**
  String get registerForOpportunities;

  /// No description provided for @reload.
  ///
  /// In ar, this message translates to:
  /// **'إعادة تحميل'**
  String get reload;

  /// No description provided for @remainingTimeForPrayer.
  ///
  /// In ar, this message translates to:
  /// **'الوقت المتبقي للصلاة'**
  String get remainingTimeForPrayer;

  /// No description provided for @restArea.
  ///
  /// In ar, this message translates to:
  /// **'منطقة الراحة'**
  String get restArea;

  /// No description provided for @restaurants.
  ///
  /// In ar, this message translates to:
  /// **'المطاعم'**
  String get restaurants;

  /// No description provided for @restroom.
  ///
  /// In ar, this message translates to:
  /// **'دورة مياة'**
  String get restroom;

  /// No description provided for @route.
  ///
  /// In ar, this message translates to:
  /// **'طريق'**
  String get route;

  /// No description provided for @route1description.
  ///
  /// In ar, this message translates to:
  /// **'بعض المزايا والحيل لميزة التنقل الذكي...'**
  String get route1description;

  /// No description provided for @route2description.
  ///
  /// In ar, this message translates to:
  /// **'يقترح التنقل الذكي ما يصل إلى ثلاثة طرق بالنظر إلى حالة المرور الحالية. سيذكرك أيضا بالطرق البديلة عند مفترق الطرق'**
  String get route2description;

  /// No description provided for @route3description.
  ///
  /// In ar, this message translates to:
  /// **'سيبقيك المساعد الصوتي على اطلاع طوال رحلتك'**
  String get route3description;

  /// No description provided for @sahm.
  ///
  /// In ar, this message translates to:
  /// **'ساهم'**
  String get sahm;

  /// No description provided for @salons.
  ///
  /// In ar, this message translates to:
  /// **'صالونات'**
  String get salons;

  /// No description provided for @saturday.
  ///
  /// In ar, this message translates to:
  /// **'السبت'**
  String get saturday;

  /// No description provided for @schools.
  ///
  /// In ar, this message translates to:
  /// **'المدارس'**
  String get schools;

  /// No description provided for @search.
  ///
  /// In ar, this message translates to:
  /// **'بحث'**
  String get search;

  /// No description provided for @seating.
  ///
  /// In ar, this message translates to:
  /// **'الجلوس'**
  String get seating;

  /// No description provided for @sec.
  ///
  /// In ar, this message translates to:
  /// **'ثانية'**
  String get sec;

  /// No description provided for @selectYourStartingAndDestinationPointsAndWeWillShowYouConvenientRoutes.
  ///
  /// In ar, this message translates to:
  /// **'حدد نقاط البداية والوجهة الخاصة بك ، وسنعرض لك طرقًا ملائمة'**
  String get selectYourStartingAndDestinationPointsAndWeWillShowYouConvenientRoutes;

  /// No description provided for @sendAWish.
  ///
  /// In ar, this message translates to:
  /// **'أرسل أمنية'**
  String get sendAWish;

  /// No description provided for @sendFeedback.
  ///
  /// In ar, this message translates to:
  /// **'سجل انطباعك'**
  String get sendFeedback;

  /// No description provided for @sendYourWishes.
  ///
  /// In ar, this message translates to:
  /// **'أرسل رغباتك'**
  String get sendYourWishes;

  /// No description provided for @sending.
  ///
  /// In ar, this message translates to:
  /// **'جارِ الإرسال...'**
  String get sending;

  /// No description provided for @services.
  ///
  /// In ar, this message translates to:
  /// **'الخدمات'**
  String get services;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @share.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة'**
  String get share;

  /// No description provided for @shareChallengeWithUs.
  ///
  /// In ar, this message translates to:
  /// **'شاركنا التحدي. ساهم في مكافحة التلوث البصري في مدينتك'**
  String get shareChallengeWithUs;

  /// No description provided for @shareFeedback.
  ///
  /// In ar, this message translates to:
  /// **'مشاركة الملاحظات'**
  String get shareFeedback;

  /// No description provided for @shareYourFeedback.
  ///
  /// In ar, this message translates to:
  /// **'شارك ملاحظاتك'**
  String get shareYourFeedback;

  /// No description provided for @shareYourFeelings.
  ///
  /// In ar, this message translates to:
  /// **'شارك مشاعرك'**
  String get shareYourFeelings;

  /// No description provided for @shareYourFeelingsAboutPark.
  ///
  /// In ar, this message translates to:
  /// **'شارك مشاعرك حول الحديقة'**
  String get shareYourFeelingsAboutPark;

  /// No description provided for @shortest.
  ///
  /// In ar, this message translates to:
  /// **'الأقصر'**
  String get shortest;

  /// No description provided for @showFavoritesOnMap.
  ///
  /// In ar, this message translates to:
  /// **'عرض المفضلة على الخريطة'**
  String get showFavoritesOnMap;

  /// No description provided for @showLess.
  ///
  /// In ar, this message translates to:
  /// **'إظهار أقل'**
  String get showLess;

  /// No description provided for @showMore.
  ///
  /// In ar, this message translates to:
  /// **'إظهار المزيد'**
  String get showMore;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signIn;

  /// No description provided for @signInToUnlock.
  ///
  /// In ar, this message translates to:
  /// **'قم بتسجيل الدخول لتصفح الإمكانات الكاملة لتطبيق بلدي'**
  String get signInToUnlock;

  /// No description provided for @signInToUnlockTheFullPotentialOfTheBaladyApp.
  ///
  /// In ar, this message translates to:
  /// **'قم بتسجيل الدخول لفتح الإمكانيات الكاملة لتطبيق بلدي'**
  String get signInToUnlockTheFullPotentialOfTheBaladyApp;

  /// No description provided for @skills.
  ///
  /// In ar, this message translates to:
  /// **'المهارات'**
  String get skills;

  /// No description provided for @snapAndSendButton.
  ///
  /// In ar, this message translates to:
  /// **'ساهم'**
  String get snapAndSendButton;

  /// No description provided for @snapAndSendDescription.
  ///
  /// In ar, this message translates to:
  /// **'حسن المشهد الحضري لمدينتك، وبلغ عن مظاهر التشوه البصري'**
  String get snapAndSendDescription;

  /// No description provided for @snapAndSendTitle.
  ///
  /// In ar, this message translates to:
  /// **'صور وأرسل'**
  String get snapAndSendTitle;

  /// No description provided for @snap_and_send.
  ///
  /// In ar, this message translates to:
  /// **'التقط وأرسل'**
  String get snap_and_send;

  /// No description provided for @somethingWentWrong.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ'**
  String get somethingWentWrong;

  /// No description provided for @somethingWentWrongPleaseTryAgainLater.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ ما يرجى المحاولة مرة أخرى لاحقًا'**
  String get somethingWentWrongPleaseTryAgainLater;

  /// No description provided for @sorryRouteNotFound.
  ///
  /// In ar, this message translates to:
  /// **'عذرا، لم يتم العثور على الطريق'**
  String get sorryRouteNotFound;

  /// No description provided for @soundSettings.
  ///
  /// In ar, this message translates to:
  /// **'إعدادات الصوت'**
  String get soundSettings;

  /// No description provided for @specifyOnTheMap.
  ///
  /// In ar, this message translates to:
  /// **'حدد على الخريطة'**
  String get specifyOnTheMap;

  /// No description provided for @sportClubs.
  ///
  /// In ar, this message translates to:
  /// **'الأندية الرياضية'**
  String get sportClubs;

  /// No description provided for @sportsGround.
  ///
  /// In ar, this message translates to:
  /// **'الملاعب الرياضية'**
  String get sportsGround;

  /// No description provided for @stairs.
  ///
  /// In ar, this message translates to:
  /// **'سلالم'**
  String get stairs;

  /// No description provided for @start.
  ///
  /// In ar, this message translates to:
  /// **'بدء'**
  String get start;

  /// No description provided for @steps.
  ///
  /// In ar, this message translates to:
  /// **'خطوات'**
  String get steps;

  /// No description provided for @streets.
  ///
  /// In ar, this message translates to:
  /// **'الشوارع'**
  String get streets;

  /// No description provided for @sunday.
  ///
  /// In ar, this message translates to:
  /// **'الأحد'**
  String get sunday;

  /// No description provided for @tellUsWhatYouWant.
  ///
  /// In ar, this message translates to:
  /// **'أخبرنا ماذا تريد...'**
  String get tellUsWhatYouWant;

  /// No description provided for @temporarilyNotWorking.
  ///
  /// In ar, this message translates to:
  /// **'لا يعمل مؤقتًا'**
  String get temporarilyNotWorking;

  /// No description provided for @thanksForYourFeedback.
  ///
  /// In ar, this message translates to:
  /// **'شكرًا لملاحظاتك'**
  String get thanksForYourFeedback;

  /// No description provided for @theShortestRoute.
  ///
  /// In ar, this message translates to:
  /// **'أقصر طريق '**
  String get theShortestRoute;

  /// No description provided for @theTripTook.
  ///
  /// In ar, this message translates to:
  /// **'استغرقت الرحلة'**
  String get theTripTook;

  /// No description provided for @thursday.
  ///
  /// In ar, this message translates to:
  /// **'الخميس'**
  String get thursday;

  /// No description provided for @tinId.
  ///
  /// In ar, this message translates to:
  /// **'رقم الرخصة التجارية'**
  String get tinId;

  /// No description provided for @to.
  ///
  /// In ar, this message translates to:
  /// **'إلى'**
  String get to;

  /// No description provided for @toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon.
  ///
  /// In ar, this message translates to:
  /// **'لحفظ الأماكن كمفضلة، افتح البطاقة وانقر على أيقونة الإشارة المرجعية'**
  String get toSavePlacesAsFavoritesOpenTheCardAndTapTheBookmarkIcon;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @todayIsADayOff.
  ///
  /// In ar, this message translates to:
  /// **'اليوم هو يوم عطلة'**
  String get todayIsADayOff;

  /// No description provided for @tryAgain.
  ///
  /// In ar, this message translates to:
  /// **'حاول مرة أخرى'**
  String get tryAgain;

  /// No description provided for @tuesday.
  ///
  /// In ar, this message translates to:
  /// **'الثلاثاء'**
  String get tuesday;

  /// No description provided for @twentyFourSeven.
  ///
  /// In ar, this message translates to:
  /// **'24/7'**
  String get twentyFourSeven;

  /// No description provided for @twitterAccount.
  ///
  /// In ar, this message translates to:
  /// **'حساب التوتير'**
  String get twitterAccount;

  /// No description provided for @unknown.
  ///
  /// In ar, this message translates to:
  /// **'غير معروف'**
  String get unknown;

  /// No description provided for @vacancies.
  ///
  /// In ar, this message translates to:
  /// **'الشواغر'**
  String get vacancies;

  /// No description provided for @viewingARoute.
  ///
  /// In ar, this message translates to:
  /// **'عرض الطريق'**
  String get viewingARoute;

  /// No description provided for @visualAesthetic.
  ///
  /// In ar, this message translates to:
  /// **'الجمالية البصرية'**
  String get visualAesthetic;

  /// No description provided for @voteWhatDoYouWantToHaveInThePark.
  ///
  /// In ar, this message translates to:
  /// **'صوّت على ماذا تريد أن يكون في الحديقة؟'**
  String get voteWhatDoYouWantToHaveInThePark;

  /// No description provided for @watchMore.
  ///
  /// In ar, this message translates to:
  /// **'مشاهدة المزيد'**
  String get watchMore;

  /// No description provided for @weAreHappyToConnectYouWithBaladyTeam.
  ///
  /// In ar, this message translates to:
  /// **'تم تطوير بوابة بلدي بالتعاون مع جهات القطاع البلدي المختلفة لتكون البوابة الوطنية الداعمة للمجتمع البلدي.\nوتشمل هذه البوابة في المرحلة الحالية ثلاث مسؤوليات رئيسية وهي:\n- الخدمات التفاعلية التي تساعد في تعزيز مفهوم الشراكة المجتمعية لتحسين جودة الخدمات المقدمة للمستفيدين.\n- الخدمات الإلكترونية التي تساعد على تقديم الطلبات الإلكترونية لاستخراج الرخص الأكثر استخدامًا.\n- الخدمات المعلوماتية والتي تساعد المستفيدين على اتخاذ القرارات ذات العلاقة بما يساهم في تحسين مستوى الرضا عن جهات القطاع البلدي.'**
  String get weAreHappyToConnectYouWithBaladyTeam;

  /// No description provided for @weCouldntFindAnythingTryChangingYourRequest.
  ///
  /// In ar, this message translates to:
  /// **'لم نتمكن من العثور على شيء. حاول تغيير طلبك'**
  String get weCouldntFindAnythingTryChangingYourRequest;

  /// No description provided for @wednesday.
  ///
  /// In ar, this message translates to:
  /// **'الأربعاء'**
  String get wednesday;

  /// No description provided for @weekend.
  ///
  /// In ar, this message translates to:
  /// **'نهاية الأسبوع'**
  String get weekend;

  /// No description provided for @whatCanTheNavigatorDo.
  ///
  /// In ar, this message translates to:
  /// **'ماذا يمكن أن يفعل التنقل الذكي ؟'**
  String get whatCanTheNavigatorDo;

  /// No description provided for @wishesSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال الأمنيات'**
  String get wishesSent;

  /// No description provided for @work.
  ///
  /// In ar, this message translates to:
  /// **'عمل'**
  String get work;

  /// No description provided for @workHours.
  ///
  /// In ar, this message translates to:
  /// **'ساعات العمل'**
  String get workHours;

  /// No description provided for @worldHealthExpo.
  ///
  /// In ar, this message translates to:
  /// **'معرض الصحة العالمية 2023'**
  String get worldHealthExpo;

  /// No description provided for @yesterday.
  ///
  /// In ar, this message translates to:
  /// **'أمس'**
  String get yesterday;

  /// No description provided for @youArrived.
  ///
  /// In ar, this message translates to:
  /// **'لقد وصلت'**
  String get youArrived;

  /// No description provided for @youReHere.
  ///
  /// In ar, this message translates to:
  /// **'أنت هنا!'**
  String get youReHere;

  /// No description provided for @youSearch.
  ///
  /// In ar, this message translates to:
  /// **'انت تبحث'**
  String get youSearch;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
