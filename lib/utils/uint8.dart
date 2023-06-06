import 'package:flutter/foundation.dart';
import 'package:web3dart/crypto.dart';

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  return Uint8List.fromList(codeUnits);
}

String convertUint8ListToString(Uint8List uint8list) {
  return String.fromCharCodes(uint8list);
}

String convertLinstInListToString(List<int> uint8list) {
  return String.fromCharCodes(uint8list);
}

Uint8List convertBytesToUint8List(List<int> bytes) {
  return Uint8List.fromList(bytes);
}

Uint8List bigIntToUint256(BigInt value) {
  final encodedValue = value.toRadixString(16).padLeft(64, '0');
  final byteData = Uint8List.fromList(hexToBytes(encodedValue));
  return byteData;
}

Uint8List encodeBytes32(Uint8List data) {
  final bytes32 = Uint8List(32);
  final paddedData = Uint8List(32);

  paddedData.setAll(32 - data.length, data);
  bytes32.setAll(0, paddedData);

  return bytes32;
}
