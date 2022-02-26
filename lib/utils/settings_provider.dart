import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';

class SettingsProvider extends ChangeNotifier {
  Future<String> readJsonData() async {
    final configFile = File('assets/config/flutter_config.json');
    final jsonString = await configFile.readAsString();
    final dynamic jsonMap = jsonDecode(jsonString);
    //print(jsonMap['path']);
    return jsonMap['path'];
  }
}
