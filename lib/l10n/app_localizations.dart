import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hu.dart';

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
    Locale('hu')
  ];

  /// Loading
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// HomePage
  ///
  /// In en, this message translates to:
  /// **'HomePage'**
  String get homepage;

  /// settingspage
  ///
  /// In en, this message translates to:
  /// **'Settings Page'**
  String get settingspage;

  /// Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme selector
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Dark theme
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darktheme;

  /// Calibre library selection
  ///
  /// In en, this message translates to:
  /// **'No library selected'**
  String get nolibraryselected;

  /// Ebook library path
  ///
  /// In en, this message translates to:
  /// **'Library path'**
  String get librarypath;

  /// Calibre library selection
  ///
  /// In en, this message translates to:
  /// **'Please select Calibre library.'**
  String get chosepath;

  /// New library
  ///
  /// In en, this message translates to:
  /// **'Pick an empty folder to create a new library.'**
  String get newlibrary;

  /// Free version has no add and edit funkction.
  ///
  /// In en, this message translates to:
  /// **'Free version has no add and edit funkction.'**
  String get attention;

  /// Empty list
  ///
  /// In en, this message translates to:
  /// **'Empty list'**
  String get emptylibrary;

  /// No book selected
  ///
  /// In en, this message translates to:
  /// **'No book selected'**
  String get nobookselected;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// List button
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get list;

  /// Tiles button
  ///
  /// In en, this message translates to:
  /// **'Tiles'**
  String get tiles;

  /// Data grid
  ///
  /// In en, this message translates to:
  /// **'Data grid'**
  String get datagrid;

  /// Error. Please select another library.
  ///
  /// In en, this message translates to:
  /// **'Error. Please select another library.'**
  String get error;

  /// Delete book text
  ///
  /// In en, this message translates to:
  /// **'Add book'**
  String get addbook;

  /// No description provided for @editbook.
  ///
  /// In en, this message translates to:
  /// **'Edit book'**
  String get editbook;

  /// No description provided for @deletebook.
  ///
  /// In en, this message translates to:
  /// **'Delete book'**
  String get deletebook;

  /// Title text
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Author text
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get author;

  /// Date
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// Create button
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// Are you sure?
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get confirmation;

  /// Title is required!
  ///
  /// In en, this message translates to:
  /// **'Title is required!'**
  String get titlerequired;

  /// Author is required!
  ///
  /// In en, this message translates to:
  /// **'Author is required!'**
  String get authorrequired;

  /// Comment is required!
  ///
  /// In en, this message translates to:
  /// **'Comment is required!'**
  String get commentrequired;

  /// Want to delete?
  ///
  /// In en, this message translates to:
  /// **'Want to delete?'**
  String get wanttodelete;

  /// Back button
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// Comment
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @openbook.
  ///
  /// In en, this message translates to:
  /// **'Open book'**
  String get openbook;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// Pick folder
  ///
  /// In en, this message translates to:
  /// **'Pick folder'**
  String get pickfolder;

  /// Close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Search term
  ///
  /// In en, this message translates to:
  /// **'Search term'**
  String get search;

  /// No description provided for @addialog.
  ///
  /// In en, this message translates to:
  /// **'No add funkction in the free version. You need Calibre to manage your library.'**
  String get addialog;
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
      <String>['en', 'hu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hu':
      return AppLocalizationsHu();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
