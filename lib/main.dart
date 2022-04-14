import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:larva/providers/userid_provider.dart';
import 'package:provider/provider.dart';

import 'constants/constants.dart';
import 'controllers/authentificationController.dart';
import 'routes/navigation.dart';
import 'screens/login_screen.dart';
import 'screens/sign_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserId()),
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
    return FutureBuilder(
        future: _auth.checkLogin(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              builder: EasyLoading.init(),
              debugShowCheckedModeBanner: false,
              title: 'Butterfly',
              initialRoute: snapshot.data == 200 ? "nav" : "login",
              routes: {
                'login': (context) => Login(),
                'sign': (context) => Sign(),
                'nav': (context) => Nav(),
                // '/user': (context) => UserDetails(),
                // '/add': (context) => Add(),
                // '/profile': (context) => Profile()
              },
              theme: ThemeData(
                scaffoldBackgroundColor: Colors.black,
                appBarTheme: AppBarTheme(
                    titleTextStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.black),
                iconTheme: IconThemeData(color: Colors.white),
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: Colors.black,
                    unselectedItemColor: Colors.white,
                    selectedItemColor: gold),
                backgroundColor: Colors.black,
                buttonColor: gold,
                bottomAppBarColor: Color(0xFF303030),
                inputDecorationTheme: InputDecorationTheme(
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                    width: 4,
                  )),
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
                    backgroundColor: MaterialStateProperty.all(gold),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    elevation: MaterialStateProperty.all(20),
                  ),
                ),
                textTheme: TextTheme(
                  headline1: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 60,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2),
                  headline2: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -0.5),
                  headline3: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 51,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1),
                  headline4: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 2),
                  headline5: GoogleFonts.dmSans(
                      letterSpacing: 2,
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w400),
                  headline6: GoogleFonts.dmSans(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.15),
                  subtitle1: GoogleFonts.dmSans(
                      color: Color(0xFFC1C1C1),
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.15),
                  subtitle2: GoogleFonts.dmSans(
                      color: Color(0xFFC1C1C1),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.1),
                  bodyText1: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5),
                  bodyText2: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.25),
                  button: GoogleFonts.roboto(
                      color: Color(0xFFC1C1C1),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.25),
                  caption: GoogleFonts.roboto(
                      color: Color(0xFFC1C1C1),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.4),
                  overline: GoogleFonts.roboto(
                      color: Color(0xFFC1C1C1),
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5),
                ),
              ),
            );
          } else {
            return Center(
              child: SvgPicture.asset(
                "lib/assets/images/butterfly.svg",
                height: 200,
                color: Colors.white,
              ),
            );
          }
        });
  }
}
