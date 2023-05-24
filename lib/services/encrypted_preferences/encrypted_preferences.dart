import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const passwordPrefix = 'password';
const walletPrefix = 'wallet';

class EncryptedPreferencesService {
  static final EncryptedPreferencesService _instance =
      EncryptedPreferencesService._internal();
  factory EncryptedPreferencesService() => _instance;
  EncryptedPreferencesService._internal();

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  IOSOptions _getIOSOptions() => const IOSOptions(
        accessibility: KeychainAccessibility.unlocked,
      );

  MacOsOptions _getMacOsOptions() => const MacOsOptions(
        accessibility: KeychainAccessibility.unlocked,
      );

  late FlutterSecureStorage _preferences;

  Future init() async {
    _preferences = FlutterSecureStorage(
      iOptions: _getIOSOptions(),
      aOptions: _getAndroidOptions(),
      mOptions: _getMacOsOptions(),
    );
  }

  Future<String?> getString(String key) async {
    return _preferences.read(key: key);
  }

  // set wallet password
  Future<void> setWalletPassword(String address, String password) async {
    final savedValue = await _preferences.read(
        key: '${passwordPrefix}_${address.toLowerCase()}');
    if (savedValue != null) {
      await _preferences.delete(
          key: '${passwordPrefix}_${address.toLowerCase()}');
    }

    await _preferences.write(
        key: 'w_${address.toLowerCase()}', value: password);
  }

  // get wallet password
  Future<String?> getWalletPassword(String address) async {
    return _preferences.read(key: '${passwordPrefix}_${address.toLowerCase()}');
  }

  // set wallet json
  Future<void> setWalletJson(String address, String json) async {
    final savedValue = await _preferences.read(
        key: '${walletPrefix}_${address.toLowerCase()}');
    if (savedValue != null) {
      await _preferences.delete(
          key: '${walletPrefix}_${address.toLowerCase()}');
    }

    await _preferences.write(
        key: '${walletPrefix}_${address.toLowerCase()}', value: json);
  }

  // get wallet json
  Future<String?> getWalletJson(String address) async {
    return _preferences.read(key: '${walletPrefix}_${address.toLowerCase()}');
  }
}
