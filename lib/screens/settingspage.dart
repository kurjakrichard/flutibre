import 'dart:io';
import 'package:io/io.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

import 'mainwindow.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final List<String> _languages = ['magyar', 'angol'];
  String? _languageSelected;
  // path to save SharePreferences
  String? _dbpath;
  String? _tempPath;
  //check if path/Ebooks exists
  bool _newFolder = false;
  bool _isLoading = false;
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
      appBar: AppBar(title: Text('Settings page')),
      body: ListView(children: [
        Padding(
          padding:
              EdgeInsets.only(top: 25.0, bottom: 10.0, left: 15.0, right: 15.0),
          child: Row(
            children: [
              Container(
                width: 120,
                child: Text('Choose language:'),
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
              child: Text(_dbpath ?? ''),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => _selectFolder(),
                child: const Text('Pick folder'),
              ),
            ),
          ],
        ),
        Row(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                if (_tempPath != null) {
                  _savePath(_tempPath!);
                  if (_newFolder) {
                    copyPath('assets/Ebooks', _tempPath!);
                    _newFolder = false;
                  }
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainWindow(),
                    ));
              },
              child: Text('Ok'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainWindow(),
                    ));
              },
              child: Text('Cancel'),
            ),
          ),
        ]),
      ]),
    );
  }

  Future<String?> _loadPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = await prefs.getString('path');

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
