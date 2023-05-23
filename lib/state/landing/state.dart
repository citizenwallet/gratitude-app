import 'package:flutter/cupertino.dart';

class Profile {
  String name;
  String description;
  String icon;

  Profile({
    required this.name,
    required this.description,
    required this.icon,
  });

  // parses from json
  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      description: json['description'],
      icon: json['icon'],
    );
  }

  // converts to json
  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'icon': icon,
      };
}

class LandingState with ChangeNotifier {
  bool loading = false;
  bool error = false;

  Profile profile = Profile(
    name: '',
    description: '',
    icon: '👩‍🚀',
  );

  void creatingReq() {
    loading = true;
    error = false;
    notifyListeners();
  }

  void creatingSuccess(Profile profile) {
    loading = false;
    error = false;
    notifyListeners();
  }

  void creatingError() {
    loading = false;
    error = true;
    notifyListeners();
  }

  void updateProfileName(String name) {
    profile.name = name;
    notifyListeners();
  }

  void updateProfileDescription(String desc) {
    profile.description = desc;
    notifyListeners();
  }

  void updateProfileIcon(String icon) {
    profile.icon = icon;
    notifyListeners();
  }
}
