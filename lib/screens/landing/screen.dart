import 'package:citizenwallet/state/app/logic.dart';
import 'package:citizenwallet/state/app/state.dart';
import 'package:citizenwallet/theme/colors.dart';
import 'package:citizenwallet/widgets/button.dart';
import 'package:citizenwallet/widgets/scanner.dart';
import 'package:citizenwallet/widgets/screen_description.dart';
import 'package:citizenwallet/screens/landing/text_copy_modal.dart';
import 'package:citizenwallet/widgets/text_input_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  late AppLogic _appLogic;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // make initial requests here
      _appLogic = AppLogic(context);

      onLoad();
    });
  }

  void onLoad() async {
    final navigator = GoRouter.of(context);

    final address = await _appLogic.loadLastWallet();

    if (address == null) {
      return;
    }
    navigator.go('/wallet/${address.toLowerCase()}');
  }

  void handleNewWallet() async {
    final navigator = GoRouter.of(context);

    final name = await showCupertinoModalPopup<String?>(
      context: context,
      barrierDismissible: true,
      builder: (modalContext) => const TextInputModal(
        title: 'Wallet Name',
        placeholder: 'Enter wallet name',
      ),
    );

    if (name == null) {
      return;
    }

    final address = await _appLogic.createWallet(name);

    if (address == null) {
      return;
    }

    navigator.go('/wallet/${address.toLowerCase()}');
  }

  void handleNewWebWallet() async {
    final navigator = GoRouter.of(context);

    final wallet = await _appLogic.createWebWallet();

    if (wallet == null) {
      return;
    }

    final hasCopied = await showCupertinoModalPopup<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (modalContext) => TextCopyModal(
        logic: _appLogic,
        title: 'Copy password',
      ),
    );

    if (hasCopied == null || !hasCopied) {
      return;
    }

    final qrWallet = wallet.toCompressedJson();

    navigator.go('/wallet/$qrWallet');
  }

  void handleImportWallet() async {
    final navigator = GoRouter.of(context);

    final result = await showCupertinoModalPopup<String?>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const Scanner(
        modalKey: 'import-qr-scanner',
        confirm: true,
      ),
    );

    if (result == null) {
      return;
    }

    if (kIsWeb) {
      final qrWallet = await _appLogic.importWebWallet(result);

      if (qrWallet == null) {
        return;
      }

      navigator.go('/wallet/$qrWallet');
      return;
    }

    final name = await showCupertinoModalPopup<String?>(
      context: context,
      barrierDismissible: true,
      builder: (modalContext) => const TextInputModal(
        title: 'Wallet Name',
        placeholder: 'Enter wallet name',
      ),
    );

    final wallet = await _appLogic.importWallet(result, name ?? 'New Wallet');

    if (wallet == null) {
      return;
    }

    navigator.go('/wallet/${wallet.data.address.toLowerCase()}');
  }

  @override
  Widget build(BuildContext context) {
    final walletLoading =
        context.select((AppState state) => state.walletLoading);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            ScreenDescription(
              topPadding: 0,
              title: Text(
                'Citizen Wallet',
                style: TextStyle(
                  color: ThemeColors.text.resolveFrom(context),
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              heading: Text(
                'Create and manage your own currencies',
                style: TextStyle(
                  color: ThemeColors.text.resolveFrom(context),
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.center,
              ),
              image: SvgPicture.asset(
                'assets/wallet.svg',
                semanticsLabel: 'A wallet',
                height: 140,
                width: 140,
              ),
              action: walletLoading
                  ? CupertinoActivityIndicator(
                      color: ThemeColors.subtle.resolveFrom(context),
                    )
                  : Column(
                      children: [
                        Button(
                          text: 'New Wallet',
                          onPressed:
                              kIsWeb ? handleNewWebWallet : handleNewWallet,
                          minWidth: 200,
                          maxWidth: 200,
                        ),
                        const SizedBox(height: 40),
                        Button(
                          text: 'Import a wallet',
                          onPressed: handleImportWallet,
                          minWidth: 200,
                          maxWidth: 200,
                        )
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
