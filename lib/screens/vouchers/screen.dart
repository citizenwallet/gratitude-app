import 'package:citizenwallet/theme/colors.dart';
import 'package:citizenwallet/widgets/button.dart';
import 'package:citizenwallet/widgets/header.dart';
import 'package:citizenwallet/widgets/profile_icon/icon.dart';
import 'package:citizenwallet/widgets/profile_icon/picker.dart';
import 'package:flutter/cupertino.dart';

class VouchersScreen extends StatefulWidget {
  final String title = 'Vouchers';
  final String address;

  const VouchersScreen({super.key, required this.address});

  @override
  VouchersScreenState createState() => VouchersScreenState();
}

class VouchersScreenState extends State<VouchersScreen>
    with TickerProviderStateMixin {
  final FocusNode descriptionFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // make initial requests here
    });
  }

  void onLoad() async {}

  void onNameSubmitted() async {
    descriptionFocusNode.requestFocus();
  }

  void onDescriptionSubmitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onIconChanged(String icon) async {
    print(icon);
  }

  void onCreate() async {}

  @override
  Widget build(BuildContext context) {
    final invalidAmount = false;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Header(
              title: widget.title,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ListView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "What's your name?",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        // controller: widget.logic.amountController,
                        placeholder: 'Enter your name',
                        decoration: invalidAmount
                            ? BoxDecoration(
                                color:
                                    const CupertinoDynamicColor.withBrightness(
                                  color: CupertinoColors.white,
                                  darkColor: CupertinoColors.black,
                                ),
                                border: Border.all(
                                  color: ThemeColors.danger,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                              )
                            : BoxDecoration(
                                color:
                                    const CupertinoDynamicColor.withBrightness(
                                  color: CupertinoColors.white,
                                  darkColor: CupertinoColors.black,
                                ),
                                border: Border.all(
                                  color:
                                      ThemeColors.border.resolveFrom(context),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
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
                        "Short description",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        // controller: widget.logic.amountController,
                        placeholder: 'Describe yourself in a few words',
                        decoration: invalidAmount
                            ? BoxDecoration(
                                color:
                                    const CupertinoDynamicColor.withBrightness(
                                  color: CupertinoColors.white,
                                  darkColor: CupertinoColors.black,
                                ),
                                border: Border.all(
                                  color: ThemeColors.danger,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                              )
                            : BoxDecoration(
                                color:
                                    const CupertinoDynamicColor.withBrightness(
                                  color: CupertinoColors.white,
                                  darkColor: CupertinoColors.black,
                                ),
                                border: Border.all(
                                  color:
                                      ThemeColors.border.resolveFrom(context),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                              ),
                        maxLines: 1,
                        maxLength: 25,
                        autocorrect: true,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.next,
                        onSubmitted: (_) {
                          onDescriptionSubmitted();
                        },
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Pick a profile icon",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          ProfileIcon(
                            '👨‍🚀',
                            size: 80,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ProfileIconPicker(onIconChanged: onIconChanged),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: 'Create profile',
                          onPressed: onCreate,
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
