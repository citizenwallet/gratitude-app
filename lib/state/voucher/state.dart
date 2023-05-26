import 'package:citizenwallet/services/wallet/models/voucher.dart';
import 'package:flutter/cupertino.dart';

class VoucherState with ChangeNotifier {
  bool loading = false;
  bool error = false;

  Voucher? voucher;
  bool isOwner = false;

  void addressReq() {
    loading = true;
    error = false;
    notifyListeners();
  }

  void addressSuccess(Voucher voucher) {
    loading = false;
    error = false;
    this.voucher = voucher;
    notifyListeners();
  }

  void addressError() {
    loading = false;
    error = true;
    notifyListeners();
  }

  void setIsOwner(bool isOwner) {
    this.isOwner = isOwner;
    notifyListeners();
  }
}
