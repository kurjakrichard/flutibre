import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  final List<String> _currencies = ['magyar', 'angol'];
  String? _currencyItemSelected;
  TextEditingController pathController = TextEditingController();
  String? _dbpath;
  bool _isLoading = false;
  bool _userAborted = false;

  @override
  void initState() {
    super.initState();
    _loadPath();
    _currencyItemSelected = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flutibre settings page')),
      body: ListView(children: [
        Padding(
          padding:
              EdgeInsets.only(top: 25.0, bottom: 10.0, left: 15.0, right: 15.0),
          child: Row(
            children: [
              Expanded(
                child: Text('Choose language:'),
              ),
              Container(width: 20),
              dropDown(_currencies),
              Expanded(
                child: Container(width: 20),
              ),
            ],
          ),
        ),
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () async {
              _removePath();
              setState(() {
                pathController = TextEditingController();
                _dbpath = '';
              });
            },
            child: Text('Delete path'),
          ),
        ),
      ]),
    );
  }

  Future<String?> _loadPath() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = await prefs.getString('path');

    setState(() {
      path;
    });

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

  Future<void> _removePath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('path');
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
    return Expanded(
      child: Padding(
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
              _currencyItemSelected = newValueSelected!;
            });
          },
          value: _currencyItemSelected,
        ),
      ),
    );
  }

  void _selectFolder() async {
    String? path;
    _resetState();
    try {
      path = await FilePicker.platform.getDirectoryPath();
      if (path != null && await File('$path/metadata.db').exists()) {
        _savePath(path);
        setState(() {
          _dbpath = path;
          _userAborted = path == null;
        });
      } else if (await Directory(path as String).list().isEmpty) {
        debugPrint('TODO');
        _savePath(path);
        setState(() {
          _dbpath = path;
          _userAborted = path == null;
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
