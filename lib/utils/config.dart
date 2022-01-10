class AppConfig {
  String? path;

  AppConfig({required this.path});

  AppConfig.fromJson(Map<String, String> json) {
    path = json['path'];
  }
}
