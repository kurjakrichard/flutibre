// ignore_for_file: unused_field
import 'dart:async';
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
      body: Wrap(alignment: WrapAlignment.center, children: [
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
        ),
        Card(
          child: ListTile(
            title: Text(AppLocalizations.of(context)!.language),
          ),
        ),
        dropDownButton(),
        Card(
          child: ListTile(
            title: Text(AppLocalizations.of(context)!.librarypath),
          ),
        ),
        ListTile(
          title: Wrap(
            children: [
              Text(_dbpath ?? 'Nincs könyvtár kiválasztva',
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ElevatedButton(
                  onPressed: () => _selectFolder(),
                  child: Text(AppLocalizations.of(context)!.pickfolder),
                ),
              ),
            ),
          ],
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
      ]),
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

  Future<String?> _loadPath() async {
    prefs = await SharedPreferences.getInstance();
    _tempPath = prefs.getString('path');
    _isPath = await File('$_tempPath/metadata.db').exists();
    _tempPath = null;
    String? path = _isPath! ? prefs.getString('path') : null;

    if (path != null) {
      setState(() {
        _dbpath = path;
      });
      return path;
    } else {
      return null;
    }
  }

  void _selectFolder() async {
    _resetState();
    try {
      _tempPath = await FilePicker.platform.getDirectoryPath();
      if (await File('$_tempPath/Ebooks/metadata.db').exists()) {
        _tempPath = '${_tempPath!}/Ebooks';
      }

      if (_tempPath != null && await File('$_tempPath/metadata.db').exists() ||
          await File('$_tempPath/Ebooks/metadata.db').exists()) {
        setState(() {
          _dbpath = _tempPath;
          _userAborted = _tempPath == null;
        });
      } else {
        setState(() {
          _newFolder = true;
          _tempPath = '${_tempPath!}/Ebooks';
          _dbpath = _tempPath;
          _userAborted = _tempPath == null;
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
//write to app path
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    File(path).create(recursive: true).then((File file) {
      return File(path).writeAsBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    });
  }
}
