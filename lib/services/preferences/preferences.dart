import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  late SharedPreferences _preferences;

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future setDarkMode(bool darkMode) async {
    await _preferences.setBool('darkMode', darkMode);
  }

  bool get darkMode =>
      _preferences.getBool('darkMode') ??
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.light;

  // has the user been onboarded
  Future setOnboarded(bool onboarded) async {
    await _preferences.setBool('onboarded', onboarded);
  }

  bool get onboarded => _preferences.getBool('onboarded') ?? false;

  // the user's address
  Future setAddress(String address) async {
    await _preferences.setString('address', address);
  }

  String? get address => _preferences.getString('address');

  // delete address
  Future deleteAddress() async {
    await _preferences.remove('address');
  }

  Future setProfileName(String name) async {
    await _preferences.setString('profileName', name);
  }

  String get profileName => _preferences.getString('profileName') ?? '';

  Future setProfileDescription(String description) async {
    await _preferences.setString('profileDescription', description);
  }

  String get profileDescription =>
      _preferences.getString('profileDescription') ?? '';

  Future setProfileIcon(String icon) async {
    await _preferences.setString('profileIcon', icon);
  }

  String? get profileIcon => _preferences.getString('profileIcon');
}
