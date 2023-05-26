import 'package:citizenwallet/services/wallet/models/voucher.dart';
import 'package:flutter/cupertino.dart';

class VoucherState with ChangeNotifier {
  bool loading = false;
  bool error = false;

  Voucher? voucher;
  bool isOwner = false;

  bool voucherCreationLoading = false;
  bool voucherCreationError = false;

  String newVoucherTitle = '';
  String newVoucherDescription = '';

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

  void updateNewVoucherTitle(String name) {
    newVoucherTitle = name;
    notifyListeners();
  }

  void updateNewVoucherDescription(String description) {
    newVoucherDescription = description;
    notifyListeners();
  }

  void createVoucherReq() {
    voucherCreationLoading = true;
    voucherCreationError = false;
    notifyListeners();
  }

  void createVoucherSuccess() {
    voucherCreationLoading = false;
    voucherCreationError = false;

    newVoucherTitle = '';
    newVoucherDescription = '';
    notifyListeners();
  }

  void createVoucherError() {
    voucherCreationLoading = false;
    voucherCreationError = true;
    notifyListeners();
  }
}
