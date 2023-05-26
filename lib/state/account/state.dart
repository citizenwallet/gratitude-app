import 'package:citizenwallet/services/wallet/wallet.dart';
import 'package:flutter/cupertino.dart';

class AccountState with ChangeNotifier {
  bool loading = true;
  bool error = false;

  String address = '';

  late WalletService wallet;

  void addressReq() {
    loading = true;
    error = false;
    notifyListeners();
  }

  void addressSuccess(String address) {
    loading = false;
    error = false;
    this.address = address;
    notifyListeners();
  }

  void addressError() {
    loading = false;
    error = true;
    notifyListeners();
  }
}
