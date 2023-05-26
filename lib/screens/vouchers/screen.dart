import 'package:citizenwallet/screens/vouchers/create_voucher_modal.dart';
import 'package:citizenwallet/screens/vouchers/profile_modal.dart';
import 'package:citizenwallet/services/wallet/models/voucher.dart';
import 'package:citizenwallet/state/account/state.dart';
import 'package:citizenwallet/state/profile/state.dart';
import 'package:citizenwallet/state/vouchers/logic.dart';
import 'package:citizenwallet/state/vouchers/state.dart';
import 'package:citizenwallet/widgets/activity/list.dart';
import 'package:citizenwallet/widgets/header.dart';
import 'package:citizenwallet/widgets/profile_icon/icon.dart';
import 'package:citizenwallet/widgets/voucher/list.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class VouchersScreen extends StatefulWidget {
  final String title = 'Regens Unite';
  final String subtitle = 'Rooted locally, connected globally';

  const VouchersScreen({super.key});

  @override
  VouchersScreenState createState() => VouchersScreenState();
}

class VouchersScreenState extends State<VouchersScreen>
    with TickerProviderStateMixin {
  final FocusNode descriptionFocusNode = FocusNode();

  late VouchersLogic _logic;

  @override
  void initState() {
    super.initState();

    _logic = VouchersLogic(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // make initial requests here

      onLoad();
    });
  }

  void onLoad() async {
    _logic.fetchVouchers();
    _logic.fetchActivities();
  }

  void onNameSubmitted() async {
    descriptionFocusNode.requestFocus();
  }

  void onDescriptionSubmitted() async {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void onIconChanged(String icon) async {
    print(icon);
  }

  void onVoucherPressed(String addr) async {
    print(addr);
  }

  void onVoucherCreate() async {
    handleVoucherCreate();
  }

  void onActivityPressed(String addr) async {
    print(addr);
  }

  void handleDisplayProfile(BuildContext context) async {
    final address = context.read<AccountState>().address;

    await showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (modalContext) => ProfileModal(
        address: address,
      ),
    );
  }

  void handleVoucherCreate() async {
    final voucher = await showCupertinoModalPopup<Voucher?>(
      context: context,
      barrierDismissible: true,
      builder: (modalContext) =>
          const CreateVoucherModal(address: '0x123456789'),
    );

    if (voucher == null) {
      return;
    }

    _logic.addVoucher(voucher);
  }

  @override
  Widget build(BuildContext context) {
    final icon = context.select((ProfileState state) => state.profile.icon);

    final vouchers = context.select((VouchersState state) => state.vouchers);
    final activities =
        context.select((VouchersState state) => state.activities);

    final loading = context.select((AccountState state) => state.loading);

    final vouchersLoading =
        context.select((VouchersState state) => state.vouchersLoading);
    final activitiesLoading =
        context.select((VouchersState state) => state.activitiesLoading);

    return CupertinoPageScaffold(
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
              actionButton: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  loading
                      ? const CupertinoActivityIndicator()
                      : CupertinoButton(
                          padding: const EdgeInsets.all(5),
                          onPressed: () => handleDisplayProfile(context),
                          child: ProfileIcon(
                            icon,
                            size: 40,
                          ),
                        ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 40,
                        child: Text(
                          "Vouchers",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 100,
                        child: loading || vouchersLoading
                            ? const CupertinoActivityIndicator()
                            : VoucherList(
                                onPressed: onVoucherPressed,
                                onCreate: onVoucherCreate,
                                vouchers: vouchers,
                              ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 40,
                        child: Text(
                          "Activity",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    if (loading || activitiesLoading)
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 100,
                          child: CupertinoActivityIndicator(),
                        ),
                      ),
                    if (!loading && !activitiesLoading)
                      ActivityList(
                        activities: activities,
                        onPressed: onActivityPressed,
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
