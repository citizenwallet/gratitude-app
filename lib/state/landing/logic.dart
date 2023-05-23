import 'package:citizenwallet/state/landing/state.dart';
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
}
