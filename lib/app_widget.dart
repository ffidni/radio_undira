import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_undira/view/dashboard_view.dart';
import 'config/my_colors.dart';
import 'get_material_color.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key, required this.navigatorKey}) : super(key: key);

  final GlobalKey<NavigatorState> navigatorKey;
  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Platform.isIOS ? Brightness.dark : Brightness.light,
        statusBarBrightness:
            Platform.isIOS ? Brightness.dark : Brightness.light,
      ),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      navigatorKey: widget.navigatorKey,
      theme: ThemeData(
        primarySwatch: generateMaterialColor(MyColors.primary),
        fontFamily: 'Ubuntu',
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: const Color(0xFF2B2B2B),
              displayColor: const Color(0xFF2B2B2B),
            ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const DashboardView(),
    );
  }
}
