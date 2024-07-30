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
    ChangeNotifierProvider(create: (_) => UserId()),
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
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                color: Colors.black,
              ),
              iconTheme: IconThemeData(color: Colors.white),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                backgroundColor: Colors.black,
                unselectedItemColor: Colors.white,
                selectedItemColor:
                    Colors.amber, // Changed from gold to amber for clarity
              ),
              inputDecorationTheme: InputDecorationTheme(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 4,
                  ),
                ),
                filled: false,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFFC1C1C1),
                    width: 3,
                  ),
                ),
                errorStyle: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 12,
                ),
              ),
              hintColor: Color(0xFFC1C1C1),
              textButtonTheme: TextButtonThemeData(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(20),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  elevation: MaterialStateProperty.all(20),
                ),
              ),
              textTheme: TextTheme(
                displayLarge: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 2,
                ),
                displayMedium: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.5,
                ),
                displaySmall: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 51,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1,
                ),
                headlineMedium: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2,
                ),
                headlineSmall: GoogleFonts.dmSans(
                  letterSpacing: 2,
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
                titleLarge: GoogleFonts.dmSans(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.15,
                ),
                titleMedium: GoogleFonts.dmSans(
                  color: Color(0xFFC1C1C1),
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.15,
                ),
                titleSmall: GoogleFonts.dmSans(
                  color: Color(0xFFC1C1C1),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1,
                ),
                bodyLarge: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
                bodyMedium: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.25,
                ),
                labelLarge: GoogleFonts.roboto(
                  color: Color(0xFFC1C1C1),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.25,
                ),
                bodySmall: GoogleFonts.roboto(
                  color: Color(0xFFC1C1C1),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.4,
                ),
                labelSmall: GoogleFonts.roboto(
                  color: Color(0xFFC1C1C1),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.5,
                ),
              ),
              colorScheme: ColorScheme(
                brightness: Brightness.dark,
                primary: Colors.black,
                onPrimary: Colors.white,
                secondary: Colors.grey,
                onSecondary: Colors.white,
                error: Colors.red,
                onError: Colors.white,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
              bottomAppBarTheme: BottomAppBarTheme(color: Color(0xFF303030)),
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
