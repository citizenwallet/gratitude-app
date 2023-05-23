import 'package:citizenwallet/state/vouchers/state.dart';
import 'package:citizenwallet/widgets/voucher/card.dart';
import 'package:flutter/cupertino.dart';

class VoucherList extends StatelessWidget {
  final List<Voucher> vouchers;
  final Function(String address) onPressed;
  final Function() onCreate;

  const VoucherList({
    Key? key,
    required this.vouchers,
    required this.onPressed,
    required this.onCreate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: CustomScrollView(
        scrollDirection: Axis.horizontal,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (context, index) {
                // return Text(voucher.title);
                return VoucherCard(
                    title: 'new voucher',
                    address: 'new',
                    icon: '👻',
                    color: CupertinoColors.systemGrey4,
                    onPressed: (_) => onCreate());
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: vouchers.length,
              (context, index) {
                final voucher = vouchers[index];

                // return Text(voucher.title);
                return VoucherCard(
                    key: Key(voucher.address),
                    title: voucher.title,
                    address: voucher.address,
                    icon: voucher.icon,
                    onPressed: onPressed);
              },
            ),
          ),
        ],
      ),
    );
  }
}
