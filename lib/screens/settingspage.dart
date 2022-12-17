import 'dart:io';
import 'package:flutibre/repository/database_connection.dart';
import 'package:flutibre/repository/database_handler.dart';
import 'package:io/io.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import '../utils/book_provider.dart';
import 'mainwindow.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final List<String> _languages = ['magyar', 'angol'];
  String? _languageSelected;
  // path to save SharePreferences
  String? _dbpath;
  String? _tempPath;
  bool? _isPath;
  //check if path/Ebooks exists
  bool _newFolder = false;
  // ignore: unused_field
  bool _isLoading = false;
  // ignore: unused_field
  bool _userAborted = false;

  @override
  void initState() {
    super.initState();
    _loadPath();
    _languageSelected = _languages[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.settingspage,
              style: Theme.of(context).textTheme.headline1)),
      body: ListView(children: [
        Padding(
          padding:
              EdgeInsets.only(top: 25.0, bottom: 10.0, left: 15.0, right: 15.0),
          child: Row(
            children: [
              Container(
                width: 120,
                child: Text(AppLocalizations.of(context)!.choselanguage + ':',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
              Container(width: 20),
              dropDown(_languages),
              Container(width: 20),
            ],
          ),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_dbpath ?? '',
                  style: Theme.of(context).textTheme.bodyText1),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _selectFolder(),
                child: Text(AppLocalizations.of(context)!.pickfolder,
                    style: Theme.of(context).textTheme.headline3),
              ),
            ),
          ],
        ),
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(AppLocalizations.of(context)!.ok,
                  style: Theme.of(context).textTheme.headline3),
              onPressed: () {
                if (_tempPath != null) {
                  _savePath(_tempPath!);
                  if (_tempPath != null && _newFolder) {
                    copyPath('assets/Ebooks', _tempPath!);
                    _newFolder = false;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainWindow(),
                      ));
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              child: Text(AppLocalizations.of(context)!.cancel,
                  style: Theme.of(context).textTheme.headline3),
              onPressed: () {
                if (_isPath!) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ]),
      ]),
    );
  }

  Future<String?> _loadPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _tempPath = await prefs.getString('path');
    _isPath = await File('$_tempPath/metadata.db').exists();
    _tempPath = null;
    String? path = _isPath! ? await prefs.getString('path') : null;

    if (path != null) {
      setState(() {
        _dbpath = path;
      });
      return path;
    } else {
      return null;
    }
  }

  _savePath(String dbpath) async {
    final prefs = await SharedPreferences.getInstance();
    if (dbpath != '') {
      await prefs.setString('path', dbpath);
    }
  }

  Future<bool> isPath() async {
    final prefs = await SharedPreferences.getInstance();
    if (await prefs.containsKey('path')) {
      return true;
    } else {
      return false;
    }
  }

  Widget dropDown(List<String> list) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: DropdownButton(
        items: list.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValueSelected) {
          setState(() {
            _languageSelected = newValueSelected!;
          });
        },
        value: _languageSelected,
      ),
    );
  }

  void _selectFolder() async {
    _resetState();
    try {
      _tempPath = await FilePicker.platform.getDirectoryPath();
      if (await File('$_tempPath/Ebooks/metadata.db').exists()) {
        _tempPath = _tempPath! + '/Ebooks';
      }

      if (_tempPath != null && await File('$_tempPath/metadata.db').exists() ||
          await File('$_tempPath/Ebooks/metadata.db').exists()) {
        setState(() {
          _dbpath = _tempPath;
          Provider.of<BookProvider>(context, listen: false).getBookList();
          _userAborted = _tempPath == null;
        });
      } else {
        setState(() {
          _newFolder = true;
          _tempPath = _tempPath! + '/Ebooks';
          _dbpath = _tempPath;
          _userAborted = _tempPath == null;
        });
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logException(String message) {
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
