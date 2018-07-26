import 'package:flutter/material.dart';
import 'package:housing_manager/ui/main.dart';
import 'package:housing_manager/settings/AppConfig.dart';

void main() {
  var configuredApp = new AppConfig(
    appName: 'Build flavors DEV',
    flavorName: 'development',
    apiBaseUrl: 'https://dev-api.example.com/',
    child: new MyApp(),
  );

  runApp(configuredApp);
}