import 'package:flutter/cupertino.dart';

class Voucher {
  final String address;
  final String title;
  final String icon;
  final String description;

  const Voucher({
    required this.address,
    required this.title,
    required this.icon,
    required this.description,
  });
}

class Activity {
  final String address;
  final String title;
  final String icon;
  final String description;

  const Activity({
    required this.address,
    required this.title,
    required this.icon,
    required this.description,
  });
}

class VouchersState with ChangeNotifier {
  bool vouchersLoading = false;
  bool vouchersError = false;

  List<Voucher> vouchers = [];

  bool activitiesLoading = false;
  bool activitiesError = false;

  List<Activity> activities = [];

  void fetchVouchersReq() {
    vouchersLoading = true;
    vouchersError = false;
    notifyListeners();
  }

  void fetchVouchersSuccess(List<Voucher> vouchers) {
    this.vouchers = vouchers;
    vouchersLoading = false;
    vouchersError = false;
    notifyListeners();
  }

  void fetchVouchersError() {
    vouchersLoading = false;
    vouchersError = true;
    notifyListeners();
  }

  void fetchActivitiesReq() {
    activitiesLoading = true;
    activitiesError = false;
    notifyListeners();
  }

  void fetchActivitiesSuccess(List<Activity> activities) {
    this.activities = activities;
    activitiesLoading = false;
    activitiesError = false;
    notifyListeners();
  }

  void fetchActivitiesError() {
    activitiesLoading = false;
    activitiesError = true;
    notifyListeners();
  }
}
