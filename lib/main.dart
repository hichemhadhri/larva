import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larva/providers/dbstate_provider.dart';
import 'package:larva/providers/userid_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'constants/constants.dart';
import 'controllers/authentificationController.dart';
import 'routes/navigation.dart';
import 'screens/login_screen.dart';
import 'screens/sign_screen.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => DbState())
  ], child: MyApp()));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black.withOpacity(0.2)
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.white
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Auth _auth = Auth();
    return FutureBuilder<int>(
      future: _auth.checkLogin(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: SvgPicture.asset(
                  "lib/assets/images/butterfly.svg",
                  height: 200,
                  color: Colors.black,
                ),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          return MaterialApp(
            builder: EasyLoading.init(),
            debugShowCheckedModeBanner: false,
            title: 'Butterfly',
            routes: {
              'login': (context) => Login(),
              'sign': (context) => Sign(),
              'nav': (context) => Nav(),
            },
            home: snapshot.data == 200 ? Nav() : Login(),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primaryColor: Colors.green[800],
              focusColor: Colors.greenAccent,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),
            themeMode: ThemeMode.dark,
          );
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: SvgPicture.asset(
                  "lib/assets/images/butterfly.svg",
                  height: 200,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
