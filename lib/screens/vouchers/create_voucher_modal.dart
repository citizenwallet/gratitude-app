import 'package:citizenwallet/state/account/state.dart';
import 'package:citizenwallet/state/profile/state.dart';
import 'package:citizenwallet/state/voucher/logic.dart';
import 'package:citizenwallet/state/voucher/state.dart';
import 'package:citizenwallet/state/vouchers/logic.dart';
import 'package:citizenwallet/theme/colors.dart';
import 'package:citizenwallet/widgets/button.dart';
import 'package:citizenwallet/widgets/dismissible_modal_popup.dart';
import 'package:citizenwallet/widgets/header.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateVoucherModal extends StatefulWidget {
  final String title = 'New Voucher';
  final String subtitle = 'Pay with something that you love doing';
  final String address;

  const CreateVoucherModal({super.key, required this.address});

  @override
  CreateVoucherModalState createState() => CreateVoucherModalState();
}

class CreateVoucherModalState extends State<CreateVoucherModal>
    with TickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  late VoucherLogic _voucherLogic;

  @override
  void initState() {
    super.initState();

    _voucherLogic = VoucherLogic(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // make initial requests here

      onLoad();
    });
  }

  void onLoad() async {
    final name = context.read<ProfileState>().profile.name;

    _nameController.text = name;
  }

  void onNameSubmitted() async {
    titleFocusNode.requestFocus();
  }

  void onTitleChanged(String title) async {
    _voucherLogic.updateVoucherTitle(title);
  }

  void onTitleSubmitted() async {
    descriptionFocusNode.requestFocus();
  }

  void onDescriptionChanged(String desc) async {
    _voucherLogic.updateVoucherDescription(desc);
  }

  void onDescriptionSubmitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onCreate() async {
    final navigator = GoRouter.of(context);

    final voucher =
        await _voucherLogic.createVoucher(_nameController.value.text);

    navigator.pop(voucher);
  }

  void handleDismiss(BuildContext context) {
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final newVoucherTitle =
        context.select((VoucherState state) => state.newVoucherTitle);
    final newVoucherDescription =
        context.select((VoucherState state) => state.newVoucherDescription);

    final isValid =
        newVoucherTitle.isNotEmpty && newVoucherDescription.isNotEmpty;

    final voucherCreationLoading =
        context.select((VoucherState state) => state.voucherCreationLoading);

    return DismissibleModalPopup(
      modaleKey: 'create-voucher-modal',
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
                          const Text(
                            "From",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          CupertinoTextField(
                            controller: _nameController,
                            placeholder: 'Xavier',
                            decoration: BoxDecoration(
                              color: const CupertinoDynamicColor.withBrightness(
                                color: CupertinoColors.white,
                                darkColor: CupertinoColors.black,
                              ),
                              border: Border.all(
                                color: ThemeColors.border.resolveFrom(context),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            maxLines: 1,
                            maxLength: 25,
                            autocorrect: false,
                            enableSuggestions: false,
                            textInputAction: TextInputAction.next,
                            onSubmitted: (_) {
                              onNameSubmitted();
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Title",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          CupertinoTextField(
                            placeholder: 'Cargo bike ride',
                            decoration: BoxDecoration(
                              color: const CupertinoDynamicColor.withBrightness(
                                color: CupertinoColors.white,
                                darkColor: CupertinoColors.black,
                              ),
                              border: Border.all(
                                color: ThemeColors.border.resolveFrom(context),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            maxLines: 1,
                            maxLength: 25,
                            autocorrect: false,
                            enableSuggestions: false,
                            focusNode: titleFocusNode,
                            textInputAction: TextInputAction.next,
                            onChanged: onTitleChanged,
                            onSubmitted: (_) {
                              onTitleSubmitted();
                            },
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Description",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          CupertinoTextField(
                            placeholder:
                                'One cargo bike ride to take you somewhere or help you move.',
                            decoration: BoxDecoration(
                              color: const CupertinoDynamicColor.withBrightness(
                                color: CupertinoColors.white,
                                darkColor: CupertinoColors.black,
                              ),
                              border: Border.all(
                                color: ThemeColors.border.resolveFrom(context),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            maxLines: 4,
                            maxLength: 25,
                            autocorrect: true,
                            enableSuggestions: false,
                            focusNode: descriptionFocusNode,
                            textInputAction: TextInputAction.next,
                            onChanged: onDescriptionChanged,
                            onSubmitted: (_) {
                              onDescriptionSubmitted();
                            },
                          ),
                          const SizedBox(height: 30),
                          if (voucherCreationLoading)
                            const CupertinoActivityIndicator()
                        ],
                      ),
                      Positioned(
                        bottom: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              text: 'Create voucher',
                              onPressed: isValid && !voucherCreationLoading
                                  ? onCreate
                                  : null,
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
        ),
      ),
    );
  }
}
