import 'package:citizenwallet/services/preferences/preferences.dart';
import 'package:citizenwallet/state/profile/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProfileLogic {
  final PreferencesService _preferences = PreferencesService();
  late ProfileState _state;

  ProfileLogic(BuildContext context) {
    _state = context.read<ProfileState>();
  }

  void updateProfileName(String name) {
    _state.updateProfileName(name);
  }

  void updateProfileDescription(String description) {
    _state.updateProfileDescription(description);
  }

  void updateProfileIcon(String icon) {
    _state.updateProfileIcon(icon);
  }

  Future<void> setDefaultProfile() async {
    _state.updateProfileName(_preferences.profileName);
    _state.updateProfileDescription(_preferences.profileDescription);
    _state.updateProfileIcon(_preferences.profileIcon ?? '👩‍🚀');
  }

  Future<void> setProfile() async {
    try {
      _state.creatingReq();

      // save to preferences
      await _preferences.setProfileName(_state.profile.name);
      await _preferences.setProfileDescription(_state.profile.description);
      await _preferences.setProfileIcon(_state.profile.icon);

      // the user has been onboarded
      await _preferences.setOnboarded(true);

      _state.creatingSuccess();
    } catch (e) {
      _state.creatingError();
    }
  }
}
