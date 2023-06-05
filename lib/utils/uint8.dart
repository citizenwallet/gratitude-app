import 'package:flutter/foundation.dart';

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

Uint8List encodeUint256(BigInt number) {
  final bytes = Uint8List(32);
  final byteData = ByteData.view(bytes.buffer);

  byteData.setUint64(24, number.toInt() >> 192);
  byteData.setUint64(16, number.toInt() >> 128);
  byteData.setUint64(8, number.toInt() >> 64);
  byteData.setUint64(0, number.toInt());

  return bytes;
}

Uint8List encodeBytes32(Uint8List data) {
  final bytes32 = Uint8List(32);
  final paddedData = Uint8List(32);

  paddedData.setAll(32 - data.length, data);
  bytes32.setAll(0, paddedData);

  return bytes32;
}
