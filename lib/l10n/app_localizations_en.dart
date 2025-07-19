// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loading => 'Loading';

  @override
  String get homepage => 'HomePage';

  @override
  String get settingspage => 'Settings Page';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get darktheme => 'Dark Theme';

  @override
  String get nolibraryselected => 'No library selected';

  @override
  String get librarypath => 'Library path';

  @override
  String get chosepath => 'Please select Calibre library.';

  @override
  String get newlibrary => 'Pick an empty folder to create a new library.';

  @override
  String get attention => 'Free version has no add and edit funkction.';

  @override
  String get emptylibrary => 'Empty list';

  @override
  String get nobookselected => 'No book selected';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get list => 'List';

  @override
  String get tiles => 'Tiles';

  @override
  String get datagrid => 'Data grid';

  @override
  String get error => 'Error. Please select another library.';

  @override
  String get addbook => 'Add book';

  @override
  String get editbook => 'Edit book';

  @override
  String get deletebook => 'Delete book';

  @override
  String get title => 'Title';

  @override
  String get author => 'Author';

  @override
  String get date => 'Date';

  @override
  String get create => 'Create';

  @override
  String get confirmation => 'Are you sure?';

  @override
  String get titlerequired => 'Title is required!';

  @override
  String get authorrequired => 'Author is required!';

  @override
  String get commentrequired => 'Comment is required!';

  @override
  String get wanttodelete => 'Want to delete?';

  @override
  String get back => 'Back';

  @override
  String get open => 'Open';

  @override
  String get openbook => 'Open book';

  @override
  String get comment => 'Comment';

  @override
  String get pickfolder => 'Pick folder';

  @override
  String get close => 'Close';

  @override
  String get search => 'Search term';

  @override
  String get addialog =>
      'No add funkction in the free version. You need Calibre to manage your library.';
}
