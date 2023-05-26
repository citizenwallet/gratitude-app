import 'package:citizenwallet/services/wallet/models/voucher.dart';
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
                return VoucherCard(
                  title: 'New',
                  address: 'new',
                  icon: '➕',
                  color: CupertinoColors.systemGrey4,
                  onPressed: (_) => onCreate(),
                );
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: vouchers.length,
              (context, index) {
                final voucher = vouchers[index];

                return VoucherCard(
                    key: Key(voucher.image),
                    title: voucher.name,
                    address: voucher.minterAddress,
                    icon: voucher.image,
                    onPressed: onPressed);
              },
            ),
          ),
        ],
      ),
    );
  }
}
