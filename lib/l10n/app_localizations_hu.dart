// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get loading => 'Betöltés';

  @override
  String get homepage => 'Kezdőoldal';

  @override
  String get settingspage => 'Beállítások';

  @override
  String get language => 'Nyelv';

  @override
  String get theme => 'Téma';

  @override
  String get darktheme => 'Sötét mód';

  @override
  String get nolibraryselected => 'Nincs könyvtár kiválasztva';

  @override
  String get librarypath => 'Könyvtár útvonal';

  @override
  String get chosepath => 'Válasszd ki a Calibre könyvtárat!';

  @override
  String get newlibrary => 'Üres mappa esetén új könyvtár jön létre.';

  @override
  String get attention =>
      'Az ingyenes verzióban nincs lehetőség könyvek hozzáadásra és szerkesztésére.';

  @override
  String get emptylibrary => 'Üres lista';

  @override
  String get nobookselected => 'Nincs könyv kiválasztva';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Mégse';

  @override
  String get list => 'Lista nézet';

  @override
  String get tiles => 'Rács nézet';

  @override
  String get datagrid => 'Részletes lista';

  @override
  String get error => 'Hiba történt. Kérlek válassz másik mappát!';

  @override
  String get addbook => 'Könyv hozzáadása';

  @override
  String get editbook => 'Könyv szerkesztése';

  @override
  String get deletebook => 'Könyv törlése';

  @override
  String get title => 'Cím';

  @override
  String get author => 'Szerző';

  @override
  String get date => 'Dátum';

  @override
  String get create => 'Hozzáad';

  @override
  String get confirmation => 'Biztos vagy benne?';

  @override
  String get titlerequired => 'A cím megadása kötelező!';

  @override
  String get authorrequired => 'A szerző megadása kötelező!';

  @override
  String get commentrequired => 'A tartalom megadása kötelező!';

  @override
  String get wanttodelete => 'Biztosan törlöd?';

  @override
  String get back => 'Vissza';

  @override
  String get open => 'Megnyit';

  @override
  String get openbook => 'Könyv megnyitás';

  @override
  String get comment => 'Tartalom';

  @override
  String get pickfolder => 'Mappa választó';

  @override
  String get close => 'Bezárás';

  @override
  String get search => 'Keresés';

  @override
  String get addialog =>
      'Nincs hozzáadás funkció az ingyenes verzióban. Használd a Calibre-t a könyvek kezeléséhez.';
}
