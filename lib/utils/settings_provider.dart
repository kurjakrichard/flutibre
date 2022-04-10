import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';

class SettingsProvider with ChangeNotifier {
  String path = 'assets/config/config.json';

  Future<String> readJsonData() async {
    final configFile = File(path);
    final jsonString = await configFile.readAsString();
    final dynamic data = jsonDecode(jsonString);
    if (Platform.isWindows) {
      return data["path"].replaceAll('/', '\\');
    } else {
      return data["path"];
    }
  }
}
