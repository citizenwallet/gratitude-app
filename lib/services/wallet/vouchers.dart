import 'dart:async';

import 'package:smartcontracts/smartcontracts.dart';
import 'package:web3dart/web3dart.dart';

Future<Vouchers> newVouchers(int chainId, Web3Client client) async {
  return Vouchers(chainId, client);
}

class Vouchers {
  final int chainId;
  final Web3Client client;

  StreamSubscription<TransferSingle>? _sub;

  Vouchers(this.chainId, this.client);

  Future<String> getUri(String addr, BigInt tokenId) async {
    final contract = RegensUniteTokens(
      address: EthereumAddress.fromHex(addr),
      client: client,
      chainId: chainId,
    );

    final uri = await contract.uri(tokenId);
    return '/$uri';
  }

  Future<void> getVoucher() async {
    // final contract = RegensUniteTokens(
    //   address: EthereumAddress.fromHex(addr),
    //   client: client,
    //   chainId: chainId,
    // );
    // final str = contract.transferSingleEvents();

    // print('length');
    // print(str.length);

    // _sub = str.listen((event) {
    //   print(event);
    // });
  }

  void dispose() {
    _sub?.cancel();
  }
}
