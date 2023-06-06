import 'dart:math';

import 'package:citizenwallet/services/encrypted_preferences/encrypted_preferences.dart';
import 'package:citizenwallet/services/preferences/preferences.dart';
import 'package:citizenwallet/services/wallet/derc20.dart';
import 'package:citizenwallet/services/wallet/wallet.dart';
import 'package:citizenwallet/state/account/state.dart';
import 'package:citizenwallet/utils/delay.dart';
import 'package:citizenwallet/utils/random.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:web3dart/web3dart.dart';

class ConfigErrorException implements Exception {
  final String message = 'wallet config error';

  ConfigErrorException();
}

class AccountLogic {
  final PreferencesService _prefs = PreferencesService();
  final EncryptedPreferencesService _ePrefs = EncryptedPreferencesService();

  late AccountState _state;

  AccountLogic(BuildContext context) {
    _state = context.read<AccountState>();
  }

  Future<void> loadWallet() async {
    try {
      _state.addressReq();

      EthPrivateKey credentials;
      String password;
      Wallet wallet;

      String? address = _prefs.address;
      if (address == null) {
        // the user has not been onboarded

        // generate new credentials
        credentials = EthPrivateKey.createRandom(Random.secure());

        password = getRandomString(64);

        wallet = Wallet.createNew(credentials, password, Random.secure());

        address = credentials.address.hex.toLowerCase();

        // save to encrypted preferences
        await _ePrefs.setWalletPassword(address, password);

        // save wallet json to encrypted preferences
        await _ePrefs.setWalletJson(address, wallet.toJson());

        // save to preferences
        await _prefs.setAddress(address);
      } else {
        // the user has been onboarded
        final savedPassword = await _ePrefs.getWalletPassword(address);
        if (savedPassword == null) {
          throw ConfigErrorException();
        }

        // get wallet json
        final String? savedWallet = await _ePrefs.getWalletJson(address);
        if (savedWallet == null) {
          throw ConfigErrorException();
        }

        // load wallet
        wallet = Wallet.fromJson(savedWallet, savedPassword);

        address = wallet.privateKey.address.hex.toLowerCase();
      }

      // instantiate wallet service
      final chainID = dotenv.get('DEFAULT_CHAIN_ID');

      final loadedWallet =
          await walletServiceFromCredentials(BigInt.parse(chainID), wallet);
      if (loadedWallet == null) {
        throw ConfigErrorException();
      }

      _state.wallet = loadedWallet;

      await _state.wallet.initUnlocked(
          dotenv.get('ERC4337_ENTRYPOINT'),
          dotenv.get('ERC4337_ACCOUNT_FACTORY'),
          dotenv.get('TEST_TOKEN_ADDRESS'));

      // final needsDeployment = await _state.wallet.needsAccountDeployment();

      // print(needsDeployment);
      // if (needsDeployment) {
      //   await _state.wallet.createAccount();
      // }

      // await _state.wallet
      //     .derc20TransferListen();

      // await _state.wallet.submitUserOp(dotenv.get('ADMIN1'), '10000', 'hello');
      // await _state.wallet.submitUserOp(
      //   '0xba6926ae40f93b9c59bceb4be81369031bad857c',
      //   '0x664ce0F7785E4bA5Ff422C77314eF982F193BeF5',
      //   '1',
      //   'hello',
      // );
      // await _state.wallet
      //     .createAccount(); // 0x3f4127dd293c272c6d1c66485f9cddda7a211848
      // await _state.wallet.getDerc20Balance(dotenv.get('TEST_TOKEN_ADDRESS'),
      //     '0x0c16630ac34964A7Bfe86C202451f78bc1087Ae7'); // 0x0c16630ac34964A7Bfe86C202451f78bc1087Ae7
      await _state.wallet.transferDerc20(
        '0x664ce0F7785E4bA5Ff422C77314eF982F193BeF5',
        BigInt.one,
      );
      // await _state.wallet.createProfile(
      //     '0xEB1FE442FF84305526EDc51ecA080f87575a0fdf'); // 0x3cd07a1FF5EFD26612C6e5CE5D30a54DAfb5c13e

      print('success!');

      _state.addressSuccess(address);
    } on ConfigErrorException {
      // something went wrong or storage was manually cleared

      // clear preferences
      await _prefs.deleteAddress();

      // wait a bit to avoid and infinite loop
      await delay(const Duration(seconds: 1));

      // try loading again
      await loadWallet();
    } catch (e) {
      _state.addressError();
    }
  }
}
