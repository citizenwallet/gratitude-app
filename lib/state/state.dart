import 'package:citizenwallet/state/app/state.dart';
import 'package:citizenwallet/state/landing/state.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

Widget provideAppState(Widget child) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppState(),
        ),
        ChangeNotifierProvider(
          create: (_) => LandingState(),
        ),
      ],
      child: child,
    );
