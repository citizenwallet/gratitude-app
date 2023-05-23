import 'package:flutter/cupertino.dart';

class ProfileIcon extends StatelessWidget {
  final String icon;
  final double size;
  final BoxBorder? border;

  const ProfileIcon(
    this.icon, {
    Key? key,
    this.size = 40,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: size,
      height: size,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 2),
          border: border ??
              Border.all(width: 1, color: CupertinoColors.systemGrey3),
          color: CupertinoColors.systemGrey4),
      child: Center(
        child: Text(
          icon,
          style: TextStyle(
            color: CupertinoColors.white,
            fontSize: size / 2,
            fontWeight: FontWeight.bold,
            fontFamilyFallback: const [
              'Noto Color Emoji',
            ],
          ),
        ),
      ),
    );
  }
}
