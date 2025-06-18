// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homePageWelcomeMessage => 'Welcome to the app';

  @override
  String get login => 'Login';

  @override
  String get loginToContinue => 'Login to continue';

  @override
  String get email => 'Email';

  @override
  String get emailExemple => 'account@example.com';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot password';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get invalidPassword => 'Invalid password';

  @override
  String get requiredEmail => 'Email is required';

  @override
  String get requiredPassword => 'Password is required';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get enterYourPassword => 'Enter your password';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get logout => 'Logout';

  @override
  String get logoutSuccess => 'Logout successful';

  @override
  String get logoutFailed => 'Logout failed';

  @override
  String get pleaseFillInAllFields => 'Please fill in all fields';

  @override
  String get loggingIn => 'Logging in...';

  @override
  String get loginSuccessful => 'Login successful';

  @override
  String get logoutSuccessMessage => 'You have successfully logged out';

  @override
  String get logoutFailedMessage => 'An error occurred while logging out';

  @override
  String get loginFailedMessage => 'An error occurred while logging in';

  @override
  String get loginSuccessMessage => 'You have successfully logged in';

  @override
  String get connectionFailedError =>
      'A connection error occurred, please check your internet connection and try again';

  @override
  String get serverError => 'A server error occurred, please try again later';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get noInternetConnectionMessage =>
      'Please check your internet connection and try again';

  @override
  String get timeOutError => 'Request timed out, please try again later';

  @override
  String get cancelMessage => 'Request cancelled';

  @override
  String get unknownError =>
      'An unknown error occurred, please try again later';

  @override
  String get connectionFailed => 'Connection failed';

  @override
  String get accessDenied => 'Access denied';

  @override
  String get loginRequired => 'You must be logged in';

  @override
  String get logoutRequired => 'You must be logged out';

  @override
  String get search => 'Search...';

  @override
  String get userManagement => 'User Management';

  @override
  String get addUser => 'Add User';

  @override
  String get addOneUser => 'Add one user';

  @override
  String get delete => 'Delete';

  @override
  String get filters => 'Filters';

  @override
  String get filterUser => 'Filter users';

  @override
  String get filterByRole => 'Filter by role';

  @override
  String get role => 'Role';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get sortUser => 'Sort users';

  @override
  String get sortBy => 'Sort by';

  @override
  String get id => 'ID';

  @override
  String get name => 'Name';

  @override
  String get perPage => 'Per page';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get num => 'Num';

  @override
  String get avatar => 'Avatar';

  @override
  String get actions => 'Actions';

  @override
  String get page => 'Page';

  @override
  String get prevPage => 'Previous';

  @override
  String get nextPage => 'Next';

  @override
  String get users => 'Users';

  @override
  String get deleteUser => 'Delete users';

  @override
  String get selectUserDelete => 'Select users to delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get repFav => 'Yes';

  @override
  String get repDeFav => 'No';

  @override
  String get pleaseFixErrorsInTheForm => 'Please fix the errors in the form';

  @override
  String get addUserMessage => 'Adding user...';

  @override
  String get failedToGetUsersMessage => 'Failed to get users';

  @override
  String get errorFailedToGetUsers => 'Error: Failed to get users';

  @override
  String get failedToAddUserMessage => 'Failed to add user';

  @override
  String get successAddUserMessage => 'User added successfully';

  @override
  String get openingFilePicker => 'Opening file picker...';

  @override
  String get canceled => 'Canceled';

  @override
  String get fileSelected => 'File selected';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get superior => 'Superior';

  @override
  String get selectSuperior => 'Select a superior';

  @override
  String delete_users(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'users',
      one: 'user',
    );
    return 'Are you sure you want to delete $_temp0?';
  }

  @override
  String get ibdm => 'IBDM';

  @override
  String get ifri_bdd => 'Ifri Machine Database';

  @override
  String get options => 'Options';

  @override
  String get me => 'Me';

  @override
  String get siroperieTitle => 'Syrup Production';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String year(int year) {
    return 'Year: $year';
  }

  @override
  String month(String month) {
    return 'Month: $month';
  }

  @override
  String day(String day) {
    return 'Day: $day';
  }

  @override
  String get hour => 'Hour';

  @override
  String get minute => 'Minute';

  @override
  String get second => 'Second';

  @override
  String get pick => 'Pick';

  @override
  String get totalSucre => 'Total Sugar:';

  @override
  String get totalSucreTetra => 'Total Tetra Sugar:';

  @override
  String get totalSucreAdue => 'Total Adue Sugar:';

  @override
  String get sucreTetraTitle => 'Tetra Sugar';

  @override
  String get sucreAdueTitle => 'Adue Sugar';

  @override
  String get showLiveData => 'Show live data';

  @override
  String get showingLiveData => 'Showing live data';

  @override
  String get inventory => 'Inventory';

  @override
  String get inventoryDescription => 'Show the inventory of a specific day';

  @override
  String get cuve => 'Tank';

  @override
  String get failedToGetInventory => 'Failed to get inventory';

  @override
  String get toOrder => 'To order';

  @override
  String tank(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tanks',
      one: 'Tank',
    );
    return '$_temp0';
  }

  @override
  String get filtrationTitle => 'Filtration';

  @override
  String get eauBrute => 'Raw Water';

  @override
  String get eauFiltrer => 'Filtered Water';

  @override
  String get eauOsmose => 'Osmosed Water';

  @override
  String get settings => 'Settings';

  @override
  String get lightmode => 'Light mode';

  @override
  String get darkmode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get helpAssistance => 'Help and Assistance';

  @override
  String get about => 'About';

  @override
  String get emailSchedules => 'Email Schedules';

  @override
  String get emailSents => 'Emails Sent';

  @override
  String get emailSchedulesDescription => 'Emails sent on defined intervals';

  @override
  String get emailSentsDescription => 'Emails sent to users';

  @override
  String get emailAlerts => 'Email Alerts';

  @override
  String get emailAlertsDescription =>
      'Emails sent when monitored values reach certain thresholds';

  @override
  String get monitored => 'Monitored';

  @override
  String get danger => 'Danger';

  @override
  String get warning => 'Warning';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get addAlertEmail => 'Add alert email';

  @override
  String get addScheduleEmail => 'Add schedule email';

  @override
  String get edit => 'Edit';

  @override
  String get save => 'Save';

  @override
  String get rapport => 'Report';

  @override
  String get interval => 'Interval';

  @override
  String get tempsEnvoi => 'Sending Time';

  @override
  String get nextRunTime => 'Next Send';

  @override
  String get days => 'Days';

  @override
  String get deletingSchedules => 'Deleting schedules...';

  @override
  String get deletingAlerts => 'Deleting alerts...';

  @override
  String get schedulesDeleted => 'Schedules deleted';

  @override
  String get alertsDeleted => 'Alerts deleted';

  @override
  String get failedToDeleteSchedules => 'Failed to delete schedules';

  @override
  String get failedToDeleteAlerts => 'Failed to delete alerts';

  @override
  String failedToDeleteScheduleWithId(int id) {
    return 'Failed to delete schedule with ID: $id';
  }

  @override
  String failedToDeleteAlertWithId(int id) {
    return 'Failed to delete alert with ID: $id';
  }

  @override
  String get sortSchedules => 'Sort schedules';

  @override
  String get sortAlerts => 'Sort alerts';

  @override
  String get filterSchedules => 'Filter schedules';

  @override
  String get filterAlerts => 'Filter alerts';

  @override
  String get editSchedule => 'Edit schedule';

  @override
  String get editAlert => 'Edit alert';

  @override
  String get editScheduleSettings => 'Edit schedule settings';

  @override
  String get editAlertSettings => 'Edit alert settings';

  @override
  String get viewSchedule => 'View schedule';

  @override
  String get viewAlert => 'View alert';

  @override
  String get view => 'View';

  @override
  String get viewScheduleSettings => 'View schedule settings';

  @override
  String get viewAlertSettings => 'View alert settings';

  @override
  String get addSchedule => 'Add schedule';

  @override
  String get addAlert => 'Add alert';

  @override
  String get addScheduleSettings => 'Add one email schedule';

  @override
  String get addAlertSettings => 'Add one email alert';

  @override
  String get unscheduled => 'Unscheduled';

  @override
  String get deleteSchedules => 'Delete schedules';

  @override
  String get deleteAlerts => 'Delete alerts';

  @override
  String get selectSchedulesToDelete => 'Select schedules to delete';

  @override
  String get selectAlertsToDelete => 'Select alerts to delete';

  @override
  String confirmSchedulesDeletion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'schedules',
      one: 'schedule',
    );
    return 'Are you sure you want to delete $_temp0?';
  }

  @override
  String get selectAReport => 'Select a report';

  @override
  String get selectAnInterval => 'Select an interval';

  @override
  String get intervalManualLabel => 'Manual interval (in days)';

  @override
  String get scheduleManually => 'Schedule the next run manually';

  @override
  String get roles => 'Roles';

  @override
  String get selectRoles => 'Select roles';

  @override
  String get selectUsers => 'Select users';

  @override
  String get sendThisAlertToRoles => 'Send this alert to roles';

  @override
  String get sendThisAlertToUsers => 'Send this alert to users';

  @override
  String get schedules => 'Schedules';

  @override
  String get alerts => 'Alerts';

  @override
  String get addANewScheduleEmail => 'Add a new schedule email';

  @override
  String get addANewAlertEmail => 'Add a new alert email';

  @override
  String get editScheduleEmail => 'Edit schedule email';

  @override
  String get editAlertEmail => 'Edit alert email';

  @override
  String get viewScheduleEmail => 'View schedule email';

  @override
  String get viewAlertEmail => 'View alert email';

  @override
  String get add => 'Add';

  @override
  String get nextRunTimeDate => 'Next send date';

  @override
  String get nextRunTimeTime => 'Next send time';

  @override
  String get filterByInterval => 'Filter by interval';

  @override
  String get filterByMonitoredValueTag => 'Filter by monitored value tag';

  @override
  String get filterByActivationState => 'Filter by activation state';

  @override
  String get selectActivationState => 'Select activation state';

  @override
  String get activationState => 'Activation state';

  @override
  String get tag => 'Tag';

  @override
  String get filterByRapport => 'Filter by report';

  @override
  String get selectInterval => 'Select interval';

  @override
  String get addingSchedule => 'Adding schedule...';

  @override
  String get scheduleAdded => 'Schedule added';

  @override
  String get failedToAddSchedule => 'Failed to add schedule';

  @override
  String get savingSchedule => 'Saving schedule...';

  @override
  String get scheduleSaved => 'Schedule saved';

  @override
  String get failedToSaveSchedule => 'Failed to save schedule';

  @override
  String get sents => 'Sent';

  @override
  String get scheduleSent => 'Schedule sent';

  @override
  String get alertSent => 'Alert sent';

  @override
  String get deleteEmailSents => 'Delete email sents';

  @override
  String get selectEmailSentsToDelete => 'Select email sents to delete';

  @override
  String delete_sents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'sents',
      one: 'sent',
    );
    return 'Are you sure you want to delete $_temp0?';
  }

  @override
  String get refresh => 'Refresh';

  @override
  String get failedToLoadSents => 'Failed to load sent emails';

  @override
  String get tempEnvoi => 'Sending time';

  @override
  String get receptionist => 'Receptionist';

  @override
  String get schedule => 'Cyclic Emails';

  @override
  String get alert => 'Alert';

  @override
  String get unknown => 'Unknown';

  @override
  String get deletingSents => 'Deleting sent emails...';

  @override
  String get sentsDeleted => 'Sent emails deleted';

  @override
  String get deleteEmailSent => 'Failed to delete sent email(s)';

  @override
  String get filterEmailsSent => 'Filter emails sent';

  @override
  String get filterBySendingTime => 'Filter by sending time';

  @override
  String get selectSendingTime => 'Select sending time';

  @override
  String get time => 'Time';

  @override
  String get filterByTypeOfEmail => 'Filter by type of email';

  @override
  String get selectTypeOfEmail => 'Select type of email';

  @override
  String get scheduleEmail => 'Schedule email';

  @override
  String get sortSents => 'Sort sent emails';

  @override
  String get order => 'Order';

  @override
  String get asc => 'Ascending';

  @override
  String get desc => 'Descending';

  @override
  String get details => 'Details';

  @override
  String get user => 'User';

  @override
  String get editUser => 'Edit user';

  @override
  String get viewUserDetails => 'View user details';

  @override
  String get hashedValue => 'Hashed value';

  @override
  String get addingUser => 'Adding user...';

  @override
  String get failedToAddUser => 'Failed to add user';

  @override
  String get userAddedSuccessfully => 'User added successfully';

  @override
  String get savingUser => 'Saving user...';

  @override
  String get failedToSaveUser => 'Failed to save user';

  @override
  String get userSavedSuccessfully => 'User saved successfully';

  @override
  String get emails => 'Emails';

  @override
  String get description => 'Description';

  @override
  String get sent => 'Sent';

  @override
  String get sentAt => 'Sent at';

  @override
  String get newEmailSent => 'A new email was sent';

  @override
  String get welcome => 'Welcome';

  @override
  String get dataFound => 'Data found';

  @override
  String get retrievingData => 'Retrieving data...';

  @override
  String get dataNotFound => 'Data not found';

  @override
  String get failedToLoadData => 'Failed to load data';

  @override
  String get utiliteTitle => 'Utilities';

  @override
  String get sendingEmail => 'Sending email...';

  @override
  String get emailSent => 'Email sent';

  @override
  String get failedToSendEmail => 'Failed to send email';

  @override
  String get find => 'Find';

  @override
  String get failedToLoadUsers => 'Failed to load users';

  @override
  String get monitoredValue => 'Monitored value';

  @override
  String get selectAValueToMonitor => 'Select a value to monitor';

  @override
  String get requiredField => 'Field is required';

  @override
  String get monitorType => 'Monitor type';

  @override
  String get selectAMonitorType => 'Select a monitor type';

  @override
  String get enterAValidInteger => 'Enter a valid integer';

  @override
  String get dangerPoint => 'Danger point';

  @override
  String get warningPoint => 'Warning point';

  @override
  String get dangerAlertIntervalInDays => 'Danger alert interval (in days)';

  @override
  String get warningAlertIntervalInDays => 'Warning alert interval (in days)';

  @override
  String get customMessage => 'Custom message';

  @override
  String get failedToLoadPossibleValuesForMonitoring =>
      'Failed to load possible values for monitoring';

  @override
  String get addingAlert => 'Adding alert...';

  @override
  String get alertAdded => 'Alert added';

  @override
  String get failedToAddAlert => 'Failed to add alert';

  @override
  String get activatingAlert => 'Activating alert...';

  @override
  String get alertActivated => 'Alert activated';

  @override
  String get failedToActivateAlert => 'Failed to activate alert';

  @override
  String get deactivatingAlert => 'Deactivating alert...';

  @override
  String get alertDeactivated => 'Alert deactivated';

  @override
  String get failedToDeactivateAlert => 'Failed to deactivate alert';

  @override
  String get savingAlert => 'Saving alert...';

  @override
  String get alertSaved => 'Alert saved';

  @override
  String get failedToSaveAlert => 'Failed to save alert';

  @override
  String get activating => 'Activating';

  @override
  String get deactivating => 'Deactivating';

  @override
  String get activated => 'Activated';

  @override
  String get deactivated => 'Deactivated';

  @override
  String get autoGenerated => 'Auto-generated';

  @override
  String get noName => 'No name';

  @override
  String get newPassword => 'New password';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get username => 'Username';

  @override
  String selectedRole(String role) {
    return 'Role: $role';
  }

  @override
  String get selectASuperior => 'Select a superior';

  @override
  String selectedSuperior(String superior) {
    return 'Superior: $superior';
  }

  @override
  String confirmUsersDeletion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'users',
      one: 'user',
    );
    return 'Are you sure you want to delete $_temp0?';
  }

  @override
  String get noUsername => 'No username';

  @override
  String get failedToGetUser => 'Failed to get user';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get youDontHavePermissionToAccessThisPage =>
      'You don\'t have permission to access this page';

  @override
  String failedToConnectToUtiliteBroadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries retries remaining',
      one: '1 retry',
      zero: 'no retries',
    );
    return 'Failed to connect to utilities broadcast, $_temp0';
  }

  @override
  String failedToConnectToFiltrationBroadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries retries remaining',
      one: '1 retry',
      zero: 'no retries',
    );
    return 'Failed to connect to filtration broadcast, $_temp0';
  }

  @override
  String failedToConnectToSiroperieBroadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries retries remaining',
      one: '1 retry',
      zero: 'no retries',
    );
    return 'Failed to connect to syrup production broadcast, $_temp0';
  }

  @override
  String get levelInL => 'Level in liters';

  @override
  String get levelInM3 => 'Level in cubic meters';

  @override
  String get levelInKG => 'Level in kilograms';

  @override
  String get fillLevel => 'Fill level';

  @override
  String get usine => 'Factory';

  @override
  String get error => 'Error';

  @override
  String get errorDownloadingCertificate => 'Error downloading certificate';

  @override
  String get to => 'To';

  @override
  String get send => 'Send';

  @override
  String viewAlertSettingsOf(String name) {
    return 'View alert settings of $name';
  }

  @override
  String editAlertSettingsOf(String name) {
    return 'Edit alert settings of $name';
  }

  @override
  String confirmAlertsDeletion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'alerts',
      one: 'alert',
    );
    return 'Are you sure you want to delete $_temp0?';
  }

  @override
  String get failedToLoadTags => 'Failed to load tags';

  @override
  String get failedToLoadAlerts => 'Failed to load alerts';

  @override
  String valueIsRequired(String value) {
    return 'The value $value is required';
  }

  @override
  String get aProposIBDM => 'About IBDM';

  @override
  String get aProposIBDMDescription =>
      'IBDM is an industrial data management software designed to facilitate the monitoring and analysis of industrial equipment performance.';

  @override
  String get contactezNous => 'Contact Us';

  @override
  String get adresse => 'Akbou, Bejaia, Algeria';

  @override
  String get createdBy =>
      'Created by: Lyes Rabhi (lyes.rabhi.020@gmail.com) & Kheloufi Mounir (mounirkheloufi2002@gmail.com)';

  @override
  String failedToConnectToCO2Broadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries retries remaining',
      one: '1 retry',
      zero: 'no retries',
    );
    return 'Failed to connect to CO2 broadcast, $_temp0';
  }

  @override
  String get co2Title => 'CO2';

  @override
  String get consommation => 'Consumption';

  @override
  String get failedToGetConsommationData => 'Failed to get consumption data';

  @override
  String get entree => 'Input';

  @override
  String get cannotBeASuperiorToYourself =>
      'You cannot be a superior to yourself';

  @override
  String get cannotBeASuperiorForHimself =>
      'You cannot be a superior for yourself';

  @override
  String get close => 'Close';

  @override
  String get serverStatus => 'Server Status';

  @override
  String get databases => 'Databases';

  @override
  String get state => 'State';

  @override
  String get percentage => 'Percentage';

  @override
  String get failedToLoadServerStatus => 'Failed to load server status';

  @override
  String get restartServer => 'Restart server';

  @override
  String get info => 'Info';

  @override
  String get host_name => 'Host name';

  @override
  String get lastUpdateTime => 'Last update time';

  @override
  String get lastUpdateDate => 'Last update date';

  @override
  String get osUptime => 'OS uptime';

  @override
  String get osBootTime => 'OS boot time';

  @override
  String get osTime => 'OS time';

  @override
  String get version => 'Version';

  @override
  String get environment => 'Environment';

  @override
  String get debug => 'Debug';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get totalMemory => 'Total memory';

  @override
  String get usedMemory => 'Used memory';

  @override
  String get availableMemory => 'Available memory';

  @override
  String get memoryUsage => 'Memory usage';

  @override
  String get memory => 'Memory';

  @override
  String get network => 'Network';

  @override
  String get received => 'Received';

  @override
  String get os => 'OS';

  @override
  String get cpuUsage => 'CPU usage';

  @override
  String get totalStorage => 'Total storage';

  @override
  String get usedStorage => 'Used storage';

  @override
  String get availableStorage => 'Available storage';

  @override
  String get storageUsage => 'Storage usage';

  @override
  String get loadingUsers => 'Loading users...';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingUserDetails => 'Loading user details...';

  @override
  String get loadingUser => 'Loading user...';

  @override
  String get loadingSents => 'Loading sent emails...';

  @override
  String get loadingAlerts => 'Loading alerts...';

  @override
  String get loadingSchedules => 'Loading schedules...';

  @override
  String get loadingTags => 'Loading tags...';

  @override
  String get loadingRoles => 'Loading roles...';

  @override
  String get loadingSuperiors => 'Loading superiors...';

  @override
  String get waitingForConnection => 'Waiting for connection...';

  @override
  String get waitingForValidData => 'Waiting for valid data...';

  @override
  String get reconnecting => 'Reconnecting...';

  @override
  String get notLoading => 'Not loading';

  @override
  String get waiting => 'Waiting...';

  @override
  String get loadingServerConfig => 'Loading server settings';

  @override
  String get serverSettings => 'Server Settings';

  @override
  String get failedToLoadServerConfig => 'Failed to load server settings';

  @override
  String get changeSecretKey => 'Change secret key';

  @override
  String get logToFiles => 'Log to files';

  @override
  String get dbConnectionCheckTimeout =>
      'Database connection check timeout (in seconds)';

  @override
  String get seconds => 'Seconds';

  @override
  String get allowedHosts => 'Allowed hosts';

  @override
  String get addAllowedHost => 'Add allowed host';

  @override
  String get trustedOrigins => 'Trusted origins';

  @override
  String get addTrustedOrigin => 'Add trusted origin';

  @override
  String get emailProviders => 'Email providers';

  @override
  String get engine => 'Engine';

  @override
  String get port => 'Port';

  @override
  String get host => 'Host';

  @override
  String get emailOfSender => 'Email of sender';

  @override
  String get useTls => 'Use TLS';

  @override
  String get systemMonitorDBTimeout =>
      'System monitor database timeout (in seconds)';

  @override
  String get newSecretKey => 'New secret key';

  @override
  String get newEmailProvider => 'New email provider';

  @override
  String get newDatabase => 'New database';

  @override
  String get dbIdentifier => 'Database identifier';

  @override
  String get configSaved => 'Configuration saved';

  @override
  String get failedToSaveConfig => 'Failed to save configuration';

  @override
  String get savingConfig => 'Saving configuration...';

  @override
  String get saveConfig => 'Save configuration';

  @override
  String get saveConfigAlertMessage =>
      'Are you sure you want to save the configuration? This will overwrite the current configuration. The new configuration will be irreversibly saved but it will not take effect until the server is restarted.';

  @override
  String failedToSendEmailWithId(int id) {
    return 'Failed to send email with ID: $id';
  }

  @override
  String failedToConnectToStatusBroadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries retries remaining',
      one: '1 retry',
      zero: 'no retries',
    );
    return 'Failed to connect to status broadcast, $_temp0';
  }

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get userWithThisEmailAlreadyExists =>
      'A user with this email already exists';

  @override
  String get list => 'List';

  @override
  String get graph => 'Graph';

  @override
  String get errorConnectingBroadcast =>
      'Error connecting to broadcast, live data will not work';

  @override
  String get date => 'Date';

  @override
  String get sucre => 'Sugar';

  @override
  String get utilite => 'Utilities';

  @override
  String get co2 => 'CO2';

  @override
  String get niveau => 'Level';

  @override
  String get volume => 'Volume';

  @override
  String get debit => 'Flow rate';

  @override
  String get presCond => 'Pres Cond';

  @override
  String get failedToGetNiveauData => 'Failed to get level data';

  @override
  String get failedToGetVolumeData => 'Failed to get volume data';

  @override
  String get failedToGetDebitData => 'Failed to get flow rate data';

  @override
  String get failedToGetPresCondData =>
      'Failed to get pressure and conductivity data';

  @override
  String get value => 'Value';

  @override
  String get visualize => 'Visualize';

  @override
  String get week => 'Week';

  @override
  String get precision => 'Precision';

  @override
  String get type => 'Type';

  @override
  String get consommationDescription =>
      'Show the consumption in a range of dates';

  @override
  String get previousDay => 'Previous day';

  @override
  String get sinceFirstOfMonth => 'Since first of month';

  @override
  String get reports => 'Reports';

  @override
  String get sucreReports => 'Sugar reports';

  @override
  String get co2Reports => 'CO2 reports';

  @override
  String get utiliteReports => 'Utilities reports';

  @override
  String get filtrationReports => 'Filtration reports';

  @override
  String get generateReport => 'Generate report';

  @override
  String get generateReportDescription =>
      'Generate a report for a specific date';

  @override
  String viewReport(String rapport) {
    return 'Report: $rapport';
  }

  @override
  String viewReportDescription(String date) {
    return 'View the report of $date';
  }

  @override
  String get loadingReports => 'Loading reports...';

  @override
  String get failedToLoadReports => 'Failed to load reports';

  @override
  String get sortReports => 'Sort reports';

  @override
  String get filterReports => 'Filter reports';

  @override
  String get hasSynthese => 'Has synthesis';

  @override
  String getIntervalName(String interval) {
    String _temp0 = intl.Intl.selectLogic(
      interval,
      {
        'jour': 'Day',
        'semaine': 'Week',
        'mois': 'Month',
        'manual': 'Manual',
        'other': 'Interval',
      },
    );
    return '$_temp0';
  }

  @override
  String get withSynthese => 'With synthesis';

  @override
  String get withoutSynthese => 'Without synthesis';

  @override
  String get failedToGenerateReport => 'Failed to generate report';

  @override
  String get generate => 'Generate';

  @override
  String get todaysReports => 'Today\'s reports';

  @override
  String get errorLoadingReports => 'Error loading reports';

  @override
  String get synthese => 'Synthesis';

  @override
  String get downloadCertificate => 'Download certificate';

  @override
  String get downloadingCertificateMessage => 'Downloading certificate...';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String fileDownloadedTo(String path) {
    return 'File downloaded to: $path';
  }

  @override
  String get downloadedWithBrowser => 'Downloaded with browser';

  @override
  String get downloadedFilePathCopiedToClipboard =>
      'Downloaded file path copied to clipboard';

  @override
  String get profile => 'Profile';

  @override
  String get noSuperior => 'No superior';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get pression => 'Pressure';

  @override
  String get conductivity => 'Conductivity';

  @override
  String get temperature => 'Temperature';

  @override
  String minLength(int length) {
    return 'Minimum length: $length';
  }

  @override
  String maxLength(int length) {
    return 'Maximum length: $length';
  }

  @override
  String hasLowercaseChars(int count) {
    return 'Must contain at least $count lowercase character';
  }

  @override
  String hasUppercaseChars(int count) {
    return 'Must contain at least $count uppercase character';
  }

  @override
  String hasNumericChars(int count) {
    return 'Must contain at least $count number';
  }

  @override
  String hasSpecialChars(int count) {
    return 'Must contain at least $count special character';
  }

  @override
  String get invalidFirstName => 'Invalid first name';

  @override
  String get invalidLastName => 'Invalid last name';

  @override
  String invalidField(String field) {
    return 'Invalid $field';
  }

  @override
  String get admin => 'Admin Panel';

  @override
  String get errorOpeningAdminPanel => 'Failed to open admin panel';

  @override
  String get logSizeLimit => 'Log file size limit';

  @override
  String get numberOfLogsToKeep => 'Number of logs to keep';

  @override
  String get logs => 'Logs';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get dataStoppedWaitSeconds => 'Alert After N seconds of no data';

  @override
  String min(int min) {
    return 'Minimum $min';
  }

  @override
  String get collapse => 'Collapse';

  @override
  String get expand => 'Expand';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get lightMode => 'Light mode';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get holdToResetToSystemTheme => 'Hold to reset to system theme';

  @override
  String get monitoredValueDescription =>
      'The field that will be monitored for changes';

  @override
  String get monitorTypeDescription =>
      'Are the values of the monitored field ascending or descending?';

  @override
  String get dangerAlertIntervalDescription =>
      'The number of days before re-sending the alert of type danger if it is not resolved';

  @override
  String get warningAlertIntervalDescription =>
      'The number of days before re-sending the alert of type warning if it is not resolved';

  @override
  String get nothingToDisplay => 'Nothing to display';
}
