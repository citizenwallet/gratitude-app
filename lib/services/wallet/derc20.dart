import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;

import 'package:smartcontracts/external.dart';
import 'package:web3dart/web3dart.dart';

Future<TestToken> newTestToken(
    int chainId, Web3Client client, String addr) async {
  return TestToken(chainId, client, addr);
}

class TestToken {
  final int chainId;
  final Web3Client client;
  final String addr;
  late DERC20 contract;
  late DeployedContract rcontract;

  // StreamSubscription<TransferSingle>? _sub;

  TestToken(this.chainId, this.client, this.addr) {
    contract = DERC20(
      address: EthereumAddress.fromHex(addr),
      chainId: chainId,
      client: client,
    );
  }

  Future<void> init() async {
    final abi = await rootBundle.loadString(
        'packages/smartcontracts/contracts/external/DERC20.abi.json');

    final cabi = ContractAbi.fromJson(abi, 'DERC20');

    rcontract = DeployedContract(cabi, EthereumAddress.fromHex(addr));
  }

  Future<BigInt> getBalance(String addr) async {
    final balance = await contract.balanceOf(EthereumAddress.fromHex(addr));

    print(balance.toString());

    // final uri = await contract.uri(tokenId);
    // return '/$uri';
    return balance;
  }

  Uint8List transferCallData(String to, BigInt amount) {
    final function = rcontract.function('transfer');

    return function.encodeCall([EthereumAddress.fromHex(to), amount]);
  }

  void dispose() {
    // _sub?.cancel();
  }
}
