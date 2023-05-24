import 'package:citizenwallet/state/account/state.dart';
import 'package:citizenwallet/state/app/state.dart';
import 'package:citizenwallet/state/profile/state.dart';
import 'package:citizenwallet/state/vouchers/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

Widget provideAppState(Widget child) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileState(),
        ),
        ChangeNotifierProvider(
          create: (_) => VouchersState(),
        ),
        ChangeNotifierProvider(
          create: (_) => AccountState(),
        ),
      ],
      child: child,
    );
