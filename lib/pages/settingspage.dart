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
import 'package:permission_handler/permission_handler.dart';
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
    return Platform.isAndroid && _path != null
        ? Column(
            children: [
              Row(children: [button('Delete library', _deleteLibrary)])
            ],
          )
        : Column(
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
                      _tempPath ??
                          AppLocalizations.of(context)!.nolibraryselected,
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  button(AppLocalizations.of(context)!.pickfolder, _loadLibrary)
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Wrap(alignment: WrapAlignment.center, children: [
                Text(AppLocalizations.of(context)!.loadlibrary),
              ]),
              const Divider(),
              Row(
                children: [
                  button(
                      AppLocalizations.of(context)!.newlibrary, _createLibrary)
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
                            await okButton(ref, context);
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
  Widget button(String title, Function action) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () async {
              try {
                print('hiba0'); //nem fut l
                action(context);
              } on NoSuchMethodError {
                print('hiba1');
                () => action; //nem fut le
                print('hiba2');
                action; //nem fut le
                print('hiba3');
                _createLibrary(context);
              }
            },
            child: Text(title),
          );
        }),
      ),
    );
  }

  //OnPressed method of loadLibrary button
  void _loadLibrary(BuildContext? context) {
    _selectFolder(newFolder: false, context: context);
  }

  //OnPressed method of createLibrary button
  void _createLibrary(BuildContext? context) {
    _selectFolder(newFolder: true, context: context);
  }

  void _deleteLibrary(BuildContext? context) {
    //TODO
    print('test');
    setState(() {
      prefs.remove('path');
      _path = null;
      _tempPath = null;
    });
    prefs.remove('path');
  }

  Future<void> okButton(WidgetRef ref, BuildContext context) async {
    if (_tempPath != null && _tempPath != _path) {
      await prefs.setString('path', _tempPath!);
      if (_tempPath != null && _newFolder) {
        await copyDatabase(_tempPath!, 'metadata.db');
        await copyDatabase(_tempPath!, 'metadata_db_prefs_backup.json');
        _newFolder = false;
      }
      if (Platform.isAndroid) {
        print('itt vagyok');

//ask for permission
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
          print('granted');
//here you add the code to store the file
          String databasePath = await getDatabasesPath();
          File file1 = File('$_tempPath/metadata.db');
          File file2 = File('$_tempPath/metadata_db_prefs_backup.json');
          File newFile1 = await file1.copy('$databasePath/metadata.db');
          File newFile2 =
              await file2.copy('$databasePath/metadata_db_prefs_backup.json');

          // Uint8List bytes = await file1.readAsBytes();
          //ByteData blob = ByteData.sublistView(bytes);
          //Uint8List bytes2 = await file2.readAsBytes();
          //ByteData blob2 = ByteData.sublistView(bytes2);
          //writeToFile(blob, '$databasePath/metadata.db');
          //writeToFile(blob2, '$databasePath/metadata_db_prefs_backup.json');

          await ref.read(bookListProvider).databaseHandler!.initialDatabase();
          await ref.read(bookListProvider).getBookItemList();
          // ignore: unused_result
          ref.refresh(booklistProvider);
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/homepage');
        }
      }
    } else {
      if (_path != null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }
  }

  //pop the Settingspage if path exists
  void cancel(BuildContext context) {
    if (_path != null) {
      Navigator.pop(context);
    }
  }

  //Handle file picker dialog and set _tempPath and _newFolder variable
  void _selectFolder({bool newFolder = false, BuildContext? context}) async {
    _resetState();

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
      print('granted');
      try {
        String? tempPath = await _loadPath(
            await FilePicker.platform.getDirectoryPath(), newFolder,
            context: context);
        if (tempPath != null && !newFolder) {
          _tempPath = tempPath;
          _newFolder = false;
        } else if (tempPath != null && newFolder) {
          _tempPath = tempPath;
          _newFolder = true;
        }
      } on PlatformException catch (e) {
        _logException('Unsupported operation$e');
      } catch (e) {
        _logException(e.toString());
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      try {
        String? tempPath = await _loadPath(
            await FilePicker.platform.getDirectoryPath(), newFolder,
            context: context);
        if (tempPath != null && !newFolder) {
          _tempPath = tempPath;
          _newFolder = false;
        } else if (tempPath != null && newFolder) {
          _tempPath = tempPath;
          _newFolder = true;
        }
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
  Future<String?> _loadPath(String? path, bool newLibrary,
      {BuildContext? context}) async {
    if (Platform.isLinux || Platform.isWindows && path != null) {
      //check path in SharedPreferences
      if (!newLibrary) {
        try {
          await io.File('$path/metadata.db').length();
          return path;
        } on Exception {
          return null;
        }
      } else {
        return await Directory(path!).list().isEmpty ? path : null;
      }
    } else if (Platform.isAndroid) {
      if (!newLibrary) {
        return await Directory(path!).list().isEmpty ? null : path;
      } else {
        return path;
      }
    }
    return null;
  }

  //Set path at start
  void setPath({BuildContext? context}) async {
    if (prefs.containsKey('path')) {
      String? path =
          await _loadPath(prefs.getString('path')!, false, context: context);
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
    if (Platform.isAndroid) {
      var path = await getApplicationDocumentsDirectory();
      writeToFile(bytes, '$path/$filename');
    } else {
      writeToFile(bytes, '$databasePath/$filename');
    }
  }

  Future<void> writeToFile(ByteData data, String path) async {
    try {
      File file = File(path);
      await file.delete();
    } catch (e) {
      debugPrint('file no exists');
    }
    final buffer = data.buffer;
    print('Itt $path');
    File(path).create(recursive: true).then((File file) {
      return File(path).writeAsBytes(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    });
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
}
