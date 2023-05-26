import 'package:citizenwallet/services/wallet/utils.dart';
import 'package:citizenwallet/state/profile/logic.dart';
import 'package:citizenwallet/state/voucher/logic.dart';
import 'package:citizenwallet/state/voucher/state.dart';
import 'package:citizenwallet/theme/colors.dart';
import 'package:citizenwallet/widgets/button.dart';
import 'package:citizenwallet/widgets/chip.dart';
import 'package:citizenwallet/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class VoucherScreen extends StatefulWidget {
  final String title = 'Regen Treasury';
  final String contractId;
  final String voucherId;

  const VoucherScreen({
    super.key,
    required this.contractId,
    required this.voucherId,
  });

  @override
  VoucherScreenState createState() => VoucherScreenState();
}

class VoucherScreenState extends State<VoucherScreen>
    with TickerProviderStateMixin {
  final FocusNode descriptionFocusNode = FocusNode();

  late ProfileLogic _logic;
  late VoucherLogic _voucherLogic;

  @override
  void initState() {
    super.initState();

    _logic = ProfileLogic(context);
    _voucherLogic = VoucherLogic(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // make initial requests here

      onLoad();
    });
  }

  void onLoad() async {
    _voucherLogic.loadVoucher(
        widget.contractId, BigInt.parse(widget.voucherId));
  }

  void onNameChanged(String name) async {
    _logic.updateProfileName(name);
  }

  void onNameSubmitted() async {
    descriptionFocusNode.requestFocus();
  }

  void onDescriptionChanged(String desc) async {
    _logic.updateProfileDescription(desc);
  }

  void onDescriptionSubmitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onIconChanged(String icon) async {
    _logic.updateProfileIcon(icon);
  }

  void handleSetProfile() async {
    final navigator = GoRouter.of(context);

    await _logic.setProfile();

    navigator.go('/vouchers');
  }

  void handleExternalUrl() async {
    _voucherLogic.openExternal(
        widget.contractId, BigInt.parse(widget.voucherId));
  }

  void handleCopy(String text) {
    Clipboard.setData(ClipboardData(text: text));

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final size = height > width ? width : height;
    final imageSize = size - 20;

    final voucher = context.select((VoucherState state) => state.voucher);

    final loading = context.select((VoucherState state) => state.loading);

    final isOwner = context.select((VoucherState state) => state.isOwner);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Header(
              title: widget.title,
              showBackButton: true,
              transparent: true,
            ),
            SizedBox(
              height: imageSize / 2,
              width: imageSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (voucher != null)
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: voucher.image,
                    ),
                  if (loading) const CupertinoActivityIndicator(),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ListView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    children: [
                      Text(
                        loading ? '...' : voucher?.name ?? '',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        loading ? '...' : voucher?.description ?? '',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "From",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          if (!loading)
                            Text(
                              voucher?.minterName ?? '',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.normal),
                            ),
                          if (loading) const CupertinoActivityIndicator(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Issued",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 5),
                          if (!loading)
                            Text(
                              voucher?.mintingDate ?? '',
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.normal),
                            ),
                          if (loading) const CupertinoActivityIndicator(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!loading)
                            Chip(
                              formatHexAddress(voucher?.minterAddress ?? ''),
                              color: ThemeColors.subtleEmphasis
                                  .resolveFrom(context),
                              textColor:
                                  ThemeColors.touchable.resolveFrom(context),
                              maxWidth: 180,
                              onTap: () =>
                                  handleCopy(voucher?.minterAddress ?? ''),
                              suffix: Icon(
                                CupertinoIcons.square_on_square,
                                size: 14,
                                color:
                                    ThemeColors.touchable.resolveFrom(context),
                              ),
                              borderRadius: 15,
                            )
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isOwner)
                          Button(
                            text: 'Transfer',
                            minWidth: 120,
                            maxWidth: 120,
                            suffix: const Row(
                              children: [
                                SizedBox(width: 5),
                                Icon(
                                  CupertinoIcons.up_arrow,
                                  size: 18,
                                  color: CupertinoColors.white,
                                ),
                              ],
                            ),
                            onPressed: !loading ? handleExternalUrl : null,
                          ),
                        if (isOwner) const SizedBox(width: 5),
                        Button(
                          text: 'Inspect',
                          minWidth: 120,
                          maxWidth: 120,
                          suffix: const Row(
                            children: [
                              SizedBox(width: 5),
                              Icon(
                                CupertinoIcons.search,
                                size: 18,
                                color: CupertinoColors.white,
                              ),
                            ],
                          ),
                          onPressed: !loading ? handleExternalUrl : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
