import 'package:citizenwallet/state/vouchers/logic.dart';
import 'package:citizenwallet/state/vouchers/state.dart';
import 'package:citizenwallet/theme/colors.dart';
import 'package:citizenwallet/widgets/button.dart';
import 'package:citizenwallet/widgets/chip.dart';
import 'package:citizenwallet/widgets/dismissible_modal_popup.dart';
import 'package:citizenwallet/widgets/header.dart';
import 'package:citizenwallet/widgets/profile_icon/icon.dart';
import 'package:citizenwallet/widgets/profile_icon/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class ProfileModal extends StatefulWidget {
  final String title;
  final String subtitle;
  final String address;

  const ProfileModal(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.address});

  @override
  ProfileModalState createState() => ProfileModalState();
}

class ProfileModalState extends State<ProfileModal>
    with TickerProviderStateMixin {
  final FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // make initial requests here

      onLoad();
    });
  }

  void onLoad() async {}

  void handleDismiss(BuildContext context) {
    GoRouter.of(context).pop();
  }

  void handleCopy() {
    Clipboard.setData(ClipboardData(text: widget.address));

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final size = height > width ? width : height;
    final qrSize = size - 80;

    return DismissibleModalPopup(
      modaleKey: 'profile-modal',
      maxHeight: height,
      paddingSides: 0,
      onUpdate: (details) {
        if (details.direction == DismissDirection.down &&
            FocusManager.instance.primaryFocus?.hasFocus == true) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      onDismissed: (_) => handleDismiss(context),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CupertinoPageScaffold(
          backgroundColor: ThemeColors.uiBackground.resolveFrom(context),
          child: SafeArea(
            child: Flex(
              direction: Axis.vertical,
              children: [
                Header(
                  transparent: true,
                  titleWidget: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        widget.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                  actionButton: CupertinoButton(
                    padding: const EdgeInsets.all(5),
                    onPressed: () => handleDismiss(context),
                    child: Icon(
                      CupertinoIcons.xmark,
                      color: ThemeColors.touchable.resolveFrom(context),
                    ),
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
                          PrettyQr(
                            data: widget.address,
                            size: qrSize,
                            roundEdges: false,
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Chip(
                                onTap: handleCopy,
                                widget.address,
                                color: ThemeColors.subtleEmphasis
                                    .resolveFrom(context),
                                textColor:
                                    ThemeColors.touchable.resolveFrom(context),
                                suffix: Icon(
                                  CupertinoIcons.square_on_square,
                                  size: 14,
                                  color: ThemeColors.touchable
                                      .resolveFrom(context),
                                ),
                                borderRadius: 15,
                                maxWidth: 180,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
