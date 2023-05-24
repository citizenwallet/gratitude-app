import 'package:citizenwallet/state/profile/logic.dart';
import 'package:citizenwallet/state/profile/state.dart';
import 'package:citizenwallet/theme/colors.dart';
import 'package:citizenwallet/widgets/button.dart';
import 'package:citizenwallet/widgets/profile_icon/icon.dart';
import 'package:citizenwallet/widgets/profile_icon/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LandingScreen extends StatefulWidget {
  final String title = 'Regens Unite';

  const LandingScreen({super.key});

  @override
  LandingScreenState createState() => LandingScreenState();
}

class LandingScreenState extends State<LandingScreen>
    with TickerProviderStateMixin {
  final FocusNode descriptionFocusNode = FocusNode();

  late ProfileLogic _logic;

  @override
  void initState() {
    super.initState();

    _logic = ProfileLogic(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // make initial requests here

      onLoad();
    });
  }

  void onLoad() async {}

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

  @override
  Widget build(BuildContext context) {
    final name = context.select((ProfileState state) => state.profile.name);
    final description =
        context.select((ProfileState state) => state.profile.description);
    final icon = context.select((ProfileState state) => state.profile.icon);

    final loading = context.select((ProfileState state) => state.loading);

    final isValid = name.isNotEmpty && description.isNotEmpty;

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
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
                        "Welcome",
                        style: TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Create a profile to get started",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Name",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      CupertinoTextField(
                        placeholder: 'Enter your name',
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
                        onChanged: onNameChanged,
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
                        placeholder: 'Describe yourself in a few words',
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
                        autocorrect: true,
                        enableSuggestions: false,
                        textInputAction: TextInputAction.next,
                        onChanged: onDescriptionChanged,
                        onSubmitted: (_) {
                          onDescriptionSubmitted();
                        },
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Pick a profile icon",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          ProfileIcon(
                            icon,
                            size: 80,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ProfileIconPicker(
                        initialValue: icon,
                        icons: animals,
                        onIconChanged: onIconChanged,
                      ),
                      const SizedBox(height: 30),
                      if (loading) const CupertinoActivityIndicator()
                    ],
                  ),
                  Positioned(
                    bottom: 20,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          text: 'Create profile',
                          suffix: const Row(
                            children: [
                              SizedBox(width: 5),
                              Icon(
                                CupertinoIcons.plus,
                                size: 18,
                                color: CupertinoColors.white,
                              ),
                            ],
                          ),
                          onPressed:
                              isValid && !loading ? handleSetProfile : null,
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
