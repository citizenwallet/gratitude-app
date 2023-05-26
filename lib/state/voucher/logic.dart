import 'package:citizenwallet/state/account/state.dart';
import 'package:citizenwallet/state/voucher/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class VoucherLogic {
  late VoucherState _state;
  late AccountState _accState;

  VoucherLogic(BuildContext context) {
    _state = context.read<VoucherState>();
    _accState = context.read<AccountState>();
  }

  void loadVoucher(String addr, BigInt voucherId) async {
    try {
      _state.addressReq();

      final voucher = await _accState.wallet.getVoucher(addr, voucherId);
      if (voucher == null) {
        throw Exception('voucher not found');
      }

      final ownAddr = _accState.wallet.address.hex.toLowerCase();

      _state.setIsOwner(ownAddr == voucher.minterAddress.toLowerCase());

      _state.addressSuccess(voucher);
      return;
    } catch (e) {
      print(e);
    }

    _state.addressError();
  }

  void openExternal(String addr, BigInt voucherId) async {
    try {
      final opensea = dotenv.get('OPENSEA_URL');

      final Uri url = Uri.parse('$opensea/$addr/${voucherId.toString()}');

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      print(e);
    }
  }
}
