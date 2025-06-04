// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get homePageWelcomeMessage => 'Bienvenue dans l\'application';

  @override
  String get login => 'Connecter';

  @override
  String get loginToContinue => 'Connectez-vous pour continuer';

  @override
  String get email => 'Email';

  @override
  String get emailExemple => 'compte@exemple.com';

  @override
  String get password => 'Mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get invalidEmail => 'Email invalide';

  @override
  String get invalidPassword => 'Mot de passe invalide';

  @override
  String get requiredEmail => 'L\'email est requis';

  @override
  String get requiredPassword => 'Le mot de passe est requis';

  @override
  String get enterYourEmail => 'Entrez votre email';

  @override
  String get enterYourPassword => 'Entrez votre mot de passe';

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get loginSuccess => 'Connexion réussie';

  @override
  String get logout => 'Déconnecter';

  @override
  String get logoutSuccess => 'Déconnexion réussie';

  @override
  String get logoutFailed => 'Échec de la déconnexion';

  @override
  String get pleaseFillInAllFields => 'Veuillez remplir tous les champs';

  @override
  String get loggingIn => 'Connexion en cours...';

  @override
  String get loginSuccessful => 'Connexion réussie';

  @override
  String get logoutSuccessMessage => 'Vous vous êtes déconnecté avec succès';

  @override
  String get logoutFailedMessage =>
      'Une erreur s\'est produite lors de la déconnexion';

  @override
  String get loginFailedMessage =>
      'Une erreur s\'est produite lors de la connexion';

  @override
  String get loginSuccessMessage => 'Vous vous êtes connecté avec succès';

  @override
  String get connectionFailedError =>
      'Une erreur de connexion s\'est produite, veuillez vérifier votre connexion Internet et réessayer';

  @override
  String get serverError =>
      'Une erreur de serveur s\'est produite, veuillez réessayer plus tard';

  @override
  String get noInternetConnection => 'Pas de connexion Internet';

  @override
  String get noInternetConnectionMessage =>
      'Veuillez vérifier votre connexion Internet et réessayer';

  @override
  String get timeOutError =>
      'La requête a expiré, veuillez réessayer plus tard';

  @override
  String get cancelMessage => 'Requête annulée';

  @override
  String get unknownError =>
      'Une erreur inconnue s\'est produite, veuillez réessayer plus tard';

  @override
  String get connectionFailed => 'Connexion échouée';

  @override
  String get accessDenied => 'Accès refusé';

  @override
  String get loginRequired => 'Vous devez être connecté';

  @override
  String get logoutRequired => 'Vous devez être déconnecté';

  @override
  String get search => 'Rechercher...';

  @override
  String get userManagement => 'Gestion des utilisateurs';

  @override
  String get addUser => 'Ajouter un utilisateur';

  @override
  String get addOneUser => 'Ajouter un utilisateur';

  @override
  String get delete => 'Supprimer';

  @override
  String get filters => 'Filtres';

  @override
  String get filterUser => 'Filtrer les utilisateurs';

  @override
  String get filterByRole => 'Filtrer par rôle';

  @override
  String get role => 'Rôle';

  @override
  String get filter => 'Filtrer';

  @override
  String get sort => 'Trier';

  @override
  String get sortUser => 'Trier les utilisateurs';

  @override
  String get sortBy => 'Trier par';

  @override
  String get id => 'ID';

  @override
  String get name => 'Nom';

  @override
  String get perPage => 'Par page';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get num => 'Num';

  @override
  String get avatar => 'Avatar';

  @override
  String get actions => 'Actions';

  @override
  String get page => 'Page';

  @override
  String get prevPage => 'Précédent';

  @override
  String get nextPage => 'Suivant';

  @override
  String get users => 'Utilisateurs';

  @override
  String get deleteUser => 'Supprimer des utilisateurs';

  @override
  String get selectUserDelete => 'Sélectionner les utilisateurs à supprimer';

  @override
  String get cancel => 'Annuler';

  @override
  String get repFav => 'Oui';

  @override
  String get repDeFav => 'Non';

  @override
  String get pleaseFixErrorsInTheForm =>
      'Veuillez corriger les erreurs dans le formulaire';

  @override
  String get addUserMessage => 'Ajout d\'un utilisateur...';

  @override
  String get failedToGetUsersMessage =>
      'Échec de la récupération des utilisateurs';

  @override
  String get errorFailedToGetUsers =>
      'Erreur : Échec de la récupération des utilisateurs';

  @override
  String get failedToAddUserMessage => 'Échec de l\'ajout de l\'utilisateur';

  @override
  String get successAddUserMessage => 'Utilisateur ajouté avec succès';

  @override
  String get openingFilePicker => 'Ouverture du sélecteur de fichiers...';

  @override
  String get canceled => 'Annulé';

  @override
  String get fileSelected => 'Fichier sélectionné';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get superior => 'Supérieur';

  @override
  String get selectSuperior => 'Sélectionner un supérieur';

  @override
  String delete_users(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les utilisateurs',
      one: 'l\'utilisateur',
    );
    return 'Êtes-vous sûr de vouloir supprimer $_temp0 ?';
  }

  @override
  String get ibdm => 'IBDM';

  @override
  String get ifri_bdd => 'Base de données des machines Ifri';

  @override
  String get options => 'Options';

  @override
  String get me => 'Moi';

  @override
  String get siroperieTitle => 'Siroperie';

  @override
  String get january => 'Janvier';

  @override
  String get february => 'Février';

  @override
  String get march => 'Mars';

  @override
  String get april => 'Avril';

  @override
  String get may => 'Mai';

  @override
  String get june => 'Juin';

  @override
  String get july => 'Juillet';

  @override
  String get august => 'Août';

  @override
  String get september => 'Septembre';

  @override
  String get october => 'Octobre';

  @override
  String get november => 'Novembre';

  @override
  String get december => 'Décembre';

  @override
  String year(int year) {
    return 'Année : $year';
  }

  @override
  String month(String month) {
    return 'Mois : $month';
  }

  @override
  String day(String day) {
    return 'Jour : $day';
  }

  @override
  String get hour => 'Heure';

  @override
  String get minute => 'Minute';

  @override
  String get second => 'Seconde';

  @override
  String get pick => 'Choisir';

  @override
  String get totalSucre => 'Sucre total :';

  @override
  String get totalSucreTetra => 'Sucre Tetra total :';

  @override
  String get totalSucreAdue => 'Sucre Adue total :';

  @override
  String get sucreTetraTitle => 'Sucre Tetra';

  @override
  String get sucreAdueTitle => 'Sucre Adue';

  @override
  String get showLiveData => 'Afficher les données en temps réel';

  @override
  String get showingLiveData => 'Affichage des données en temps réel';

  @override
  String get inventory => 'Inventaire';

  @override
  String get inventoryDescription =>
      'Afficher l\'inventaire d\'un jour spécifique';

  @override
  String get cuve => 'Cuve';

  @override
  String get failedToGetInventory =>
      'Échec de la récupération de l\'inventaire';

  @override
  String get toOrder => 'À commander';

  @override
  String tank(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Citernes',
      one: 'Citerne',
    );
    return '$_temp0';
  }

  @override
  String get filtrationTitle => 'Filtration';

  @override
  String get eauBrute => 'Eau brute';

  @override
  String get eauFiltrer => 'Eau filtrée';

  @override
  String get eauOsmose => 'Eau osmosée';

  @override
  String get settings => 'Paramètres';

  @override
  String get lightmode => 'Mode clair';

  @override
  String get darkmode => 'Mode sombre';

  @override
  String get language => 'Langue';

  @override
  String get helpAssistance => 'Aide et assistance';

  @override
  String get about => 'À propos';

  @override
  String get emailSchedules => 'Email Cycliques';

  @override
  String get emailSents => 'Emails envoyés';

  @override
  String get emailSchedulesDescription =>
      'Emails envoyés à intervalles définis';

  @override
  String get emailSentsDescription => 'Emails envoyés aux utilisateurs';

  @override
  String get emailAlerts => 'Alertes par email';

  @override
  String get emailAlertsDescription =>
      'Emails envoyés lorsque les valeurs surveillées atteignent certains seuils';

  @override
  String get monitored => 'Surveillé';

  @override
  String get danger => 'Danger';

  @override
  String get warning => 'Avertissement';

  @override
  String get active => 'Actif';

  @override
  String get inactive => 'Inactif';

  @override
  String get addAlertEmail => 'Ajouter une alerte par email';

  @override
  String get addScheduleEmail => 'Ajouter un email cyclique';

  @override
  String get edit => 'Modifier';

  @override
  String get save => 'Enregistrer';

  @override
  String get rapport => 'Rapport';

  @override
  String get interval => 'Intervalle';

  @override
  String get tempsEnvoi => 'Heure d\'envoi';

  @override
  String get nextRunTime => 'Prochain envoi';

  @override
  String get days => 'Jours';

  @override
  String get deletingSchedules => 'Suppression des emails cycliques...';

  @override
  String get deletingAlerts => 'Suppression des alertes...';

  @override
  String get schedulesDeleted => 'Emails cycliques supprimées';

  @override
  String get alertsDeleted => 'Alertes supprimées';

  @override
  String get failedToDeleteSchedules =>
      'Échec de la suppression des emails cycliques';

  @override
  String get failedToDeleteAlerts => 'Échec de la suppression des alertes';

  @override
  String failedToDeleteScheduleWithId(int id) {
    return 'Échec de la suppression de l\'email cyclique avec l\'ID : $id';
  }

  @override
  String failedToDeleteAlertWithId(int id) {
    return 'Échec de la suppression de l\'alerte avec l\'ID : $id';
  }

  @override
  String get sortSchedules => 'Trier les emails cycliques';

  @override
  String get sortAlerts => 'Trier les alertes';

  @override
  String get filterSchedules => 'Filtrer les emails cycliques';

  @override
  String get filterAlerts => 'Filtrer les alertes';

  @override
  String get editSchedule => 'Modifier l\'email cyclique';

  @override
  String get editAlert => 'Modifier l\'alerte';

  @override
  String get editScheduleSettings =>
      'Modifier les paramètres d\'email cyclique';

  @override
  String get editAlertSettings => 'Modifier les paramètres d\'alerte';

  @override
  String get viewSchedule => 'Consulter l\'email cyclique';

  @override
  String get viewAlert => 'Consulter l\'alerte';

  @override
  String get view => 'Consulter';

  @override
  String get viewScheduleSettings => 'Voir les paramètres d\'email cyclique';

  @override
  String get viewAlertSettings => 'Voir les paramètres d\'alerte';

  @override
  String get addSchedule => 'Ajouter un email cyclique';

  @override
  String get addAlert => 'Ajouter une alerte';

  @override
  String get addScheduleSettings => 'Ajouter un email cyclique';

  @override
  String get addAlertSettings => 'Ajouter une alerte par email';

  @override
  String get unscheduled => 'Non programmé';

  @override
  String get deleteSchedules => 'Supprimer les emails cycliques';

  @override
  String get deleteAlerts => 'Supprimer les alertes';

  @override
  String get selectSchedulesToDelete =>
      'Sélectionner les emails cycliques à supprimer';

  @override
  String get selectAlertsToDelete => 'Sélectionner les alertes à supprimer';

  @override
  String confirmSchedulesDeletion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les emails cycliques',
      one: 'l\'email cyclique',
    );
    return 'Êtes-vous sûr de vouloir supprimer $_temp0 ?';
  }

  @override
  String get selectAReport => 'Sélectionner un rapport';

  @override
  String get selectAnInterval => 'Sélectionner un intervalle';

  @override
  String get intervalManualLabel => 'Intervalle manuel (en jours)';

  @override
  String get scheduleManually => 'Programmer le prochain envoi manuellement';

  @override
  String get roles => 'Rôles';

  @override
  String get selectRoles => 'Sélectionner des rôles';

  @override
  String get selectUsers => 'Sélectionner des utilisateurs';

  @override
  String get sendThisAlertToRoles => 'Envoyer cette alerte aux rôles';

  @override
  String get sendThisAlertToUsers => 'Envoyer cette alerte aux utilisateurs';

  @override
  String get schedules => 'Emails Cycliques';

  @override
  String get alerts => 'Alertes';

  @override
  String get addANewScheduleEmail => 'Ajouter un nouvel email cyclique';

  @override
  String get addANewAlertEmail => 'Ajouter une nouvelle alerte par email';

  @override
  String get editScheduleEmail => 'Modifier l\'email cyclique';

  @override
  String get editAlertEmail => 'Modifier l\'alerte par email';

  @override
  String get viewScheduleEmail => 'Voir l\'email cyclique';

  @override
  String get viewAlertEmail => 'Voir l\'alerte par email';

  @override
  String get add => 'Ajouter';

  @override
  String get nextRunTimeDate => 'Date du prochain envoi';

  @override
  String get nextRunTimeTime => 'Heure du prochain envoi';

  @override
  String get filterByInterval => 'Filtrer par intervalle';

  @override
  String get filterByMonitoredValueTag =>
      'Filtrer par étiquette de valeur surveillée';

  @override
  String get filterByActivationState => 'Filtrer par état d\'activation';

  @override
  String get selectActivationState => 'Sélectionner l\'état d\'activation';

  @override
  String get activationState => 'État d\'activation';

  @override
  String get tag => 'Étiquette';

  @override
  String get filterByRapport => 'Filtrer par rapport';

  @override
  String get selectInterval => 'Sélectionner un intervalle';

  @override
  String get addingSchedule => 'Ajout d\'un email cyclique...';

  @override
  String get scheduleAdded => 'Emails cyclique ajoutée';

  @override
  String get failedToAddSchedule => 'Échec de l\'ajout de l\'email cyclique';

  @override
  String get savingSchedule => 'Enregistrement de l\'email cyclique...';

  @override
  String get scheduleSaved => 'Emails cyclique enregistrée';

  @override
  String get failedToSaveSchedule =>
      'Échec de l\'enregistrement de l\'email cyclique';

  @override
  String get sents => 'Envoyés';

  @override
  String get scheduleSent => 'Email cyclique envoyée';

  @override
  String get alertSent => 'Alerte envoyée';

  @override
  String get deleteEmailSents => 'Supprimer les emails envoyés';

  @override
  String get selectEmailSentsToDelete =>
      'Sélectionner les emails envoyés à supprimer';

  @override
  String delete_sents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les emails envoyés',
      one: 'l\'email envoyé',
    );
    return 'Êtes-vous sûr de vouloir supprimer $_temp0 ?';
  }

  @override
  String get refresh => 'Rafraîchir';

  @override
  String get failedToLoadSents => 'Échec du chargement des emails envoyés';

  @override
  String get tempEnvoi => 'Heure d\'envoi';

  @override
  String get receptionist => 'Réceptionniste';

  @override
  String get schedule => 'Email cyclique';

  @override
  String get alert => 'Alerte';

  @override
  String get unknown => 'Inconnu';

  @override
  String get deletingSents => 'Suppression des emails envoyés...';

  @override
  String get sentsDeleted => 'Emails envoyés supprimés';

  @override
  String get deleteEmailSent =>
      'Échec de la suppression de(s) email(s) envoyé(s)';

  @override
  String get filterEmailsSent => 'Filtrer les emails envoyés';

  @override
  String get filterBySendingTime => 'Filtrer par heure d\'envoi';

  @override
  String get selectSendingTime => 'Sélectionner l\'heure d\'envoi';

  @override
  String get time => 'Heure';

  @override
  String get filterByTypeOfEmail => 'Filtrer par type d\'email';

  @override
  String get selectTypeOfEmail => 'Sélectionner le type d\'email';

  @override
  String get scheduleEmail => 'Email cyclique';

  @override
  String get sortSents => 'Trier les emails envoyés';

  @override
  String get order => 'Ordre';

  @override
  String get asc => 'Ascendant';

  @override
  String get desc => 'Descendant';

  @override
  String get details => 'Détails';

  @override
  String get user => 'Utilisateur';

  @override
  String get editUser => 'Modifier l\'utilisateur';

  @override
  String get viewUserDetails => 'Voir les détails de l\'utilisateur';

  @override
  String get hashedValue => 'Valeur hachée';

  @override
  String get addingUser => 'Ajout d\'un utilisateur...';

  @override
  String get failedToAddUser => 'Échec de l\'ajout de l\'utilisateur';

  @override
  String get userAddedSuccessfully => 'Utilisateur ajouté avec succès';

  @override
  String get savingUser => 'Enregistrement de l\'utilisateur...';

  @override
  String get failedToSaveUser => 'Échec de l\'enregistrement de l\'utilisateur';

  @override
  String get userSavedSuccessfully => 'Utilisateur enregistré avec succès';

  @override
  String get emails => 'Emails';

  @override
  String get description => 'Description';

  @override
  String get sent => 'Envoyé';

  @override
  String get sentAt => 'Envoyé à';

  @override
  String get newEmailSent => 'Un nouvel email a été envoyé';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get dataFound => 'Données trouvées';

  @override
  String get retrievingData => 'Récupération des données...';

  @override
  String get dataNotFound => 'Données non trouvées';

  @override
  String get failedToLoadData => 'Échec du chargement des données';

  @override
  String get utiliteTitle => 'Utilité';

  @override
  String get sendingEmail => 'Envoi de l\'email...';

  @override
  String get emailSent => 'Email envoyé';

  @override
  String get failedToSendEmail => 'Échec de l\'envoi de l\'email';

  @override
  String get find => 'Trouver';

  @override
  String get failedToLoadUsers => 'Échec du chargement des utilisateurs';

  @override
  String get monitoredValue => 'Valeur surveillée';

  @override
  String get selectAValueToMonitor => 'Sélectionner une valeur à surveiller';

  @override
  String get requiredField => 'Le champ est requis';

  @override
  String get monitorType => 'Type de surveillance';

  @override
  String get selectAMonitorType => 'Sélectionner un type de surveillance';

  @override
  String get enterAValidInteger => 'Entrez un entier valide';

  @override
  String get dangerPoint => 'Point de danger';

  @override
  String get warningPoint => 'Point d\'avertissement';

  @override
  String get dangerAlertIntervalInDays =>
      'Intervalle d\'alerte de danger (en jours)';

  @override
  String get warningAlertIntervalInDays =>
      'Intervalle d\'alerte d\'avertissement (en jours)';

  @override
  String get customMessage => 'Message personnalisé';

  @override
  String get failedToLoadPossibleValuesForMonitoring =>
      'Échec du chargement des valeurs possibles pour la surveillance';

  @override
  String get addingAlert => 'Ajout d\'une alerte...';

  @override
  String get alertAdded => 'Alerte ajoutée';

  @override
  String get failedToAddAlert => 'Échec de l\'ajout de l\'alerte';

  @override
  String get activatingAlert => 'Activation de l\'alerte...';

  @override
  String get alertActivated => 'Alerte activée';

  @override
  String get failedToActivateAlert => 'Échec de l\'activation de l\'alerte';

  @override
  String get deactivatingAlert => 'Désactivation de l\'alerte...';

  @override
  String get alertDeactivated => 'Alerte désactivée';

  @override
  String get failedToDeactivateAlert =>
      'Échec de la désactivation de l\'alerte';

  @override
  String get savingAlert => 'Enregistrement de l\'alerte...';

  @override
  String get alertSaved => 'Alerte enregistrée';

  @override
  String get failedToSaveAlert => 'Échec de l\'enregistrement de l\'alerte';

  @override
  String get activating => 'Activation';

  @override
  String get deactivating => 'Désactivation';

  @override
  String get activated => 'Activé';

  @override
  String get deactivated => 'Désactivé';

  @override
  String get autoGenerated => 'Généré automatiquement';

  @override
  String get noName => 'Pas de nom';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get firstName => 'Prénom';

  @override
  String get lastName => 'Nom de famille';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String selectedRole(String role) {
    return 'Rôle : $role';
  }

  @override
  String get selectASuperior => 'Sélectionner un supérieur';

  @override
  String selectedSuperior(String superior) {
    return 'Supérieur : $superior';
  }

  @override
  String confirmUsersDeletion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les utilisateurs',
      one: 'l\'utilisateur',
    );
    return 'Êtes-vous sûr de vouloir supprimer $_temp0 ?';
  }

  @override
  String get noUsername => 'Pas de nom d\'utilisateur';

  @override
  String get failedToGetUser => 'Échec de la récupération de l\'utilisateur';

  @override
  String get pageNotFound => 'Page non trouvée';

  @override
  String get youDontHavePermissionToAccessThisPage =>
      'Vous n\'avez pas la permission d\'accéder à cette page';

  @override
  String failedToConnectToUtiliteBroadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries tentatives restantes',
      one: '1 tentative',
      zero: 'aucune tentative',
    );
    return 'Échec de la connexion à la diffusion des Utilité, $_temp0';
  }

  @override
  String failedToConnectToFiltrationBroadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries tentatives restantes',
      one: '1 tentative',
      zero: 'aucune tentative',
    );
    return 'Échec de la connexion à la diffusion de filtration, $_temp0';
  }

  @override
  String failedToConnectToSiroperieBroadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries tentatives restantes',
      one: '1 tentative',
      zero: 'aucune tentative',
    );
    return 'Échec de la connexion à la diffusion de siroperie, $_temp0';
  }

  @override
  String get levelInL => 'Niveau en litres';

  @override
  String get levelInM3 => 'Niveau en mètres cubes';

  @override
  String get levelInKG => 'Niveau en kilogrammes';

  @override
  String get fillLevel => 'Niveau de remplissage';

  @override
  String get usine => 'Usine';

  @override
  String get error => 'Erreur';

  @override
  String get errorDownloadingCertificate =>
      'Erreur lors du téléchargement du certificat';

  @override
  String get to => 'À';

  @override
  String get send => 'Envoyer';

  @override
  String viewAlertSettingsOf(String name) {
    return 'Voir les paramètres d\'alerte de $name';
  }

  @override
  String editAlertSettingsOf(String name) {
    return 'Modifier les paramètres d\'alerte de $name';
  }

  @override
  String confirmAlertsDeletion(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les alertes',
      one: 'l\'alerte',
    );
    return 'Êtes-vous sûr de vouloir supprimer $_temp0 ?';
  }

  @override
  String get failedToLoadTags => 'Échec du chargement des étiquettes';

  @override
  String get failedToLoadAlerts => 'Échec du chargement des alertes';

  @override
  String valueIsRequired(String value) {
    return 'La valeur $value est requise';
  }

  @override
  String get aProposIBDM => 'À propos d\'IBDM';

  @override
  String get aProposIBDMDescription =>
      'IBDM est un logiciel de gestion de données industrielles conçu pour faciliter la surveillance et l\'analyse des performances des équipements industriels.';

  @override
  String get contactezNous => 'Contactez-nous';

  @override
  String get adresse => 'Akbou, Béjaïa, Algérie';

  @override
  String get createdBy =>
      'Créé par : Lyes Rabhi (lyes.rabhi.020@gmail.com) & Kheloufi Mounir (mounirkheloufi2002@gmail.com)';

  @override
  String failedToConnectToCO2Broadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries tentatives restantes',
      one: '1 tentative',
      zero: 'aucune tentative',
    );
    return 'Échec de la connexion à la diffusion de CO2, $_temp0';
  }

  @override
  String get co2Title => 'CO2';

  @override
  String get consommation => 'Consommation';

  @override
  String get failedToGetConsommationData =>
      'Échec de la récupération des données de consommation';

  @override
  String get entree => 'Entrée';

  @override
  String get cannotBeASuperiorToYourself =>
      'Vous ne pouvez pas être votre propre supérieur';

  @override
  String get cannotBeASuperiorForHimself =>
      'Vous ne pouvez pas être supérieur à vous-même';

  @override
  String get close => 'Fermer';

  @override
  String get serverStatus => 'État du serveur';

  @override
  String get databases => 'Bases de données';

  @override
  String get state => 'État';

  @override
  String get percentage => 'Pourcentage';

  @override
  String get failedToLoadServerStatus =>
      'Échec du chargement de l\'état du serveur';

  @override
  String get restartServer => 'Redémarrer le serveur';

  @override
  String get info => 'Info';

  @override
  String get host_name => 'Nom d\'hôte';

  @override
  String get lastUpdateTime => 'Heure de la dernière mise à jour';

  @override
  String get lastUpdateDate => 'Date de la dernière mise à jour';

  @override
  String get osUptime => 'Temps de fonctionnement du système d\'exploitation';

  @override
  String get osBootTime => 'Heure de démarrage du système d\'exploitation';

  @override
  String get osTime => 'Heure du système d\'exploitation';

  @override
  String get version => 'Version';

  @override
  String get environment => 'Environnement';

  @override
  String get debug => 'Débogage';

  @override
  String get on => 'Activé';

  @override
  String get off => 'Désactivé';

  @override
  String get totalMemory => 'Mémoire totale';

  @override
  String get usedMemory => 'Mémoire utilisée';

  @override
  String get availableMemory => 'Mémoire disponible';

  @override
  String get memoryUsage => 'Utilisation de la mémoire';

  @override
  String get memory => 'Mémoire';

  @override
  String get network => 'Réseau';

  @override
  String get received => 'Reçu';

  @override
  String get os => 'Système d\'exploitation';

  @override
  String get cpuUsage => 'Utilisation du processeur';

  @override
  String get totalStorage => 'Stockage total';

  @override
  String get usedStorage => 'Stockage utilisé';

  @override
  String get availableStorage => 'Stockage disponible';

  @override
  String get storageUsage => 'Utilisation du stockage';

  @override
  String get loadingUsers => 'Chargement des utilisateurs...';

  @override
  String get loading => 'Chargement...';

  @override
  String get loadingUserDetails =>
      'Chargement des détails de l\'utilisateur...';

  @override
  String get loadingUser => 'Chargement de l\'utilisateur...';

  @override
  String get loadingSents => 'Chargement des emails envoyés...';

  @override
  String get loadingAlerts => 'Chargement des alertes...';

  @override
  String get loadingSchedules => 'Chargement des emails cycliques...';

  @override
  String get loadingTags => 'Chargement des étiquettes...';

  @override
  String get loadingRoles => 'Chargement des rôles...';

  @override
  String get loadingSuperiors => 'Chargement des supérieurs...';

  @override
  String get waitingForConnection => 'En attente de connexion...';

  @override
  String get waitingForValidData => 'En attente de données valides...';

  @override
  String get reconnecting => 'Reconnexion...';

  @override
  String get notLoading => 'Non chargé';

  @override
  String get waiting => 'En attente...';

  @override
  String get loadingServerConfig => 'Chargement des paramètres du serveur';

  @override
  String get serverSettings => 'Paramètres du serveur';

  @override
  String get failedToLoadServerConfig =>
      'Échec du chargement des paramètres du serveur';

  @override
  String get changeSecretKey => 'Changer la clé secrète';

  @override
  String get logToFiles => 'Journaliser dans des fichiers';

  @override
  String get dbConnectionCheckTimeout =>
      'Délai de vérification de la connexion à les bases de données';

  @override
  String get seconds => 'Secondes';

  @override
  String get allowedHosts => 'Hôtes autorisés';

  @override
  String get addAllowedHost => 'Ajouter un hôte autorisé';

  @override
  String get trustedOrigins => 'Origines de confiance';

  @override
  String get addTrustedOrigin => 'Ajouter une origine de confiance';

  @override
  String get emailProviders => 'Fournisseurs d\'emails';

  @override
  String get engine => 'Moteur';

  @override
  String get port => 'Port';

  @override
  String get host => 'Hôte';

  @override
  String get emailOfSender => 'Email de l\'expéditeur';

  @override
  String get useTls => 'Utiliser TLS';

  @override
  String get systemMonitorDBTimeout => 'Délai de la surviellance du systéme';

  @override
  String get newSecretKey => 'Nouvelle clé secrète';

  @override
  String get newEmailProvider => 'Nouveau fournisseur d\'email';

  @override
  String get newDatabase => 'Nouvelle base de données';

  @override
  String get dbIdentifier => 'Identifiant de la base de données';

  @override
  String get configSaved => 'Configuration enregistrée';

  @override
  String get failedToSaveConfig =>
      'Échec de l\'enregistrement de la configuration';

  @override
  String get savingConfig => 'Enregistrement de la configuration...';

  @override
  String get saveConfig => 'Enregistrer la configuration';

  @override
  String get saveConfigAlertMessage =>
      'Êtes-vous sûr de vouloir enregistrer la configuration ? Cela écrasera la configuration actuelle. La nouvelle configuration sera enregistrée de manière irréversible mais ne prendra effet qu\'après le redémarrage du serveur.';

  @override
  String failedToSendEmailWithId(int id) {
    return 'Échec de l\'envoi de l\'email avec l\'ID : $id';
  }

  @override
  String failedToConnectToStatusBroadcast(int retries) {
    String _temp0 = intl.Intl.pluralLogic(
      retries,
      locale: localeName,
      other: '$retries tentatives restantes',
      one: '1 tentative',
      zero: 'aucune tentative',
    );
    return 'Échec de la connexion à la diffusion de l\'état, $_temp0';
  }

  @override
  String get invalidEmailOrPassword => 'Email ou mot de passe invalide';

  @override
  String get userWithThisEmailAlreadyExists =>
      'Un utilisateur avec cet email existe déjà';

  @override
  String get list => 'Liste';

  @override
  String get graph => 'Graphe';

  @override
  String get errorConnectingBroadcast =>
      'Erreur de connexion à la diffusion, les données en temps réel ne fonctionneront pas';

  @override
  String get date => 'Date';

  @override
  String get sucre => 'Sucre';

  @override
  String get utilite => 'Utilité';

  @override
  String get co2 => 'CO2';

  @override
  String get niveau => 'Niveau';

  @override
  String get volume => 'Volume';

  @override
  String get debit => 'Débit';

  @override
  String get presCond => 'Pres Cond';

  @override
  String get failedToGetNiveauData =>
      'Échec de la récupération des données de niveau';

  @override
  String get failedToGetVolumeData =>
      'Échec de la récupération des données de volume';

  @override
  String get failedToGetDebitData =>
      'Échec de la récupération des données de débit';

  @override
  String get failedToGetPresCondData =>
      'Échec de la récupération des données de pression et conductivité';

  @override
  String get value => 'Valeur';

  @override
  String get visualize => 'Visualiser';

  @override
  String get week => 'Semaine';

  @override
  String get precision => 'Précision';

  @override
  String get type => 'Type';

  @override
  String get consommationDescription =>
      'Afficher la consommation dans une plage de dates';

  @override
  String get previousDay => 'Jour précédent';

  @override
  String get sinceFirstOfMonth => 'Depuis le début du mois';

  @override
  String get reports => 'Rapports';

  @override
  String get sucreReports => 'Rapports du sucre';

  @override
  String get co2Reports => 'Rapports du CO2';

  @override
  String get utiliteReports => 'Rapports d\'Utilité';

  @override
  String get filtrationReports => 'Rapports du filtration';

  @override
  String get generateReport => 'Générer un rapport';

  @override
  String get generateReportDescription =>
      'Générer un rapport pour une date spécifique';

  @override
  String viewReport(String rapport) {
    return 'Rapport : $rapport';
  }

  @override
  String viewReportDescription(String date) {
    return 'Voir le rapport du $date';
  }

  @override
  String get loadingReports => 'Chargement des rapports...';

  @override
  String get failedToLoadReports => 'Échec du chargement des rapports';

  @override
  String get sortReports => 'Trier les rapports';

  @override
  String get filterReports => 'Filtrer les rapports';

  @override
  String get hasSynthese => 'A une synthèse';

  @override
  String getIntervalName(String interval) {
    String _temp0 = intl.Intl.selectLogic(
      interval,
      {
        'jour': 'Jour',
        'semaine': 'Semaine',
        'mois': 'Mois',
        'manual': 'Manuel',
        'other': 'Intervalle',
      },
    );
    return '$_temp0';
  }

  @override
  String get withSynthese => 'Avec synthèse';

  @override
  String get withoutSynthese => 'Sans synthèse';

  @override
  String get failedToGenerateReport => 'Échec de la génération du rapport';

  @override
  String get generate => 'Générer';

  @override
  String get todaysReports => 'Rapports d\'aujourd\'hui';

  @override
  String get errorLoadingReports => 'Erreur lors du chargement des rapports';

  @override
  String get synthese => 'Synthèse';

  @override
  String get downloadCertificate => 'Télécharger le certificat';

  @override
  String get downloadingCertificateMessage => 'Téléchargement du certificat...';

  @override
  String get downloadFailed => 'Échec du téléchargement';

  @override
  String fileDownloadedTo(String path) {
    return 'Fichier téléchargé à : $path';
  }

  @override
  String get downloadedWithBrowser => 'Téléchargé avec le navigateur';

  @override
  String get downloadedFilePathCopiedToClipboard =>
      'Chemin du fichier téléchargé copié dans le presse-papiers';

  @override
  String get profile => 'Profil';

  @override
  String get noSuperior => 'Aucun supérieur';

  @override
  String get welcomeBack => 'Bon retour';

  @override
  String get pression => 'Pression';

  @override
  String get conductivity => 'Conductivité';

  @override
  String get temperature => 'Température';

  @override
  String minLength(int length) {
    return 'Longueur minimale : $length';
  }

  @override
  String maxLength(int length) {
    return 'Longueur maximale : $length';
  }

  @override
  String hasLowercaseChars(int count) {
    return 'Doit contenir au moins $count caractère minuscule';
  }

  @override
  String hasUppercaseChars(int count) {
    return 'Doit contenir au moins $count caractère majuscule';
  }

  @override
  String hasNumericChars(int count) {
    return 'Doit contenir au moins $count chiffre';
  }

  @override
  String hasSpecialChars(int count) {
    return 'Doit contenir au moins $count caractère spécial';
  }

  @override
  String get invalidFirstName => 'Prénom invalide';

  @override
  String get invalidLastName => 'Nom de famille invalide';

  @override
  String invalidField(String field) {
    return '$field invalide';
  }

  @override
  String get admin => 'Panneau d\'Administration';

  @override
  String get errorOpeningAdminPanel =>
      'Échec de l\'ouverture du panneau d\'administration';

  @override
  String get logSizeLimit => 'Limite de taille des fichiers journals';

  @override
  String get numberOfLogsToKeep => 'Nombre de journaux à conserver';

  @override
  String get logs => 'Journaux';

  @override
  String get permissionDenied => 'Permission refusée';

  @override
  String get dataStoppedWaitSeconds => 'Alerter après N secondes sans données';

  @override
  String min(int min) {
    return 'Minimum: $min';
  }

  @override
  String get collapse => 'Rétrécir';

  @override
  String get expand => 'Agrandir';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get lightMode => 'Mode clair';

  @override
  String get changeLanguage => 'Changer de langue';

  @override
  String get holdToResetToSystemTheme =>
      'Appuyez longuement pour réinitialiser au thème du système';

  @override
  String get monitoredValueDescription =>
      'Le champ qui sera surveillé pour les changements';

  @override
  String get monitorTypeDescription =>
      'Les valeurs du champ surveillé sont-elles ascendantes ou descendantes ?';

  @override
  String get dangerAlertIntervalDescription =>
      'Le nombre de jours avant de renvoyer l\'alerte de type danger si elle n\'est pas résolue';

  @override
  String get warningAlertIntervalDescription =>
      'Le nombre de jours avant de renvoyer l\'alerte de type avertissement si elle n\'est pas résolue';

  @override
  String get nothingToDisplay => 'Rien à afficher';
}
