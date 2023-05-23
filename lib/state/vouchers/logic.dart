import 'package:citizenwallet/state/vouchers/state.dart';
import 'package:citizenwallet/utils/delay.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class VouchersLogic {
  late VouchersState _state;

  VouchersLogic(BuildContext context) {
    _state = context.read<VouchersState>();
  }

  Future<void> fetchVouchers() async {
    try {
      _state.fetchVouchersReq();

      // make api call here
      await delay(const Duration(seconds: 1));

      _state.fetchVouchersSuccess([
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
      ]);
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

  void updateVoucherTitle(String title) {
    _state.updateNewVoucherTitle(title);
  }

  void updateVoucherDescription(String description) {
    _state.updateNewVoucherDescription(description);
  }

  void updateNewVoucherIcon(String icon) {
    _state.updateNewVoucherIcon(icon);
  }

  Future<void> createVoucher() async {
    try {
      _state.createVoucherReq();

      // make api call here
      await delay(const Duration(seconds: 1));

      _state.createVoucherSuccess();
    } catch (e) {
      _state.createVoucherError();
    }
  }
}
