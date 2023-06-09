import 'package:citizenwallet/utils/currency.dart';

class CWWallet {
  final String name;
  final String address;
  String _balance;
  final String currencyName;
  final String symbol;
  final int decimalDigits;
  final bool locked;

  CWWallet(
    this._balance, {
    required this.name,
    required this.address,
    required this.currencyName,
    required this.symbol,
    this.decimalDigits = 2,
    this.locked = true,
  });

  String get balance => _balance;

  get formattedBalance => formatCurrency(
        double.tryParse(balance) ?? 0.0,
        symbol,
        decimalDigits: decimalDigits,
      );

  // convert to Wallet object from JSON
  CWWallet.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        address = json['address'],
        _balance = json['balance'],
        currencyName = json['currencyName'],
        symbol = json['symbol'],
        decimalDigits = json['decimalDigits'],
        locked = json['locked'];

  // Convert a Conversation object into a Map object.
  // The keys must correspond to the names of the columns in the database.
  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'balance': _balance,
        'currencyName': currencyName,
        'symbol': symbol,
        'decimalDigits': decimalDigits,
        'locked': locked,
      };

  void setBalance(String balance) {
    _balance = balance;
  }
}
