import 'package:citizenwallet/services/wallet/models/voucher.dart';
import 'package:citizenwallet/state/vouchers/state.dart';
import 'package:citizenwallet/utils/delay.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class VouchersLogic {
  late VouchersState _state;

  VouchersLogic(BuildContext context) {
    _state = context.read<VouchersState>();
  }

  void addVoucher(Voucher voucher) {
    _state.addVoucher(voucher);
  }

  Future<void> fetchVouchers() async {
    try {
      _state.fetchVouchersReq();

      // make api call here
      await delay(const Duration(seconds: 1));

      _state.fetchVouchersSuccess([]);
    } catch (e) {
      _state.fetchVouchersError();
    }
  }

  Future<void> fetchActivities() async {
    try {
      _state.fetchActivitiesReq();

      // make api call here
      await delay(const Duration(seconds: 1));

      _state.fetchActivitiesSuccess([
        const Activity(
            address: '0x123', title: 'Xavier', icon: '😸', description: '...'),
        const Activity(
            address: '0x345', title: 'Leen', icon: '💀', description: '...'),
        const Activity(
            address: '0x456', title: 'Kevin', icon: '🎃', description: '...'),
        const Activity(
            address: '0x678',
            title: 'Jeanne',
            icon: '😵‍💫',
            description: '...'),
        const Activity(
            address: '0x789', title: '...', icon: '😸', description: '...'),
      ]);
    } catch (e) {
      _state.fetchActivitiesError();
    }
  }
}
