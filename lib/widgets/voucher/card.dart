import 'package:citizenwallet/widgets/profile_icon/icon.dart';
import 'package:flutter/cupertino.dart';

class VoucherCard extends StatelessWidget {
  final String title;
  final String address;
  final String icon;
  final Color color;
  final Function(String address) onPressed;

  const VoucherCard({
    Key? key,
    required this.title,
    required this.address,
    required this.icon,
    this.color = const Color.fromARGB(255, 103, 157, 245),
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () => onPressed(address),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileIcon(icon),
            // Container(
            //   height: 40,
            //   width: 40,
            //   decoration: BoxDecoration(
            //     color: CupertinoColors.white,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: const Center(
            //     child: Icon(
            //       CupertinoIcons.question,
            //       color: CupertinoColors.darkBackgroundGray,
            //     ),
            //   ),
            // ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              style: const TextStyle(
                color: CupertinoColors.black,
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
