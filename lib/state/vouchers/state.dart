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
  bool loading = false;
  bool error = false;

  List<Voucher> vouchers = [
    const Voucher(
      address: '0x123',
      title: 'hello',
      icon: '😧',
      description: 'world',
    ),
    const Voucher(
      address: '0x345',
      title: 'gratitude',
      icon: '😵',
      description: 'so nice',
    ),
    const Voucher(
      address: '0x567',
      title: 'another',
      icon: '😵',
      description: 'wow, amazing',
    ),
  ];

  List<Activity> activities = [
    const Activity(
        address: '0x123', title: 'Xavier', icon: '😸', description: '...'),
    const Activity(
        address: '0x345', title: 'Leen', icon: '💀', description: '...'),
    const Activity(
        address: '0x456', title: 'Kevin', icon: '🎃', description: '...'),
    const Activity(
        address: '0x678', title: 'Jeanne', icon: '😵‍💫', description: '...'),
    const Activity(
        address: '0x789', title: '...', icon: '😸', description: '...'),
  ];
}
