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
import 'package:shared_preferences/shared_preferences.dart';
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
  bool? _isPath;
  String? _dbpath;
  String? _tempPath;
  bool _newFolder = false;
  bool _isLoading = false;
  bool _userAborted = false;
  @override
  void initState() {
    super.initState();
    _loadPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingspage)),
      body: ListView(
        children: [
          Wrap(
              alignment: WrapAlignment.center,
              children: [themeSwitcher(), languageSelector(), manageLibrary()]),
        ],
      ),
    );
  }

  Widget themeSwitcher() {
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

  Widget languageSelector() {
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

  Widget manageLibrary() {
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
                _dbpath ?? AppLocalizations.of(context)!.nolibraryselected,
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => _selectFolder(),
          child: Text(AppLocalizations.of(context)!.pickfolder),
        ),
        const SizedBox(
          height: 6,
        ),
        Wrap(alignment: WrapAlignment.center, children: [
          Text(AppLocalizations.of(context)!.chosepath),
        ]),
        const Divider(),
        ElevatedButton(
          onPressed: () => _createLibrary(),
          child: Text(AppLocalizations.of(context)!.newlibrary),
        ),
        const SizedBox(
          height: 6,
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
                        String? checkPath = await _loadPath();
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                ),
                onPressed: () {
                  if (_isPath != null && _isPath!) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
        ]),
      ],
    );
  }

  Future<String?> _loadPath() async {
    prefs = await SharedPreferences.getInstance();
    _tempPath = prefs.getString('path');
    _isPath = await io.File('$_tempPath/metadata.db').exists();
    int? bytes;

    try {
      bytes = await io.File('${prefs.getString('path')}/metadata.db').length();
    } on Exception {
      bytes = 0;
    }
    _isPath = bytes != 0;

    _tempPath = null;
    String? path = _isPath! ? prefs.getString('path') : null;

    if (path != null) {
      setState(() {
        _dbpath = path;
      });
      return path;
    } else {
      return _dbpath = null;
    }
  }

  void _selectFolder() async {
    _resetState();
    try {
      int bytes = 0;
      _tempPath = await FilePicker.platform.getDirectoryPath();

      var b = await Directory(_tempPath!).list().isEmpty;
      if (!b) {
        try {
          bytes = await io.File('$_tempPath/metadata.db').length();
          if (bytes == 0) {
            _tempPath = null;
          }
        } on Exception {
          bytes = 0;
          _tempPath = null;
        }
      } else {
        bytes = 1;
      }

      if (_tempPath != null && await File('$_tempPath/metadata.db').exists()) {
        setState(() {
          _dbpath = _tempPath;
          _userAborted = _tempPath == null;
        });
      } else if (bytes != 0) {
        setState(() {
          _newFolder = true;
          _dbpath = _tempPath;
          _userAborted = _tempPath == null;
          bytes = 0;
        });
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
