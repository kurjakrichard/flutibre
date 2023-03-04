// ignore_for_file: unused_field
import 'dart:async';
import 'dart:io' as io;
import 'dart:io';
// ignore: unnecessary_import
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final Map<String, String> _localeList = {'en': 'English', 'hu': 'magyar'};

  final Map<String, String> _reverseLocaleList = {
    'English': 'en',
    'magyar': 'hu'
  };
  //true path is exist in SharedPreferences
  bool? _isPath;
  //Saved path from SharedPreferences
  String? _path;
  //Database path before ok
  String? _tempPath;
  bool _newFolder = false;
  bool _isLoading = false;
  bool _userAborted = false;
  @override
  void initState() {
    super.initState();
    applyPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingspage)),
      body: ListView(
        children: [
          Wrap(alignment: WrapAlignment.center, children: [
            themeSwitcher(context),
            languageSelector(context),
            manageLibrary(context)
          ]),
        ],
      ),
    );
  }

  Widget themeSwitcher(BuildContext context) {
    return Column(children: [
      Card(
        child: ListTile(
          title: Text(AppLocalizations.of(context)!.theme),
        ),
      ),
      Consumer(
        builder: (context, ref, child) => SwitchListTile(
          title: Text(AppLocalizations.of(context)!.darktheme),
          value: ref.watch(themeProvider).darkTheme,
          onChanged: (newValue) {
            ref.read(themeProvider).toggleTheme();
          },
        ),
      )
    ]);
  }

  Widget languageSelector(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text(AppLocalizations.of(context)!.language),
          ),
        ),
        dropDownButton(),
      ],
    );
  }

  Widget manageLibrary(BuildContext context) {
    return Column(
      children: [
        Card(
          child: ListTile(
            title: Text(AppLocalizations.of(context)!.librarypath),
          ),
        ),
        ListTile(
          title: Wrap(
            children: [
              Text(
                _path ?? AppLocalizations.of(context)!.nolibraryselected,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 600.0),
                child: ElevatedButton(
                  onPressed: () => _selectFolder(),
                  child: Text(AppLocalizations.of(context)!.pickfolder),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Wrap(alignment: WrapAlignment.center, children: [
          Text(AppLocalizations.of(context)!.chosepath),
        ]),
        const Divider(),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 600.0),
                child: ElevatedButton(
                  onPressed: () => _createLibrary(),
                  child: Text(AppLocalizations.of(context)!.newlibrary),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Wrap(alignment: WrapAlignment.center, children: [
          Text(AppLocalizations.of(context)!.createlibrary),
        ]),
        const SizedBox(
          height: 12,
        ),
        Row(children: [
          Expanded(
            child: Consumer(
              builder: (BuildContext context, ref, Widget? child) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text(AppLocalizations.of(context)!.ok),
                    onPressed: () async {
                      if (_tempPath != null) {
                        await prefs.setString('path', _tempPath!);
                        if (_tempPath != null && _newFolder) {
                          await copyDatabase(_tempPath!, 'metadata.db');
                          await copyDatabase(
                              _tempPath!, 'metadata_db_prefs_backup.json');
                          _newFolder = false;
                        }

                        await ref
                            .read(bookListProvider)
                            .databaseHandler!
                            .initialDatabase();

                        await ref.read(bookListProvider).getBookItemList();
                        // ignore: unused_result
                        ref.refresh(booklistProvider);
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, '/homepage');
                      } else {
                        String? checkPath = _path;
                        if (checkPath != null) {
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
          button(AppLocalizations.of(context)!.cancel, context, () => cancel),
        ]),
      ],
    );
  }

  Widget dropDownButton() {
    return Consumer(
      builder: (context, ref, child) => DropdownButton<String>(
          icon: const Icon(Icons.arrow_downward),
          isExpanded: true,
          underline: Container(),
          value:
              _localeList[ref.watch(localeProvider).currentLocale.languageCode],
          items: _localeList.values.map((String value) {
            return DropdownMenuItem(
                value: value, child: Center(child: Text(value)));
          }).toList(),
          onChanged: (newValueSelected) {
            ref
                .read(localeProvider)
                .setLocale(Locale(_reverseLocaleList[newValueSelected]!));
          }),
    );
  }

  //Handle all elevated button
  Widget button(String title, BuildContext context, Function action) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () {
              action(context);
            },
            child: Text(title),
          );
        }),
      ),
    );
  }

  //pop the Settingspage
  VoidCallback cancel(BuildContext context) {
    Navigator.pop(context);
    throw '';
  }

  void applyPath() async {
    if (prefs.containsKey('path')) {
      String? path = await _loadPath(prefs.getString('path')!);
      if (path != null) {
        setState(() {
          _path = path;
        });
      } else {
        _path = null;
      }
    }
  }

  //load library path at start
  Future<String?> _loadPath(String path) async {
    if (Platform.isLinux || Platform.isWindows) {
      //check path in SharedPreferences
      if (path != '') {
        try {
          await io.File('$path/metadata.db').length();
          return path;
        } on Exception {
          return null;
        }
      } else {
        return path;
      }
    } else if (Platform.isAndroid) {
      //TODO
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      _tempPath = await getDatabasesPath();
      return null;
      //Check metadata.db exists
    }
    return null;
  }

  void _selectFolder() async {
    _resetState();

    try {
      String? tempPath = await FilePicker.platform.getDirectoryPath();
      if (tempPath != null) {
        _tempPath = await _loadPath(tempPath);
        _path = _tempPath;
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation$e');
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _createLibrary() {}

  void _logException(String message) {
    // ignore: avoid_print
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _userAborted = false;
    });
  }

  Future<void> copyDatabase(String databasePath, String filename) async {
    var bytes = await rootBundle.load('assets/books/$filename');
    String dir = databasePath;
    writeToFile(bytes, '$dir/$filename');
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    File(path).create(recursive: true).then((File file) {
      return File(path).writeAsBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    });
  }
}
