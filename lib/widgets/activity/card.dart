import 'package:citizenwallet/theme/colors.dart';
import 'package:citizenwallet/widgets/profile_icon/icon.dart';
import 'package:flutter/cupertino.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String icon;
  final String description;
  final Function(String address) onPressed;

  const ActivityCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.description,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () => onPressed(title),
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
        margin: const EdgeInsets.only(bottom: 10),
        height: 100,
        decoration: BoxDecoration(
          color: ThemeColors.surfaceSubtle.resolveFrom(context),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileIcon(
              icon,
              size: 60,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ThemeColors.surfaceText.resolveFrom(context),
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: ThemeColors.surfaceText.resolveFrom(context),
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
