import 'package:citizenwallet/state/landing/state.dart';
import 'package:citizenwallet/utils/delay.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class LandingLogic {
  late LandingState _state;

  LandingLogic(BuildContext context) {
    _state = context.read<LandingState>();
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

  Future<void> createProfile() async {
    try {
      _state.creatingReq();

      // make api call here
      await delay(const Duration(seconds: 1));

      _state.creatingSuccess(Profile(
        name: _state.profile.name,
        description: _state.profile.description,
        icon: _state.profile.icon,
      ));
    } catch (e) {
      _state.creatingError();
    }
  }
}
