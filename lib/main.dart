import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants/constants.dart';
import 'routes/navigation.dart';
import 'screens/login_screen.dart';
import 'screens/sign_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Larva',
      initialRoute: '',
      routes: {
        '': (context) => Login(),
        'sign': (context) => Sign(),
        'nav': (context) => Nav(),
        // '/user': (context) => UserDetails(),
        // '/add': (context) => Add(),
        // '/profile': (context) => Profile()
      },
      theme: ThemeData(
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
              color: Color(0xFFC1C1C1),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5),
          bodyText2: GoogleFonts.roboto(
              color: Color(0xFFC1C1C1),
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
      home: Sign(),
    );
  }
}
