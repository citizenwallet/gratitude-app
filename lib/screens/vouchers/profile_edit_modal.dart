import 'package:citizenwallet/state/profile/logic.dart';
import 'package:citizenwallet/state/profile/state.dart';
import 'package:citizenwallet/theme/colors.dart';
import 'package:citizenwallet/widgets/button.dart';
import 'package:citizenwallet/widgets/dismissible_modal_popup.dart';
import 'package:citizenwallet/widgets/header.dart';
import 'package:citizenwallet/widgets/profile_icon/icon.dart';
import 'package:citizenwallet/widgets/profile_icon/picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileEditModal extends StatefulWidget {
  const ProfileEditModal({super.key});

  @override
  ProfileEditModalState createState() => ProfileEditModalState();
}

class ProfileEditModalState extends State<ProfileEditModal>
    with TickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();

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

  void onLoad() async {
    nameController.text = context.read<ProfileState>().profile.name;
  }

  void onNameChanged(String name) async {
    _logic.updateProfileName(name);
  }

  void onNameSubmitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onIconChanged(String icon) async {
    _logic.updateProfileIcon(icon);
  }

  void handleDismiss(BuildContext context) async {
    final navigator = GoRouter.of(context);

    await _logic.setDefaultProfile();

    navigator.pop();
  }

  void handleSetProfile() async {
    final navigator = GoRouter.of(context);

    await _logic.setProfile();

    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final name = context.select((ProfileState state) => state.profile.name);
    final description =
        context.select((ProfileState state) => state.profile.description);
    final icon = context.select((ProfileState state) => state.profile.icon);

    final loading = context.select((ProfileState state) => state.loading);

    final isValid = name.isNotEmpty && description.isNotEmpty;

    return DismissibleModalPopup(
      modaleKey: 'profile-edit-modal',
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
                  title: 'Edit profile',
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
                          const SizedBox(height: 5),
                          const Text(
                            "Name",
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          CupertinoTextField(
                            controller: nameController,
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
                          if (loading) const CupertinoActivityIndicator(),
                        ],
                      ),
                      Positioned(
                        bottom: 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Button(
                              text: 'Save changes',
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
        ),
      ),
    );
  }
}
