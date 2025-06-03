import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr')
  ];

  /// Welcome message on the home page
  ///
  /// In en, this message translates to:
  /// **'Welcome to the app'**
  String get homePageWelcomeMessage;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Prompt to login to continue
  ///
  /// In en, this message translates to:
  /// **'Login to continue'**
  String get loginToContinue;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Example email address
  ///
  /// In en, this message translates to:
  /// **'account@example.com'**
  String get emailExemple;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgotPassword;

  /// Remember me checkbox label
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// Error message for invalid email
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// Error message for invalid password
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// Error message for required email
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get requiredEmail;

  /// Error message for required password
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get requiredPassword;

  /// Placeholder text for email field
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Placeholder text for password field
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// Login failed message
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// Login success message
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccess;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Logout success message
  ///
  /// In en, this message translates to:
  /// **'Logout successful'**
  String get logoutSuccess;

  /// Logout failed message
  ///
  /// In en, this message translates to:
  /// **'Logout failed'**
  String get logoutFailed;

  /// Prompt to fill in all fields
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get pleaseFillInAllFields;

  /// Logging in status message
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loggingIn;

  /// Login successful message
  ///
  /// In en, this message translates to:
  /// **'Login successful'**
  String get loginSuccessful;

  /// Logout success detailed message
  ///
  /// In en, this message translates to:
  /// **'You have successfully logged out'**
  String get logoutSuccessMessage;

  /// Logout failed detailed message
  ///
  /// In en, this message translates to:
  /// **'An error occurred while logging out'**
  String get logoutFailedMessage;

  /// Login failed detailed message
  ///
  /// In en, this message translates to:
  /// **'An error occurred while logging in'**
  String get loginFailedMessage;

  /// Login success detailed message
  ///
  /// In en, this message translates to:
  /// **'You have successfully logged in'**
  String get loginSuccessMessage;

  /// Connection failed error message
  ///
  /// In en, this message translates to:
  /// **'A connection error occurred, please check your internet connection and try again'**
  String get connectionFailedError;

  /// Server error message
  ///
  /// In en, this message translates to:
  /// **'A server error occurred, please try again later'**
  String get serverError;

  /// No internet connection message
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Detailed no internet connection message
  ///
  /// In en, this message translates to:
  /// **'Please check your internet connection and try again'**
  String get noInternetConnectionMessage;

  /// Timeout error message
  ///
  /// In en, this message translates to:
  /// **'Request timed out, please try again later'**
  String get timeOutError;

  /// Request cancelled message
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get cancelMessage;

  /// Unknown error message
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred, please try again later'**
  String get unknownError;

  /// Connection failed message
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get connectionFailed;

  /// Access denied message
  ///
  /// In en, this message translates to:
  /// **'Access denied'**
  String get accessDenied;

  /// Login required message
  ///
  /// In en, this message translates to:
  /// **'You must be logged in'**
  String get loginRequired;

  /// Logout required message
  ///
  /// In en, this message translates to:
  /// **'You must be logged out'**
  String get logoutRequired;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// User management section title
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// Add user button text
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addUser;

  /// Add one user button text
  ///
  /// In en, this message translates to:
  /// **'Add one user'**
  String get addOneUser;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Filters section title
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// Filter users button text
  ///
  /// In en, this message translates to:
  /// **'Filter users'**
  String get filterUser;

  /// Filter by role option
  ///
  /// In en, this message translates to:
  /// **'Filter by role'**
  String get filterByRole;

  /// Role field label
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// Filter button text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Sort section title
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// Sort users button text
  ///
  /// In en, this message translates to:
  /// **'Sort users'**
  String get sortUser;

  /// Sort by label
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// ID field label
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Per page label
  ///
  /// In en, this message translates to:
  /// **'Per page'**
  String get perPage;

  /// Yes option
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No option
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @num.
  ///
  /// In en, this message translates to:
  /// **'Num'**
  String get num;

  /// Avatar field label
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// Actions field label
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Page label
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// Previous page button text
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get prevPage;

  /// Next page button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextPage;

  /// Users section title
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// Delete users button text
  ///
  /// In en, this message translates to:
  /// **'Delete users'**
  String get deleteUser;

  /// Prompt to select users to delete
  ///
  /// In en, this message translates to:
  /// **'Select users to delete'**
  String get selectUserDelete;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Yes option for favorites
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get repFav;

  /// No option for favorites
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get repDeFav;

  /// Prompt to fix errors in the form
  ///
  /// In en, this message translates to:
  /// **'Please fix the errors in the form'**
  String get pleaseFixErrorsInTheForm;

  /// Adding user status message
  ///
  /// In en, this message translates to:
  /// **'Adding user...'**
  String get addUserMessage;

  /// Failed to get users message
  ///
  /// In en, this message translates to:
  /// **'Failed to get users'**
  String get failedToGetUsersMessage;

  /// Error message for failed to get users
  ///
  /// In en, this message translates to:
  /// **'Error: Failed to get users'**
  String get errorFailedToGetUsers;

  /// Failed to add user message
  ///
  /// In en, this message translates to:
  /// **'Failed to add user'**
  String get failedToAddUserMessage;

  /// User added successfully message
  ///
  /// In en, this message translates to:
  /// **'User added successfully'**
  String get successAddUserMessage;

  /// Opening file picker status message
  ///
  /// In en, this message translates to:
  /// **'Opening file picker...'**
  String get openingFilePicker;

  /// Canceled status message
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get canceled;

  /// File selected status message
  ///
  /// In en, this message translates to:
  /// **'File selected'**
  String get fileSelected;

  /// Phone number field label
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// Superior field label
  ///
  /// In en, this message translates to:
  /// **'Superior'**
  String get superior;

  /// Prompt to select a superior
  ///
  /// In en, this message translates to:
  /// **'Select a superior'**
  String get selectSuperior;

  /// Confirmation message for deleting users
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count, plural, one {user} other {users}}?'**
  String delete_users(int count);

  /// IBDM acronym
  ///
  /// In en, this message translates to:
  /// **'IBDM'**
  String get ibdm;

  /// Ifri Machine Database full name
  ///
  /// In en, this message translates to:
  /// **'Ifri Machine Database'**
  String get ifri_bdd;

  /// Options section title
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// Me section title
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// Syrup production section title
  ///
  /// In en, this message translates to:
  /// **'Syrup Production'**
  String get siroperieTitle;

  /// Month name for January
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// Month name for February
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// Month name for March
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// Month name for April
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// Month name for May
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// Month name for June
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// Month name for July
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// Month name for August
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// Month name for September
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// Month name for October
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// Month name for November
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// Month name for December
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// Year display with placeholder
  ///
  /// In en, this message translates to:
  /// **'Year: {year}'**
  String year(int year);

  /// Month display with placeholder
  ///
  /// In en, this message translates to:
  /// **'Month: {month}'**
  String month(String month);

  /// Day display with placeholder
  ///
  /// In en, this message translates to:
  /// **'Day: {day}'**
  String day(String day);

  /// Hour label
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get hour;

  /// Minute label
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get minute;

  /// Second label
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get second;

  /// Pick button text
  ///
  /// In en, this message translates to:
  /// **'Pick'**
  String get pick;

  /// Total sugar label
  ///
  /// In en, this message translates to:
  /// **'Total Sugar:'**
  String get totalSucre;

  /// Total tetra sugar label
  ///
  /// In en, this message translates to:
  /// **'Total Tetra Sugar:'**
  String get totalSucreTetra;

  /// Total adue sugar label
  ///
  /// In en, this message translates to:
  /// **'Total Adue Sugar:'**
  String get totalSucreAdue;

  /// Tetra sugar section title
  ///
  /// In en, this message translates to:
  /// **'Tetra Sugar'**
  String get sucreTetraTitle;

  /// Adue sugar section title
  ///
  /// In en, this message translates to:
  /// **'Adue Sugar'**
  String get sucreAdueTitle;

  /// Show live data button text
  ///
  /// In en, this message translates to:
  /// **'Show live data'**
  String get showLiveData;

  /// Showing live data status message
  ///
  /// In en, this message translates to:
  /// **'Showing live data'**
  String get showingLiveData;

  /// Inventory section title
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// Description for inventory section
  ///
  /// In en, this message translates to:
  /// **'Show the inventory of a specific day'**
  String get inventoryDescription;

  /// Tank label
  ///
  /// In en, this message translates to:
  /// **'Tank'**
  String get cuve;

  /// Failed to get inventory message
  ///
  /// In en, this message translates to:
  /// **'Failed to get inventory'**
  String get failedToGetInventory;

  /// To order label
  ///
  /// In en, this message translates to:
  /// **'To order'**
  String get toOrder;

  /// Tank label with pluralization
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Tank} other {Tanks}}'**
  String tank(int count);

  /// Filtration section title
  ///
  /// In en, this message translates to:
  /// **'Filtration'**
  String get filtrationTitle;

  /// Raw water label
  ///
  /// In en, this message translates to:
  /// **'Raw Water'**
  String get eauBrute;

  /// Filtered water label
  ///
  /// In en, this message translates to:
  /// **'Filtered Water'**
  String get eauFiltrer;

  /// Osmosed water label
  ///
  /// In en, this message translates to:
  /// **'Osmosed Water'**
  String get eauOsmose;

  /// Settings section title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Light mode option
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightmode;

  /// Dark mode option
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkmode;

  /// Language selection label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Help and assistance section title
  ///
  /// In en, this message translates to:
  /// **'Help and Assistance'**
  String get helpAssistance;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Email schedules section title
  ///
  /// In en, this message translates to:
  /// **'Email Schedules'**
  String get emailSchedules;

  /// Emails sent section title
  ///
  /// In en, this message translates to:
  /// **'Emails Sent'**
  String get emailSents;

  /// Description for email schedules section
  ///
  /// In en, this message translates to:
  /// **'Emails sent on defined intervals'**
  String get emailSchedulesDescription;

  /// Description for emails sent section
  ///
  /// In en, this message translates to:
  /// **'Emails sent to users'**
  String get emailSentsDescription;

  /// Email alerts section title
  ///
  /// In en, this message translates to:
  /// **'Email Alerts'**
  String get emailAlerts;

  /// Description for email alerts section
  ///
  /// In en, this message translates to:
  /// **'Emails sent when monitored values reach certain thresholds'**
  String get emailAlertsDescription;

  /// Monitored label
  ///
  /// In en, this message translates to:
  /// **'Monitored'**
  String get monitored;

  /// Danger alert level label
  ///
  /// In en, this message translates to:
  /// **'Danger'**
  String get danger;

  /// Warning alert level label
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Active status label
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Inactive status label
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// Add alert email button text
  ///
  /// In en, this message translates to:
  /// **'Add alert email'**
  String get addAlertEmail;

  /// Add schedule email button text
  ///
  /// In en, this message translates to:
  /// **'Add schedule email'**
  String get addScheduleEmail;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Report label
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get rapport;

  /// Interval label
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get interval;

  /// Sending time label
  ///
  /// In en, this message translates to:
  /// **'Sending Time'**
  String get tempsEnvoi;

  /// Next send label
  ///
  /// In en, this message translates to:
  /// **'Next Send'**
  String get nextRunTime;

  /// Days label
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// Deleting schedules status message
  ///
  /// In en, this message translates to:
  /// **'Deleting schedules...'**
  String get deletingSchedules;

  /// Deleting alerts status message
  ///
  /// In en, this message translates to:
  /// **'Deleting alerts...'**
  String get deletingAlerts;

  /// Schedules deleted message
  ///
  /// In en, this message translates to:
  /// **'Schedules deleted'**
  String get schedulesDeleted;

  /// Alerts deleted message
  ///
  /// In en, this message translates to:
  /// **'Alerts deleted'**
  String get alertsDeleted;

  /// Failed to delete schedules message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete schedules'**
  String get failedToDeleteSchedules;

  /// Failed to delete alerts message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete alerts'**
  String get failedToDeleteAlerts;

  /// Failed to delete schedule message with ID
  ///
  /// In en, this message translates to:
  /// **'Failed to delete schedule with ID: {id}'**
  String failedToDeleteScheduleWithId(int id);

  /// Failed to delete alert message with ID
  ///
  /// In en, this message translates to:
  /// **'Failed to delete alert with ID: {id}'**
  String failedToDeleteAlertWithId(int id);

  /// Sort schedules button text
  ///
  /// In en, this message translates to:
  /// **'Sort schedules'**
  String get sortSchedules;

  /// Sort alerts button text
  ///
  /// In en, this message translates to:
  /// **'Sort alerts'**
  String get sortAlerts;

  /// Filter schedules button text
  ///
  /// In en, this message translates to:
  /// **'Filter schedules'**
  String get filterSchedules;

  /// Filter alerts button text
  ///
  /// In en, this message translates to:
  /// **'Filter alerts'**
  String get filterAlerts;

  /// Edit schedule button text
  ///
  /// In en, this message translates to:
  /// **'Edit schedule'**
  String get editSchedule;

  /// Edit alert button text
  ///
  /// In en, this message translates to:
  /// **'Edit alert'**
  String get editAlert;

  /// Edit schedule settings option
  ///
  /// In en, this message translates to:
  /// **'Edit schedule settings'**
  String get editScheduleSettings;

  /// Edit alert settings option
  ///
  /// In en, this message translates to:
  /// **'Edit alert settings'**
  String get editAlertSettings;

  /// View schedule button text
  ///
  /// In en, this message translates to:
  /// **'View schedule'**
  String get viewSchedule;

  /// View alert button text
  ///
  /// In en, this message translates to:
  /// **'View alert'**
  String get viewAlert;

  /// View button text
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// View schedule settings option
  ///
  /// In en, this message translates to:
  /// **'View schedule settings'**
  String get viewScheduleSettings;

  /// View alert settings option
  ///
  /// In en, this message translates to:
  /// **'View alert settings'**
  String get viewAlertSettings;

  /// Add schedule button text
  ///
  /// In en, this message translates to:
  /// **'Add schedule'**
  String get addSchedule;

  /// Add alert button text
  ///
  /// In en, this message translates to:
  /// **'Add alert'**
  String get addAlert;

  /// Add one email schedule option
  ///
  /// In en, this message translates to:
  /// **'Add one email schedule'**
  String get addScheduleSettings;

  /// Add one email alert option
  ///
  /// In en, this message translates to:
  /// **'Add one email alert'**
  String get addAlertSettings;

  /// Unscheduled status label
  ///
  /// In en, this message translates to:
  /// **'Unscheduled'**
  String get unscheduled;

  /// Delete schedules button text
  ///
  /// In en, this message translates to:
  /// **'Delete schedules'**
  String get deleteSchedules;

  /// Delete alerts button text
  ///
  /// In en, this message translates to:
  /// **'Delete alerts'**
  String get deleteAlerts;

  /// Prompt to select schedules to delete
  ///
  /// In en, this message translates to:
  /// **'Select schedules to delete'**
  String get selectSchedulesToDelete;

  /// Prompt to select alerts to delete
  ///
  /// In en, this message translates to:
  /// **'Select alerts to delete'**
  String get selectAlertsToDelete;

  /// Confirmation message for deleting schedules
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count, plural, one {schedule} other {schedules}}?'**
  String confirmSchedulesDeletion(int count);

  /// Prompt to select a report
  ///
  /// In en, this message translates to:
  /// **'Select a report'**
  String get selectAReport;

  /// Prompt to select an interval
  ///
  /// In en, this message translates to:
  /// **'Select an interval'**
  String get selectAnInterval;

  /// Manual interval label in days
  ///
  /// In en, this message translates to:
  /// **'Manual interval (in days)'**
  String get intervalManualLabel;

  /// Schedule the next run manually option
  ///
  /// In en, this message translates to:
  /// **'Schedule the next run manually'**
  String get scheduleManually;

  /// Roles section title
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// Prompt to select roles
  ///
  /// In en, this message translates to:
  /// **'Select roles'**
  String get selectRoles;

  /// Prompt to select users
  ///
  /// In en, this message translates to:
  /// **'Select users'**
  String get selectUsers;

  /// Option to send alert to roles
  ///
  /// In en, this message translates to:
  /// **'Send this alert to roles'**
  String get sendThisAlertToRoles;

  /// Option to send alert to users
  ///
  /// In en, this message translates to:
  /// **'Send this alert to users'**
  String get sendThisAlertToUsers;

  /// Schedules section title
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get schedules;

  /// Alerts section title
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// Add a new schedule email button text
  ///
  /// In en, this message translates to:
  /// **'Add a new schedule email'**
  String get addANewScheduleEmail;

  /// Add a new alert email button text
  ///
  /// In en, this message translates to:
  /// **'Add a new alert email'**
  String get addANewAlertEmail;

  /// Edit schedule email button text
  ///
  /// In en, this message translates to:
  /// **'Edit schedule email'**
  String get editScheduleEmail;

  /// Edit alert email button text
  ///
  /// In en, this message translates to:
  /// **'Edit alert email'**
  String get editAlertEmail;

  /// View schedule email button text
  ///
  /// In en, this message translates to:
  /// **'View schedule email'**
  String get viewScheduleEmail;

  /// View alert email button text
  ///
  /// In en, this message translates to:
  /// **'View alert email'**
  String get viewAlertEmail;

  /// Add button text
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Next send date label
  ///
  /// In en, this message translates to:
  /// **'Next send date'**
  String get nextRunTimeDate;

  /// Next send time label
  ///
  /// In en, this message translates to:
  /// **'Next send time'**
  String get nextRunTimeTime;

  /// Filter by interval option
  ///
  /// In en, this message translates to:
  /// **'Filter by interval'**
  String get filterByInterval;

  /// Filter by monitored value tag option
  ///
  /// In en, this message translates to:
  /// **'Filter by monitored value tag'**
  String get filterByMonitoredValueTag;

  /// Filter by activation state option
  ///
  /// In en, this message translates to:
  /// **'Filter by activation state'**
  String get filterByActivationState;

  /// Prompt to select activation state
  ///
  /// In en, this message translates to:
  /// **'Select activation state'**
  String get selectActivationState;

  /// Activation state label
  ///
  /// In en, this message translates to:
  /// **'Activation state'**
  String get activationState;

  /// Tag label
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get tag;

  /// Filter by report option
  ///
  /// In en, this message translates to:
  /// **'Filter by report'**
  String get filterByRapport;

  /// Prompt to select interval
  ///
  /// In en, this message translates to:
  /// **'Select interval'**
  String get selectInterval;

  /// Adding schedule status message
  ///
  /// In en, this message translates to:
  /// **'Adding schedule...'**
  String get addingSchedule;

  /// Schedule added message
  ///
  /// In en, this message translates to:
  /// **'Schedule added'**
  String get scheduleAdded;

  /// Failed to add schedule message
  ///
  /// In en, this message translates to:
  /// **'Failed to add schedule'**
  String get failedToAddSchedule;

  /// Saving schedule status message
  ///
  /// In en, this message translates to:
  /// **'Saving schedule...'**
  String get savingSchedule;

  /// Schedule saved message
  ///
  /// In en, this message translates to:
  /// **'Schedule saved'**
  String get scheduleSaved;

  /// Failed to save schedule message
  ///
  /// In en, this message translates to:
  /// **'Failed to save schedule'**
  String get failedToSaveSchedule;

  /// Sent label
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sents;

  /// Schedule sent message
  ///
  /// In en, this message translates to:
  /// **'Schedule sent'**
  String get scheduleSent;

  /// Alert sent message
  ///
  /// In en, this message translates to:
  /// **'Alert sent'**
  String get alertSent;

  /// Delete email sents button text
  ///
  /// In en, this message translates to:
  /// **'Delete email sents'**
  String get deleteEmailSents;

  /// Prompt to select email sents to delete
  ///
  /// In en, this message translates to:
  /// **'Select email sents to delete'**
  String get selectEmailSentsToDelete;

  /// Confirmation message for deleting sent emails
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count, plural, one {sent} other {sents}}?'**
  String delete_sents(int count);

  /// Refresh button text
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// Failed to load sent emails message
  ///
  /// In en, this message translates to:
  /// **'Failed to load sent emails'**
  String get failedToLoadSents;

  /// Sending time label
  ///
  /// In en, this message translates to:
  /// **'Sending time'**
  String get tempEnvoi;

  /// Receptionist role label
  ///
  /// In en, this message translates to:
  /// **'Receptionist'**
  String get receptionist;

  /// Cyclic emails section title
  ///
  /// In en, this message translates to:
  /// **'Cyclic Emails'**
  String get schedule;

  /// Alert label
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// Unknown status label
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Deleting sent emails status message
  ///
  /// In en, this message translates to:
  /// **'Deleting sent emails...'**
  String get deletingSents;

  /// Sent emails deleted message
  ///
  /// In en, this message translates to:
  /// **'Sent emails deleted'**
  String get sentsDeleted;

  /// Failed to delete sent email(s) message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete sent email(s)'**
  String get deleteEmailSent;

  /// Filter emails sent button text
  ///
  /// In en, this message translates to:
  /// **'Filter emails sent'**
  String get filterEmailsSent;

  /// Filter by sending time option
  ///
  /// In en, this message translates to:
  /// **'Filter by sending time'**
  String get filterBySendingTime;

  /// Prompt to select sending time
  ///
  /// In en, this message translates to:
  /// **'Select sending time'**
  String get selectSendingTime;

  /// Time label
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// Filter by type of email option
  ///
  /// In en, this message translates to:
  /// **'Filter by type of email'**
  String get filterByTypeOfEmail;

  /// Prompt to select type of email
  ///
  /// In en, this message translates to:
  /// **'Select type of email'**
  String get selectTypeOfEmail;

  /// Schedule email label
  ///
  /// In en, this message translates to:
  /// **'Schedule email'**
  String get scheduleEmail;

  /// Sort sent emails button text
  ///
  /// In en, this message translates to:
  /// **'Sort sent emails'**
  String get sortSents;

  /// Order label
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// Ascending order option
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get asc;

  /// Descending order option
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get desc;

  /// Details label
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// User label
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// Edit user button text
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get editUser;

  /// View user details button text
  ///
  /// In en, this message translates to:
  /// **'View user details'**
  String get viewUserDetails;

  /// Hashed value label
  ///
  /// In en, this message translates to:
  /// **'Hashed value'**
  String get hashedValue;

  /// Adding user status message
  ///
  /// In en, this message translates to:
  /// **'Adding user...'**
  String get addingUser;

  /// Failed to add user message
  ///
  /// In en, this message translates to:
  /// **'Failed to add user'**
  String get failedToAddUser;

  /// User added successfully message
  ///
  /// In en, this message translates to:
  /// **'User added successfully'**
  String get userAddedSuccessfully;

  /// Saving user status message
  ///
  /// In en, this message translates to:
  /// **'Saving user...'**
  String get savingUser;

  /// Failed to save user message
  ///
  /// In en, this message translates to:
  /// **'Failed to save user'**
  String get failedToSaveUser;

  /// User saved successfully message
  ///
  /// In en, this message translates to:
  /// **'User saved successfully'**
  String get userSavedSuccessfully;

  /// Emails section title
  ///
  /// In en, this message translates to:
  /// **'Emails'**
  String get emails;

  /// Description label
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Sent status label
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// Sent at label
  ///
  /// In en, this message translates to:
  /// **'Sent at'**
  String get sentAt;

  /// New email sent message
  ///
  /// In en, this message translates to:
  /// **'A new email was sent'**
  String get newEmailSent;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Data found message
  ///
  /// In en, this message translates to:
  /// **'Data found'**
  String get dataFound;

  /// Retrieving data status message
  ///
  /// In en, this message translates to:
  /// **'Retrieving data...'**
  String get retrievingData;

  /// Data not found message
  ///
  /// In en, this message translates to:
  /// **'Data not found'**
  String get dataNotFound;

  /// Failed to load data message
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get failedToLoadData;

  /// Utilities section title
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utiliteTitle;

  /// Sending email status message
  ///
  /// In en, this message translates to:
  /// **'Sending email...'**
  String get sendingEmail;

  /// Email sent message
  ///
  /// In en, this message translates to:
  /// **'Email sent'**
  String get emailSent;

  /// Failed to send email message
  ///
  /// In en, this message translates to:
  /// **'Failed to send email'**
  String get failedToSendEmail;

  /// Find button text
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get find;

  /// Failed to load users message
  ///
  /// In en, this message translates to:
  /// **'Failed to load users'**
  String get failedToLoadUsers;

  /// Monitored value label
  ///
  /// In en, this message translates to:
  /// **'Monitored value'**
  String get monitoredValue;

  /// Prompt to select a value to monitor
  ///
  /// In en, this message translates to:
  /// **'Select a value to monitor'**
  String get selectAValueToMonitor;

  /// Error message for required field
  ///
  /// In en, this message translates to:
  /// **'Field is required'**
  String get requiredField;

  /// Monitor type label
  ///
  /// In en, this message translates to:
  /// **'Monitor type'**
  String get monitorType;

  /// Prompt to select a monitor type
  ///
  /// In en, this message translates to:
  /// **'Select a monitor type'**
  String get selectAMonitorType;

  /// Error message for invalid integer
  ///
  /// In en, this message translates to:
  /// **'Enter a valid integer'**
  String get enterAValidInteger;

  /// Danger point label
  ///
  /// In en, this message translates to:
  /// **'Danger point'**
  String get dangerPoint;

  /// Warning point label
  ///
  /// In en, this message translates to:
  /// **'Warning point'**
  String get warningPoint;

  /// Danger alert interval label in days
  ///
  /// In en, this message translates to:
  /// **'Danger alert interval (in days)'**
  String get dangerAlertIntervalInDays;

  /// Warning alert interval label in days
  ///
  /// In en, this message translates to:
  /// **'Warning alert interval (in days)'**
  String get warningAlertIntervalInDays;

  /// Custom message label
  ///
  /// In en, this message translates to:
  /// **'Custom message'**
  String get customMessage;

  /// Failed to load possible values for monitoring message
  ///
  /// In en, this message translates to:
  /// **'Failed to load possible values for monitoring'**
  String get failedToLoadPossibleValuesForMonitoring;

  /// Adding alert status message
  ///
  /// In en, this message translates to:
  /// **'Adding alert...'**
  String get addingAlert;

  /// Alert added message
  ///
  /// In en, this message translates to:
  /// **'Alert added'**
  String get alertAdded;

  /// Failed to add alert message
  ///
  /// In en, this message translates to:
  /// **'Failed to add alert'**
  String get failedToAddAlert;

  /// Activating alert status message
  ///
  /// In en, this message translates to:
  /// **'Activating alert...'**
  String get activatingAlert;

  /// Alert activated message
  ///
  /// In en, this message translates to:
  /// **'Alert activated'**
  String get alertActivated;

  /// Failed to activate alert message
  ///
  /// In en, this message translates to:
  /// **'Failed to activate alert'**
  String get failedToActivateAlert;

  /// Deactivating alert status message
  ///
  /// In en, this message translates to:
  /// **'Deactivating alert...'**
  String get deactivatingAlert;

  /// Alert deactivated message
  ///
  /// In en, this message translates to:
  /// **'Alert deactivated'**
  String get alertDeactivated;

  /// Failed to deactivate alert message
  ///
  /// In en, this message translates to:
  /// **'Failed to deactivate alert'**
  String get failedToDeactivateAlert;

  /// Saving alert status message
  ///
  /// In en, this message translates to:
  /// **'Saving alert...'**
  String get savingAlert;

  /// Alert saved message
  ///
  /// In en, this message translates to:
  /// **'Alert saved'**
  String get alertSaved;

  /// Failed to save alert message
  ///
  /// In en, this message translates to:
  /// **'Failed to save alert'**
  String get failedToSaveAlert;

  /// Activating status label
  ///
  /// In en, this message translates to:
  /// **'Activating'**
  String get activating;

  /// Deactivating status label
  ///
  /// In en, this message translates to:
  /// **'Deactivating'**
  String get deactivating;

  /// Activated status label
  ///
  /// In en, this message translates to:
  /// **'Activated'**
  String get activated;

  /// Deactivated status label
  ///
  /// In en, this message translates to:
  /// **'Deactivated'**
  String get deactivated;

  /// Auto-generated label
  ///
  /// In en, this message translates to:
  /// **'Auto-generated'**
  String get autoGenerated;

  /// No name label
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// First name field label
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// Last name field label
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Selected role display with placeholder
  ///
  /// In en, this message translates to:
  /// **'Role: {role}'**
  String selectedRole(String role);

  /// Prompt to select a superior
  ///
  /// In en, this message translates to:
  /// **'Select a superior'**
  String get selectASuperior;

  /// Selected superior display with placeholder
  ///
  /// In en, this message translates to:
  /// **'Superior: {superior}'**
  String selectedSuperior(String superior);

  /// Confirmation message for deleting users
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count, plural, one {user} other {users}}?'**
  String confirmUsersDeletion(int count);

  /// No username label
  ///
  /// In en, this message translates to:
  /// **'No username'**
  String get noUsername;

  /// Failed to get user message
  ///
  /// In en, this message translates to:
  /// **'Failed to get user'**
  String get failedToGetUser;

  /// Page not found message
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// Permission denied message for page access
  ///
  /// In en, this message translates to:
  /// **'You don\'t have permission to access this page'**
  String get youDontHavePermissionToAccessThisPage;

  /// Failed to connect to utilities broadcast message
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to utilities broadcast, {retries, plural, zero {no retries} one {1 retry} other {{retries} retries remaining}}'**
  String failedToConnectToUtiliteBroadcast(int retries);

  /// Failed to connect to filtration broadcast message
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to filtration broadcast, {retries, plural, zero {no retries} one {1 retry} other {{retries} retries remaining}}'**
  String failedToConnectToFiltrationBroadcast(int retries);

  /// Failed to connect to syrup production broadcast message
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to syrup production broadcast, {retries, plural, zero {no retries} one {1 retry} other {{retries} retries remaining}}'**
  String failedToConnectToSiroperieBroadcast(int retries);

  /// Level in liters label
  ///
  /// In en, this message translates to:
  /// **'Level in liters'**
  String get levelInL;

  /// Level in cubic meters label
  ///
  /// In en, this message translates to:
  /// **'Level in cubic meters'**
  String get levelInM3;

  /// Level in kilograms label
  ///
  /// In en, this message translates to:
  /// **'Level in kilograms'**
  String get levelInKG;

  /// Fill level label
  ///
  /// In en, this message translates to:
  /// **'Fill level'**
  String get fillLevel;

  /// Factory label
  ///
  /// In en, this message translates to:
  /// **'Factory'**
  String get usine;

  /// Error label
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Error downloading certificate message
  ///
  /// In en, this message translates to:
  /// **'Error downloading certificate'**
  String get errorDownloadingCertificate;

  /// To label
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// Send button text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// View alert settings for a specific name
  ///
  /// In en, this message translates to:
  /// **'View alert settings of {name}'**
  String viewAlertSettingsOf(String name);

  /// Edit alert settings for a specific name
  ///
  /// In en, this message translates to:
  /// **'Edit alert settings of {name}'**
  String editAlertSettingsOf(String name);

  /// Confirmation message for deleting alerts
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {count, plural, one {alert} other {alerts}}?'**
  String confirmAlertsDeletion(int count);

  /// Failed to load tags message
  ///
  /// In en, this message translates to:
  /// **'Failed to load tags'**
  String get failedToLoadTags;

  /// Failed to load alerts message
  ///
  /// In en, this message translates to:
  /// **'Failed to load alerts'**
  String get failedToLoadAlerts;

  /// Error message for required value
  ///
  /// In en, this message translates to:
  /// **'The value {value} is required'**
  String valueIsRequired(String value);

  /// About IBDM section title
  ///
  /// In en, this message translates to:
  /// **'About IBDM'**
  String get aProposIBDM;

  /// Description for About IBDM section
  ///
  /// In en, this message translates to:
  /// **'IBDM is an industrial data management software designed to facilitate the monitoring and analysis of industrial equipment performance.'**
  String get aProposIBDMDescription;

  /// Contact us section title
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactezNous;

  /// Address information
  ///
  /// In en, this message translates to:
  /// **'Akbou, Bejaia, Algeria'**
  String get adresse;

  /// Creators' information
  ///
  /// In en, this message translates to:
  /// **'Created by: Lyes Rabhi (lyes.rabhi.020@gmail.com) & Kheloufi Mounir (mounirkheloufi2002@gmail.com)'**
  String get createdBy;

  /// Failed to connect to CO2 broadcast message
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to CO2 broadcast, {retries, plural, zero {no retries} one {1 retry} other {{retries} retries remaining}}'**
  String failedToConnectToCO2Broadcast(int retries);

  /// CO2 section title
  ///
  /// In en, this message translates to:
  /// **'CO2'**
  String get co2Title;

  /// Consumption label
  ///
  /// In en, this message translates to:
  /// **'Consumption'**
  String get consommation;

  /// Failed to get consumption data message
  ///
  /// In en, this message translates to:
  /// **'Failed to get consumption data'**
  String get failedToGetConsommationData;

  /// Input label
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get entree;

  /// Error message for invalid superior selection
  ///
  /// In en, this message translates to:
  /// **'You cannot be a superior to yourself'**
  String get cannotBeASuperiorToYourself;

  /// Error message for invalid superior self-selection
  ///
  /// In en, this message translates to:
  /// **'You cannot be a superior for yourself'**
  String get cannotBeASuperiorForHimself;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Server status section title
  ///
  /// In en, this message translates to:
  /// **'Server Status'**
  String get serverStatus;

  /// Databases section title
  ///
  /// In en, this message translates to:
  /// **'Databases'**
  String get databases;

  /// State label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// Percentage label
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// Failed to load server status message
  ///
  /// In en, this message translates to:
  /// **'Failed to load server status'**
  String get failedToLoadServerStatus;

  /// Restart server button text
  ///
  /// In en, this message translates to:
  /// **'Restart server'**
  String get restartServer;

  /// Info label
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// Host name label
  ///
  /// In en, this message translates to:
  /// **'Host name'**
  String get host_name;

  /// Last update time label
  ///
  /// In en, this message translates to:
  /// **'Last update time'**
  String get lastUpdateTime;

  /// Last update date label
  ///
  /// In en, this message translates to:
  /// **'Last update date'**
  String get lastUpdateDate;

  /// OS uptime label
  ///
  /// In en, this message translates to:
  /// **'OS uptime'**
  String get osUptime;

  /// OS boot time label
  ///
  /// In en, this message translates to:
  /// **'OS boot time'**
  String get osBootTime;

  /// OS time label
  ///
  /// In en, this message translates to:
  /// **'OS time'**
  String get osTime;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Environment label
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// Debug label
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get debug;

  /// On status label
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// Off status label
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// Total memory label
  ///
  /// In en, this message translates to:
  /// **'Total memory'**
  String get totalMemory;

  /// Used memory label
  ///
  /// In en, this message translates to:
  /// **'Used memory'**
  String get usedMemory;

  /// Available memory label
  ///
  /// In en, this message translates to:
  /// **'Available memory'**
  String get availableMemory;

  /// Memory usage label
  ///
  /// In en, this message translates to:
  /// **'Memory usage'**
  String get memoryUsage;

  /// Memory label
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// Network label
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// Received label
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get received;

  /// Operating system label
  ///
  /// In en, this message translates to:
  /// **'OS'**
  String get os;

  /// CPU usage label
  ///
  /// In en, this message translates to:
  /// **'CPU usage'**
  String get cpuUsage;

  /// Total storage label
  ///
  /// In en, this message translates to:
  /// **'Total storage'**
  String get totalStorage;

  /// Used storage label
  ///
  /// In en, this message translates to:
  /// **'Used storage'**
  String get usedStorage;

  /// Available storage label
  ///
  /// In en, this message translates to:
  /// **'Available storage'**
  String get availableStorage;

  /// Storage usage label
  ///
  /// In en, this message translates to:
  /// **'Storage usage'**
  String get storageUsage;

  /// Loading users status message
  ///
  /// In en, this message translates to:
  /// **'Loading users...'**
  String get loadingUsers;

  /// General loading status message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Loading user details status message
  ///
  /// In en, this message translates to:
  /// **'Loading user details...'**
  String get loadingUserDetails;

  /// Loading user status message
  ///
  /// In en, this message translates to:
  /// **'Loading user...'**
  String get loadingUser;

  /// Loading sent emails status message
  ///
  /// In en, this message translates to:
  /// **'Loading sent emails...'**
  String get loadingSents;

  /// Loading alerts status message
  ///
  /// In en, this message translates to:
  /// **'Loading alerts...'**
  String get loadingAlerts;

  /// Loading schedules status message
  ///
  /// In en, this message translates to:
  /// **'Loading schedules...'**
  String get loadingSchedules;

  /// Loading tags status message
  ///
  /// In en, this message translates to:
  /// **'Loading tags...'**
  String get loadingTags;

  /// Loading roles status message
  ///
  /// In en, this message translates to:
  /// **'Loading roles...'**
  String get loadingRoles;

  /// Loading superiors status message
  ///
  /// In en, this message translates to:
  /// **'Loading superiors...'**
  String get loadingSuperiors;

  /// Waiting for connection status message
  ///
  /// In en, this message translates to:
  /// **'Waiting for connection...'**
  String get waitingForConnection;

  /// Waiting for valid data status message
  ///
  /// In en, this message translates to:
  /// **'Waiting for valid data...'**
  String get waitingForValidData;

  /// Reconnecting status message
  ///
  /// In en, this message translates to:
  /// **'Reconnecting...'**
  String get reconnecting;

  /// Not loading status message
  ///
  /// In en, this message translates to:
  /// **'Not loading'**
  String get notLoading;

  /// Waiting status message
  ///
  /// In en, this message translates to:
  /// **'Waiting...'**
  String get waiting;

  /// Loading server settings status message
  ///
  /// In en, this message translates to:
  /// **'Loading server settings'**
  String get loadingServerConfig;

  /// Server settings section title
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// Failed to load server settings message
  ///
  /// In en, this message translates to:
  /// **'Failed to load server settings'**
  String get failedToLoadServerConfig;

  /// Change secret key option
  ///
  /// In en, this message translates to:
  /// **'Change secret key'**
  String get changeSecretKey;

  /// Log to files option
  ///
  /// In en, this message translates to:
  /// **'Log to files'**
  String get logToFiles;

  /// Database connection check timeout label in seconds
  ///
  /// In en, this message translates to:
  /// **'Database connection check timeout (in seconds)'**
  String get dbConnectionCheckTimeout;

  /// Seconds label
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get seconds;

  /// Allowed hosts label
  ///
  /// In en, this message translates to:
  /// **'Allowed hosts'**
  String get allowedHosts;

  /// Add allowed host button text
  ///
  /// In en, this message translates to:
  /// **'Add allowed host'**
  String get addAllowedHost;

  /// Trusted origins label
  ///
  /// In en, this message translates to:
  /// **'Trusted origins'**
  String get trustedOrigins;

  /// Add trusted origin button text
  ///
  /// In en, this message translates to:
  /// **'Add trusted origin'**
  String get addTrustedOrigin;

  /// Email providers label
  ///
  /// In en, this message translates to:
  /// **'Email providers'**
  String get emailProviders;

  /// Engine label
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get engine;

  /// Port label
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// Host label
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// Email of sender label
  ///
  /// In en, this message translates to:
  /// **'Email of sender'**
  String get emailOfSender;

  /// Use TLS option
  ///
  /// In en, this message translates to:
  /// **'Use TLS'**
  String get useTls;

  /// System monitor database timeout label in seconds
  ///
  /// In en, this message translates to:
  /// **'System monitor database timeout (in seconds)'**
  String get systemMonitorDBTimeout;

  /// New secret key label
  ///
  /// In en, this message translates to:
  /// **'New secret key'**
  String get newSecretKey;

  /// New email provider label
  ///
  /// In en, this message translates to:
  /// **'New email provider'**
  String get newEmailProvider;

  /// New database label
  ///
  /// In en, this message translates to:
  /// **'New database'**
  String get newDatabase;

  /// Database identifier label
  ///
  /// In en, this message translates to:
  /// **'Database identifier'**
  String get dbIdentifier;

  /// Configuration saved message
  ///
  /// In en, this message translates to:
  /// **'Configuration saved'**
  String get configSaved;

  /// Failed to save configuration message
  ///
  /// In en, this message translates to:
  /// **'Failed to save configuration'**
  String get failedToSaveConfig;

  /// Saving configuration status message
  ///
  /// In en, this message translates to:
  /// **'Saving configuration...'**
  String get savingConfig;

  /// Save configuration button text
  ///
  /// In en, this message translates to:
  /// **'Save configuration'**
  String get saveConfig;

  /// Confirmation message for saving configuration
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to save the configuration? This will overwrite the current configuration. The new configuration will be irreversibly saved but it will not take effect until the server is restarted.'**
  String get saveConfigAlertMessage;

  /// Failed to send email message with ID
  ///
  /// In en, this message translates to:
  /// **'Failed to send email with ID: {id}'**
  String failedToSendEmailWithId(int id);

  /// Failed to connect to status broadcast message
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to status broadcast, {retries, plural, zero {no retries} one {1 retry} other {{retries} retries remaining}}'**
  String failedToConnectToStatusBroadcast(int retries);

  /// Invalid email or password message
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// Error message for existing email
  ///
  /// In en, this message translates to:
  /// **'A user with this email already exists'**
  String get userWithThisEmailAlreadyExists;

  /// List view label
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// Graph view label
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get graph;

  /// Error connecting to broadcast message
  ///
  /// In en, this message translates to:
  /// **'Error connecting to broadcast, live data will not work'**
  String get errorConnectingBroadcast;

  /// Date label
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Sugar label
  ///
  /// In en, this message translates to:
  /// **'Sugar'**
  String get sucre;

  /// Utilities label
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get utilite;

  /// CO2 label
  ///
  /// In en, this message translates to:
  /// **'CO2'**
  String get co2;

  /// Level label
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get niveau;

  /// Volume label
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// Flow rate label
  ///
  /// In en, this message translates to:
  /// **'Flow rate'**
  String get debit;

  /// Pressure and conductivity label
  ///
  /// In en, this message translates to:
  /// **'Pres Cond'**
  String get presCond;

  /// Failed to get level data message
  ///
  /// In en, this message translates to:
  /// **'Failed to get level data'**
  String get failedToGetNiveauData;

  /// Failed to get volume data message
  ///
  /// In en, this message translates to:
  /// **'Failed to get volume data'**
  String get failedToGetVolumeData;

  /// Failed to get flow rate data message
  ///
  /// In en, this message translates to:
  /// **'Failed to get flow rate data'**
  String get failedToGetDebitData;

  /// Failed to get pressure and conductivity data message
  ///
  /// In en, this message translates to:
  /// **'Failed to get pressure and conductivity data'**
  String get failedToGetPresCondData;

  /// Value label
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// Visualize button text
  ///
  /// In en, this message translates to:
  /// **'Visualize'**
  String get visualize;

  /// Week label
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// Precision label
  ///
  /// In en, this message translates to:
  /// **'Precision'**
  String get precision;

  /// Type label
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Description for consumption section
  ///
  /// In en, this message translates to:
  /// **'Show the consumption in a range of dates'**
  String get consommationDescription;

  /// Previous day label
  ///
  /// In en, this message translates to:
  /// **'Previous day'**
  String get previousDay;

  /// Since first of month label
  ///
  /// In en, this message translates to:
  /// **'Since first of month'**
  String get sinceFirstOfMonth;

  /// Reports section title
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// Sugar reports section title
  ///
  /// In en, this message translates to:
  /// **'Sugar reports'**
  String get sucreReports;

  /// CO2 reports section title
  ///
  /// In en, this message translates to:
  /// **'CO2 reports'**
  String get co2Reports;

  /// Utilities reports section title
  ///
  /// In en, this message translates to:
  /// **'Utilities reports'**
  String get utiliteReports;

  /// Filtration reports section title
  ///
  /// In en, this message translates to:
  /// **'Filtration reports'**
  String get filtrationReports;

  /// Generate report button text
  ///
  /// In en, this message translates to:
  /// **'Generate report'**
  String get generateReport;

  /// Description for generating a report
  ///
  /// In en, this message translates to:
  /// **'Generate a report for a specific date'**
  String get generateReportDescription;

  /// View report with placeholder
  ///
  /// In en, this message translates to:
  /// **'Report: {rapport}'**
  String viewReport(String rapport);

  /// Description for viewing a report with date
  ///
  /// In en, this message translates to:
  /// **'View the report of {date}'**
  String viewReportDescription(String date);

  /// Loading reports status message
  ///
  /// In en, this message translates to:
  /// **'Loading reports...'**
  String get loadingReports;

  /// Failed to load reports message
  ///
  /// In en, this message translates to:
  /// **'Failed to load reports'**
  String get failedToLoadReports;

  /// Sort reports button text
  ///
  /// In en, this message translates to:
  /// **'Sort reports'**
  String get sortReports;

  /// Filter reports button text
  ///
  /// In en, this message translates to:
  /// **'Filter reports'**
  String get filterReports;

  /// Has synthesis label
  ///
  /// In en, this message translates to:
  /// **'Has synthesis'**
  String get hasSynthese;

  /// Interval name with placeholder
  ///
  /// In en, this message translates to:
  /// **'{interval, select, jour {Day} semaine {Week} mois {Month} manual {Manual} other {Interval}}'**
  String getIntervalName(String interval);

  /// With synthesis label
  ///
  /// In en, this message translates to:
  /// **'With synthesis'**
  String get withSynthese;

  /// Without synthesis label
  ///
  /// In en, this message translates to:
  /// **'Without synthesis'**
  String get withoutSynthese;

  /// Failed to generate report message
  ///
  /// In en, this message translates to:
  /// **'Failed to generate report'**
  String get failedToGenerateReport;

  /// Generate button text
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// Today's reports section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s reports'**
  String get todaysReports;

  /// Error loading reports message
  ///
  /// In en, this message translates to:
  /// **'Error loading reports'**
  String get errorLoadingReports;

  /// Synthesis label
  ///
  /// In en, this message translates to:
  /// **'Synthesis'**
  String get synthese;

  /// Download certificate button text
  ///
  /// In en, this message translates to:
  /// **'Download certificate'**
  String get downloadCertificate;

  /// Downloading certificate status message
  ///
  /// In en, this message translates to:
  /// **'Downloading certificate...'**
  String get downloadingCertificateMessage;

  /// Download failed message
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// File downloaded to path message
  ///
  /// In en, this message translates to:
  /// **'File downloaded to: {path}'**
  String fileDownloadedTo(String path);

  /// Downloaded with browser message
  ///
  /// In en, this message translates to:
  /// **'Downloaded with browser'**
  String get downloadedWithBrowser;

  /// Downloaded file path copied to clipboard message
  ///
  /// In en, this message translates to:
  /// **'Downloaded file path copied to clipboard'**
  String get downloadedFilePathCopiedToClipboard;

  /// Profile section title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No superior label
  ///
  /// In en, this message translates to:
  /// **'No superior'**
  String get noSuperior;

  /// Welcome back message
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Pressure label
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get pression;

  /// Conductivity label
  ///
  /// In en, this message translates to:
  /// **'Conductivity'**
  String get conductivity;

  /// Temperature label
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// Minimum length requirement message
  ///
  /// In en, this message translates to:
  /// **'Minimum length: {length}'**
  String minLength(int length);

  /// Maximum length requirement message
  ///
  /// In en, this message translates to:
  /// **'Maximum length: {length}'**
  String maxLength(int length);

  /// Lowercase character requirement message
  ///
  /// In en, this message translates to:
  /// **'Must contain at least {count} lowercase character'**
  String hasLowercaseChars(int count);

  /// Uppercase character requirement message
  ///
  /// In en, this message translates to:
  /// **'Must contain at least {count} uppercase character'**
  String hasUppercaseChars(int count);

  /// Numeric character requirement message
  ///
  /// In en, this message translates to:
  /// **'Must contain at least {count} number'**
  String hasNumericChars(int count);

  /// Special character requirement message
  ///
  /// In en, this message translates to:
  /// **'Must contain at least {count} special character'**
  String hasSpecialChars(int count);

  /// Invalid first name message
  ///
  /// In en, this message translates to:
  /// **'Invalid first name'**
  String get invalidFirstName;

  /// Invalid last name message
  ///
  /// In en, this message translates to:
  /// **'Invalid last name'**
  String get invalidLastName;

  /// Invalid field message with placeholder
  ///
  /// In en, this message translates to:
  /// **'Invalid {field}'**
  String invalidField(String field);

  /// Admin button label
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get admin;

  /// Failed to open admin panel message
  ///
  /// In en, this message translates to:
  /// **'Failed to open admin panel'**
  String get errorOpeningAdminPanel;

  /// Log file size limit label
  ///
  /// In en, this message translates to:
  /// **'Log file size limit'**
  String get logSizeLimit;

  /// Number of logs to keep label
  ///
  /// In en, this message translates to:
  /// **'Number of logs to keep'**
  String get numberOfLogsToKeep;

  /// Logs section title
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// Permission denied message
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// Alert after N seconds of no data label in seconds
  ///
  /// In en, this message translates to:
  /// **'Alert After N seconds of no data'**
  String get dataStoppedWaitSeconds;

  /// Minimum value label with placeholder
  ///
  /// In en, this message translates to:
  /// **'Minimum {min}'**
  String min(int min);

  /// Collapse button text
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// Expand button text
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// Dark mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// Light mode toggle label
  ///
  /// In en, this message translates to:
  /// **'Light mode'**
  String get lightMode;

  /// Change language button label
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// Hold to reset to system theme message
  ///
  /// In en, this message translates to:
  /// **'Hold to reset to system theme'**
  String get holdToResetToSystemTheme;

  /// Description for monitored value field
  ///
  /// In en, this message translates to:
  /// **'The field that will be monitored for changes'**
  String get monitoredValueDescription;

  /// Description for monitor type field
  ///
  /// In en, this message translates to:
  /// **'Are the values of the monitored field ascending or descending?'**
  String get monitorTypeDescription;

  /// Description for danger alert interval field
  ///
  /// In en, this message translates to:
  /// **'The number of days before re-sending the alert of type danger if it is not resolved'**
  String get dangerAlertIntervalDescription;

  /// No description provided for @warningAlertIntervalDescription.
  ///
  /// In en, this message translates to:
  /// **'The number of days before re-sending the alert of type warning if it is not resolved'**
  String get warningAlertIntervalDescription;

  /// Message when there is nothing to display
  ///
  /// In en, this message translates to:
  /// **'Nothing to display'**
  String get nothingToDisplay;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
