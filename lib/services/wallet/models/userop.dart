import 'package:citizenwallet/services/wallet/utils.dart';
import 'package:citizenwallet/utils/uint8.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web3dart/crypto.dart';

const String zeroAddress = '0x0000000000000000000000000000000000000000';
final BigInt defaultCallGasLimit = BigInt.from(35000);
final BigInt defaultVerificationGasLimit = BigInt.from(70000);
final BigInt defaultPreVerificationGas = BigInt.from(21000);
final BigInt defaultMaxFeePerGas = BigInt.from(21000);
final BigInt defaultMaxPriorityFeePerGas = BigInt.from(21000);
final Uint8List emptyBytes = hexToBytes('0x');
final Uint8List dummySignature = hexToBytes(
    '0x199eeba2a9216ed01f9caded6d1b585fc6b0982a73a85f665081fe17a54a24256176fee7747a58b0b2d7db627f705bcd7e7dd0ede7636372985621c8668637b61b');

class UserOp {
  String sender;
  BigInt nonce;
  Uint8List initCode;
  Uint8List callData;
  BigInt callGasLimit;
  BigInt verificationGasLimit;
  BigInt preVerificationGas;
  BigInt maxFeePerGas;
  BigInt maxPriorityFeePerGas;
  Uint8List paymasterAndData;
  Uint8List signature;

  UserOp({
    required this.sender,
    required this.nonce,
    required this.initCode,
    required this.callData,
    required this.callGasLimit,
    required this.verificationGasLimit,
    required this.preVerificationGas,
    required this.maxFeePerGas,
    required this.maxPriorityFeePerGas,
    required this.paymasterAndData,
    required this.signature,
  });

  // default user op
  factory UserOp.defaultUserOp() {
    return UserOp(
      sender: zeroAddress,
      nonce: BigInt.zero,
      initCode: emptyBytes,
      callData: emptyBytes,
      callGasLimit: defaultCallGasLimit,
      verificationGasLimit: defaultVerificationGasLimit,
      preVerificationGas: defaultPreVerificationGas,
      maxFeePerGas: defaultMaxFeePerGas,
      maxPriorityFeePerGas: defaultMaxPriorityFeePerGas,
      paymasterAndData: emptyBytes,
      signature: dummySignature,
    );
  }

  // instantiate from json
  factory UserOp.fromJson(Map<String, dynamic> json) {
    return UserOp(
      sender: json['sender'],
      nonce: hexToInt(json['nonce']),
      initCode: hexToBytes(json['initCode']),
      callData: hexToBytes(json['callData']),
      callGasLimit: hexToInt(json['callGasLimit']),
      verificationGasLimit: hexToInt(json['verificationGasLimit']),
      preVerificationGas: hexToInt(json['preVerificationGas']),
      maxFeePerGas: hexToInt(json['maxFeePerGas']),
      maxPriorityFeePerGas: hexToInt(json['maxPriorityFeePerGas']),
      paymasterAndData: hexToBytes(json['paymasterAndData']),
      signature: hexToBytes(json['signature']),
    );
  }

  // convert to json
  Map<String, dynamic> toJson() {
    return {
      'sender': sender,
      'nonce': bigIntToHex(nonce),
      'initCode': bytesToHex(initCode, include0x: true),
      'callData': bytesToHex(callData, include0x: true),
      'callGasLimit': bigIntToHex(callGasLimit),
      'verificationGasLimit': bigIntToHex(verificationGasLimit),
      'preVerificationGas': bigIntToHex(preVerificationGas),
      'maxFeePerGas': bigIntToHex(maxFeePerGas),
      'maxPriorityFeePerGas': bigIntToHex(maxPriorityFeePerGas),
      'paymasterAndData': bytesToHex(paymasterAndData, include0x: true),
      'signature': bytesToHex(signature, include0x: true),
    };
  }

  // getUserOpHash returns the hash of the user op
  Uint8List getUserOpHash(String entrypoint, String chainId) {
    final List<Uint8List> buffer = [];

    buffer.add(hexToBytes(sender));
    buffer.add(encodeUint256(nonce));
    buffer.add(encodeBytes32(keccak256(initCode)));
    buffer.add(encodeBytes32(keccak256(callData)));
    buffer.add(encodeUint256(callGasLimit));
    buffer.add(encodeUint256(verificationGasLimit));
    buffer.add(encodeUint256(preVerificationGas));
    buffer.add(encodeUint256(maxFeePerGas));
    buffer.add(encodeUint256(maxPriorityFeePerGas));
    buffer.add(encodeBytes32(keccak256(paymasterAndData)));

    final packed = Uint8List.fromList(buffer
        .fold([], (previousValue, element) => previousValue..addAll(element)));

    final List<Uint8List> buffer1 = [];

    buffer1.add(encodeBytes32(keccak256(packed)));
    buffer1.add(hexToBytes(entrypoint));
    buffer1.add(encodeUint256(BigInt.parse(chainId)));

    final encoded = Uint8List.fromList(buffer1
        .fold([], (previousValue, element) => previousValue..addAll(element)));

    return keccak256(encoded);
  }

  // sign signs the user op
  void generateSignature(
      EthPrivateKey credentials, String entrypoint, int chainId) {
    final hash = getUserOpHash(
      entrypoint,
      chainId.toString(),
    );

    final signature = sign(
      hash,
      credentials.privateKey,
    );

    // encode the signature
    final r = signature.r.toRadixString(16).padLeft(64, '0');
    final s = signature.s.toRadixString(16).padLeft(64, '0');
    final v = bytesToHex(intToBytes(BigInt.from(signature.v + 4)));

    // compact the signature
    // 0x - padding
    // v - 1 byte
    // r - 32 bytes
    // s - 32 bytes

    this.signature = hexToBytes('0x$r$s$v');
  }
}
