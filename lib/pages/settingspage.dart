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
import 'package:permission_handler/permission_handler.dart';
import '../main.dart';
import '../providers/booklist_provider.dart';

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
  //Saved path from SharedPreferences
  String? _path;
  //Database path before ok
  String? _tempPath;
  //true if new library created
  bool _newFolder = false;
  bool _isLoading = false;
  bool _userAborted = false;
  @override
  void initState() {
    super.initState();
    setPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingspage)),
      body: ListView(
        children: [
          Wrap(alignment: WrapAlignment.center, children: [
            if (true) themeSwitcher(),
            languageSelector(),
            manageLibrary()
          ]),
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
          value: ref.watch(themeProvider),
          onChanged: (_) {
            ref.read(themeProvider.notifier).toggleTheme();
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
                _tempPath ?? AppLocalizations.of(context)!.nolibraryselected,
              ),
            ],
          ),
        ),
        Row(
          children: [
            button(AppLocalizations.of(context)!.pickfolder, _selectFolder)
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Wrap(alignment: WrapAlignment.center, children: [
          Text(AppLocalizations.of(context)!.chosepath),
          const Text(' '),
          Text(AppLocalizations.of(context)!.newlibrary),
          const Text(' '),
          Text(AppLocalizations.of(context)!.attention),
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
                      await applyChanges(ref);
                    },
                  ),
                );
              },
            ),
          ),
          button(AppLocalizations.of(context)!.cancel, cancel),
        ]),
      ],
    );
  }

  Widget dropDownButton() {
    return Consumer(
      builder: (context, ref, child) => Material(
        child: DropdownButton<String>(
            icon: const Icon(Icons.arrow_downward),
            isExpanded: true,
            underline: Container(),
            value: _localeList[ref.watch(localeProvider)],
            items: _localeList.values.map((String value) {
              return DropdownMenuItem(
                  value: value, child: Center(child: Text(value)));
            }).toList(),
            onChanged: (newValueSelected) {
              ref
                  .read(localeProvider.notifier)
                  .setLocale(_reverseLocaleList[newValueSelected]!);
            }),
      ),
    );
  }

  //Handle all elevated button
  Widget button(String title, Function action) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            action();
          },
          child: Text(title),
        ),
      ),
    );
  }

  Future<void> applyChanges(WidgetRef ref) async {
    if (_tempPath != null && _tempPath != _path) {
      await prefs.setString('path', _tempPath!);
      if (_tempPath != null && _newFolder) {
        await copyDatabase(_tempPath!, 'metadata.db');
        await copyDatabase(_tempPath!, 'metadata_db_prefs_backup.json');
        await copyDatabase(
            _tempPath!, 'Richard Kurjak/Flutibre user manual (1)/cover.jpg');
        await copyDatabase(_tempPath!,
            'Richard Kurjak/Flutibre user manual (1)/Flutibre user manual - Richard Kurjak.pdf');
        await copyDatabase(
            _tempPath!, 'Richard Kurjak/Flutibre user manual (1)/metadata.opf');

        _newFolder = false;
      }
      ref.read(bookListProvider.notifier);

      // ignore: unused_result
      ref.invalidate(bookListProvider);

      if (mounted) {
        Navigator.pushNamed(context, '/homepage');
      }
    } else {
      cancel();
    }
  }

  //pop the Settingspage if path exists
  void cancel() {
    if (_path != null) {
      Navigator.pop(context);
    }
  }

  //Handle file picker dialog and set _tempPath and _newFolder variable
  void _selectFolder() async {
    _resetState();

    if (Platform.isAndroid) {
      await Permission.manageExternalStorage.request();
      var status = await Permission.manageExternalStorage.status;
      if (status.isDenied) {
        // We didn't ask for permission yet or the permission has been denied   before but not permanently.
        return;
      }
      // You can can also directly ask the permission about its status.
      if (await Permission.storage.isRestricted) {
        // The OS restricts access, for example because of parental controls.
        return;
      }

      if (status.isGranted) {
        try {
          String? tempPath =
              await _loadPath(await FilePicker.platform.getDirectoryPath());

          setState(() {
            _tempPath = tempPath;
            _userAborted = _tempPath == null;
          });
        } on PlatformException catch (e) {
          _logException('Unsupported operation$e');
        } catch (e) {
          _logException(e.toString());
        } finally {
          setState(() => _isLoading = false);
        }
      }
    } else {
      try {
        String? tempPath = await _loadPath(
          await FilePicker.platform.getDirectoryPath(),
        );
        setState(() {
          _tempPath = tempPath;
          _userAborted = _tempPath == null;
        });
      } on PlatformException catch (e) {
        _logException('Unsupported operation$e');
      } catch (e) {
        _logException(e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  //Return library path if the path correct else null
  Future<String?> _loadPath(String? path) async {
    try {
      await io.File('$path/metadata.db').length();
      _newFolder = false;
      return path;
    } on Exception {
      if (await Directory(path!).list().isEmpty) {
        _newFolder = true;
        return path;
      }
      return null;
    }
  }

  //Set path at start
  void setPath() async {
    if (prefs.containsKey('path')) {
      String? path = await _loadPath(prefs.getString('path')!);
      if (path != null) {
        setState(() {
          _path = path;
          _tempPath = _path;
        });
      }
    }
  }

  Future<void> copyDatabase(String databasePath, String filename) async {
    var bytes = await rootBundle.load('assets/books/$filename');
    writeToFile(bytes, '$databasePath/$filename');
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    File(path).create(recursive: true).then((File file) {
      return File(path).writeAsBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    });
  }

  void _logException(String message) {
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
}
