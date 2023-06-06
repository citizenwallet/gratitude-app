// test if the qr code signature matches the data

import 'dart:convert';

import 'package:citizenwallet/services/wallet/models/qr/qr.dart';
import 'package:citizenwallet/services/wallet/models/signer.dart';
import 'package:citizenwallet/services/wallet/models/userop.dart';
import 'package:citizenwallet/services/wallet/utils.dart';
import 'package:citizenwallet/utils/uint8.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';

void main() {
  dotenv.load(fileName: '.env');

  group('UserOp', () {
    test('parsing, generation and signing wallets', () async {
      final useropjson = {
        'sender': '0x83EfDe8fbB1D7C1FF60A6d9F5AD848Dd23Ce9876',
        'nonce': '0x0',
        'initCode':
            '0x9406cc6185a346906296840746125a0e449764545fbfb9cf000000000000000000000000c84382ff58cf6d109f7ea2ff42379919102771e20000000000000000000000000000000000000000000000000000000000000000',
        'callData':
            '0xb61d27f6000000000000000000000000fe4f5145f6e09952a5ba9e956ed0c25e3fa4c7f1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000044a9059cbb0000000000000000000000000c16630ac34964a7bfe86c202451f78bc1087ae70000000000000000000000000000000000000000000000000de0b6b3a764000000000000000000000000000000000000000000000000000000000000',
        'callGasLimit': '0x13352',
        'verificationGasLimit': '0xb6ca4',
        'preVerificationGas': '0xc004',
        'maxFeePerGas': '0x8aab8b58',
        'maxPriorityFeePerGas': '0x8aab8b38',
        'paymasterAndData':
            '0xe93eca6595fe94091dc1af46aac2a8b5d799077000000000000000000000000000000000000000000000000000000000647b5a5a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c153e7734485c52069856396577bff829dc87a18d88adf37a2425f841d5d1d0f32eef0daa538a3482cec5659622f45028b19477dbad2b01a34d4fbf4783bf9aa1b',
        'signature':
            '0x199eeba2a9216ed01f9caded6d1b585fc6b0982a73a85f665081fe17a54a24256176fee7747a58b0b2d7db627f705bcd7e7dd0ede7636372985621c8668637b61b'
      };

      final expectedHash =
          '0xe3031164f5911c9f9d66db02a5e76b01b093365295b649eb8faa78ffd85c68ce';
      final expectedSig =
          '0x199eeba2a9216ed01f9caded6d1b585fc6b0982a73a85f665081fe17a54a24256176fee7747a58b0b2d7db627f705bcd7e7dd0ede7636372985621c8668637b61b';

      final userop = UserOp.fromJson(useropjson);

      expect(userop.sender == useropjson['sender'], true);
      expect(bigIntToHex(userop.nonce) == useropjson['nonce'], true);
      expect(
          bytesToHex(userop.initCode, include0x: true) ==
              useropjson['initCode'],
          true);
      expect(
          bytesToHex(userop.callData, include0x: true) ==
              useropjson['callData'],
          true);
      expect(
          bigIntToHex(userop.callGasLimit) == useropjson['callGasLimit'], true);
      expect(
          bigIntToHex(userop.verificationGasLimit) ==
              useropjson['verificationGasLimit'],
          true);
      expect(
          bigIntToHex(userop.preVerificationGas) ==
              useropjson['preVerificationGas'],
          true);
      expect(
          bigIntToHex(userop.maxFeePerGas) == useropjson['maxFeePerGas'], true);
      expect(
          bigIntToHex(userop.maxPriorityFeePerGas) ==
              useropjson['maxPriorityFeePerGas'],
          true);
      expect(
          bytesToHex(userop.paymasterAndData, include0x: true) ==
              useropjson['paymasterAndData'],
          true);

      final cred =
          EthPrivateKey.fromHex(dotenv.get('ERC4337_TEST_SIGNING_KEY'));
      userop.generateSignature(cred, dotenv.get('ERC4337_ENTRYPOINT'), 80001);

      final hash = bytesToHex(
          userop.getUserOpHash(dotenv.get('ERC4337_ENTRYPOINT'), '80001'),
          include0x: true);

      print('expected: $expectedHash');
      print('actual: $hash');

      expect(hash == expectedHash, true);

      final sig = bytesToHex(userop.signature, include0x: true);

      print('expected: $expectedSig');
      print('actual: $sig');
      print(
          'old: 0x5da706c09a4f168d21a7075fc14eef9628afed1bff8949581d5902a86e52035c4b886a0ab1f1b160334021cd0f598ff506bb5be368c004d16b9412f917b693a91c');

      expect(sig == expectedSig, true);
    });
  });
}
